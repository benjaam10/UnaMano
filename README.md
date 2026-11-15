# UnaMano — Marketplace de tareas

Proyecto Full Stack para Base de Datos: React.js + FastAPI + Microsoft SQL Server, sin ORM y con consultas SQL escritas manualmente.

## 1. Arquitectura

- `prototype/`: prototipo visual estático para revisar la interfaz antes de levantar el sistema real.
- `frontend/`: React + Vite, responsive y con tema claro/oscuro.
- `backend/`: FastAPI, autenticación JWT, autorización por rol y SQL parametrizado mediante `pyodbc`.
- `sql/`: script original, migración, vistas/procedimientos y datos maestros.

## 2. Requisitos

- Python 3.11+ (probado con 3.13 en el entorno de generación).
- Node.js 20+ y npm.
- Microsoft SQL Server.
- ODBC Driver 18 for SQL Server.

## 3. Base de datos

Se requiere SQL Server 2019 o superior. Los scripts integrales usan las rutas predeterminadas de archivos de SQL Server y no incluyen rutas locales de otro equipo.

### Instalación desde cero en SQL Server Management Studio

Conéctate a SQL Server con una cuenta que pueda crear bases de datos y ejecuta estos archivos en orden:

1. `sql/instalacion_completa.sql`: crea `Proyecto_UnaMano`, las tablas originales, extensiones del marketplace, datos maestros y las tres cuentas demo. También agrega Santiago como ubicación mínima para las direcciones de esas cuentas.
2. `sql/carga_demo_localidades_tareas.sql`: carga regiones, ciudades y comunas demo de Chile, además de 20 tareas. Es idempotente para localidades y tareas existentes; no elimina datos.

`instalacion_completa.sql` es solo para una instalación nueva: ejecútalo una vez y no lo uses para actualizar una base existente. Si ya existe `Proyecto_UnaMano`, cancela la ejecución. Los archivos SQL numerados anteriores se conservan como scripts modulares y referencia.

**Cuentas demo** (contraseña igual para cada cuenta):

| Rol | Correo | Contraseña |
| Cliente | `cliente@demo.cl` | `cliente123` |
| Estudiante | `estudiante@demo.cl` | `estudiante123` |
| Admin | `admin@demo.cl` | `admin123` |

Para conectar el backend, configura `DATABASE_CONNECTION_STRING` en `backend/.env` con `DATABASE=Proyecto_UnaMano` y los datos de tu instancia.

## 4. Backend

```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
copy .env.example .env
.\.venv\Scripts\python.exe -m uvicorn app.main:app --reload
```

Swagger: `http://127.0.0.1:8000/docs`

`.env` mínimo:

```env
DATABASE_CONNECTION_STRING=DRIVER={ODBC Driver 18 for SQL Server};SERVER=localhost;DATABASE=Proyecto_UnaMano;Trusted_Connection=yes;Encrypt=no;TrustServerCertificate=yes
JWT_SECRET=cambia-esta-clave-en-tu-equipo
JWT_EXPIRE_MINUTES=480
FRONTEND_ORIGIN=http://localhost:5173
PAYMENT_COMMISSION_PERCENT=10
ALLOW_ADMIN_REGISTRATION=true
```

## 5. Frontend

```powershell
cd frontend
fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
fnm use 26
node -v 
npm -v
npm install
npm run dev
```

Abrir `http://localhost:5173`.

## 6. Prototipo

Antes del frontend real se puede abrir `prototype/index.html` directamente en el navegador. Incluye navegación, feed tipo marketplace, filtros, creación de tarea, perfil y chat visual.
Cuentas demo:
cliente@demo.cl / cliente123
estudiante@demo.cl / estudiante123
admin@demo.cl / admin123

## 7. Reglas principales implementadas

- Estado de alumno/cliente como `BIT`.
- Desactivación lógica: nunca se elimina físicamente el perfil.
- Un solo pago por `id_tarea`.
- `monto_total_pago = monto_neto_pago - comision_pago`.
- El cliente paga el monto ofrecido; el saldo del estudiante acumula el monto total después de comisión. El pago agrega una notificación en el chat asociado a la tarea.
- La tarea solo puede ser pagada después de que el estudiante la marque como finalizada.
- Una sola postulación puede pasar a aceptada; las demás pendientes se rechazan automáticamente en la misma transacción.
- La ventana de aprobación usa la tabla indicada:
  - más de 1 semana: 2 días antes del inicio;
  - más de 3 días: 1 día antes;
  - más de 1 día: 8 horas antes;
  - más de 8 horas: 4 horas antes.
- Una tarea con 8 horas o menos de anticipación no puede publicarse.
- El cliente no puede editar una tarea después de que exista una postulación.
- El informe entregado también establece que, si ya existe un estudiante aceptado, la cancelación del cliente solo es posible hasta 5 horas antes del inicio y debe quedar registrada en historial.
- El estudiante que cancela después de ser aceptado recibe una penalización de 1 punto y la cancelación queda registrada.
- El chat es solo textual y queda asociado a una tarea y estudiante.
- El perfil de Administrador permite descargar un informe Excel de tareas con filtros opcionales por categoría, estado, fechas de inicio, región y comuna. El rango de pago ofrecido solo se permite al filtrar tareas finalizadas.
- El Excel incluye el detalle de tareas y una hoja de resumen con pagos registrados, comisiones y netos para estudiantes.

## 8. Seguridad SQL

No se construyen consultas concatenando datos de usuario. Los parámetros llegan mediante `?` en `pyodbc`, y los cambios críticos usan procedimientos almacenados con `XACT_ABORT`, transacciones y bloqueo `UPDLOCK/HOLDLOCK`.

## 9. Testing ejecutado en esta entrega

- `python -m compileall backend/app`
- `pytest backend/tests`
- `npm run build` del frontend, cuando las dependencias npm estén instaladas en el entorno de prueba.

La conexión real a tu SQL Server no puede probarse desde este entorno porque no hay una instancia SQL Server/ODBC local disponible. La migración queda lista para ejecutarse en SSMS.
