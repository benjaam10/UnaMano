/* Instalación integral de Proyecto_UnaMano para una base nueva.
   Crea esquema, datos maestros y cuentas demo. Agrega Santiago como localidad mínima
   para las direcciones demo; usa el segundo script para cargar el resto de localidades y tareas.
   Ejecútalo una sola vez con permisos para crear bases de datos. */
USE [master]
GO
IF DB_ID(N'Proyecto_UnaMano') IS NOT NULL
BEGIN
    THROW 51000, 'La base Proyecto_UnaMano ya existe. Usa una instancia nueva para esta instalación.', 1;
END
GO
CREATE DATABASE [Proyecto_UnaMano];
GO
USE [Proyecto_UnaMano]
GO
/****** Objeto: Table [dbo].[Categoria] Fecha de script: 01-11-2026 18:45:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categoria](
	[id_categoria] [int] IDENTITY(1,1) NOT NULL,
	[nombre_categoria] [varchar](50) NOT NULL,
	[descripcion_categoria] [varchar](200) NOT NULL,
 CONSTRAINT [PK__Categori__CD54BC5AEC373156] PRIMARY KEY CLUSTERED 
(
	[id_categoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Ciudad] Fecha de script: 01-11-2026 18:45:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ciudad](
	[id_ciudad] [int] IDENTITY(1,1) NOT NULL,
	[nombre_ciudad] [varchar](100) NOT NULL,
	[id_region_ciudad] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_ciudad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Cliente] Fecha de script: 01-11-2026 18:45:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cliente](
	[id_cliente] [int] IDENTITY(1,1) NOT NULL,
	[rut_cliente] [varchar](12) NOT NULL,
	[nombre1_cliente] [varchar](50) NOT NULL,
	[nombre2_cliente] [varchar](50) NULL,
	[apellido1_cliente] [varchar](50) NOT NULL,
	[apellido2_cliente] [varbinary](50) NULL,
	[fechanacimiento_cliente] [date] NULL,
	[telefono_cliente] [varchar](15) NOT NULL,
	[email_cliente] [varchar](100) NOT NULL,
	[id_direccion_cliente] [int] NOT NULL,
 CONSTRAINT [PK__Cliente__677F38F514CF8EA6] PRIMARY KEY CLUSTERED 
(
	[id_cliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__Cliente__DD4F5D638108180E] UNIQUE NONCLUSTERED 
(
	[rut_cliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Comuna] Fecha de script: 01-11-2026 18:45:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comuna](
	[id_comuna] [int] IDENTITY(1,1) NOT NULL,
	[nombre_comuna] [varchar](100) NOT NULL,
	[id_ciudad_comuna] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_comuna] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Direccion] Fecha de script: 01-11-2026 18:45:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Direccion](
	[id_direccion] [int] IDENTITY(1,1) NOT NULL,
	[calle_direccion] [varchar](200) NOT NULL,
	[numero_direccion] [varchar](20) NOT NULL,
	[dpto_direccion] [varchar](50) NULL,
	[referencia_direccion] [nvarchar](200) NULL,
	[id_region_direccion] [int] NOT NULL,
 CONSTRAINT [PK__Direccio__25C35D075F823DEA] PRIMARY KEY CLUSTERED 
(
	[id_direccion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[EstadoPostulacion] Fecha de script: 01-11-2026 18:45:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadoPostulacion](
	[id_estadopostulacion] [int] IDENTITY(1,1) NOT NULL,
	[nombre_estadopostulacion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_EstadoPostulacion] PRIMARY KEY CLUSTERED 
(
	[id_estadopostulacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[EstadoTarea] Fecha de script: 01-11-2026 18:45:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstadoTarea](
	[id_estado] [int] IDENTITY(1,1) NOT NULL,
	[nombre_estado] [varchar](50) NOT NULL,
 CONSTRAINT [PK__Estado_T__86989FB2C17D98E7] PRIMARY KEY CLUSTERED 
(
	[id_estado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Estudiante] Fecha de script: 01-11-2026 18:45:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Estudiante](
	[id_estudiante] [int] IDENTITY(1,1) NOT NULL,
	[rut_estudiante] [varchar](12) NOT NULL,
	[nombre1_estudiante] [varchar](50) NOT NULL,
	[nombre2_estudiante] [varchar](50) NULL,
	[apellido1_estudiante] [varchar](50) NOT NULL,
	[apellido2_estudiante] [varchar](50) NULL,
	[fechanacimiento_estudiante] [date] NOT NULL,
	[telefono_estudiante] [varchar](15) NOT NULL,
	[id_direccion_estudiante] [int] NOT NULL,
	[email_estudiante] [varchar](100) NOT NULL,
	[universidad_estudiante] [varchar](100) NOT NULL,
	[carrera_estudiante] [varchar](100) NOT NULL,
 CONSTRAINT [PK__Estudian__E0B2763CD77BBEFA] PRIMARY KEY CLUSTERED 
(
	[id_estudiante] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__Estudian__7E3ECC642C2384FB] UNIQUE NONCLUSTERED 
(
	[email_estudiante] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ__Estudian__D1BB648217A37148] UNIQUE NONCLUSTERED 
(
	[rut_estudiante] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[EstudianteHabilidad] Fecha de script: 01-11-2026 18:45:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstudianteHabilidad](
	[id_eh] [int] IDENTITY(1,1) NOT NULL,
	[id_estudiante_eh] [int] NOT NULL,
	[id_habilidad_eh] [int] NOT NULL,
	[id_niveldominio_eh] [int] NOT NULL,
 CONSTRAINT [PK__Estudian__00B7CEBE78B3BFBF] PRIMARY KEY CLUSTERED 
(
	[id_eh] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Habilidad] Fecha de script: 01-11-2026 18:45:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Habilidad](
	[id_habilidad] [int] IDENTITY(1,1) NOT NULL,
	[nombre_habilidad] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_habilidad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[MedioPago] Fecha de script: 01-11-2026 18:45:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MedioPago](
	[id_mediopago] [int] IDENTITY(1,1) NOT NULL,
	[nombre_mediopago] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_mediopago] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[NivelDominio] Fecha de script: 01-11-2026 18:45:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NivelDominio](
	[id_niveldominio] [int] NOT NULL,
	[nombre_niveldominio] [varchar](20) NOT NULL,
 CONSTRAINT [PK_NivelDominio] PRIMARY KEY CLUSTERED 
(
	[id_niveldominio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Pago] Fecha de script: 01-11-2026 18:45:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pago](
	[id_pago] [int] IDENTITY(1,1) NOT NULL,
	[fecha_pago] [datetime] NOT NULL,
	[monto_neto_pago] [decimal](10, 2) NOT NULL,
	[comision_pago] [decimal](10, 2) NOT NULL,
	[monto_total_pago] [decimal](10, 2) NOT NULL,
	[id_tarea_pago] [int] NOT NULL,
	[id_mediopago_pago] [int] NOT NULL,
 CONSTRAINT [PK__Pago__0941B074A27B23B0] PRIMARY KEY CLUSTERED 
(
	[id_pago] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Postulacion] Fecha de script: 01-11-2026 18:45:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Postulacion](
	[id_postulacion] [int] IDENTITY(1,1) NOT NULL,
	[fecha_postulacion] [datetime] NOT NULL,
	[id_estadopostulacion] [int] NOT NULL,
	[id_tarea_postulacion] [int] NOT NULL,
	[id_estudiante_postulacion] [int] NOT NULL,
 CONSTRAINT [PK__Postulac__533D250ED544147E] PRIMARY KEY CLUSTERED 
(
	[id_postulacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Region] Fecha de script: 01-11-2026 18:45:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Region](
	[id_region] [int] IDENTITY(1,1) NOT NULL,
	[nombre_region] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_region] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[Tarea] Fecha de script: 01-11-2026 18:45:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tarea](
	[id_tarea] [int] IDENTITY(1,1) NOT NULL,
	[titulo_tarea] [varchar](100) NOT NULL,
	[descripcion_tarea] [varchar](500) NOT NULL,
	[pago_ofrecido_tarea] [decimal](10, 2) NOT NULL,
	[fecha_creacion_tarea] [datetime] NOT NULL,
	[id_cliente_tarea] [int] NOT NULL,
	[id_direccion_tarea] [int] NOT NULL,
	[id_categoria_tarea] [int] NOT NULL,
	[id_estado_tarea] [int] NOT NULL,
 CONSTRAINT [PK__Tarea__C0ECF707C2296674] PRIMARY KEY CLUSTERED 
(
	[id_tarea] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Pago] ADD  CONSTRAINT [DF__Pago__fecha_pago__19DFD96B]  DEFAULT (getdate()) FOR [fecha_pago]
GO
ALTER TABLE [dbo].[Postulacion] ADD  CONSTRAINT [DF__Postulaci__fecha__5BE2A6F2]  DEFAULT (getdate()) FOR [fecha_postulacion]
GO
ALTER TABLE [dbo].[Postulacion] ADD  CONSTRAINT [DF__Postulaci__estad__5CD6CB2B]  DEFAULT ('Pendiente') FOR [id_estadopostulacion]
GO
ALTER TABLE [dbo].[Tarea] ADD  CONSTRAINT [DF__Tarea__fecha_cre__5629CD9C]  DEFAULT (getdate()) FOR [fecha_creacion_tarea]
GO
ALTER TABLE [dbo].[Ciudad]  WITH CHECK ADD  CONSTRAINT [FK_Ciudad_Region] FOREIGN KEY([id_region_ciudad])
REFERENCES [dbo].[Region] ([id_region])
GO
ALTER TABLE [dbo].[Ciudad] CHECK CONSTRAINT [FK_Ciudad_Region]
GO
ALTER TABLE [dbo].[Cliente]  WITH CHECK ADD  CONSTRAINT [FK_Cliente_Direccion] FOREIGN KEY([id_direccion_cliente])
REFERENCES [dbo].[Direccion] ([id_direccion])
GO
ALTER TABLE [dbo].[Cliente] CHECK CONSTRAINT [FK_Cliente_Direccion]
GO
ALTER TABLE [dbo].[Comuna]  WITH CHECK ADD  CONSTRAINT [FK_Comuna_Ciudad] FOREIGN KEY([id_ciudad_comuna])
REFERENCES [dbo].[Ciudad] ([id_ciudad])
GO
ALTER TABLE [dbo].[Comuna] CHECK CONSTRAINT [FK_Comuna_Ciudad]
GO
ALTER TABLE [dbo].[Direccion]  WITH CHECK ADD  CONSTRAINT [FK_Direccion_Region] FOREIGN KEY([id_region_direccion])
REFERENCES [dbo].[Region] ([id_region])
GO
ALTER TABLE [dbo].[Direccion] CHECK CONSTRAINT [FK_Direccion_Region]
GO
ALTER TABLE [dbo].[Estudiante]  WITH CHECK ADD  CONSTRAINT [FK_Estudiante_Direccion] FOREIGN KEY([id_direccion_estudiante])
REFERENCES [dbo].[Direccion] ([id_direccion])
GO
ALTER TABLE [dbo].[Estudiante] CHECK CONSTRAINT [FK_Estudiante_Direccion]
GO
ALTER TABLE [dbo].[EstudianteHabilidad]  WITH CHECK ADD  CONSTRAINT [FK_EH_Estudiante] FOREIGN KEY([id_estudiante_eh])
REFERENCES [dbo].[Estudiante] ([id_estudiante])
GO
ALTER TABLE [dbo].[EstudianteHabilidad] CHECK CONSTRAINT [FK_EH_Estudiante]
GO
ALTER TABLE [dbo].[EstudianteHabilidad]  WITH CHECK ADD  CONSTRAINT [FK_EH_Habilidad] FOREIGN KEY([id_habilidad_eh])
REFERENCES [dbo].[Habilidad] ([id_habilidad])
GO
ALTER TABLE [dbo].[EstudianteHabilidad] CHECK CONSTRAINT [FK_EH_Habilidad]
GO
ALTER TABLE [dbo].[EstudianteHabilidad]  WITH CHECK ADD  CONSTRAINT [FK_EstudianteHabilidad_NivelDominio] FOREIGN KEY([id_niveldominio_eh])
REFERENCES [dbo].[NivelDominio] ([id_niveldominio])
GO
ALTER TABLE [dbo].[EstudianteHabilidad] CHECK CONSTRAINT [FK_EstudianteHabilidad_NivelDominio]
GO
ALTER TABLE [dbo].[Pago]  WITH CHECK ADD  CONSTRAINT [FK_Pago_MedioPago] FOREIGN KEY([id_mediopago_pago])
REFERENCES [dbo].[MedioPago] ([id_mediopago])
GO
ALTER TABLE [dbo].[Pago] CHECK CONSTRAINT [FK_Pago_MedioPago]
GO
ALTER TABLE [dbo].[Pago]  WITH CHECK ADD  CONSTRAINT [FK_Pago_Tarea] FOREIGN KEY([id_tarea_pago])
REFERENCES [dbo].[Tarea] ([id_tarea])
GO
ALTER TABLE [dbo].[Pago] CHECK CONSTRAINT [FK_Pago_Tarea]
GO
ALTER TABLE [dbo].[Postulacion]  WITH CHECK ADD  CONSTRAINT [FK_Postulacion_EstadoPostulacion] FOREIGN KEY([id_estadopostulacion])
REFERENCES [dbo].[EstadoPostulacion] ([id_estadopostulacion])
GO
ALTER TABLE [dbo].[Postulacion] CHECK CONSTRAINT [FK_Postulacion_EstadoPostulacion]
GO
ALTER TABLE [dbo].[Postulacion]  WITH CHECK ADD  CONSTRAINT [FK_Postulacion_Estudiante1] FOREIGN KEY([id_estudiante_postulacion])
REFERENCES [dbo].[Estudiante] ([id_estudiante])
GO
ALTER TABLE [dbo].[Postulacion] CHECK CONSTRAINT [FK_Postulacion_Estudiante1]
GO
ALTER TABLE [dbo].[Postulacion]  WITH CHECK ADD  CONSTRAINT [FK_Postulacion_Tarea1] FOREIGN KEY([id_tarea_postulacion])
REFERENCES [dbo].[Tarea] ([id_tarea])
GO
ALTER TABLE [dbo].[Postulacion] CHECK CONSTRAINT [FK_Postulacion_Tarea1]
GO
ALTER TABLE [dbo].[Tarea]  WITH CHECK ADD  CONSTRAINT [FK_Tarea_Categoria1] FOREIGN KEY([id_categoria_tarea])
REFERENCES [dbo].[Categoria] ([id_categoria])
GO
ALTER TABLE [dbo].[Tarea] CHECK CONSTRAINT [FK_Tarea_Categoria1]
GO
ALTER TABLE [dbo].[Tarea]  WITH CHECK ADD  CONSTRAINT [FK_Tarea_Cliente1] FOREIGN KEY([id_cliente_tarea])
REFERENCES [dbo].[Cliente] ([id_cliente])
GO
ALTER TABLE [dbo].[Tarea] CHECK CONSTRAINT [FK_Tarea_Cliente1]
GO
ALTER TABLE [dbo].[Tarea]  WITH CHECK ADD  CONSTRAINT [FK_Tarea_Direccion] FOREIGN KEY([id_direccion_tarea])
REFERENCES [dbo].[Direccion] ([id_direccion])
GO
ALTER TABLE [dbo].[Tarea] CHECK CONSTRAINT [FK_Tarea_Direccion]
GO
ALTER TABLE [dbo].[Tarea]  WITH CHECK ADD  CONSTRAINT [FK_Tarea_Estado_Tarea] FOREIGN KEY([id_estado_tarea])
REFERENCES [dbo].[EstadoTarea] ([id_estado])
GO
ALTER TABLE [dbo].[Tarea] CHECK CONSTRAINT [FK_Tarea_Estado_Tarea]
GO
USE [master]
GO
ALTER DATABASE [Proyecto_UnaMano] SET  READ_WRITE 
GO

USE [Proyecto_UnaMano]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* ================================================================
   EXTENSIONES: no elimina ni renombra entidades/atributos existentes.
   ================================================================ */

