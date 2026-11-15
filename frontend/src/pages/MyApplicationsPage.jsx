import {useEffect, useState} from 'react';
import {Link} from 'react-router-dom';
import {api} from '../services/api';

function applicationStatus(application) {
  return ['Finalizada', 'Vencida'].includes(application.nombre_estado_tarea)
    ? application.nombre_estado_tarea
    : application.nombre_estadopostulacion;
}

export default function MyApplicationsPage() {
  const [applications, setApplications] = useState([]);
  const [filter, setFilter] = useState('Todas');

  useEffect(() => {
    api('/my-applications').then(setApplications);
  }, []);

  const visibleApplications = applications.filter(application =>
    filter === 'Todas' || applicationStatus(application) === filter
  );

  return <main className="section my-applications">
    <div className="section-head">
      <div>
        <span className="eyebrow">ESTUDIANTE</span>
        <h1>Mis postulaciones</h1>
      </div>
      <label className="application-filter">
        Filtrar por estado
        <select value={filter} onChange={event => setFilter(event.target.value)}>
          <option value="Todas">Todas</option>
          <option value="Pendiente">Pendiente</option>
          <option value="Aceptada">Aceptada</option>
          <option value="Finalizada">Finalizada</option>
          <option value="Vencida">Vencida</option>
        </select>
      </label>
    </div>

    {visibleApplications.length === 0
      ? <p className="meta">No hay postulaciones para este estado.</p>
      : <div className="task-grid">
        {visibleApplications.map(application => {
          const status = applicationStatus(application);
          return <article key={application.id_postulacion} className="task-card">
            <span className="tag">{status}</span>
            <h3>{application.titulo_tarea}</h3>
            <p>{application.descripcion_tarea}</p>
            <div className="meta">{application.nombre_comuna} · {new Date(application.fecha_inicio_tarea).toLocaleString('es-CL')}</div>
            <div className="task-foot">
              <b>${Number(application.pago_ofrecido_tarea).toLocaleString('es-CL')}</b>
              <Link className="secondary btn" to={`/tareas/${application.id_tarea}`}>Abrir</Link>
            </div>
          </article>;
        })}
      </div>}
  </main>;
}
