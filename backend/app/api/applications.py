from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException
from app.api.deps import get_current_user, require_role
from app.db.connection import fetch_all, fetch_one, transaction

router=APIRouter(tags=["Postulaciones"])

@router.get("/my-applications")
def my_applications(user=Depends(require_role("Estudiante"))):
    return fetch_all("""
        SELECT p.id_postulacion,p.fecha_postulacion,ep.nombre_estadopostulacion,
               t.id_tarea,t.titulo_tarea,t.descripcion_tarea,t.pago_ofrecido_tarea,t.fecha_inicio_tarea,
               et.nombre_estado AS nombre_estado_tarea,
               ca.nombre_categoria,cl.nombre1_cliente+' '+cl.apellido1_cliente AS cliente,
               r.nombre_region,co.nombre_comuna,ci.nombre_ciudad
        FROM dbo.Postulacion p
        JOIN dbo.EstadoPostulacion ep ON ep.id_estadopostulacion=p.id_estadopostulacion
        JOIN dbo.Tarea t ON t.id_tarea=p.id_tarea_postulacion
        JOIN dbo.EstadoTarea et ON et.id_estado=t.id_estado_tarea
        JOIN dbo.Categoria ca ON ca.id_categoria=t.id_categoria_tarea
        JOIN dbo.Cliente cl ON cl.id_cliente=t.id_cliente_tarea
        JOIN dbo.Direccion d ON d.id_direccion=t.id_direccion_tarea
        JOIN dbo.Region r ON r.id_region=d.id_region_direccion
        LEFT JOIN dbo.Comuna co ON co.id_comuna=d.id_comuna_direccion
        LEFT JOIN dbo.Ciudad ci ON ci.id_ciudad=co.id_ciudad_comuna
        WHERE p.id_estudiante_postulacion=? ORDER BY p.fecha_postulacion DESC
    """,[user["id_estudiante_usuario"]])

@router.post("/tasks/{task_id}/apply")
def apply(task_id:int,user=Depends(require_role("Estudiante"))):
    try:
        with transaction() as conn:
            cur=conn.cursor()
            cur.execute("""
                SELECT t.id_estado_tarea, et.nombre_estado, t.fecha_inicio_tarea,
                       CASE
                         WHEN DATEDIFF(MINUTE,t.fecha_creacion_tarea,t.fecha_inicio_tarea) > 10080
                           THEN DATEADD(HOUR,-48,t.fecha_inicio_tarea)
                         WHEN DATEDIFF(MINUTE,t.fecha_creacion_tarea,t.fecha_inicio_tarea) > 4320
                           THEN DATEADD(HOUR,-24,t.fecha_inicio_tarea)
                         WHEN DATEDIFF(MINUTE,t.fecha_creacion_tarea,t.fecha_inicio_tarea) > 1440
                           THEN DATEADD(HOUR,-8,t.fecha_inicio_tarea)
                         WHEN DATEDIFF(MINUTE,t.fecha_creacion_tarea,t.fecha_inicio_tarea) > 480
                           THEN DATEADD(HOUR,-4,t.fecha_inicio_tarea)
                         ELSE t.fecha_inicio_tarea
                       END AS limite
                FROM dbo.Tarea t
                JOIN dbo.EstadoTarea et ON et.id_estado=t.id_estado_tarea
                WHERE t.id_tarea=?
            """, task_id)
            task=cur.fetchone()
            if not task:
                raise HTTPException(404, "Tarea no encontrada")
            if task[1] != "Disponible":
                raise HTTPException(409, "La tarea ya no está disponible")
            if task[3] and datetime.now() > task[3]:
                raise HTTPException(409, "El plazo de postulación ya venció")
            cur.execute("""
                SELECT 1
                FROM dbo.Postulacion p
                JOIN dbo.EstadoPostulacion ep ON ep.id_estadopostulacion=p.id_estadopostulacion
                WHERE p.id_tarea_postulacion=? AND p.id_estudiante_postulacion=?
                  AND ep.nombre_estadopostulacion IN ('Pendiente','Aceptada')
            """, task_id, user["id_estudiante_usuario"])
            if cur.fetchone():
                raise HTTPException(409, "Ya tienes una postulación activa para esta tarea")
            cur.execute("SELECT id_estadopostulacion FROM dbo.EstadoPostulacion WHERE nombre_estadopostulacion='Pendiente'")
            pending=cur.fetchone()
            if not pending:
                raise HTTPException(500, "No existe el estado Pendiente en la base de datos")
            cur.execute("""
                INSERT dbo.Postulacion(fecha_postulacion,id_estadopostulacion,
                                       id_tarea_postulacion,id_estudiante_postulacion)
                VALUES(GETDATE(),?,?,?)
            """, pending[0], task_id, user["id_estudiante_usuario"])
    except HTTPException:
        raise
    except Exception as exc:
        raise HTTPException(409, f"No se pudo registrar la postulación: {exc}")
    return {"message":"Postulación registrada"}

