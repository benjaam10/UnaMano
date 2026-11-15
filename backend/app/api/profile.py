from fastapi import APIRouter, Depends, HTTPException
from app.api.deps import get_current_user, require_role
from app.db.connection import fetch_all, fetch_one, transaction
from pydantic import BaseModel, Field

router=APIRouter(prefix="/profile",tags=["Perfil"])

@router.get("")
def profile(user=Depends(get_current_user)):
    if user["nombre_rol"]=="Cliente":
        profile_data = fetch_one("""SELECT c.id_cliente,c.rut_cliente,c.nombre1_cliente,c.nombre2_cliente,c.apellido1_cliente,
            CONVERT(varchar(50),c.apellido2_cliente) AS apellido2_cliente,c.fechanacimiento_cliente,c.telefono_cliente,c.email_cliente,c.estado_cliente,
            d.calle_direccion,d.numero_direccion,d.dpto_direccion,d.referencia_direccion,d.id_region_direccion,d.id_comuna_direccion,
            r.nombre_region,co.nombre_comuna,ci.nombre_ciudad
            FROM dbo.Cliente c JOIN dbo.Direccion d ON d.id_direccion=c.id_direccion_cliente
            JOIN dbo.Region r ON r.id_region=d.id_region_direccion LEFT JOIN dbo.Comuna co ON co.id_comuna=d.id_comuna_direccion LEFT JOIN dbo.Ciudad ci ON ci.id_ciudad=co.id_ciudad_comuna
            WHERE c.id_cliente=?""",[user["id_cliente_usuario"]])
        profile_data["id_usuario"] = user["id_usuario"]
        return profile_data
    if user["nombre_rol"]=="Estudiante":
        profile_data = fetch_one("""SELECT e.id_estudiante,e.rut_estudiante,e.nombre1_estudiante,e.nombre2_estudiante,e.apellido1_estudiante,e.apellido2_estudiante,
            e.fechanacimiento_estudiante,e.telefono_estudiante,e.email_estudiante,e.universidad_estudiante,e.carrera_estudiante,e.estado_alumno,
            d.calle_direccion,d.numero_direccion,d.dpto_direccion,d.referencia_direccion,d.id_region_direccion,d.id_comuna_direccion,
            r.nombre_region,co.nombre_comuna,ci.nombre_ciudad
            FROM dbo.Estudiante e JOIN dbo.Direccion d ON d.id_direccion=e.id_direccion_estudiante
            JOIN dbo.Region r ON r.id_region=d.id_region_direccion LEFT JOIN dbo.Comuna co ON co.id_comuna=d.id_comuna_direccion LEFT JOIN dbo.Ciudad ci ON ci.id_ciudad=co.id_ciudad_comuna
            WHERE e.id_estudiante=?""",[user["id_estudiante_usuario"]])
        balance = fetch_one("""
            SELECT COALESCE(SUM(pg.monto_total_pago), 0) AS saldo_acumulado
            FROM dbo.Pago pg
            JOIN dbo.Tarea t ON t.id_tarea=pg.id_tarea_pago
            JOIN dbo.Postulacion p ON p.id_tarea_postulacion=t.id_tarea
            JOIN dbo.EstadoPostulacion ep ON ep.id_estadopostulacion=p.id_estadopostulacion
            WHERE p.id_estudiante_postulacion=?
              AND ep.nombre_estadopostulacion='Aceptada'
        """, [user["id_estudiante_usuario"]])
        profile_data["saldo_acumulado"] = balance["saldo_acumulado"]
        profile_data["id_usuario"] = user["id_usuario"]
        return profile_data
    if user["nombre_rol"]=="Admin":
        earnings = fetch_one("""
            SELECT COALESCE(SUM(comision_pago), CAST(0 AS decimal(10,2))) AS ganancias_comisiones,
                   COUNT(*) AS cantidad_pagos
            FROM dbo.Pago
        """)
        return {**user, **earnings}
    return user

class AddressUpdate(BaseModel):
    id_region: int=Field(gt=0)
    id_comuna: int=Field(gt=0)
    calle: str=Field(min_length=1,max_length=200)
    numero: str=Field(min_length=1,max_length=20)
    dpto: str|None=None
    referencia: str|None=None

