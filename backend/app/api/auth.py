from datetime import date
from fastapi import APIRouter, HTTPException
from app.core.security import hash_password, verify_password, create_access_token
from app.core.config import settings
from app.db.connection import transaction, fetch_one
from app.schemas.auth import RegisterRequest, LoginRequest, TokenResponse

router = APIRouter(prefix="/auth", tags=["Autenticación"])

@router.post("/register", response_model=TokenResponse)
def register(payload: RegisterRequest):
    if payload.role.value == "Admin" and not settings.allow_admin_registration:
        raise HTTPException(403, "El registro de administradores está deshabilitado")
    if payload.role.value != "Admin":
        required = {
            "RUT": payload.rut, "nombre": payload.nombre1, "apellido": payload.apellido1,
            "teléfono": payload.telefono, "calle": payload.calle, "número": payload.numero,
            "región": payload.id_region, "comuna": payload.id_comuna,
        }
        missing = next((name for name, value in required.items() if not value), None)
        if missing:
            raise HTTPException(422, f"{missing} es obligatorio")
    if payload.role.value == "Estudiante" and (not payload.universidad or not payload.carrera or not payload.fecha_nacimiento):
        raise HTTPException(422, "Fecha de nacimiento, universidad y carrera son obligatorias para estudiantes")
    try:
        with transaction() as conn:
            cur = conn.cursor()
            cur.execute("SELECT 1 FROM dbo.Usuario WHERE email_usuario = ?", payload.email)
            if cur.fetchone():
                raise HTTPException(409, "El correo ya está registrado")
            cur.execute("SELECT 1 FROM dbo.Cliente WHERE rut_cliente = ?", payload.rut)
            if cur.fetchone():
                raise HTTPException(409, "El RUT ya está registrado")
            cur.execute("SELECT 1 FROM dbo.Estudiante WHERE rut_estudiante = ?", payload.rut)
            if cur.fetchone():
                raise HTTPException(409, "El RUT ya está registrado")

            password_hash = hash_password(payload.password)
            person_id = None
            id_direccion = None

            if payload.role.value == "Cliente":
                cur.execute("""
                    INSERT INTO dbo.Direccion(calle_direccion, numero_direccion, dpto_direccion,
                        referencia_direccion, id_region_direccion, id_comuna_direccion)
                    OUTPUT INSERTED.id_direccion
                    VALUES (?, ?, ?, ?, ?, ?)
                """, payload.calle, payload.numero, payload.dpto, payload.referencia,
                    payload.id_region, payload.id_comuna)
                id_direccion = cur.fetchone()[0]
                if id_direccion is None:
                    raise HTTPException(500, "No fue posible obtener la dirección creada")
                cur.execute("""
                    INSERT INTO dbo.Cliente(rut_cliente, nombre1_cliente, nombre2_cliente,
                        apellido1_cliente, apellido2_cliente, fechanacimiento_cliente,
                        telefono_cliente, email_cliente, id_direccion_cliente, estado_cliente)
                    OUTPUT INSERTED.id_cliente
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1)
                """, payload.rut, payload.nombre1, payload.nombre2, payload.apellido1,
                    payload.apellido2.encode("utf-8") if payload.apellido2 else None,
                    date.fromisoformat(payload.fecha_nacimiento) if payload.fecha_nacimiento else None,
                    payload.telefono, payload.email, id_direccion)
                person_id = cur.fetchone()[0]
                cur.execute("SELECT id_rol FROM dbo.Rol WHERE nombre_rol = 'Cliente'")
                id_role = cur.fetchone()[0]
                cur.execute("""
                    INSERT INTO dbo.Usuario(email_usuario, password_hash_usuario, id_rol_usuario,
                        id_cliente_usuario, id_estudiante_usuario, estado_usuario)
                    OUTPUT INSERTED.id_usuario
                    VALUES (?, ?, ?, ?, NULL, 1)
                """, payload.email, password_hash, id_role, person_id)
                user_id = cur.fetchone()[0]
            elif payload.role.value == "Estudiante":
                cur.execute("""
                    INSERT INTO dbo.Direccion(calle_direccion, numero_direccion, dpto_direccion,
                        referencia_direccion, id_region_direccion, id_comuna_direccion)
                    OUTPUT INSERTED.id_direccion
                    VALUES (?, ?, ?, ?, ?, ?)
                """, payload.calle, payload.numero, payload.dpto, payload.referencia,
                    payload.id_region, payload.id_comuna)
                id_direccion = cur.fetchone()[0]
                if id_direccion is None:
                    raise HTTPException(500, "No fue posible obtener la dirección creada")
                cur.execute("""
                    INSERT INTO dbo.Estudiante(rut_estudiante, nombre1_estudiante, nombre2_estudiante,
                        apellido1_estudiante, apellido2_estudiante, fechanacimiento_estudiante,
                        telefono_estudiante, id_direccion_estudiante, email_estudiante,
                        universidad_estudiante, carrera_estudiante, estado_alumno)
                    OUTPUT INSERTED.id_estudiante
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1)
                """, payload.rut, payload.nombre1, payload.nombre2, payload.apellido1,
                    payload.apellido2, date.fromisoformat(payload.fecha_nacimiento) if payload.fecha_nacimiento else date(2000,1,1),
                    payload.telefono, id_direccion, payload.email, payload.universidad, payload.carrera)
                person_id = cur.fetchone()[0]
                cur.execute("SELECT id_rol FROM dbo.Rol WHERE nombre_rol = 'Estudiante'")
                id_role = cur.fetchone()[0]
                cur.execute("""
                    INSERT INTO dbo.Usuario(email_usuario, password_hash_usuario, id_rol_usuario,
                        id_cliente_usuario, id_estudiante_usuario, estado_usuario)
                    OUTPUT INSERTED.id_usuario
                    VALUES (?, ?, ?, NULL, ?, 1)
                """, payload.email, password_hash, id_role, person_id)
                user_id = cur.fetchone()[0]
            else:
                cur.execute("SELECT id_rol FROM dbo.Rol WHERE nombre_rol = 'Admin'")
                id_role = cur.fetchone()[0]
                cur.execute("""
                    INSERT INTO dbo.Usuario(email_usuario, password_hash_usuario, id_rol_usuario,
                        id_cliente_usuario, id_estudiante_usuario, estado_usuario)
                    OUTPUT INSERTED.id_usuario
                    VALUES (?, ?, ?, NULL, NULL, 1)
                """, payload.email, password_hash, id_role)
                user_id = cur.fetchone()[0]
            if user_id is None:
                raise HTTPException(500, "No fue posible obtener el usuario creado")
            conn.commit()
    except HTTPException:
        raise
    except Exception as exc:
        raise HTTPException(400, f"No fue posible registrar la cuenta: {exc}")

    token = create_access_token({"sub": str(user_id), "role": payload.role.value,
                                 "id_cliente": None if payload.role.value != "Cliente" else person_id,
                                 "id_estudiante": None if payload.role.value != "Estudiante" else person_id})
    return TokenResponse(access_token=token, role=payload.role.value)