IF COL_LENGTH('dbo.Cliente','estado_cliente') IS NULL
    ALTER TABLE dbo.Cliente ADD estado_cliente bit NOT NULL CONSTRAINT DF_Cliente_estado_cliente DEFAULT(1);
GO
IF COL_LENGTH('dbo.Estudiante','estado_alumno') IS NULL
    ALTER TABLE dbo.Estudiante ADD estado_alumno bit NOT NULL CONSTRAINT DF_Estudiante_estado_alumno DEFAULT(1);
GO
IF COL_LENGTH('dbo.Direccion','id_comuna_direccion') IS NULL
    ALTER TABLE dbo.Direccion ADD id_comuna_direccion int NULL;
GO
IF COL_LENGTH('dbo.Tarea','fecha_inicio_tarea') IS NULL
    ALTER TABLE dbo.Tarea ADD fecha_inicio_tarea datetime NULL;
GO
IF COL_LENGTH('dbo.Tarea','id_nombre_tarea') IS NULL
    ALTER TABLE dbo.Tarea ADD id_nombre_tarea int NULL;
GO
IF COL_LENGTH('dbo.Tarea','fecha_inicio_tarea') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM sys.default_constraints WHERE parent_object_id=OBJECT_ID('dbo.Tarea') AND name='DF_Tarea_fecha_inicio_tarea')
        ALTER TABLE dbo.Tarea ADD CONSTRAINT DF_Tarea_fecha_inicio_tarea DEFAULT (DATEADD(day,1,GETDATE())) FOR fecha_inicio_tarea;
    UPDATE dbo.Tarea SET fecha_inicio_tarea=DATEADD(day,1,GETDATE()) WHERE fecha_inicio_tarea IS NULL;
    ALTER TABLE dbo.Tarea ALTER COLUMN fecha_inicio_tarea datetime NOT NULL;
