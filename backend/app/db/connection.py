from contextlib import contextmanager
from typing import Iterable, Any
import pyodbc

from app.core.config import settings

def get_connection() -> pyodbc.Connection:
    if not settings.db_connection_string:
        raise RuntimeError("DATABASE_CONNECTION_STRING no está configurada")
    return pyodbc.connect(settings.db_connection_string, timeout=10)

def rows_to_dicts(cursor) -> list[dict]:
    columns = [c[0] for c in cursor.description] if cursor.description else []
    return [dict(zip(columns, row)) for row in cursor.fetchall()] if columns else []

def row_to_dict(cursor):
    rows = rows_to_dicts(cursor)
    return rows[0] if rows else None

@contextmanager
def transaction():
    conn = get_connection()
    try:
        yield conn
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()

def fetch_all(sql: str, params: Iterable[Any] = ()) -> list[dict]:
    conn = get_connection()
    try:
        cur = conn.cursor()
        cur.execute(sql, tuple(params))
        return rows_to_dicts(cur)
    finally:
        conn.close()

def fetch_one(sql: str, params: Iterable[Any] = ()) -> dict | None:
    conn = get_connection()
    try:
        cur = conn.cursor()
        cur.execute(sql, tuple(params))
        return row_to_dict(cur)
    finally:
        conn.close()

def execute(sql: str, params: Iterable[Any] = ()) -> int:
    with transaction() as conn:
        cur = conn.cursor()
        cur.execute(sql, tuple(params))
        return cur.rowcount
