USE [Proyecto_UnaMano];
GO

/*
  Datos geográficos de uso inicial y tres cuentas demo.
  Este script es idempotente: se puede ejecutar nuevamente sin duplicar
  regiones, ciudades, comunas ni cuentas.
*/
IF NOT EXISTS (SELECT 1 FROM dbo.Rol WHERE nombre_rol = 'Admin')
    INSERT dbo.Rol(nombre_rol) VALUES ('Admin');
IF NOT EXISTS (SELECT 1 FROM dbo.Rol WHERE nombre_rol = 'Cliente')
    INSERT dbo.Rol(nombre_rol) VALUES ('Cliente');
IF NOT EXISTS (SELECT 1 FROM dbo.Rol WHERE nombre_rol = 'Estudiante')
    INSERT dbo.Rol(nombre_rol) VALUES ('Estudiante');
GO

DECLARE @regiones TABLE (nombre varchar(100) NOT NULL);
INSERT INTO @regiones VALUES
('Arica y Parinacota'), ('Tarapacá'), ('Antofagasta'), ('Atacama'),
('Coquimbo'), ('Valparaíso'), ('Metropolitana de Santiago'), ('O''Higgins'),
('Maule'), ('Ñuble'), ('Biobío'), ('La Araucanía'), ('Los Ríos'),
('Los Lagos'), ('Aysén'), ('Magallanes y de la Antártica Chilena');

INSERT INTO dbo.Region (nombre_region)
SELECT r.nombre
FROM @regiones r
WHERE NOT EXISTS (SELECT 1 FROM dbo.Region x WHERE x.nombre_region = r.nombre);
GO

DECLARE @ciudades TABLE (region varchar(100), ciudad varchar(100));
INSERT INTO @ciudades VALUES
('Arica y Parinacota','Arica'), ('Tarapacá','Iquique'), ('Antofagasta','Antofagasta'),
('Atacama','Copiapó'), ('Coquimbo','La Serena'), ('Valparaíso','Valparaíso'),
('Metropolitana de Santiago','Santiago'), ('O''Higgins','Rancagua'), ('Maule','Talca'),
('Ñuble','Chillán'), ('Biobío','Concepción'), ('La Araucanía','Temuco'),
('Los Ríos','Valdivia'), ('Los Lagos','Puerto Montt'), ('Aysén','Coyhaique'),
('Magallanes y de la Antártica Chilena','Punta Arenas');

INSERT INTO dbo.Ciudad (nombre_ciudad, id_region_ciudad)
SELECT c.ciudad, r.id_region
FROM @ciudades c
JOIN dbo.Region r ON r.nombre_region = c.region
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.Ciudad x
    WHERE x.nombre_ciudad = c.ciudad AND x.id_region_ciudad = r.id_region
);
GO

DECLARE @comunas TABLE (region varchar(100), ciudad varchar(100), comuna varchar(100));
INSERT INTO @comunas VALUES
('Arica y Parinacota','Arica','Arica'),
('Tarapacá','Iquique','Iquique'), ('Tarapacá','Iquique','Alto Hospicio'),
('Antofagasta','Antofagasta','Antofagasta'), ('Antofagasta','Antofagasta','Calama'),
('Atacama','Copiapó','Copiapó'), ('Atacama','Copiapó','Vallenar'),
('Coquimbo','La Serena','La Serena'), ('Coquimbo','La Serena','Coquimbo'),
('Coquimbo','La Serena','Ovalle'),
('Valparaíso','Valparaíso','Valparaíso'), ('Valparaíso','Valparaíso','Viña del Mar'),
('Valparaíso','Valparaíso','Quilpué'), ('Valparaíso','Valparaíso','Villa Alemana'),
('Metropolitana de Santiago','Santiago','Santiago'), ('Metropolitana de Santiago','Santiago','Maipú'),
('Metropolitana de Santiago','Santiago','Las Condes'), ('Metropolitana de Santiago','Santiago','Providencia'),
('Metropolitana de Santiago','Santiago','Puente Alto'), ('Metropolitana de Santiago','Santiago','Ñuñoa'),
('O''Higgins','Rancagua','Rancagua'), ('O''Higgins','Rancagua','San Fernando'),
('Maule','Talca','Talca'), ('Maule','Talca','Curicó'), ('Maule','Talca','Linares'),
('Ñuble','Chillán','Chillán'), ('Ñuble','Chillán','San Carlos'),
('Biobío','Concepción','Concepción'), ('Biobío','Concepción','Talcahuano'),
('Biobío','Concepción','Los Ángeles'), ('Biobío','Concepción','San Pedro de la Paz'),
('La Araucanía','Temuco','Temuco'), ('La Araucanía','Temuco','Villarrica'),
('La Araucanía','Temuco','Angol'), ('La Araucanía','Temuco','Pucón'),
('Los Ríos','Valdivia','Valdivia'), ('Los Ríos','Valdivia','La Unión'),
('Los Lagos','Puerto Montt','Puerto Montt'), ('Los Lagos','Puerto Montt','Osorno'),
('Los Lagos','Puerto Montt','Castro'), ('Los Lagos','Puerto Montt','Puerto Varas'),
('Aysén','Coyhaique','Coyhaique'), ('Aysén','Coyhaique','Puerto Aysén'),
('Magallanes y de la Antártica Chilena','Punta Arenas','Punta Arenas'),
('Magallanes y de la Antártica Chilena','Punta Arenas','Puerto Natales');

