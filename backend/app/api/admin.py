from datetime import date, datetime
from decimal import Decimal
from io import BytesIO
from fastapi import APIRouter, Depends, HTTPException
from fastapi.responses import StreamingResponse
from pydantic import BaseModel, Field
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill
from app.api.deps import require_role
from app.db.connection import fetch_all, fetch_one, transaction

router=APIRouter(prefix="/admin",tags=["Administrador"])
class CategoryIn(BaseModel):
    nombre_categoria:str=Field(min_length=1,max_length=50)
    descripcion_categoria:str=Field(default="",max_length=200)
class TaskNameIn(BaseModel):
    nombre_tarea:str=Field(min_length=1,max_length=100)
    descripcion_nombre_tarea:str=Field(default="",max_length=300)
    id_categoria_nombre_tarea:int=Field(gt=0)

@router.get("/categories")
def categories(user=Depends(require_role("Admin"))):
    return fetch_all("SELECT id_categoria,nombre_categoria,descripcion_categoria,estado_categoria FROM dbo.Categoria ORDER BY nombre_categoria")
@router.post("/categories")
def create_category(data:CategoryIn,user=Depends(require_role("Admin"))):
    with transaction() as conn:
        cur=conn.cursor(); cur.execute("INSERT INTO dbo.Categoria(nombre_categoria,descripcion_categoria,estado_categoria) VALUES(?,?,1)",data.nombre_categoria,data.descripcion_categoria or "Sin descripción")
        cur.execute("SELECT CAST(SCOPE_IDENTITY() AS int)"); return_id=cur.fetchone()[0]
    return fetch_one("SELECT * FROM dbo.Categoria WHERE id_categoria=?",[return_id])
@router.put("/categories/{category_id}")
def update_category(category_id:int,data:CategoryIn,user=Depends(require_role("Admin"))):
    with transaction() as conn:
        cur=conn.cursor(); cur.execute("UPDATE dbo.Categoria SET nombre_categoria=?,descripcion_categoria=? WHERE id_categoria=?",data.nombre_categoria,data.descripcion_categoria or "Sin descripción",category_id)
        if cur.rowcount==0: raise HTTPException(404,"Categoría no encontrada")
    return fetch_one("SELECT * FROM dbo.Categoria WHERE id_categoria=?",[category_id])
@router.patch("/categories/{category_id}/toggle")
def toggle_category(category_id:int,user=Depends(require_role("Admin"))):
    execute_sql="UPDATE dbo.Categoria SET estado_categoria=CASE WHEN estado_categoria=1 THEN 0 ELSE 1 END WHERE id_categoria=?"
    with transaction() as conn:
        cur=conn.cursor(); cur.execute(execute_sql,category_id)
    return fetch_one("SELECT * FROM dbo.Categoria WHERE id_categoria=?",[category_id])

@router.get("/task-names")
def task_names(user=Depends(require_role("Admin"))):
    return fetch_all("""SELECT nt.id_nombre_tarea,nt.nombre_tarea,nt.descripcion_nombre_tarea,nt.id_categoria_nombre_tarea,nt.estado_nombre_tarea,ca.nombre_categoria
                       FROM dbo.NombreTarea nt JOIN dbo.Categoria ca ON ca.id_categoria=nt.id_categoria_nombre_tarea ORDER BY ca.nombre_categoria,nt.nombre_tarea""")
@router.post("/task-names")
def create_task_name(data:TaskNameIn,user=Depends(require_role("Admin"))):
    with transaction() as conn:
        cur=conn.cursor(); cur.execute("INSERT INTO dbo.NombreTarea(nombre_tarea,descripcion_nombre_tarea,id_categoria_nombre_tarea,estado_nombre_tarea) VALUES(?,?,?,1)",data.nombre_tarea,data.descripcion_nombre_tarea,data.id_categoria_nombre_tarea)
        cur.execute("SELECT CAST(SCOPE_IDENTITY() AS int)"); rid=cur.fetchone()[0]
    return fetch_one("SELECT * FROM dbo.NombreTarea WHERE id_nombre_tarea=?",[rid])
@router.put("/task-names/{name_id}")
def update_task_name(name_id:int,data:TaskNameIn,user=Depends(require_role("Admin"))):
    with transaction() as conn:
        cur=conn.cursor(); cur.execute("UPDATE dbo.NombreTarea SET nombre_tarea=?,descripcion_nombre_tarea=?,id_categoria_nombre_tarea=? WHERE id_nombre_tarea=?",data.nombre_tarea,data.descripcion_nombre_tarea,data.id_categoria_nombre_tarea,name_id)
        if cur.rowcount==0: raise HTTPException(404,"Nombre de tarea no encontrado")
    return fetch_one("SELECT * FROM dbo.NombreTarea WHERE id_nombre_tarea=?",[name_id])
@router.patch("/task-names/{name_id}/toggle")
def toggle_task_name(name_id:int,user=Depends(require_role("Admin"))):
    with transaction() as conn:
        cur=conn.cursor(); cur.execute("UPDATE dbo.NombreTarea SET estado_nombre_tarea=CASE WHEN estado_nombre_tarea=1 THEN 0 ELSE 1 END WHERE id_nombre_tarea=?",name_id)
    return fetch_one("SELECT * FROM dbo.NombreTarea WHERE id_nombre_tarea=?",[name_id])