END
GO

IF OBJECT_ID('dbo.Rol','U') IS NULL
CREATE TABLE dbo.Rol(
    id_rol int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre_rol varchar(30) NOT NULL UNIQUE,
    estado_rol bit NOT NULL DEFAULT(1)
);
GO
IF OBJECT_ID('dbo.Usuario','U') IS NULL
CREATE TABLE dbo.Usuario(
    id_usuario int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    email_usuario varchar(100) NOT NULL UNIQUE,
    password_hash_usuario varchar(500) NOT NULL,
    id_rol_usuario int NOT NULL,
    id_cliente_usuario int NULL,
    id_estudiante_usuario int NULL,
    estado_usuario bit NOT NULL DEFAULT(1),
    fecha_creacion_usuario datetime NOT NULL DEFAULT(GETDATE()),
    CONSTRAINT FK_Usuario_Rol FOREIGN KEY(id_rol_usuario) REFERENCES dbo.Rol(id_rol),
    CONSTRAINT FK_Usuario_Cliente FOREIGN KEY(id_cliente_usuario) REFERENCES dbo.Cliente(id_cliente),
    CONSTRAINT FK_Usuario_Estudiante FOREIGN KEY(id_estudiante_usuario) REFERENCES dbo.Estudiante(id_estudiante),
    CONSTRAINT CK_Usuario_UnPerfil CHECK (
        (id_cliente_usuario IS NULL AND id_estudiante_usuario IS NULL) OR
        (id_cliente_usuario IS NOT NULL AND id_estudiante_usuario IS NULL) OR
        (id_cliente_usuario IS NULL AND id_estudiante_usuario IS NOT NULL)
    )
);
GO

