from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException, Query
from app.api.deps import get_current_user, require_role
from app.db.connection import fetch_all, fetch_one, transaction
from app.schemas.tasks import TaskCreate, TaskUpdate
from app.services.business_rules import approval_deadline

router = APIRouter(prefix="/tasks", tags=["Tareas"])

def _detail(task_id: int):
    return fetch_one("""
    SELECT t.*, et.nombre_estado, ca.nombre_categoria,
           nt.nombre_tarea, cl.nombre1_cliente + ' ' + cl.apellido1_cliente AS cliente,
           r.id_region, r.nombre_region, co.id_comuna, co.nombre_comuna,
           ci.id_ciudad, ci.nombre_ciudad, d.calle_direccion, d.numero_direccion,
           d.dpto_direccion, d.referencia_direccion,
           v.fecha_limite_aprobacion, v.horas_anticipacion_publicacion,
           p.id_pago, p.monto_neto_pago, p.comision_pago, p.monto_total_pago
    FROM dbo.Tarea t
    JOIN dbo.EstadoTarea et ON et.id_estado=t.id_estado_tarea
    JOIN dbo.Categoria ca ON ca.id_categoria=t.id_categoria_tarea
    LEFT JOIN dbo.NombreTarea nt ON nt.id_nombre_tarea=t.id_nombre_tarea
    JOIN dbo.Cliente cl ON cl.id_cliente=t.id_cliente_tarea
    JOIN dbo.Direccion d ON d.id_direccion=t.id_direccion_tarea
    JOIN dbo.Region r ON r.id_region=d.id_region_direccion
    LEFT JOIN dbo.Comuna co ON co.id_comuna=d.id_comuna_direccion
    LEFT JOIN dbo.Ciudad ci ON ci.id_ciudad=co.id_ciudad_comuna
    LEFT JOIN dbo.vw_TareaPlazo v ON v.id_tarea=t.id_tarea
    LEFT JOIN dbo.Pago p ON p.id_tarea_pago=t.id_tarea
    WHERE t.id_tarea=?
    """, [task_id])

@router.get("")
def list_tasks(region: int|None=Query(None), comuna: int|None=Query(None), categoria: int|None=Query(None)):
    sql = """
    SELECT t.id_tarea, t.titulo_tarea, t.descripcion_tarea, t.pago_ofrecido_tarea,
           t.fecha_inicio_tarea, t.id_categoria_tarea, t.id_estado_tarea, et.nombre_estado,
           ca.nombre_categoria, nt.nombre_tarea, cl.id_cliente,
           cl.nombre1_cliente + ' ' + cl.apellido1_cliente AS cliente,
           r.id_region, r.nombre_region, co.id_comuna, co.nombre_comuna,
           ci.id_ciudad, ci.nombre_ciudad, d.calle_direccion, d.numero_direccion,
           v.fecha_limite_aprobacion
    FROM dbo.Tarea t
    JOIN dbo.EstadoTarea et ON et.id_estado=t.id_estado_tarea AND et.nombre_estado='Disponible'
    JOIN dbo.Categoria ca ON ca.id_categoria=t.id_categoria_tarea
    LEFT JOIN dbo.NombreTarea nt ON nt.id_nombre_tarea=t.id_nombre_tarea
    JOIN dbo.Cliente cl ON cl.id_cliente=t.id_cliente_tarea AND cl.estado_cliente=1
    JOIN dbo.Direccion d ON d.id_direccion=t.id_direccion_tarea
    JOIN dbo.Region r ON r.id_region=d.id_region_direccion
    LEFT JOIN dbo.Comuna co ON co.id_comuna=d.id_comuna_direccion
    LEFT JOIN dbo.Ciudad ci ON ci.id_ciudad=co.id_ciudad_comuna
    LEFT JOIN dbo.vw_TareaPlazo v ON v.id_tarea=t.id_tarea
    WHERE 1=1
    """
    params=[]
    if region is not None: sql += " AND d.id_region_direccion=?"; params.append(region)
    if comuna is not None: sql += " AND d.id_comuna_direccion=?"; params.append(comuna)
    if categoria is not None: sql += " AND t.id_categoria_tarea=?"; params.append(categoria)
    sql += " ORDER BY t.fecha_inicio_tarea ASC"
    return fetch_all(sql, params)