@router.get("/tasks/{task_id}/applications")
def list_apps(task_id:int,user=Depends(require_role("Cliente","Admin"))):
    task=fetch_one("SELECT id_cliente_tarea FROM dbo.Tarea WHERE id_tarea=?",[task_id])
    if not task: raise HTTPException(404,"Tarea no encontrada")
    if user["nombre_rol"]=="Cliente" and task["id_cliente_tarea"]!=user["id_cliente_usuario"]: raise HTTPException(403,"No es tu tarea")
    return fetch_all("""
        SELECT p.id_postulacion,p.fecha_postulacion,p.id_estadopostulacion,ep.nombre_estadopostulacion,
               e.id_estudiante,e.nombre1_estudiante,e.apellido1_estudiante,e.universidad_estudiante,e.carrera_estudiante,
               e.estado_alumno
        FROM dbo.Postulacion p
        JOIN dbo.EstadoPostulacion ep ON ep.id_estadopostulacion=p.id_estadopostulacion
        JOIN dbo.Estudiante e ON e.id_estudiante=p.id_estudiante_postulacion
        WHERE p.id_tarea_postulacion=? ORDER BY p.fecha_postulacion DESC
    """,[task_id])

@router.post("/applications/{application_id}/accept")
def accept(application_id:int,user=Depends(require_role("Cliente"))):
    try:
        with transaction() as conn:
            cur=conn.cursor()
            cur.execute("""
                SELECT p.id_postulacion, ep.nombre_estadopostulacion, t.id_estado_tarea
                FROM dbo.Postulacion p
                JOIN dbo.EstadoPostulacion ep ON ep.id_estadopostulacion=p.id_estadopostulacion
                JOIN dbo.Tarea t ON t.id_tarea=p.id_tarea_postulacion
                WHERE p.id_postulacion=? AND t.id_cliente_tarea=?
            """, application_id, user["id_cliente_usuario"])
            application=cur.fetchone()
            if not application:
                raise HTTPException(404, "La postulación no existe o no pertenece a una tarea tuya")
            if application[1] != "Pendiente":
                raise HTTPException(409, f"La postulación ya no está pendiente: {application[1]}")
            cur.execute("SELECT id_estado FROM dbo.EstadoTarea WHERE nombre_estado='Disponible'")
            available=cur.fetchone()
            if not available or application[2] != available[0]:
                raise HTTPException(409, "La tarea ya no está disponible")
            cur.execute("EXEC dbo.sp_AceptarPostulacion ?, ?", application_id, user["id_usuario"])
    except HTTPException:
        raise
    except Exception as exc:
        raise HTTPException(409, f"No se pudo aceptar la postulación: {exc}")
    return {"message":"Postulación aceptada"}

@router.post("/applications/{application_id}/reject")
def reject(application_id:int,user=Depends(require_role("Cliente"))):
    app=fetch_one("""SELECT p.id_postulacion,t.id_cliente_tarea FROM dbo.Postulacion p JOIN dbo.Tarea t ON t.id_tarea=p.id_tarea_postulacion WHERE p.id_postulacion=?""",[application_id])
    if not app: raise HTTPException(404,"Postulación no encontrada")
    if app["id_cliente_tarea"]!=user["id_cliente_usuario"]: raise HTTPException(403,"No es tu tarea")
    fetch_one("EXEC dbo.sp_RechazarPostulacion ?, ?",[application_id,user["id_usuario"]])
    return {"message":"Postulación rechazada"}

@router.post("/applications/{application_id}/cancel")
def cancel(application_id:int,user=Depends(require_role("Estudiante"))):
    try:
        with transaction() as conn:
            cur=conn.cursor(); cur.execute("EXEC dbo.sp_CancelarPostulacion ?, ?", application_id, user["id_usuario"])
    except Exception as exc: raise HTTPException(409,str(exc))
    return {"message":"Postulación cancelada"}
