# Arquitectura

## Capas

**React** presenta el marketplace, autenticación, perfil, tareas, postulaciones, administración y chat.

**FastAPI** expone endpoints REST y aplica autorización por rol. No existe ORM: las consultas están escritas a mano y reciben parámetros mediante `pyodbc`.

**SQL Server** concentra integridad referencial, estados, transacciones y reglas críticas de concurrencia mediante procedimientos almacenados.

## Relación con 3FN

Las tablas territoriales existentes (`Region` → `Ciudad` → `Comuna`) se mantienen. La dirección recibe `id_comuna_direccion` para poder seleccionar región → comuna → ciudad; la ciudad y región asociadas a una comuna se derivan por JOIN. La columna `id_region_direccion` existente se conserva para compatibilidad con el modelo original y se valida al escribir.

`NombreTarea` evita repetir el nombre de una tarea en cada fila de `Tarea` y queda asociado a `Categoria`.

## Integridad referencial

Las FK de la base original se mantienen. Las nuevas FK relacionan Usuario, Rol, NombreTarea, Conversacion, Mensaje, HistorialTarea y Penalizacion sin borrar físicamente perfiles.

## Seguridad

- Password: `scrypt` en Python.
- Sesión: JWT firmado.
- SQL injection: parámetros `?` de ODBC; no se concatenan valores de usuario.
- Autorización: rol validado en backend y propietario de la tarea validado antes de operaciones de cliente.
- Aceptación: procedimiento transaccional con bloqueo para impedir dos estudiantes aceptados para la misma tarea.