IF OBJECT_ID('dbo.NombreTarea','U') IS NULL
CREATE TABLE dbo.NombreTarea(
    id_nombre_tarea int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre_tarea varchar(100) NOT NULL,
    descripcion_nombre_tarea varchar(300) NULL,
    id_categoria_nombre_tarea int NOT NULL,
    estado_nombre_tarea bit NOT NULL DEFAULT(1),
    CONSTRAINT FK_NombreTarea_Categoria FOREIGN KEY(id_categoria_nombre_tarea) REFERENCES dbo.Categoria(id_categoria),
    CONSTRAINT UQ_NombreTarea_Categoria UNIQUE(nombre_tarea,id_categoria_nombre_tarea)
);
GO

IF COL_LENGTH('dbo.Categoria','estado_categoria') IS NULL
    ALTER TABLE dbo.Categoria ADD estado_categoria bit NOT NULL CONSTRAINT DF_Categoria_estado_categoria DEFAULT(1);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Direccion_Comuna')
ALTER TABLE dbo.Direccion WITH CHECK ADD CONSTRAINT FK_Direccion_Comuna FOREIGN KEY(id_comuna_direccion) REFERENCES dbo.Comuna(id_comuna);
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Tarea_NombreTarea')
ALTER TABLE dbo.Tarea WITH CHECK ADD CONSTRAINT FK_Tarea_NombreTarea FOREIGN KEY(id_nombre_tarea) REFERENCES dbo.NombreTarea(id_nombre_tarea);
GO
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Direccion_Comuna_Region_Consistencia')
BEGIN
    /* La consistencia región/comuna se valida en procedimientos de escritura. */
END
GO

IF OBJECT_ID('dbo.Conversacion','U') IS NULL
CREATE TABLE dbo.Conversacion(
    id_conversacion int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_tarea_conversacion int NOT NULL,
    id_cliente_conversacion int NOT NULL,
    id_estudiante_conversacion int NOT NULL,
    fecha_creacion_conversacion datetime NOT NULL DEFAULT(GETDATE()),
    estado_conversacion bit NOT NULL DEFAULT(1),
    CONSTRAINT FK_Conversacion_Tarea FOREIGN KEY(id_tarea_conversacion) REFERENCES dbo.Tarea(id_tarea),
    CONSTRAINT FK_Conversacion_Cliente FOREIGN KEY(id_cliente_conversacion) REFERENCES dbo.Cliente(id_cliente),
    CONSTRAINT FK_Conversacion_Estudiante FOREIGN KEY(id_estudiante_conversacion) REFERENCES dbo.Estudiante(id_estudiante),
    CONSTRAINT UQ_Conversacion_Tarea_Estudiante UNIQUE(id_tarea_conversacion,id_estudiante_conversacion)
);
GO
IF OBJECT_ID('dbo.Mensaje','U') IS NULL
CREATE TABLE dbo.Mensaje(
    id_mensaje int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_conversacion_mensaje int NOT NULL,
    id_usuario_emisor_mensaje int NOT NULL,
    contenido_mensaje varchar(2000) NOT NULL,
    fecha_mensaje datetime NOT NULL DEFAULT(GETDATE()),
    CONSTRAINT FK_Mensaje_Conversacion FOREIGN KEY(id_conversacion_mensaje) REFERENCES dbo.Conversacion(id_conversacion),
    CONSTRAINT FK_Mensaje_Usuario FOREIGN KEY(id_usuario_emisor_mensaje) REFERENCES dbo.Usuario(id_usuario)
);
GO
IF OBJECT_ID('dbo.HistorialTarea','U') IS NULL
CREATE TABLE dbo.HistorialTarea(
    id_historial_tarea int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_tarea_historial int NOT NULL,
    estado_anterior_historial varchar(50) NULL,
    estado_nuevo_historial varchar(50) NOT NULL,
    fecha_historial_tarea datetime NOT NULL DEFAULT(GETDATE()),
    tipo_evento_historial varchar(50) NOT NULL,
    id_usuario_historial int NULL,
    detalle_historial varchar(500) NULL,
    CONSTRAINT FK_HistorialTarea_Tarea FOREIGN KEY(id_tarea_historial) REFERENCES dbo.Tarea(id_tarea),
    CONSTRAINT FK_HistorialTarea_Usuario FOREIGN KEY(id_usuario_historial) REFERENCES dbo.Usuario(id_usuario)
);
GO
IF OBJECT_ID('dbo.Penalizacion','U') IS NULL
CREATE TABLE dbo.Penalizacion(
    id_penalizacion int IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_estudiante_penalizacion int NOT NULL,
    id_tarea_penalizacion int NOT NULL,
    fecha_penalizacion datetime NOT NULL DEFAULT(GETDATE()),
    puntos_penalizacion int NOT NULL DEFAULT(1),
    motivo_penalizacion varchar(300) NOT NULL,
    CONSTRAINT FK_Penalizacion_Estudiante FOREIGN KEY(id_estudiante_penalizacion) REFERENCES dbo.Estudiante(id_estudiante),
    CONSTRAINT FK_Penalizacion_Tarea FOREIGN KEY(id_tarea_penalizacion) REFERENCES dbo.Tarea(id_tarea)
);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='UX_Pago_id_tarea_pago' AND object_id=OBJECT_ID('dbo.Pago'))
CREATE UNIQUE INDEX UX_Pago_id_tarea_pago ON dbo.Pago(id_tarea_pago);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='UX_Cliente_email_activo' AND object_id=OBJECT_ID('dbo.Cliente'))
CREATE UNIQUE INDEX UX_Cliente_email_activo ON dbo.Cliente(email_cliente);
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Postulacion_Tarea_Estudiante' AND object_id=OBJECT_ID('dbo.Postulacion'))
CREATE INDEX IX_Postulacion_Tarea_Estudiante ON dbo.Postulacion(id_tarea_postulacion,id_estudiante_postulacion,id_estadopostulacion);
GO