@router.get("/tasks")
def admin_tasks(user=Depends(require_role("Admin"))):
    return fetch_all("""
        SELECT t.id_tarea,t.titulo_tarea,t.descripcion_tarea,t.pago_ofrecido_tarea,
               t.fecha_creacion_tarea,t.fecha_inicio_tarea,et.nombre_estado,
               ca.nombre_categoria,nt.nombre_tarea,c.id_cliente,
               c.nombre1_cliente,c.apellido1_cliente,
               d.calle_direccion,d.numero_direccion,r.nombre_region,
               co.nombre_comuna,ci.nombre_ciudad
        FROM dbo.Tarea t
        JOIN dbo.EstadoTarea et ON et.id_estado=t.id_estado_tarea
        JOIN dbo.Categoria ca ON ca.id_categoria=t.id_categoria_tarea
        LEFT JOIN dbo.NombreTarea nt ON nt.id_nombre_tarea=t.id_nombre_tarea
        JOIN dbo.Cliente c ON c.id_cliente=t.id_cliente_tarea
        JOIN dbo.Direccion d ON d.id_direccion=t.id_direccion_tarea
        JOIN dbo.Region r ON r.id_region=d.id_region_direccion
        LEFT JOIN dbo.Comuna co ON co.id_comuna=d.id_comuna_direccion
        LEFT JOIN dbo.Ciudad ci ON ci.id_ciudad=co.id_ciudad_comuna
        ORDER BY t.fecha_creacion_tarea DESC
    """)

def _validate_task_report_filters(estado, fecha_desde, fecha_hasta, precio_minimo, precio_maximo):
    allowed_states = {"Disponible", "Asignada", "Finalizada", "Cancelada", "Vencida"}
    if estado and estado not in allowed_states:
        raise HTTPException(422, "Estado de tarea inválido")
    if fecha_desde and fecha_hasta and fecha_desde > fecha_hasta:
        raise HTTPException(422, "La fecha desde no puede ser posterior a la fecha hasta")
    if precio_minimo is not None and precio_maximo is not None and precio_minimo > precio_maximo:
        raise HTTPException(422, "El precio mínimo no puede superar el precio máximo")
    if (precio_minimo is not None or precio_maximo is not None) and estado != "Finalizada":
        raise HTTPException(422, "El rango de precio solo se puede aplicar a tareas finalizadas")

def _task_report_workbook(rows, filters):
    workbook = Workbook()
    report = workbook.active
    report.title = "Tareas"

    headers = [
        "ID tarea", "Título", "Categoría", "Estado", "Fecha de publicación",
        "Fecha de inicio", "Pago ofrecido", "Comisión", "Neto estudiante",
        "Fecha de pago", "Cliente", "Estudiante", "Región", "Comuna", "Descripción",
    ]
    report.append(headers)
    for cell in report[1]:
        cell.font = Font(bold=True, color="FFFFFF")
        cell.fill = PatternFill("solid", fgColor="2457C5")
    report.freeze_panes = "A2"
    report.auto_filter.ref = f"A1:O{max(1, len(rows) + 1)}"

    for row in rows:
        report.append([
            row["id_tarea"], row["titulo_tarea"], row["nombre_categoria"], row["nombre_estado"],
            row["fecha_creacion_tarea"], row["fecha_inicio_tarea"],
            float(row["pago_ofrecido_tarea"]), float(row["comision"]), float(row["neto_estudiante"]),
            row["fecha_pago"], row["cliente"], row["estudiante"], row["nombre_region"],
            row["nombre_comuna"], row["descripcion_tarea"],
        ])

    for row in report.iter_rows(min_row=2):
        for column in (7, 8, 9):
            row[column - 1].number_format = '"$"#,##0.00'
        for column in (5, 6, 10):
            row[column - 1].number_format = "dd-mm-yyyy hh:mm"

    widths = [12, 32, 20, 16, 22, 22, 18, 16, 20, 22, 28, 28, 34, 24, 60]
    for index, width in enumerate(widths, start=1):
        report.column_dimensions[report.cell(row=1, column=index).column_letter].width = width

    summary = workbook.create_sheet("Resumen")
    commission_total = sum((row["comision"] or Decimal("0") for row in rows), Decimal("0"))
    offered_total = sum((row["pago_ofrecido_tarea"] or Decimal("0") for row in rows), Decimal("0"))
    student_total = sum((row["neto_estudiante"] or Decimal("0") for row in rows), Decimal("0"))
    paid_count = sum(1 for row in rows if row["fecha_pago"] is not None)
    summary.append(["Resumen del reporte", ""])
    summary["A1"].font = Font(bold=True, size=14, color="2457C5")
    summary.append(["Generado", datetime.now()])
    summary.append(["Tareas", len(rows)])
    summary.append(["Pagos registrados", paid_count])
    summary.append(["Pago ofrecido total", float(offered_total)])
    summary.append(["Ganancias por comisiones", float(commission_total)])
    summary.append(["Neto total para estudiantes", float(student_total)])
    summary.append(["Filtros aplicados", ""])
    for label, value in filters:
        if value is not None:
            summary.append([label, value])
    for index, width in enumerate((32, 42), start=1):
        summary.column_dimensions[summary.cell(row=1, column=index).column_letter].width = width
    for row in (5, 6, 7):
        summary.cell(row=row, column=2).number_format = '"$"#,##0.00'
    summary["B2"].number_format = "dd-mm-yyyy hh:mm"

    output = BytesIO()
    workbook.save(output)
    output.seek(0)
    return output

