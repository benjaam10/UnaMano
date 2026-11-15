from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from app.core.security import decode_access_token
from app.db.connection import fetch_one

bearer = HTTPBearer(auto_error=False)

def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(bearer)) -> dict:
    if not credentials:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Debes iniciar sesión")
    try:
        token = decode_access_token(credentials.credentials)
    except Exception:
        raise HTTPException(status_code=401, detail="Token inválido o expirado")
    try:
        user_id = int(token["sub"])
    except (KeyError, TypeError, ValueError):
        raise HTTPException(status_code=401, detail="Token inválido o expirado")
    row = fetch_one("""
        SELECT u.id_usuario, u.email_usuario, r.nombre_rol, u.id_cliente_usuario,
               COALESCE(
                   u.id_estudiante_usuario,
                   (SELECT TOP 1 e2.id_estudiante
                    FROM dbo.Estudiante e2
                    WHERE e2.email_estudiante=u.email_usuario)
               ) AS id_estudiante_usuario,
               u.estado_usuario,
               c.estado_cliente, e.estado_alumno
        FROM dbo.Usuario u
        JOIN dbo.Rol r ON r.id_rol = u.id_rol_usuario
        LEFT JOIN dbo.Cliente c ON c.id_cliente = u.id_cliente_usuario
        LEFT JOIN dbo.Estudiante e ON e.id_estudiante = u.id_estudiante_usuario
        WHERE u.id_usuario = ?
    """, [user_id])
    if not row or not row["estado_usuario"]:
        raise HTTPException(status_code=401, detail="Cuenta desactivada")
    row["nombre_rol"] = row["nombre_rol"].strip()
    return row

def require_role(*roles: str):
    def dependency(user = Depends(get_current_user)):
        if user["nombre_rol"] not in {role.strip() for role in roles}:
            raise HTTPException(status_code=403, detail="No tienes permisos para esta operación")
        return user
    return dependency
