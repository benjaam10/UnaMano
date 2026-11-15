USE [Proyecto_UnaMano]
GO

IF NOT EXISTS (SELECT 1 FROM dbo.EstadoTarea WHERE nombre_estado='Vencida')
    INSERT dbo.EstadoTarea(nombre_estado) VALUES('Vencida');
GO

CREATE OR ALTER PROCEDURE dbo.sp_CancelarTareaCliente
    @id_tarea int,
    @id_usuario_cliente int
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRANSACTION;

    DECLARE @cancel int=(SELECT id_estado FROM dbo.EstadoTarea WHERE nombre_estado='Cancelada');
    DECLARE @final int=(SELECT id_estado FROM dbo.EstadoTarea WHERE nombre_estado='Finalizada');
    DECLARE @expired int=(SELECT id_estado FROM dbo.EstadoTarea WHERE nombre_estado='Vencida');
    DECLARE @accepted int;
    DECLARE @taskClient int,@state int,@start datetime;

    SELECT @taskClient=t.id_cliente_tarea,@state=t.id_estado_tarea,@start=t.fecha_inicio_tarea
    FROM dbo.Tarea t WITH(UPDLOCK,HOLDLOCK)
    WHERE t.id_tarea=@id_tarea;

    IF @taskClient IS NULL OR NOT EXISTS(
        SELECT 1 FROM dbo.Usuario
        WHERE id_usuario=@id_usuario_cliente
          AND id_cliente_usuario=@taskClient
          AND estado_usuario=1
    )
        THROW 51040,'No eres el dueño de esta tarea',1;

    IF @state IN (@final,@cancel,@expired)
        THROW 51041,'La tarea ya está cerrada o vencida',1;

    SELECT @accepted=id_estadopostulacion
    FROM dbo.EstadoPostulacion
    WHERE nombre_estadopostulacion='Aceptada';

    IF EXISTS(
        SELECT 1
        FROM dbo.Postulacion
        WHERE id_tarea_postulacion=@id_tarea
          AND id_estadopostulacion=@accepted
    ) AND GETDATE()>DATEADD(HOUR,-5,@start)
        THROW 51042,'Con un estudiante aceptado, solo puedes cancelar hasta 5 horas antes del inicio',1;

    UPDATE dbo.Tarea SET id_estado_tarea=@cancel WHERE id_tarea=@id_tarea;

    INSERT dbo.HistorialTarea(
        id_tarea_historial,estado_anterior_historial,estado_nuevo_historial,
        tipo_evento_historial,id_usuario_historial,detalle_historial
    )
    VALUES(
        @id_tarea,
        (SELECT nombre_estado FROM dbo.EstadoTarea WHERE id_estado=@state),
        'Cancelada','CANCELACION_CLIENTE',@id_usuario_cliente,'Cancelación registrada.'
    );

    COMMIT TRANSACTION;
END
GO

CREATE OR ALTER TRIGGER dbo.TR_Postulacion_UnaAceptadaPorTarea
ON dbo.Postulacion
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS(
        SELECT p.id_tarea_postulacion
        FROM dbo.Postulacion p
        JOIN dbo.EstadoPostulacion ep
          ON ep.id_estadopostulacion=p.id_estadopostulacion
        JOIN (SELECT DISTINCT id_tarea_postulacion FROM inserted) changed
          ON changed.id_tarea_postulacion=p.id_tarea_postulacion
        WHERE ep.nombre_estadopostulacion='Aceptada'
        GROUP BY p.id_tarea_postulacion
        HAVING COUNT(*)>1
    )
        THROW 51080,'Una tarea no puede tener más de una postulación aceptada',1;
END
GO

