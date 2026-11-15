# SQL manual: no ORM. Todos los valores externos se pasan como parámetros.
LOGIN_QUERY = """
SELECT u.id_usuario, u.email_usuario, u.password_hash_usuario, r.nombre_rol,
       u.id_cliente_usuario, u.id_estudiante_usuario,
       u.estado_usuario, c.estado_cliente, e.estado_alumno
FROM dbo.Usuario u
JOIN dbo.Rol r ON r.id_rol = u.id_rol_usuario
LEFT JOIN dbo.Cliente c ON c.id_cliente = u.id_cliente_usuario
LEFT JOIN dbo.Estudiante e ON e.id_estudiante = u.id_estudiante_usuario
WHERE u.email_usuario = ? AND u.estado_usuario = 1
"""

TASK_LIST_QUERY = """
SELECT t.id_tarea, t.titulo_tarea, t.descripcion_tarea, t.pago_ofrecido_tarea,
       t.fecha_creacion_tarea, t.fecha_inicio_tarea, t.id_cliente_tarea,
       t.id_direccion_tarea, t.id_categoria_tarea, t.id_estado_tarea,
       et.nombre_estado, ca.nombre_categoria, nt.id_nombre_tarea, nt.nombre_tarea,
       cl.nombre1_cliente + ' ' + cl.apellido1_cliente AS cliente,
       r.nombre_region, ciu.nombre_ciudad, co.nombre_comuna,
       d.calle_direccion, d.numero_direccion, d.dpto_direccion, d.referencia_direccion
FROM dbo.Tarea t
JOIN dbo.EstadoTarea et ON et.id_estado = t.id_estado_tarea
JOIN dbo.Categoria ca ON ca.id_categoria = t.id_categoria_tarea
LEFT JOIN dbo.NombreTarea nt ON nt.id_nombre_tarea = t.id_nombre_tarea
JOIN dbo.Cliente cl ON cl.id_cliente = t.id_cliente_tarea
JOIN dbo.Direccion d ON d.id_direccion = t.id_direccion_tarea
JOIN dbo.Region r ON r.id_region = d.id_region_direccion
LEFT JOIN dbo.Comuna co ON co.id_comuna = d.id_comuna_direccion
LEFT JOIN dbo.Ciudad ciu ON ciu.id_ciudad = co.id_ciudad_comuna
WHERE et.nombre_estado = 'Disponible' AND cl.estado_cliente = 1
"""

PROFILE_CLIENT_QUERY = """
SELECT c.*, r.nombre_region, co.nombre_comuna, ciu.nombre_ciudad,
       u.email_usuario, u.estado_usuario, ro.nombre_rol
FROM dbo.Cliente c
JOIN dbo.Usuario u ON u.id_cliente_usuario = c.id_cliente
JOIN dbo.Rol ro ON ro.id_rol = u.id_rol_usuario
JOIN dbo.Direccion d ON d.id_direccion = c.id_direccion_cliente
JOIN dbo.Region r ON r.id_region = d.id_region_direccion
LEFT JOIN dbo.Comuna co ON co.id_comuna = d.id_comuna_direccion
LEFT JOIN dbo.Ciudad ciu ON ciu.id_ciudad = co.id_ciudad_comuna
WHERE c.id_cliente = ?
"""

PROFILE_STUDENT_QUERY = """
SELECT e.*, r.nombre_region, co.nombre_comuna, ciu.nombre_ciudad,
       u.email_usuario, u.estado_usuario, ro.nombre_rol
FROM dbo.Estudiante e
JOIN dbo.Usuario u ON u.id_estudiante_usuario = e.id_estudiante
JOIN dbo.Rol ro ON ro.id_rol = u.id_rol_usuario
JOIN dbo.Direccion d ON d.id_direccion = e.id_direccion_estudiante
JOIN dbo.Region r ON r.id_region = d.id_region_direccion
LEFT JOIN dbo.Comuna co ON co.id_comuna = d.id_comuna_direccion
LEFT JOIN dbo.Ciudad ciu ON ciu.id_ciudad = co.id_ciudad_comuna
WHERE e.id_estudiante = ?
"""
