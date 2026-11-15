from fastapi import APIRouter, Depends, HTTPException
from app.api.deps import get_current_user, require_role
from app.db.connection import fetch_all, fetch_one, transaction
from app.schemas.chat import MessageIn

router=APIRouter(prefix="/chat",tags=["Chat"])

@router.get("/conversations")
def conversations(user=Depends(require_role("Cliente","Estudiante"))):
    if user["nombre_rol"] == "Cliente":
        return fetch_all("""
            SELECT p.id_tarea_postulacion AS id_tarea,
                   p.id_estudiante_postulacion AS id_estudiante,
                   t.titulo_tarea,
                   COALESCE(e.nombre1_estudiante, '') + ' ' + COALESCE(e.apellido1_estudiante, '') AS contacto,
                   'Estudiante' AS tipo_contacto
            FROM dbo.Postulacion p
            JOIN dbo.EstadoPostulacion ep ON ep.id_estadopostulacion=p.id_estadopostulacion
            JOIN dbo.Tarea t ON t.id_tarea=p.id_tarea_postulacion
            JOIN dbo.Estudiante e ON e.id_estudiante=p.id_estudiante_postulacion
            WHERE t.id_cliente_tarea=? AND ep.nombre_estadopostulacion='Aceptada'
            ORDER BY p.fecha_postulacion DESC
        """, [user["id_cliente_usuario"]])
    return fetch_all("""
        SELECT p.id_tarea_postulacion AS id_tarea,
               p.id_estudiante_postulacion AS id_estudiante,
               t.titulo_tarea,
               COALESCE(c.nombre1_cliente, '') + ' ' + COALESCE(c.apellido1_cliente, '') AS contacto,
               'Cliente' AS tipo_contacto
        FROM dbo.Postulacion p
        JOIN dbo.EstadoPostulacion ep ON ep.id_estadopostulacion=p.id_estadopostulacion
        JOIN dbo.Tarea t ON t.id_tarea=p.id_tarea_postulacion
        JOIN dbo.Cliente c ON c.id_cliente=t.id_cliente_tarea
        WHERE p.id_estudiante_postulacion=? AND ep.nombre_estadopostulacion='Aceptada'
        ORDER BY p.fecha_postulacion DESC
    """, [user["id_estudiante_usuario"]])

def _conversation(task_id:int, student_id:int):
    return fetch_one("SELECT * FROM dbo.Conversacion WHERE id_tarea_conversacion=? AND id_estudiante_conversacion=?",[task_id,student_id])

def _require_accepted_application(task_id:int, student_id:int):
    row=fetch_one("""
        SELECT p.id_postulacion
        FROM dbo.Postulacion p
        JOIN dbo.EstadoPostulacion ep ON ep.id_estadopostulacion=p.id_estadopostulacion
        WHERE p.id_tarea_postulacion=? AND p.id_estudiante_postulacion=?
          AND ep.nombre_estadopostulacion='Aceptada'
    """,[task_id,student_id])
    if not row:
        raise HTTPException(403,"El chat estará disponible cuando el cliente acepte la postulación")

@router.get("/{task_id}/{student_id}/messages")
def messages(task_id:int,student_id:int,user=Depends(require_role("Cliente","Estudiante"))):
    _require_accepted_application(task_id,student_id)
    conv=_conversation(task_id,student_id)
    if not conv: return []
    allowed = (user["nombre_rol"]=="Estudiante" and user["id_estudiante_usuario"]==student_id) or (user["nombre_rol"]=="Cliente" and user["id_cliente_usuario"]==conv["id_cliente_conversacion"])
    if not allowed: raise HTTPException(403,"No tienes acceso a este chat")
    return fetch_all("""
        SELECT m.id_mensaje,m.id_conversacion_mensaje,m.id_usuario_emisor_mensaje,m.contenido_mensaje,m.fecha_mensaje,
               u.email_usuario,r.nombre_rol
        FROM dbo.Mensaje m JOIN dbo.Usuario u ON u.id_usuario=m.id_usuario_emisor_mensaje JOIN dbo.Rol r ON r.id_rol=u.id_rol_usuario
        WHERE m.id_conversacion_mensaje=? ORDER BY m.fecha_mensaje ASC,m.id_mensaje ASC
    """,[conv["id_conversacion"]])

@router.post("/{task_id}/{student_id}/messages")
def send(task_id:int,student_id:int,payload:MessageIn,user=Depends(require_role("Cliente","Estudiante"))):
    _require_accepted_application(task_id,student_id)
    task=fetch_one("SELECT id_cliente_tarea FROM dbo.Tarea WHERE id_tarea=?",[task_id])
    if not task: raise HTTPException(404,"Tarea no encontrada")
    if user["nombre_rol"]=="Cliente":
        if task["id_cliente_tarea"]!=user["id_cliente_usuario"]: raise HTTPException(403,"No es tu tarea")
        client_id=user["id_cliente_usuario"]
    else:
        if user["id_estudiante_usuario"]!=student_id: raise HTTPException(403,"No es tu chat")
        client_id=task["id_cliente_tarea"]
    with transaction() as conn:
        cur=conn.cursor()
        cur.execute("""SELECT id_conversacion FROM dbo.Conversacion WHERE id_tarea_conversacion=? AND id_estudiante_conversacion=?""",task_id,student_id)
        row=cur.fetchone()
        if row: conv_id=row[0]
        else:
            cur.execute("""INSERT INTO dbo.Conversacion(
                              id_tarea_conversacion,id_cliente_conversacion,
                              id_estudiante_conversacion,fecha_creacion_conversacion,
                              estado_conversacion
                          )
                          OUTPUT INSERTED.id_conversacion
                          VALUES(?,?,?,GETDATE(),1)""", task_id, client_id, student_id)
            conv_id=cur.fetchone()[0]
        cur.execute("""INSERT INTO dbo.Mensaje(
                          id_conversacion_mensaje,id_usuario_emisor_mensaje,
                          contenido_mensaje,fecha_mensaje
                      )
                      OUTPUT INSERTED.id_mensaje
                      VALUES(?,?,?,GETDATE())""",
                    conv_id, user["id_usuario"], payload.contenido_mensaje)
        msg_id=cur.fetchone()[0]
    return fetch_one("SELECT id_mensaje,id_conversacion_mensaje,id_usuario_emisor_mensaje,contenido_mensaje,fecha_mensaje FROM dbo.Mensaje WHERE id_mensaje=?",[msg_id])