@router.get("/mine")
def my_tasks(user=Depends(require_role("Cliente"))):
    return fetch_all("""
        SELECT t.id_tarea,t.titulo_tarea,t.descripcion_tarea,t.pago_ofrecido_tarea,t.fecha_inicio_tarea,
               et.nombre_estado,ca.nombre_categoria,nt.nombre_tarea,
               r.nombre_region,co.nombre_comuna,ci.nombre_ciudad,d.calle_direccion,d.numero_direccion
        FROM dbo.Tarea t JOIN dbo.EstadoTarea et ON et.id_estado=t.id_estado_tarea
        JOIN dbo.Categoria ca ON ca.id_categoria=t.id_categoria_tarea
        LEFT JOIN dbo.NombreTarea nt ON nt.id_nombre_tarea=t.id_nombre_tarea
        JOIN dbo.Direccion d ON d.id_direccion=t.id_direccion_tarea
        JOIN dbo.Region r ON r.id_region=d.id_region_direccion
        LEFT JOIN dbo.Comuna co ON co.id_comuna=d.id_comuna_direccion
        LEFT JOIN dbo.Ciudad ci ON ci.id_ciudad=co.id_ciudad_comuna
        WHERE t.id_cliente_tarea=? ORDER BY t.fecha_inicio_tarea ASC
    """,[user["id_cliente_usuario"]])

@router.get("/{task_id}")
def get_task(task_id: int):
    row = _detail(task_id)
    if not row: raise HTTPException(404, "Tarea no encontrada")
    return row

@router.post("", dependencies=[Depends(require_role("Cliente"))])
def create_task(payload: TaskCreate, user=Depends(get_current_user)):
    now = datetime.now().replace(microsecond=0)
    try: approval_deadline(now, payload.fecha_inicio_tarea)
    except ValueError as exc: raise HTTPException(422, str(exc))
    if user["estado_cliente"] != 1: raise HTTPException(403, "Cliente desactivado")
    try:
        with transaction() as conn:
            cur = conn.cursor()
            cur.execute("SELECT 1 FROM dbo.NombreTarea WHERE id_nombre_tarea=? AND id_categoria_nombre_tarea=? AND estado_nombre_tarea=1", payload.id_nombre_tarea, payload.id_categoria_tarea)
            if not cur.fetchone():
                raise HTTPException(422, "El nombre de tarea no corresponde a la categoría")
            cur.execute("SELECT 1 FROM dbo.Comuna co JOIN dbo.Ciudad ci ON ci.id_ciudad=co.id_ciudad_comuna WHERE co.id_comuna=? AND ci.id_region_ciudad=?", payload.direccion.id_comuna, payload.direccion.id_region)
            if not cur.fetchone():
                raise HTTPException(422, "La comuna no pertenece a la región seleccionada")
            cur.execute("""INSERT INTO dbo.Direccion(calle_direccion, numero_direccion, dpto_direccion, referencia_direccion, id_region_direccion, id_comuna_direccion)
                           OUTPUT INSERTED.id_direccion
                           VALUES (?,?,?,?,?,?)""", payload.direccion.calle, payload.direccion.numero, payload.direccion.dpto, payload.direccion.referencia, payload.direccion.id_region, payload.direccion.id_comuna)
            address_id = cur.fetchone()[0]
            if address_id is None:
                raise HTTPException(500, "No fue posible obtener la dirección creada")
            cur.execute("SELECT id_estado FROM dbo.EstadoTarea WHERE nombre_estado='Disponible'")
            state = cur.fetchone()
            if not state:
                raise HTTPException(500, "No existe el estado Disponible en la base de datos")
            cur.execute("""INSERT INTO dbo.Tarea(titulo_tarea, descripcion_tarea, pago_ofrecido_tarea, fecha_creacion_tarea,
                         fecha_inicio_tarea, id_cliente_tarea, id_direccion_tarea, id_categoria_tarea, id_nombre_tarea, id_estado_tarea)
                         OUTPUT INSERTED.id_tarea
                         VALUES (?,?,?,?,?,?,?,?,?,?)""", payload.titulo_tarea, payload.descripcion_tarea, payload.pago_ofrecido_tarea,
                        now, payload.fecha_inicio_tarea, user["id_cliente_usuario"], address_id, payload.id_categoria_tarea, payload.id_nombre_tarea, state[0])
            task_id = cur.fetchone()[0]
            if task_id is None:
                raise HTTPException(500, "No fue posible obtener la tarea creada")
    except HTTPException:
        raise
    except Exception as exc:
        raise HTTPException(400, f"No fue posible publicar la tarea: {exc}")
    return _detail(task_id)

