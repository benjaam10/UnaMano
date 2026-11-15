USE [Proyecto_UnaMano];
GO

/*
  Carga 20 tareas demo para diciembre de 2026.
  Requiere ejecutar antes 01_bd_unamano_modificaciones.sql,
  02_datos_demo.sql y 04_datos_chile_y_usuarios_demo.sql.
*/
DECLARE @cliente int = (
    SELECT TOP 1 id_cliente
    FROM dbo.Cliente
    WHERE email_cliente = 'cliente@demo.cl'
);
DECLARE @disponible int = (
    SELECT TOP 1 id_estado
    FROM dbo.EstadoTarea
    WHERE nombre_estado = 'Disponible'
);

IF @cliente IS NULL THROW 51020, 'No existe cliente@demo.cl. Ejecuta primero el script de usuarios demo.', 1;
IF @disponible IS NULL THROW 51021, 'No existe el estado Disponible. Ejecuta 01_bd_unamano_modificaciones.sql.', 1;

DECLARE @datos TABLE (
    orden int IDENTITY(1,1),
    titulo varchar(100),
    descripcion varchar(500),
    monto decimal(10,2),
    inicio datetime,
    categoria varchar(50),
    nombre varchar(100),
    calle varchar(200),
    numero varchar(20),
    region varchar(100),
    comuna varchar(100)
);

INSERT INTO @datos (titulo, descripcion, monto, inicio, categoria, nombre, calle, numero, region, comuna)
VALUES
('Limpieza de departamento', 'Limpieza general de un departamento de dos habitaciones.', 25000, '2026-12-01T10:00:00', 'Hogar', 'Limpieza general', 'Alameda', '100', 'Metropolitana de Santiago', 'Santiago'),
('Limpieza de cocina', 'Limpieza profunda de cocina y logia.', 18000, '2026-12-02T15:00:00', 'Hogar', 'Limpieza general', 'Portugal', '220', 'Metropolitana de Santiago', 'Ñuñoa'),
('Ayuda con trámite municipal', 'Acompañamiento para realizar un trámite presencial.', 15000, '2026-12-03T09:30:00', 'Trámites', 'Ayuda con trámite', 'Providencia', '450', 'Metropolitana de Santiago', 'Providencia'),
('Instalar computador', 'Configuración de computador, impresora y conexión a internet.', 30000, '2026-12-04T11:00:00', 'Tecnología', 'Instalación de computador', 'Las Condes', '800', 'Metropolitana de Santiago', 'Las Condes'),
('Corte de pasto', 'Corte y limpieza de jardín delantero.', 22000, '2026-12-05T08:30:00', 'Jardinería', 'Corte de pasto', 'Los Carrera', '120', 'Ñuble', 'Chillán'),
('Limpieza de casa', 'Limpieza general antes de recibir visitas.', 28000, '2026-12-06T14:00:00', 'Hogar', 'Limpieza general', 'O Higgins', '55', 'O''Higgins', 'Rancagua'),
('Ayuda con trámite universitario', 'Apoyo para retirar y entregar documentos.', 12000, '2026-12-07T10:30:00', 'Trámites', 'Ayuda con trámite', 'Independencia', '90', 'Biobío', 'Concepción'),
('Configuración de notebook', 'Instalar programas básicos y configurar correo.', 20000, '2026-12-08T16:00:00', 'Tecnología', 'Instalación de computador', 'Colón', '310', 'Valparaíso', 'Valparaíso'),
('Mantención de jardín', 'Corte de pasto y retiro de hojas.', 24000, '2026-12-09T09:00:00', 'Jardinería', 'Corte de pasto', 'Alerce', '75', 'Los Lagos', 'Puerto Montt'),
('Limpieza post mudanza', 'Limpieza de vivienda desocupada después de una mudanza.', 35000, '2026-12-10T13:00:00', 'Hogar', 'Limpieza general', 'Vicuña Mackenna', '200', 'Metropolitana de Santiago', 'Maipú'),
('Trámite en registro civil', 'Acompañamiento para realizar trámite en Registro Civil.', 14000, '2026-12-11T09:00:00', 'Trámites', 'Ayuda con trámite', 'Baquedano', '130', 'Antofagasta', 'Antofagasta'),
('Instalación de impresora', 'Instalar impresora y dejarla lista para imprimir por wifi.', 17000, '2026-12-12T12:00:00', 'Tecnología', 'Instalación de computador', 'Prat', '440', 'Tarapacá', 'Iquique'),
('Corte de pasto y poda', 'Corte de pasto y poda de arbustos pequeños.', 26000, '2026-12-13T10:00:00', 'Jardinería', 'Corte de pasto', 'Picarte', '510', 'Los Ríos', 'Valdivia'),
('Limpieza de oficina', 'Limpieza general de una oficina pequeña.', 30000, '2026-12-15T08:00:00', 'Hogar', 'Limpieza general', 'O Higgins', '120', 'Biobío', 'Concepción'),
('Ayuda con documentos', 'Ordenar, escanear y enviar documentos digitales.', 13000, '2026-12-16T15:30:00', 'Trámites', 'Ayuda con trámite', 'Balmaceda', '77', 'La Araucanía', 'Temuco'),
('Formatear computador', 'Respaldo y reinstalación del sistema operativo.', 35000, '2026-12-17T10:00:00', 'Tecnología', 'Instalación de computador', 'Arturo Prat', '260', 'Coquimbo', 'La Serena'),
('Corte de pasto en parcela', 'Corte de pasto en patio amplio y retiro de residuos.', 40000, '2026-12-18T09:00:00', 'Jardinería', 'Corte de pasto', 'Errázuriz', '45', 'Maule', 'Talca'),
('Limpieza de terraza', 'Limpieza y orden de terraza y quincho.', 19000, '2026-12-20T11:00:00', 'Hogar', 'Limpieza general', 'Baquedano', '88', 'Magallanes y de la Antártica Chilena', 'Punta Arenas'),
('Trámite y retiro de documentos', 'Retirar documentos y entregarlos en domicilio.', 16000, '2026-12-22T14:30:00', 'Trámites', 'Ayuda con trámite', 'Condell', '150', 'Valparaíso', 'Viña del Mar'),
('Configurar red wifi', 'Configurar router y conectar dispositivos del hogar.', 25000, '2026-12-28T17:00:00', 'Tecnología', 'Instalación de computador', 'Baquedano', '300', 'Antofagasta', 'Calama');