@router.put("/address")
def update_address(data: AddressUpdate,user=Depends(require_role("Cliente","Estudiante"))):
    if user["nombre_rol"]=="Cliente":
        person_id=user["id_cliente_usuario"]; table="Cliente"; fk="id_direccion_cliente"; pk="id_cliente"
    else:
        person_id=user["id_estudiante_usuario"]; table="Estudiante"; fk="id_direccion_estudiante"; pk="id_estudiante"
    with transaction() as conn:
        cur=conn.cursor()
        cur.execute("SELECT 1 FROM dbo.Comuna co JOIN dbo.Ciudad ci ON ci.id_ciudad=co.id_ciudad_comuna WHERE co.id_comuna=? AND ci.id_region_ciudad=?", data.id_comuna,data.id_region)
        if not cur.fetchone(): raise HTTPException(422,"Comuna y región no coinciden")
        cur.execute(f"SELECT {fk} FROM dbo.{table} WHERE {pk}=?", person_id)
        address_id=cur.fetchone()[0]
        cur.execute("UPDATE dbo.Direccion SET id_region_direccion=?,id_comuna_direccion=?,calle_direccion=?,numero_direccion=?,dpto_direccion=?,referencia_direccion=? WHERE id_direccion=?",
                    data.id_region,data.id_comuna,data.calle,data.numero,data.dpto,data.referencia,address_id)
    return profile(user)

@router.post("/student/validate")
def validate_student(user=Depends(require_role("Estudiante"))):
    with transaction() as conn:
        cur=conn.cursor(); cur.execute("UPDATE dbo.Estudiante SET estado_alumno=1 WHERE id_estudiante=?",user["id_estudiante_usuario"])
    return {"estado_alumno":1,"message":"Perfil marcado como estudiante regular"}

@router.post("/deactivate")
def deactivate(user=Depends(require_role("Cliente","Estudiante"))):
    with transaction() as conn:
        cur=conn.cursor()
        if user["nombre_rol"]=="Cliente":
            cur.execute("UPDATE dbo.Cliente SET estado_cliente=0 WHERE id_cliente=?",user["id_cliente_usuario"])
        else:
            cur.execute("UPDATE dbo.Estudiante SET estado_alumno=0 WHERE id_estudiante=?",user["id_estudiante_usuario"])
        cur.execute("UPDATE dbo.Usuario SET estado_usuario=0 WHERE id_usuario=?",user["id_usuario"])
    return {"message":"Cuenta desactivada"}

@router.get("/skills")
def skills(user=Depends(require_role("Estudiante"))):
    return fetch_all("""SELECT eh.id_eh,eh.id_habilidad_eh,eh.id_niveldominio_eh,h.nombre_habilidad,nd.nombre_niveldominio
                       FROM dbo.EstudianteHabilidad eh JOIN dbo.Habilidad h ON h.id_habilidad=eh.id_habilidad_eh
                       JOIN dbo.NivelDominio nd ON nd.id_niveldominio=eh.id_niveldominio_eh
                       WHERE eh.id_estudiante_eh=? ORDER BY h.nombre_habilidad""",[user["id_estudiante_usuario"]])

@router.get("/skills/options")
def skill_options(user=Depends(require_role("Estudiante"))):
    return {
        "habilidades": fetch_all("SELECT id_habilidad,nombre_habilidad FROM dbo.Habilidad ORDER BY nombre_habilidad"),
        "niveles": fetch_all("SELECT id_niveldominio,nombre_niveldominio FROM dbo.NivelDominio ORDER BY id_niveldominio")
    }

class SkillIn(BaseModel):
    id_habilidad: int=Field(gt=0)
    id_niveldominio: int=Field(gt=0)

@router.post("/skills")
def add_skill(data:SkillIn,user=Depends(require_role("Estudiante"))):
    with transaction() as conn:
        cur=conn.cursor()
        cur.execute("SELECT 1 FROM dbo.EstudianteHabilidad WHERE id_estudiante_eh=? AND id_habilidad_eh=?",user["id_estudiante_usuario"],data.id_habilidad)
        if cur.fetchone():
            cur.execute("UPDATE dbo.EstudianteHabilidad SET id_niveldominio_eh=? WHERE id_estudiante_eh=? AND id_habilidad_eh=?",data.id_niveldominio,user["id_estudiante_usuario"],data.id_habilidad)
        else:
            cur.execute("INSERT dbo.EstudianteHabilidad(id_estudiante_eh,id_habilidad_eh,id_niveldominio_eh) VALUES(?,?,?)",user["id_estudiante_usuario"],data.id_habilidad,data.id_niveldominio)
    return skills(user)