@router.get("/reports/tasks.xlsx")
def download_task_report(
    categoria: int | None = None,
    estado: str | None = None,
    fecha_desde: date | None = None,
    fecha_hasta: date | None = None,
    precio_minimo: Decimal | None = None,
    precio_maximo: Decimal | None = None,
    region: int | None = None,
    comuna: int | None = None,
    user=Depends(require_role("Admin")),
):
    _validate_task_report_filters(estado, fecha_desde, fecha_hasta, precio_minimo, precio_maximo)

    conditions = []
    params = []
    if categoria is not None:
        conditions.append("t.id_categoria_tarea=?")
        params.append(categoria)
    if estado:
        conditions.append("et.nombre_estado=?")
        params.append(estado)
    if fecha_desde:
        conditions.append("t.fecha_inicio_tarea>=?")
        params.append(fecha_desde)
    if fecha_hasta:
        conditions.append("t.fecha_inicio_tarea<DATEADD(DAY,1,?)")
        params.append(fecha_hasta)
    if precio_minimo is not None:
        conditions.append("t.pago_ofrecido_tarea>=?")
        params.append(precio_minimo)
    if precio_maximo is not None:
        conditions.append("t.pago_ofrecido_tarea<=?")
        params.append(precio_maximo)
    if region is not None:
        conditions.append("d.id_region_direccion=?")
        params.append(region)
    if comuna is not None:
        conditions.append("d.id_comuna_direccion=?")
        params.append(comuna)

    where_clause = "WHERE " + " AND ".join(conditions) if conditions else ""
    rows = fetch_all(f"""
        SELECT t.id_tarea,t.titulo_tarea,t.descripcion_tarea,t.pago_ofrecido_tarea,
               t.fecha_creacion_tarea,t.fecha_inicio_tarea,et.nombre_estado,
               ca.nombre_categoria,r.nombre_region,co.nombre_comuna,
               COALESCE(cl.nombre1_cliente + ' ' + cl.apellido1_cliente,'') AS cliente,
               COALESCE(assigned.nombre1_estudiante + ' ' + assigned.apellido1_estudiante,'Sin asignar') AS estudiante,
               COALESCE(pg.comision_pago,CAST(0 AS decimal(10,2))) AS comision,
               COALESCE(pg.monto_total_pago,CAST(0 AS decimal(10,2))) AS neto_estudiante,
               pg.fecha_pago
        FROM dbo.Tarea t
        JOIN dbo.EstadoTarea et ON et.id_estado=t.id_estado_tarea
        JOIN dbo.Categoria ca ON ca.id_categoria=t.id_categoria_tarea
        JOIN dbo.Cliente cl ON cl.id_cliente=t.id_cliente_tarea
        JOIN dbo.Direccion d ON d.id_direccion=t.id_direccion_tarea
        JOIN dbo.Region r ON r.id_region=d.id_region_direccion
        LEFT JOIN dbo.Comuna co ON co.id_comuna=d.id_comuna_direccion
        LEFT JOIN dbo.Pago pg ON pg.id_tarea_pago=t.id_tarea
        OUTER APPLY (
            SELECT TOP (1) e.nombre1_estudiante,e.apellido1_estudiante
            FROM dbo.Postulacion p
            JOIN dbo.EstadoPostulacion ep ON ep.id_estadopostulacion=p.id_estadopostulacion
            JOIN dbo.Estudiante e ON e.id_estudiante=p.id_estudiante_postulacion
            WHERE p.id_tarea_postulacion=t.id_tarea AND ep.nombre_estadopostulacion='Aceptada'
            ORDER BY p.fecha_postulacion DESC,p.id_postulacion DESC
        ) assigned
        {where_clause}
        ORDER BY t.fecha_inicio_tarea DESC,t.id_tarea DESC
    """, params)

    filters = [
        ("Categoría (ID)", categoria),
        ("Estado", estado),
        ("Inicio desde", fecha_desde.isoformat() if fecha_desde else None),
        ("Inicio hasta", fecha_hasta.isoformat() if fecha_hasta else None),
        ("Precio mínimo", precio_minimo),
        ("Precio máximo", precio_maximo),
        ("Región (ID)", region),
        ("Comuna (ID)", comuna),
    ]
    output = _task_report_workbook(rows, filters)
    filename = f"reporte_tareas_{datetime.now():%Y%m%d_%H%M%S}.xlsx"
    return StreamingResponse(
        output,
        media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        headers={"Content-Disposition": f'attachment; filename="{filename}"'},
    )