/* Estados/roles maestros */
IF NOT EXISTS (SELECT 1 FROM dbo.Rol WHERE nombre_rol='Admin') INSERT dbo.Rol(nombre_rol) VALUES('Admin');
IF NOT EXISTS (SELECT 1 FROM dbo.Rol WHERE nombre_rol='Cliente') INSERT dbo.Rol(nombre_rol) VALUES('Cliente');
IF NOT EXISTS (SELECT 1 FROM dbo.Rol WHERE nombre_rol='Estudiante') INSERT dbo.Rol(nombre_rol) VALUES('Estudiante');
GO
IF NOT EXISTS (SELECT 1 FROM dbo.EstadoPostulacion WHERE nombre_estadopostulacion='Pendiente') INSERT dbo.EstadoPostulacion(nombre_estadopostulacion) VALUES('Pendiente');
IF NOT EXISTS (SELECT 1 FROM dbo.EstadoPostulacion WHERE nombre_estadopostulacion='Aceptada') INSERT dbo.EstadoPostulacion(nombre_estadopostulacion) VALUES('Aceptada');
IF NOT EXISTS (SELECT 1 FROM dbo.EstadoPostulacion WHERE nombre_estadopostulacion='Rechazada') INSERT dbo.EstadoPostulacion(nombre_estadopostulacion) VALUES('Rechazada');
IF NOT EXISTS (SELECT 1 FROM dbo.EstadoPostulacion WHERE nombre_estadopostulacion='Cancelada') INSERT dbo.EstadoPostulacion(nombre_estadopostulacion) VALUES('Cancelada');
GO
IF NOT EXISTS (SELECT 1 FROM dbo.EstadoTarea WHERE nombre_estado='Disponible') INSERT dbo.EstadoTarea(nombre_estado) VALUES('Disponible');
IF NOT EXISTS (SELECT 1 FROM dbo.EstadoTarea WHERE nombre_estado='Asignada') INSERT dbo.EstadoTarea(nombre_estado) VALUES('Asignada');
IF NOT EXISTS (SELECT 1 FROM dbo.EstadoTarea WHERE nombre_estado='Finalizada') INSERT dbo.EstadoTarea(nombre_estado) VALUES('Finalizada');
IF NOT EXISTS (SELECT 1 FROM dbo.EstadoTarea WHERE nombre_estado='Cancelada') INSERT dbo.EstadoTarea(nombre_estado) VALUES('Cancelada');
IF NOT EXISTS (SELECT 1 FROM dbo.EstadoTarea WHERE nombre_estado='Vencida') INSERT dbo.EstadoTarea(nombre_estado) VALUES('Vencida');
GO
IF NOT EXISTS (SELECT 1 FROM dbo.MedioPago WHERE nombre_mediopago='Pago de demostración') INSERT dbo.MedioPago(nombre_mediopago) VALUES('Pago de demostración');
GO

/* Vistas */
CREATE OR ALTER VIEW dbo.vw_TareaPlazo AS
SELECT t.id_tarea,
       t.fecha_creacion_tarea,
       t.fecha_inicio_tarea,
       DATEDIFF(MINUTE,t.fecha_creacion_tarea,t.fecha_inicio_tarea)/60.0 AS horas_anticipacion_publicacion,
       CASE
         WHEN DATEDIFF(MINUTE,t.fecha_creacion_tarea,t.fecha_inicio_tarea) > 10080 THEN DATEADD(HOUR,-48,t.fecha_inicio_tarea)
         WHEN DATEDIFF(MINUTE,t.fecha_creacion_tarea,t.fecha_inicio_tarea) > 4320 THEN DATEADD(HOUR,-24,t.fecha_inicio_tarea)
         WHEN DATEDIFF(MINUTE,t.fecha_creacion_tarea,t.fecha_inicio_tarea) > 1440 THEN DATEADD(HOUR,-8,t.fecha_inicio_tarea)
         WHEN DATEDIFF(MINUTE,t.fecha_creacion_tarea,t.fecha_inicio_tarea) > 480 THEN DATEADD(HOUR,-4,t.fecha_inicio_tarea)
         ELSE t.fecha_inicio_tarea
       END AS fecha_limite_aprobacion
FROM dbo.Tarea t;
GO
CREATE OR ALTER VIEW dbo.vw_AdminTareas AS
SELECT t.id_tarea,t.titulo_tarea,t.descripcion_tarea,t.pago_ofrecido_tarea,t.fecha_creacion_tarea,t.fecha_inicio_tarea,
       et.nombre_estado,ca.nombre_categoria,nt.nombre_tarea,
       c.id_cliente,c.nombre1_cliente,c.apellido1_cliente,
       d.calle_direccion,d.numero_direccion,r.nombre_region,co.nombre_comuna,ci.nombre_ciudad,
       vp.fecha_limite_aprobacion,
       CASE WHEN EXISTS(SELECT 1 FROM dbo.Postulacion p WHERE p.id_tarea_postulacion=t.id_tarea AND p.id_estadopostulacion=(SELECT id_estadopostulacion FROM dbo.EstadoPostulacion WHERE nombre_estadopostulacion='Aceptada')) THEN 1 ELSE 0 END AS tiene_aceptada
