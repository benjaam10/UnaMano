from datetime import datetime, timedelta

class BusinessRuleError(ValueError):
    pass

def approval_deadline(fecha_creacion: datetime, fecha_inicio: datetime) -> datetime:
    hours = (fecha_inicio - fecha_creacion).total_seconds() / 3600
    if hours <= 8:
        raise BusinessRuleError("No se puede publicar una tarea con 8 horas o menos de anticipación")
    if hours > 168:
        return fecha_inicio - timedelta(days=2)
    if hours > 72:
        return fecha_inicio - timedelta(days=1)
    if hours > 24:
        return fecha_inicio - timedelta(hours=8)
    return fecha_inicio - timedelta(hours=4)

def can_apply(now: datetime, deadline: datetime) -> bool:
    return now <= deadline

def can_edit_task(has_applications: bool) -> bool:
    return not has_applications

def can_cancel_client(now: datetime, start: datetime, has_accepted: bool) -> bool:
    if not has_accepted:
        return True
    return now <= start - timedelta(hours=5)
