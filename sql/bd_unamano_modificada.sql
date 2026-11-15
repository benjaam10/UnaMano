USE [master]
GO
/****** Objeto: Database [Proyecto_UnaMano] Fecha de script: 01-11-2026 18:45:38 ******/
CREATE DATABASE [Proyecto_UnaMano]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Proyecto_UnaMano', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\Proyecto_UnaMano.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Proyecto_UnaMano_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\Proyecto_UnaMano_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Proyecto_UnaMano] SET COMPATIBILITY_LEVEL = 170
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Proyecto_UnaMano].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Proyecto_UnaMano] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Proyecto_UnaMano] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Proyecto_UnaMano] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Proyecto_UnaMano] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Proyecto_UnaMano] SET ARITHABORT OFF 
GO
ALTER DATABASE [Proyecto_UnaMano] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Proyecto_UnaMano] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Proyecto_UnaMano] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Proyecto_UnaMano] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Proyecto_UnaMano] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Proyecto_UnaMano] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Proyecto_UnaMano] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Proyecto_UnaMano] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Proyecto_UnaMano] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Proyecto_UnaMano] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Proyecto_UnaMano] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Proyecto_UnaMano] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Proyecto_UnaMano] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Proyecto_UnaMano] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Proyecto_UnaMano] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Proyecto_UnaMano] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Proyecto_UnaMano] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Proyecto_UnaMano] SET RECOVERY FULL 
GO
ALTER DATABASE [Proyecto_UnaMano] SET  MULTI_USER 
GO
ALTER DATABASE [Proyecto_UnaMano] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Proyecto_UnaMano] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Proyecto_UnaMano] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Proyecto_UnaMano] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Proyecto_UnaMano] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Proyecto_UnaMano] SET OPTIMIZED_LOCKING = OFF 
GO
ALTER DATABASE [Proyecto_UnaMano] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Proyecto_UnaMano] SET QUERY_STORE = ON
GO
ALTER DATABASE [Proyecto_UnaMano] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
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

/* ================================================================
   MODIFICACIONES UNA MANO
   ================================================================ */

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
    DECLARE @taskClient int,@state int,@start datetime,@accepted int,@final int;
    SELECT @taskClient=t.id_cliente_tarea,@state=t.id_estado_tarea,@start=t.fecha_inicio_tarea FROM dbo.Tarea t WITH(UPDLOCK,HOLDLOCK) WHERE t.id_tarea=@id_tarea;
    IF @taskClient IS NULL OR NOT EXISTS(SELECT 1 FROM dbo.Usuario WHERE id_usuario=@id_usuario_cliente AND id_cliente_usuario=@taskClient AND estado_usuario=1) THROW 51040,'No eres el dueño de esta tarea',1;
    IF @state IN (@final,@cancel) THROW 51041,'La tarea ya está cerrada',1;
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