FROM dbo.Tarea t
JOIN dbo.EstadoTarea et ON et.id_estado=t.id_estado_tarea
JOIN dbo.Categoria ca ON ca.id_categoria=t.id_categoria_tarea
LEFT JOIN dbo.NombreTarea nt ON nt.id_nombre_tarea=t.id_nombre_tarea
JOIN dbo.Cliente c ON c.id_cliente=t.id_cliente_tarea
JOIN dbo.Direccion d ON d.id_direccion=t.id_direccion_tarea
JOIN dbo.Region r ON r.id_region=d.id_region_direccion
LEFT JOIN dbo.Comuna co ON co.id_comuna=d.id_comuna_direccion
LEFT JOIN dbo.Ciudad ci ON ci.id_ciudad=co.id_ciudad_comuna
LEFT JOIN dbo.vw_TareaPlazo vp ON vp.id_tarea=t.id_tarea;
GO

/* Procedimiento: postular */
CREATE OR ALTER PROCEDURE dbo.sp_CrearPostulacion @id_tarea int, @id_estudiante int
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    BEGIN TRAN;
    DECLARE @disp int=(SELECT id_estado FROM dbo.EstadoTarea WHERE nombre_estado='Disponible');
    DECLARE @pend int=(SELECT id_estadopostulacion FROM dbo.EstadoPostulacion WHERE nombre_estadopostulacion='Pendiente');
    DECLARE @accepted int=(SELECT id_estadopostulacion FROM dbo.EstadoPostulacion WHERE nombre_estadopostulacion='Aceptada');
    DECLARE @now datetime=GETDATE(), @deadline datetime;
    DECLARE @inicio datetime, @creacion datetime, @estado int;
    SELECT @inicio=fecha_inicio_tarea,@creacion=fecha_creacion_tarea,@estado=id_estado_tarea FROM dbo.Tarea WITH(UPDLOCK,HOLDLOCK) WHERE id_tarea=@id_tarea;
    IF @inicio IS NULL THROW 51000,'La tarea no tiene fecha de inicio',1;
    IF @estado<>@disp THROW 51001,'La tarea ya no está disponible',1;
    SELECT @deadline=fecha_limite_aprobacion FROM dbo.vw_TareaPlazo WHERE id_tarea=@id_tarea;
    IF @now>@deadline THROW 51002,'El plazo de postulación/aprobación ya venció',1;
    IF NOT EXISTS(SELECT 1 FROM dbo.Estudiante WHERE id_estudiante=@id_estudiante AND estado_alumno=1) THROW 51003,'El estudiante no está validado',1;
    IF EXISTS(SELECT 1 FROM dbo.Postulacion WHERE id_tarea_postulacion=@id_tarea AND id_estudiante_postulacion=@id_estudiante AND id_estadopostulacion IN (@pend,@accepted)) THROW 51004,'Ya existe una postulación activa',1;
    INSERT dbo.Postulacion(fecha_postulacion,id_estadopostulacion,id_tarea_postulacion,id_estudiante_postulacion) VALUES(@now,@pend,@id_tarea,@id_estudiante);
    COMMIT;
END
GO