@router.post("/login", response_model=TokenResponse)
def login(payload: LoginRequest):
    row = fetch_one("""
        SELECT u.id_usuario, u.email_usuario, u.password_hash_usuario, r.nombre_rol,
               u.id_cliente_usuario,
               COALESCE(
                   u.id_estudiante_usuario,
                   (SELECT TOP 1 e2.id_estudiante
                    FROM dbo.Estudiante e2
                    WHERE e2.email_estudiante=u.email_usuario)
               ) AS id_estudiante_usuario,
               u.estado_usuario, c.estado_cliente, e.estado_alumno
        FROM dbo.Usuario u
        JOIN dbo.Rol r ON r.id_rol = u.id_rol_usuario
        LEFT JOIN dbo.Cliente c ON c.id_cliente = u.id_cliente_usuario
        LEFT JOIN dbo.Estudiante e ON e.id_estudiante = u.id_estudiante_usuario
        WHERE u.email_usuario = ?
    """, [payload.email])
    if not row or not verify_password(payload.password, row["password_hash_usuario"]):
        raise HTTPException(401, "Correo o contraseña incorrectos")
    if not row["estado_usuario"]:
        raise HTTPException(403, "La cuenta está desactivada")
    if row["nombre_rol"] == "Cliente" and not row["estado_cliente"]:
        raise HTTPException(403, "El perfil de cliente está desactivado")
    token = create_access_token({"sub": str(row["id_usuario"]), "role": row["nombre_rol"],
                                 "id_cliente": row["id_cliente_usuario"],
                                 "id_estudiante": row["id_estudiante_usuario"]})
    return TokenResponse(access_token=token, role=row["nombre_rol"])
