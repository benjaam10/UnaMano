USE [Proyecto_UnaMano]
GO

IF NOT EXISTS (SELECT 1 FROM dbo.MedioPago WHERE nombre_mediopago='Pago de demostración')
    INSERT dbo.MedioPago(nombre_mediopago) VALUES('Pago de demostración');
GO

CREATE OR ALTER PROCEDURE dbo.sp_RegistrarPago
    @id_tarea int,
    @id_usuario_cliente int,
    @porcentaje_comision decimal(5,2)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRAN;

    DECLARE @final int=(SELECT id_estado FROM dbo.EstadoTarea WHERE nombre_estado='Finalizada');
    DECLARE @accepted int=(SELECT id_estadopostulacion FROM dbo.EstadoPostulacion WHERE nombre_estadopostulacion='Aceptada');
    DECLARE @idMedio int=(SELECT TOP 1 id_mediopago FROM dbo.MedioPago WHERE nombre_mediopago='Pago de demostración');
    DECLARE @cliente int,@student int,@net decimal(10,2),@com decimal(10,2),@total decimal(10,2);
    DECLARE @conversation int,@payment int,@message varchar(2000);

    IF @porcentaje_comision < 0 OR @porcentaje_comision > 100
        THROW 51062,'El porcentaje de comisión debe estar entre 0 y 100',1;

    SELECT @cliente=id_cliente_tarea,@net=pago_ofrecido_tarea
    FROM dbo.Tarea WITH(UPDLOCK,HOLDLOCK)
    WHERE id_tarea=@id_tarea AND id_estado_tarea=@final;

    IF @cliente IS NULL OR NOT EXISTS(
        SELECT 1 FROM dbo.Usuario
        WHERE id_usuario=@id_usuario_cliente AND id_cliente_usuario=@cliente AND estado_usuario=1
    )
        THROW 51060,'La tarea no está finalizada o no eres el cliente',1;

    IF EXISTS(SELECT 1 FROM dbo.Pago WHERE id_tarea_pago=@id_tarea)
        THROW 51061,'La tarea ya tiene un pago',1;

    IF (SELECT COUNT(*) FROM dbo.Postulacion WHERE id_tarea_postulacion=@id_tarea AND id_estadopostulacion=@accepted) <> 1
        THROW 51063,'La tarea debe tener exactamente un estudiante aceptado para recibir el pago',1;

    SELECT @student=id_estudiante_postulacion
    FROM dbo.Postulacion
    WHERE id_tarea_postulacion=@id_tarea AND id_estadopostulacion=@accepted;

    IF @idMedio IS NULL
        THROW 51064,'No existe el medio de pago de demostración',1;

    SET @com=ROUND(@net*@porcentaje_comision/100.0,2);
    SET @total=@net-@com;

    INSERT dbo.Pago(fecha_pago,monto_neto_pago,comision_pago,monto_total_pago,id_tarea_pago,id_mediopago_pago)
    VALUES(GETDATE(),@net,@com,@total,@id_tarea,@idMedio);
    SET @payment=CAST(SCOPE_IDENTITY() AS int);

    SELECT @conversation=id_conversacion
    FROM dbo.Conversacion
    WHERE id_tarea_conversacion=@id_tarea AND id_estudiante_conversacion=@student;

    IF @conversation IS NULL
    BEGIN
        INSERT dbo.Conversacion(
            id_tarea_conversacion,id_cliente_conversacion,id_estudiante_conversacion,
            fecha_creacion_conversacion,estado_conversacion
        )
        VALUES(@id_tarea,@cliente,@student,GETDATE(),1);
        SET @conversation=CAST(SCOPE_IDENTITY() AS int);
    END

    SET @message=CONCAT(
        'Pago recibido: se abonaron $',FORMAT(@total,'N0','es-CL'),
        ' a tu saldo, después de descontar $',FORMAT(@com,'N0','es-CL'),' de comisión.'
    );

    INSERT dbo.Mensaje(id_conversacion_mensaje,id_usuario_emisor_mensaje,contenido_mensaje,fecha_mensaje)
    VALUES(@conversation,@id_usuario_cliente,@message,GETDATE());

    COMMIT;

    SELECT @payment AS id_pago,@net AS monto_neto_pago,@com AS comision_pago,@total AS monto_total_pago;
END
GO