/* Procedimiento: aceptar postulación de forma transaccional */
CREATE OR ALTER PROCEDURE dbo.sp_AceptarPostulacion @id_postulacion int, @id_usuario_cliente int
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON;
    BEGIN TRAN;
    DECLARE @accepted int=(SELECT id_estadopostulacion FROM dbo.EstadoPostulacion WHERE nombre_estadopostulacion='Aceptada');
    DECLARE @pending int=(SELECT id_estadopostulacion FROM dbo.EstadoPostulacion WHERE nombre_estadopostulacion='Pendiente');
    DECLARE @rejected int=(SELECT id_estadopostulacion FROM dbo.EstadoPostulacion WHERE nombre_estadopostulacion='Rechazada');
    DECLARE @assigned int=(SELECT id_estado FROM dbo.EstadoTarea WHERE nombre_estado='Asignada');
    DECLARE @available int=(SELECT id_estado FROM dbo.EstadoTarea WHERE nombre_estado='Disponible');
    DECLARE @task int,@student int,@client int,@start datetime,@deadline datetime,@oldstate varchar(50);
    SELECT @task=p.id_tarea_postulacion,@student=p.id_estudiante_postulacion,@oldstate=ep.nombre_estadopostulacion,
           @start=t.fecha_inicio_tarea,@client=t.id_cliente_tarea
    FROM dbo.Postulacion p WITH(UPDLOCK,HOLDLOCK)
    JOIN dbo.EstadoPostulacion ep ON ep.id_estadopostulacion=p.id_estadopostulacion
    JOIN dbo.Tarea t WITH(UPDLOCK,HOLDLOCK) ON t.id_tarea=p.id_tarea_postulacion
    WHERE p.id_postulacion=@id_postulacion;
    IF @task IS NULL THROW 51010,'Postulación no encontrada',1;
    IF @client IS NULL OR NOT EXISTS(SELECT 1 FROM dbo.Usuario WHERE id_usuario=@id_usuario_cliente AND id_cliente_usuario=@client AND estado_usuario=1) THROW 51011,'No eres el dueño de la tarea',1;
    IF @oldstate<>'Pendiente' THROW 51012,'La postulación ya no está pendiente',1;
    IF NOT EXISTS(SELECT 1 FROM dbo.Estudiante WHERE id_estudiante=@student AND estado_alumno=1) THROW 51016,'El estudiante ya no está validado como activo',1;
    IF EXISTS(SELECT 1 FROM dbo.Tarea WHERE id_tarea=@task AND id_estado_tarea<>@available) THROW 51013,'La tarea ya no está disponible',1;
    SELECT @deadline=fecha_limite_aprobacion FROM dbo.vw_TareaPlazo WHERE id_tarea=@task;
    IF GETDATE()>@deadline THROW 51014,'El plazo máximo para aprobar ya venció',1;
    IF @start<=GETDATE() THROW 51015,'La tarea ya comenzó',1;
    UPDATE dbo.Postulacion SET id_estadopostulacion=@accepted WHERE id_postulacion=@id_postulacion;
    UPDATE dbo.Postulacion SET id_estadopostulacion=@rejected WHERE id_tarea_postulacion=@task AND id_estadopostulacion=@pending AND id_postulacion<>@id_postulacion;
    UPDATE dbo.Tarea SET id_estado_tarea=@assigned WHERE id_tarea=@task;
    INSERT dbo.HistorialTarea(id_tarea_historial,estado_anterior_historial,estado_nuevo_historial,tipo_evento_historial,id_usuario_historial,detalle_historial)
    VALUES(@task,'Disponible','Asignada','ACEPTACION_POSTULACION',@id_usuario_cliente,'Se aceptó un único estudiante y se rechazaron postulaciones pendientes.');
    COMMIT;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_RechazarPostulacion @id_postulacion int,@id_usuario_cliente int
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON; BEGIN TRAN;
    DECLARE @rejected int=(SELECT id_estadopostulacion FROM dbo.EstadoPostulacion WHERE nombre_estadopostulacion='Rechazada');
    UPDATE p SET id_estadopostulacion=@rejected
    FROM dbo.Postulacion p JOIN dbo.Tarea t ON t.id_tarea=p.id_tarea_postulacion
    WHERE p.id_postulacion=@id_postulacion AND t.id_cliente_tarea=(SELECT id_cliente_usuario FROM dbo.Usuario WHERE id_usuario=@id_usuario_cliente);
    IF @@ROWCOUNT=0 THROW 51020,'No se puede rechazar la postulación',1;
    COMMIT;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_CancelarPostulacion @id_postulacion int,@id_usuario_estudiante int
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON; BEGIN TRAN;
    DECLARE @cancel int=(SELECT id_estadopostulacion FROM dbo.EstadoPostulacion WHERE nombre_estadopostulacion='Cancelada');
    DECLARE @accepted int=(SELECT id_estadopostulacion FROM dbo.EstadoPostulacion WHERE nombre_estadopostulacion='Aceptada');
    DECLARE @pending int=(SELECT id_estadopostulacion FROM dbo.EstadoPostulacion WHERE nombre_estadopostulacion='Pendiente');
    DECLARE @available int=(SELECT id_estado FROM dbo.EstadoTarea WHERE nombre_estado='Disponible');
    DECLARE @task int,@student int,@client int,@state int;
    SELECT @task=p.id_tarea_postulacion,@student=p.id_estudiante_postulacion,@client=t.id_cliente_tarea,@state=p.id_estadopostulacion
    FROM dbo.Postulacion p WITH(UPDLOCK,HOLDLOCK) JOIN dbo.Tarea t WITH(UPDLOCK,HOLDLOCK) ON t.id_tarea=p.id_tarea_postulacion WHERE p.id_postulacion=@id_postulacion;
    IF @student IS NULL OR NOT EXISTS(SELECT 1 FROM dbo.Usuario WHERE id_usuario=@id_usuario_estudiante AND id_estudiante_usuario=@student AND estado_usuario=1) THROW 51030,'No puedes cancelar esta postulación',1;
    IF @state NOT IN (@accepted,@pending) THROW 51031,'La postulación no está activa',1;
    UPDATE dbo.Postulacion SET id_estadopostulacion=@cancel WHERE id_postulacion=@id_postulacion;
    IF @state=@accepted
    BEGIN
        UPDATE dbo.Tarea SET id_estado_tarea=@available WHERE id_tarea=@task AND fecha_inicio_tarea>GETDATE();
        INSERT dbo.Penalizacion(id_estudiante_penalizacion,id_tarea_penalizacion,puntos_penalizacion,motivo_penalizacion)
        VALUES(@student,@task,1,'Cancelación posterior a la aceptación');
        INSERT dbo.HistorialTarea(id_tarea_historial,estado_anterior_historial,estado_nuevo_historial,tipo_evento_historial,id_usuario_historial,detalle_historial)
        VALUES(@task,'Asignada','Disponible','CANCELACION_ESTUDIANTE',@id_usuario_estudiante,'El estudiante canceló luego de ser aceptado; se aplicó 1 punto de penalización.');
    END
    COMMIT;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_CancelarTareaCliente @id_tarea int,@id_usuario_cliente int
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON; BEGIN TRAN;
    DECLARE @cancel int=(SELECT id_estado FROM dbo.EstadoTarea WHERE nombre_estado='Cancelada');
    DECLARE @final int=(SELECT id_estado FROM dbo.EstadoTarea WHERE nombre_estado='Finalizada');
    DECLARE @expired int=(SELECT id_estado FROM dbo.EstadoTarea WHERE nombre_estado='Vencida');
    DECLARE @taskClient int,@state int,@start datetime,@accepted int;
    SELECT @taskClient=t.id_cliente_tarea,@state=t.id_estado_tarea,@start=t.fecha_inicio_tarea FROM dbo.Tarea t WITH(UPDLOCK,HOLDLOCK) WHERE t.id_tarea=@id_tarea;
    IF @taskClient IS NULL OR NOT EXISTS(SELECT 1 FROM dbo.Usuario WHERE id_usuario=@id_usuario_cliente AND id_cliente_usuario=@taskClient AND estado_usuario=1) THROW 51040,'No eres el dueño de esta tarea',1;
    IF @state IN (@final,@cancel,@expired) THROW 51041,'La tarea ya está cerrada o vencida',1;
    SELECT @accepted=id_estadopostulacion FROM dbo.EstadoPostulacion WHERE nombre_estadopostulacion='Aceptada';
    IF EXISTS(SELECT 1 FROM dbo.Postulacion WHERE id_tarea_postulacion=@id_tarea AND id_estadopostulacion=@accepted) AND GETDATE()>DATEADD(HOUR,-5,@start)
        THROW 51042,'Con un estudiante aceptado, solo puedes cancelar hasta 5 horas antes del inicio',1;
    UPDATE dbo.Tarea SET id_estado_tarea=@cancel WHERE id_tarea=@id_tarea;
    INSERT dbo.HistorialTarea(id_tarea_historial,estado_anterior_historial,estado_nuevo_historial,tipo_evento_historial,id_usuario_historial,detalle_historial)
    VALUES(@id_tarea,(SELECT nombre_estado FROM dbo.EstadoTarea WHERE id_estado=@state),'Cancelada','CANCELACION_CLIENTE',@id_usuario_cliente,'Cancelación registrada.');
    COMMIT;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_FinalizarTarea @id_tarea int,@id_usuario_estudiante int
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON; BEGIN TRAN;
    DECLARE @assigned int=(SELECT id_estado FROM dbo.EstadoTarea WHERE nombre_estado='Asignada');
    DECLARE @final int=(SELECT id_estado FROM dbo.EstadoTarea WHERE nombre_estado='Finalizada');
    DECLARE @accepted int=(SELECT id_estadopostulacion FROM dbo.EstadoPostulacion WHERE nombre_estadopostulacion='Aceptada');
    DECLARE @student int;
    SELECT @student=p.id_estudiante_postulacion FROM dbo.Postulacion p JOIN dbo.Tarea t ON t.id_tarea=p.id_tarea_postulacion WHERE p.id_tarea_postulacion=@id_tarea AND p.id_estadopostulacion=@accepted;
    IF @student IS NULL OR NOT EXISTS(SELECT 1 FROM dbo.Usuario WHERE id_usuario=@id_usuario_estudiante AND id_estudiante_usuario=@student) THROW 51050,'No eres el estudiante asignado',1;
    IF NOT EXISTS(SELECT 1 FROM dbo.Tarea WHERE id_tarea=@id_tarea AND id_estado_tarea=@assigned) THROW 51051,'La tarea no está en estado Asignada',1;
    UPDATE dbo.Tarea SET id_estado_tarea=@final WHERE id_tarea=@id_tarea;
    INSERT dbo.HistorialTarea(id_tarea_historial,estado_anterior_historial,estado_nuevo_historial,tipo_evento_historial,id_usuario_historial,detalle_historial)
    VALUES(@id_tarea,'Asignada','Finalizada','FINALIZACION_ESTUDIANTE',@id_usuario_estudiante,'El estudiante marcó el trabajo como finalizado.');
    COMMIT;
