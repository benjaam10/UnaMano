USE [Proyecto_UnaMano]
GO
IF NOT EXISTS (SELECT 1 FROM dbo.NivelDominio)
BEGIN
    INSERT dbo.NivelDominio(id_niveldominio,nombre_niveldominio) VALUES(1,'Básico'),(2,'Intermedio'),(3,'Avanzado');
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Categoria)
BEGIN
    INSERT dbo.Categoria(nombre_categoria,descripcion_categoria,estado_categoria) VALUES
    ('Hogar','Limpieza, orden y pequeños trabajos del hogar',1),
    ('Trámites','Ayuda con trámites y gestiones cotidianas',1),
    ('Tecnología','Soporte informático y dispositivos',1),
    ('Jardinería','Mantención de jardines y exteriores',1);
END
GO
IF NOT EXISTS (SELECT 1 FROM dbo.NombreTarea)
BEGIN
    INSERT dbo.NombreTarea(nombre_tarea,descripcion_nombre_tarea,id_categoria_nombre_tarea,estado_nombre_tarea)
    SELECT 'Limpieza general','Limpieza básica de un domicilio',id_categoria,1 FROM dbo.Categoria WHERE nombre_categoria='Hogar';
    INSERT dbo.NombreTarea(nombre_tarea,descripcion_nombre_tarea,id_categoria_nombre_tarea,estado_nombre_tarea)
    SELECT 'Ayuda con trámite','Acompañamiento o gestión de un trámite',id_categoria,1 FROM dbo.Categoria WHERE nombre_categoria='Trámites';
    INSERT dbo.NombreTarea(nombre_tarea,descripcion_nombre_tarea,id_categoria_nombre_tarea,estado_nombre_tarea)
    SELECT 'Instalación de computador','Configuración básica de equipos',id_categoria,1 FROM dbo.Categoria WHERE nombre_categoria='Tecnología';
    INSERT dbo.NombreTarea(nombre_tarea,descripcion_nombre_tarea,id_categoria_nombre_tarea,estado_nombre_tarea)
    SELECT 'Corte de pasto','Mantención básica del jardín',id_categoria,1 FROM dbo.Categoria WHERE nombre_categoria='Jardinería';
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Habilidad)
BEGIN
    INSERT dbo.Habilidad(nombre_habilidad) VALUES('Limpieza'),('Jardinería'),('Soporte informático'),('Trámites'),('Pintura'),('Armado de muebles');
END
GO
