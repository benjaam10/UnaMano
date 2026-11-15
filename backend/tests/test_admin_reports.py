from datetime import date, datetime
from decimal import Decimal

import pytest
from fastapi import HTTPException
from openpyxl import load_workbook

from app.api.admin import _task_report_workbook, _validate_task_report_filters


def test_price_range_requires_finalized_tasks():
    with pytest.raises(HTTPException) as error:
        _validate_task_report_filters(
            "Asignada", None, None, Decimal("1000"), None
        )

    assert error.value.status_code == 422


def test_report_rejects_reversed_price_and_date_ranges():
    with pytest.raises(HTTPException):
        _validate_task_report_filters(
            "Finalizada", None, None, Decimal("2000"), Decimal("1000")
        )

    with pytest.raises(HTTPException):
        _validate_task_report_filters(
            None, date(2026, 12, 2), date(2026, 12, 1), None, None
        )


def test_report_accepts_expired_task_state():
    _validate_task_report_filters("Vencida", None, None, None, None)


def test_excel_report_includes_commission_totals():
    rows = [{
        "id_tarea": 1,
        "titulo_tarea": "Limpieza",
        "nombre_categoria": "Hogar",
        "nombre_estado": "Finalizada",
        "fecha_creacion_tarea": datetime(2026, 11, 1, 10),
        "fecha_inicio_tarea": datetime(2026, 12, 1, 10),
        "pago_ofrecido_tarea": Decimal("10000"),
        "comision": Decimal("1000"),
        "neto_estudiante": Decimal("9000"),
        "fecha_pago": datetime(2026, 12, 2, 10),
        "cliente": "Cliente Demo",
        "estudiante": "Estudiante Demo",
        "nombre_region": "Metropolitana de Santiago",
        "nombre_comuna": "Santiago",
        "descripcion_tarea": "Descripción",
    }]

    workbook = load_workbook(_task_report_workbook(rows, []))

    assert workbook["Tareas"]["H2"].value == 1000
    assert workbook["Resumen"]["B6"].value == 1000