DECLARE @i int = 1;
DECLARE @total int = (SELECT COUNT(*) FROM @datos);
DECLARE @categoriaId int;
DECLARE @nombreId int;
DECLARE @regionId int;
DECLARE @comunaId int;
DECLARE @direccionId int;
DECLARE @titulo varchar(100);
DECLARE @descripcion varchar(500);
DECLARE @monto decimal(10,2);
DECLARE @inicio datetime;
DECLARE @calle varchar(200);
DECLARE @numero varchar(20);
DECLARE @nuevasDirecciones TABLE (id_direccion int);

WHILE @i <= @total
BEGIN
    SET @categoriaId = NULL;
    SET @nombreId = NULL;
    SET @regionId = NULL;
    SET @comunaId = NULL;
    SET @direccionId = NULL;

    SELECT @titulo=titulo,@descripcion=descripcion,@monto=monto,@inicio=inicio,
           @calle=calle,@numero=numero
    FROM @datos WHERE orden=@i;

    SELECT @categoriaId=ca.id_categoria,@nombreId=nt.id_nombre_tarea
    FROM @datos d
    JOIN dbo.Categoria ca ON ca.nombre_categoria=d.categoria AND ca.estado_categoria=1
    JOIN dbo.NombreTarea nt ON nt.nombre_tarea=d.nombre AND nt.id_categoria_nombre_tarea=ca.id_categoria AND nt.estado_nombre_tarea=1
    WHERE d.orden=@i;

    SELECT @regionId=r.id_region
    FROM @datos d JOIN dbo.Region r ON r.nombre_region=d.region
    WHERE d.orden=@i;

    SELECT @comunaId=co.id_comuna
    FROM @datos d
    JOIN dbo.Ciudad ci ON ci.id_region_ciudad=@regionId
    JOIN dbo.Comuna co ON co.id_ciudad_comuna=ci.id_ciudad AND co.nombre_comuna=d.comuna
    WHERE d.orden=@i;

    IF @categoriaId IS NULL OR @nombreId IS NULL OR @regionId IS NULL OR @comunaId IS NULL
        THROW 51022, 'Falta una categoría, nombre de tarea, región o comuna requerida por los datos demo.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.Tarea WHERE titulo_tarea=@titulo AND id_cliente_tarea=@cliente)
    BEGIN
        DELETE FROM @nuevasDirecciones;
        INSERT dbo.Direccion(calle_direccion, numero_direccion, id_region_direccion, id_comuna_direccion)
        OUTPUT INSERTED.id_direccion INTO @nuevasDirecciones (id_direccion)
        VALUES (@calle, @numero, @regionId, @comunaId);
        SELECT @direccionId=id_direccion FROM @nuevasDirecciones;

        INSERT dbo.Tarea (
            titulo_tarea, descripcion_tarea, pago_ofrecido_tarea,
            fecha_creacion_tarea, fecha_inicio_tarea, id_cliente_tarea,
            id_direccion_tarea, id_categoria_tarea, id_nombre_tarea, id_estado_tarea
        )
        VALUES (
            @titulo, @descripcion, @monto, GETDATE(), @inicio, @cliente,
            @direccionId, @categoriaId, @nombreId, @disponible
        );
    END;

    SET @i=@i+1;
END;
