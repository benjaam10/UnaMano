USE [Proyecto_UnaMano]
GO

-- 1) Feed de tareas disponibles, con ubicación y plazo de aprobación
SELECT * FROM dbo.vw_TareaPlazo WHERE fecha_inicio_tarea > GETDATE();
GO

-- 2) Postulantes por tarea, con estado
SELECT p.id_postulacion,p.fecha_postulacion,ep.nombre_estadopostulacion,
       e.id_estudiante,e.nombre1_estudiante,e.apellido1_estudiante,e.carrera_estudiante,
       h.nombre_habilidad,nd.nombre_niveldominio
FROM dbo.Postulacion p
JOIN dbo.EstadoPostulacion ep ON ep.id_estadopostulacion=p.id_estadopostulacion
JOIN dbo.Estudiante e ON e.id_estudiante=p.id_estudiante_postulacion
LEFT JOIN dbo.EstudianteHabilidad eh ON eh.id_estudiante_eh=e.id_estudiante
LEFT JOIN dbo.Habilidad h ON h.id_habilidad=eh.id_habilidad_eh
LEFT JOIN dbo.NivelDominio nd ON nd.id_niveldominio=eh.id_niveldominio_eh
WHERE p.id_tarea_postulacion=?
ORDER BY p.fecha_postulacion DESC;
GO

-- 3) Pagos y dinero que recibe el estudiante
SELECT p.id_tarea_pago,p.monto_neto_pago,p.comision_pago,p.monto_total_pago,p.fecha_pago
FROM dbo.Pago p
ORDER BY p.fecha_pago DESC;
GO

-- 4) Historial de estados de una tarea
SELECT * FROM dbo.HistorialTarea WHERE id_tarea_historial=? ORDER BY fecha_historial_tarea;
GO

-- Las consultas anteriores son manuales y parametrizadas cuando provienen de la aplicación.