@router.put("/{task_id}")
def update_task(task_id: int, payload: TaskUpdate, user=Depends(require_role("Cliente", "Admin"))):
    task = fetch_one("""SELECT t.id_tarea, t.id_cliente_tarea, t.id_estado_tarea, et.nombre_estado,
                               CASE WHEN EXISTS(SELECT 1 FROM dbo.Postulacion p WHERE p.id_tarea_postulacion=t.id_tarea) THEN 1 ELSE 0 END AS tiene_postulaciones
                        FROM dbo.Tarea t JOIN dbo.EstadoTarea et ON et.id_estado=t.id_estado_tarea WHERE t.id_tarea=?""", [task_id])
    if not task: raise HTTPException(404, "Tarea no encontrada")
    if user["nombre_rol"]=="Cliente" and task["id_cliente_tarea"]!=user["id_cliente_usuario"]: raise HTTPException(403, "No es tu tarea")
    if user["nombre_rol"]=="Cliente" and task["tiene_postulaciones"]: raise HTTPException(409, "No puedes modificar una tarea después de recibir postulaciones")
    with transaction() as conn:
        cur=conn.cursor()
        cur.execute("SELECT 1 FROM dbo.NombreTarea WHERE id_nombre_tarea=? AND id_categoria_nombre_tarea=? AND estado_nombre_tarea=1", payload.id_nombre_tarea, payload.id_categoria_tarea)
        if not cur.fetchone(): raise HTTPException(422, "Nombre de tarea inválido")
        cur.execute("SELECT id_direccion_tarea FROM dbo.Tarea WHERE id_tarea=?", task_id); old_address=cur.fetchone()[0]
        cur.execute("""UPDATE dbo.Direccion SET calle_direccion=?, numero_direccion=?, dpto_direccion=?, referencia_direccion=?, id_region_direccion=?, id_comuna_direccion=? WHERE id_direccion=?""",
                    payload.direccion.calle, payload.direccion.numero, payload.direccion.dpto, payload.direccion.referencia, payload.direccion.id_region, payload.direccion.id_comuna, old_address)
        cur.execute("""UPDATE dbo.Tarea SET titulo_tarea=?, descripcion_tarea=?, pago_ofrecido_tarea=?, fecha_inicio_tarea=?, id_categoria_tarea=?, id_nombre_tarea=? WHERE id_tarea=?""",
                    payload.titulo_tarea, payload.descripcion_tarea, payload.pago_ofrecido_tarea, payload.fecha_inicio_tarea, payload.id_categoria_tarea, payload.id_nombre_tarea, task_id)
    return _detail(task_id)

@router.delete("/{task_id}")
def cancel_task(task_id:int, user=Depends(require_role("Cliente","Admin"))):
    row=fetch_one("SELECT t.id_tarea, t.id_cliente_tarea FROM dbo.Tarea t WHERE t.id_tarea=?", [task_id])
    if not row: raise HTTPException(404,"Tarea no encontrada")
    if user["nombre_rol"]=="Cliente" and row["id_cliente_tarea"]!=user["id_cliente_usuario"]: raise HTTPException(403,"No es tu tarea")
    try:
        fetch_one("EXEC dbo.sp_CancelarTareaCliente ? , ?", [task_id, user["id_usuario"]])
    except Exception as exc:
        raise HTTPException(409, str(exc))
    return _detail(task_id)

@router.post("/{task_id}/complete")
def complete_task(task_id:int, user=Depends(require_role("Estudiante"))):
    try:
        with transaction() as conn:
            cur=conn.cursor(); cur.execute("EXEC dbo.sp_FinalizarTarea ?, ?", task_id, user["id_usuario"])
    except Exception as exc: raise HTTPException(409,str(exc))
    return _detail(task_id)

@router.post("/{task_id}/pay")
def pay_task(task_id:int, user=Depends(require_role("Cliente"))):
    try:
        with transaction() as conn:
            cur=conn.cursor(); cur.execute("EXEC dbo.sp_RegistrarPago ?, ?, ?", task_id, user["id_usuario"], float(__import__('os').getenv('PAYMENT_COMMISSION_PERCENT','10')))
            rows=[]
            if cur.description:
                cols=[d[0] for d in cur.description]; rows=[dict(zip(cols,r)) for r in cur.fetchall()]
    except Exception as exc: raise HTTPException(409,str(exc))
    return rows[0] if rows else {"ok":True}