END
GO

CREATE OR ALTER PROCEDURE dbo.sp_RegistrarPago @id_tarea int,@id_usuario_cliente int,@porcentaje_comision decimal(5,2)
AS
BEGIN
    SET NOCOUNT ON; SET XACT_ABORT ON; BEGIN TRAN;
    DECLARE @final int=(SELECT id_estado FROM dbo.EstadoTarea WHERE nombre_estado='Finalizada');
    DECLARE @idMedio int=(SELECT TOP 1 id_mediopago FROM dbo.MedioPago WHERE nombre_mediopago='Pago de demostración');
    DECLARE @cliente int,@net decimal(10,2),@com decimal(10,2),@total decimal(10,2);
    SELECT @cliente=id_cliente_tarea,@net=pago_ofrecido_tarea FROM dbo.Tarea WITH(UPDLOCK,HOLDLOCK) WHERE id_tarea=@id_tarea AND id_estado_tarea=@final;
    IF @cliente IS NULL OR NOT EXISTS(SELECT 1 FROM dbo.Usuario WHERE id_usuario=@id_usuario_cliente AND id_cliente_usuario=@cliente AND estado_usuario=1) THROW 51060,'La tarea no está finalizada o no eres el cliente',1;
    IF EXISTS(SELECT 1 FROM dbo.Pago WHERE id_tarea_pago=@id_tarea) THROW 51061,'La tarea ya tiene un pago',1;
    SET @com=ROUND(@net*@porcentaje_comision/100.0,2); SET @total=@net-@com;
    INSERT dbo.Pago(fecha_pago,monto_neto_pago,comision_pago,monto_total_pago,id_tarea_pago,id_mediopago_pago)
    VALUES(GETDATE(),@net,@com,@total,@id_tarea,@idMedio);
    SELECT CAST(SCOPE_IDENTITY() AS int) AS id_pago,@net AS monto_neto_pago,@com AS comision_pago,@total AS monto_total_pago;
    COMMIT;
END
GO

/* Índices útiles para la búsqueda */
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Tarea_Estado_Fecha' AND object_id=OBJECT_ID('dbo.Tarea'))
CREATE INDEX IX_Tarea_Estado_Fecha ON dbo.Tarea(id_estado_tarea,fecha_inicio_tarea);
GO

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

USE [Proyecto_UnaMano]
GO
IF NOT EXISTS (SELECT 1 FROM dbo.Region WHERE nombre_region='Metropolitana de Santiago')
    INSERT dbo.Region(nombre_region) VALUES('Metropolitana de Santiago');
GO
IF NOT EXISTS (
    SELECT 1 FROM dbo.Ciudad ci JOIN dbo.Region r ON r.id_region=ci.id_region_ciudad
    WHERE ci.nombre_ciudad='Santiago' AND r.nombre_region='Metropolitana de Santiago'
)
    INSERT dbo.Ciudad(nombre_ciudad,id_region_ciudad)
    SELECT 'Santiago',id_region FROM dbo.Region WHERE nombre_region='Metropolitana de Santiago';
GO
IF NOT EXISTS (
    SELECT 1 FROM dbo.Comuna co
    JOIN dbo.Ciudad ci ON ci.id_ciudad=co.id_ciudad_comuna
    JOIN dbo.Region r ON r.id_region=ci.id_region_ciudad
    WHERE co.nombre_comuna='Santiago' AND ci.nombre_ciudad='Santiago'
      AND r.nombre_region='Metropolitana de Santiago'
)
    INSERT dbo.Comuna(nombre_comuna,id_ciudad_comuna)
    SELECT 'Santiago',ci.id_ciudad
    FROM dbo.Ciudad ci JOIN dbo.Region r ON r.id_region=ci.id_region_ciudad
    WHERE ci.nombre_ciudad='Santiago' AND r.nombre_region='Metropolitana de Santiago';
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

/* Restricciones adicionales y proceso por lotes de tareas vencidas */
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
