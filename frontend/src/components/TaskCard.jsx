import {Link} from 'react-router-dom';

export default function TaskCard({task}) {
  const category = (task.nombre_categoria || '').toLowerCase();
  const visual = category.includes('jard') ? 'garden' : category.includes('hogar') ? 'home' : category.includes('tecn') ? 'tech' : 'service';
  return <article className="task-card">
    <div className={`task-visual ${visual}`} aria-hidden="true"><span>{visual === 'garden' ? '🌿' : visual === 'home' ? '🏠' : visual === 'tech' ? '💻' : '🤝'}</span></div>
    <div className="task-card-body">
      <div className="task-card-top"><span className="tag">{task.nombre_categoria}</span><span className="task-date">Disponible</span></div>
      <strong className="task-price">${Number(task.pago_ofrecido_tarea).toLocaleString('es-CL')}</strong>
      <h3>{task.nombre_tarea || task.titulo_tarea}</h3>
      <div className="meta">⌖ {task.nombre_comuna || 'Sin comuna'}</div>
      <p>{task.descripcion_tarea}</p>
      <Link className="primary btn task-link" to={`/tareas/${task.id_tarea}`}>Ver tarea</Link>
    </div>
  </article>;
}
