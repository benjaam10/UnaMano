from fastapi import APIRouter
from app.db.connection import fetch_all, fetch_one
router = APIRouter(prefix="/locations", tags=["Ubicación"])
@router.get("/regions")
def regions():
    return fetch_all("SELECT id_region, nombre_region FROM dbo.Region ORDER BY nombre_region")
@router.get("/regions/{id_region}/communes")
def communes(id_region: int):
    return fetch_all("""
        SELECT DISTINCT co.id_comuna, co.nombre_comuna
        FROM dbo.Comuna co
        JOIN dbo.Ciudad ci ON ci.id_ciudad = co.id_ciudad_comuna
        WHERE ci.id_region_ciudad = ? ORDER BY co.nombre_comuna
    """, [id_region])
@router.get("/communes/{id_comuna}/city")
def city(id_comuna: int):
    return fetch_one("""
        SELECT ci.id_ciudad, ci.nombre_ciudad, r.id_region, r.nombre_region
        FROM dbo.Comuna co
        JOIN dbo.Ciudad ci ON ci.id_ciudad = co.id_ciudad_comuna
        JOIN dbo.Region r ON r.id_region = ci.id_region_ciudad
        WHERE co.id_comuna = ?
    """, [id_comuna])
@router.get("/categories")
def categories():
    return fetch_all("SELECT id_categoria, nombre_categoria, descripcion_categoria FROM dbo.Categoria WHERE estado_categoria = 1 ORDER BY nombre_categoria")
@router.get("/categories/{id_categoria}/names")
def task_names(id_categoria: int):
    return fetch_all("""
        SELECT id_nombre_tarea, nombre_tarea, descripcion_nombre_tarea
        FROM dbo.NombreTarea WHERE id_categoria_nombre_tarea = ? AND estado_nombre_tarea = 1
        ORDER BY nombre_tarea
    """, [id_categoria])