CREATE OR ALTER TRIGGER dbo.TR_Tarea_ValidarTransiciones
ON dbo.Tarea
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(id_estado_tarea) AND EXISTS(
        SELECT 1
        FROM inserted i
        JOIN deleted d ON d.id_tarea=i.id_tarea
        JOIN dbo.EstadoTarea old_state ON old_state.id_estado=d.id_estado_tarea
        JOIN dbo.EstadoTarea new_state ON new_state.id_estado=i.id_estado_tarea
        WHERE old_state.nombre_estado<>new_state.nombre_estado
          AND NOT(
              (old_state.nombre_estado='Disponible'
                  AND new_state.nombre_estado IN ('Asignada','Cancelada','Vencida'))
              OR
              (old_state.nombre_estado='Asignada'
                  AND new_state.nombre_estado IN ('Disponible','Finalizada','Cancelada'))
          )
    )
        THROW 51081,'Transición de estado de tarea no permitida',1;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_ProcesarTareasVencidas
    @fecha_corte datetime = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @corte datetime=COALESCE(@fecha_corte,GETDATE());
    DECLARE @disponible int=(SELECT id_estado FROM dbo.EstadoTarea WHERE nombre_estado='Disponible');
    DECLARE @vencida int=(SELECT id_estado FROM dbo.EstadoTarea WHERE nombre_estado='Vencida');
    DECLARE @pendiente int=(SELECT id_estadopostulacion FROM dbo.EstadoPostulacion WHERE nombre_estadopostulacion='Pendiente');
    DECLARE @rechazada int=(SELECT id_estadopostulacion FROM dbo.EstadoPostulacion WHERE nombre_estadopostulacion='Rechazada');
    DECLARE @aceptada int=(SELECT id_estadopostulacion FROM dbo.EstadoPostulacion WHERE nombre_estadopostulacion='Aceptada');
    DECLARE @id_tarea int;
    DECLARE @tareas_vencidas int=0;
    DECLARE @postulaciones_rechazadas int=0;
    DECLARE @tarea_actualizada TABLE (id_tarea int PRIMARY KEY);
    DECLARE @postulacion_actualizada TABLE (id_postulacion int PRIMARY KEY);

    IF @disponible IS NULL OR @vencida IS NULL OR @pendiente IS NULL OR @rechazada IS NULL OR @aceptada IS NULL
        THROW 51090,'Faltan estados requeridos para procesar vencimientos',1;

    DECLARE cursor_tareas_vencidas CURSOR LOCAL FAST_FORWARD FOR
        SELECT t.id_tarea
        FROM dbo.Tarea t
        JOIN dbo.vw_TareaPlazo vp ON vp.id_tarea=t.id_tarea
        WHERE t.id_estado_tarea=@disponible
          AND vp.fecha_limite_aprobacion<=@corte
          AND NOT EXISTS(
              SELECT 1
              FROM dbo.Postulacion p
              WHERE p.id_tarea_postulacion=t.id_tarea
                AND p.id_estadopostulacion=@aceptada
          )
        ORDER BY vp.fecha_limite_aprobacion,t.id_tarea;

    BEGIN TRY
        BEGIN TRANSACTION;
        OPEN cursor_tareas_vencidas;
        FETCH NEXT FROM cursor_tareas_vencidas INTO @id_tarea;

        WHILE @@FETCH_STATUS=0
        BEGIN
            DELETE FROM @tarea_actualizada;
            UPDATE dbo.Tarea
            SET id_estado_tarea=@vencida
            OUTPUT inserted.id_tarea INTO @tarea_actualizada(id_tarea)
            WHERE id_tarea=@id_tarea
              AND id_estado_tarea=@disponible
              AND EXISTS(
                  SELECT 1
                  FROM dbo.vw_TareaPlazo vp
                  WHERE vp.id_tarea=@id_tarea
                    AND vp.fecha_limite_aprobacion<=@corte
              )
              AND NOT EXISTS(
                  SELECT 1
                  FROM dbo.Postulacion p
                  WHERE p.id_tarea_postulacion=@id_tarea
                    AND p.id_estadopostulacion=@aceptada
              );

            IF EXISTS(SELECT 1 FROM @tarea_actualizada)
            BEGIN
                DELETE FROM @postulacion_actualizada;
                UPDATE dbo.Postulacion
                SET id_estadopostulacion=@rechazada
                OUTPUT inserted.id_postulacion INTO @postulacion_actualizada(id_postulacion)
                WHERE id_tarea_postulacion=@id_tarea
                  AND id_estadopostulacion=@pendiente;

                SELECT @postulaciones_rechazadas=@postulaciones_rechazadas+COUNT(*)
                FROM @postulacion_actualizada;

                INSERT dbo.HistorialTarea(
                    id_tarea_historial,estado_anterior_historial,estado_nuevo_historial,
                    tipo_evento_historial,id_usuario_historial,detalle_historial
                )
                VALUES(
                    @id_tarea,'Disponible','Vencida','VENCIMIENTO_TAREA',NULL,
                    'La fecha límite de aprobación venció sin que se aceptara una postulación.'
                );

                SET @tareas_vencidas=@tareas_vencidas+1;
            END

            FETCH NEXT FROM cursor_tareas_vencidas INTO @id_tarea;
        END

        CLOSE cursor_tareas_vencidas;
        DEALLOCATE cursor_tareas_vencidas;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF CURSOR_STATUS('local','cursor_tareas_vencidas')>=0
            CLOSE cursor_tareas_vencidas;
        IF CURSOR_STATUS('local','cursor_tareas_vencidas')>-3
            DEALLOCATE cursor_tareas_vencidas;
        IF XACT_STATE()<>0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;

    SELECT @corte AS fecha_corte,
           @tareas_vencidas AS tareas_vencidas,
           @postulaciones_rechazadas AS postulaciones_rechazadas;
END
GO
