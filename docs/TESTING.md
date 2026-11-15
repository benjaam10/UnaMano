# Testing de la entrega

## Ejecutado

1. `python -m py_compile` sobre todo `backend/app`: OK.
2. `pytest -q backend/tests`: **9 passed**.
3. Validación sintáctica de 16 archivos `.js/.jsx` con TypeScript `transpileModule`: OK.
4. Checks estructurales del SQL: tablas/atributos originales presentes y extensiones críticas presentes: OK.

## No ejecutado

- `vite build`: no ejecutado porque `npm install` no alcanzó a completar en el entorno de generación.
- Conexión real a SQL Server: no ejecutada porque este entorno no tiene una instancia SQL Server/ODBC disponible.

Por ello, la entrega distingue entre pruebas locales ejecutadas y validación de integración pendiente de correr en el SQL Server del equipo.