INSERT INTO dbo.Comuna (nombre_comuna, id_ciudad_comuna)
SELECT c.comuna, ci.id_ciudad
FROM @comunas c
JOIN dbo.Region r ON r.nombre_region = c.region
JOIN dbo.Ciudad ci ON ci.nombre_ciudad = c.ciudad AND ci.id_region_ciudad = r.id_region
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.Comuna x
    WHERE x.nombre_comuna = c.comuna AND x.id_ciudad_comuna = ci.id_ciudad
);
GO

/*
  Cuentas demo:
  cliente@demo.cl / cliente123
  estudiante@demo.cl / estudiante123
  admin@demo.cl / admin123
*/
DECLARE @idRegion int = (SELECT TOP 1 id_region FROM dbo.Region WHERE nombre_region = 'Metropolitana de Santiago');
DECLARE @idComuna int = (
    SELECT TOP 1 co.id_comuna
    FROM dbo.Comuna co
    JOIN dbo.Ciudad ci ON ci.id_ciudad = co.id_ciudad_comuna
    WHERE co.nombre_comuna = 'Santiago' AND ci.id_region_ciudad = @idRegion
);
DECLARE @idRolCliente int = (SELECT id_rol FROM dbo.Rol WHERE nombre_rol = 'Cliente');
DECLARE @idRolEstudiante int = (SELECT id_rol FROM dbo.Rol WHERE nombre_rol = 'Estudiante');
DECLARE @idRolAdmin int = (SELECT id_rol FROM dbo.Rol WHERE nombre_rol = 'Admin');
DECLARE @idDireccion int;
DECLARE @idPersona int;

IF NOT EXISTS (SELECT 1 FROM dbo.Usuario WHERE email_usuario = 'cliente@demo.cl')
BEGIN
    INSERT dbo.Direccion(calle_direccion, numero_direccion, dpto_direccion, referencia_direccion, id_region_direccion, id_comuna_direccion)
    VALUES ('Alameda', '100', NULL, 'Cuenta demo cliente', @idRegion, @idComuna);
    SET @idDireccion = SCOPE_IDENTITY();
    INSERT dbo.Cliente(rut_cliente, nombre1_cliente, nombre2_cliente, apellido1_cliente, apellido2_cliente,
        fechanacimiento_cliente, telefono_cliente, email_cliente, id_direccion_cliente, estado_cliente)
    VALUES ('11111111-1', 'Cliente', NULL, 'Demo', NULL, '1995-01-01', '912345678',
        'cliente@demo.cl', @idDireccion, 1);
    SET @idPersona = SCOPE_IDENTITY();
    INSERT dbo.Usuario(email_usuario, password_hash_usuario, id_rol_usuario, id_cliente_usuario, id_estudiante_usuario, estado_usuario)
    VALUES ('cliente@demo.cl', 'scrypt$16384$8$1$bENOoHZUKkh4ZO0g7Eq8Ow==$-yMqsiECIrG3IATVQFM1JtGRIlOGZrttgS0k1GwUhR8P9heyBAEkxbhZ_lGIRKc4UWC4RzkwDMPMFUSw8MVaTw==', @idRolCliente, @idPersona, NULL, 1);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Usuario WHERE email_usuario = 'estudiante@demo.cl')
BEGIN
    INSERT dbo.Direccion(calle_direccion, numero_direccion, dpto_direccion, referencia_direccion, id_region_direccion, id_comuna_direccion)
    VALUES ('Vicuña Mackenna', '200', NULL, 'Cuenta demo estudiante', @idRegion, @idComuna);
    SET @idDireccion = SCOPE_IDENTITY();
    INSERT dbo.Estudiante(rut_estudiante, nombre1_estudiante, nombre2_estudiante, apellido1_estudiante, apellido2_estudiante,
        fechanacimiento_estudiante, telefono_estudiante, id_direccion_estudiante, email_estudiante, universidad_estudiante, carrera_estudiante, estado_alumno)
    VALUES ('22222222-2', 'Estudiante', NULL, 'Demo', NULL, '2000-01-01', '923456789',
        @idDireccion, 'estudiante@demo.cl', 'Universidad San Sebastián', 'Ingeniería Civil Informática', 1);
    SET @idPersona = SCOPE_IDENTITY();
    INSERT dbo.Usuario(email_usuario, password_hash_usuario, id_rol_usuario, id_cliente_usuario, id_estudiante_usuario, estado_usuario)
    VALUES ('estudiante@demo.cl', 'scrypt$16384$8$1$sSAtHvzNEYJedrA_CqNOzg==$Ho1o1cO287SLyttyYqEyGKIQJ7D2MYheePy97gYWFUiuHWe14H5fS-BEOQ7ffJPX5IAkVHzmwg5NAXqjnT9A2A==', @idRolEstudiante, NULL, @idPersona, 1);
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Usuario WHERE email_usuario = 'admin@demo.cl')
BEGIN
    INSERT dbo.Usuario(email_usuario, password_hash_usuario, id_rol_usuario, id_cliente_usuario, id_estudiante_usuario, estado_usuario)
    VALUES ('admin@demo.cl', 'scrypt$16384$8$1$F132GX29__IVyeOE7UHVIg==$pWHCE-CjmO5yzYyoc-OFqkd9Vctulcd5R4kGMYHWpB3aQFl3BxBA8i7DIFkQz9ABKoAiZGE_MHCHyVr1ppv34A==', @idRolAdmin, NULL, NULL, 1);
END;
GO

SELECT email_usuario, r.nombre_rol, estado_usuario
FROM dbo.Usuario u
JOIN dbo.Rol r ON r.id_rol = u.id_rol_usuario
WHERE email_usuario IN ('cliente@demo.cl', 'estudiante@demo.cl', 'admin@demo.cl');
