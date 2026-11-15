import {useEffect, useState} from 'react';
import {useParams, useSearchParams} from 'react-router-dom';
import {api} from '../services/api';
import Chat from '../components/Chat';

export default function TaskDetailPage({user}) {
  const {id} = useParams();
  const [searchParams] = useSearchParams();
  const [task, setTask] = useState(null);
  const [applications, setApplications] = useState([]);
  const [myApplication, setMyApplication] = useState(null);
  const [chatStudent, setChatStudent] = useState(null);
  const [message, setMessage] = useState('');
  const [working, setWorking] = useState(false);

  async function load() {
    setTask(await api(`/tasks/${id}`));
    if (user?.role === 'Cliente') {
      setApplications(await api(`/tasks/${id}/applications`));
    } else if (user?.role === 'Estudiante') {
      const mine = await api('/my-applications');
      setMyApplication(mine.find(a => String(a.id_tarea) === String(id)) || null);
    }
  }

  useEffect(() => { load(); }, [id, user?.role]);
  useEffect(() => {
    const requestedStudent = searchParams.get('chat');
    if (user?.role === 'Cliente' && requestedStudent) setChatStudent(Number(requestedStudent));
  }, [searchParams, user?.role]);

  if (!task) return <main className="section">Cargando...</main>;

  async function act(path) {
    setMessage('');
    setWorking(true);
    try {
      const result = await api(path, {method: 'POST'});
      await load();
      setMessage(path.endsWith('/pay')
        ? `Pago realizado correctamente. Se abonaron $${Number(result.monto_total_pago).toLocaleString('es-CL')} al saldo del estudiante.`
        : 'Operación realizada correctamente.');
    } catch (error) {
      setMessage(error.message);
    } finally {
      setWorking(false);
    }
  }

  const acceptedStudent = applications.find(a => a.nombre_estadopostulacion === 'Aceptada');
  const accepted = myApplication?.nombre_estadopostulacion === 'Aceptada';

  return <main className="section">
    {message && <p className={message.includes('correctamente') ? 'notice' : 'error'}>{message}</p>}
    <div className="detail">
      <span className="tag">{task.nombre_categoria}</span>
      <h1>{task.nombre_tarea || task.titulo_tarea}</h1>
      <p>{task.descripcion_tarea}</p>
      <div className="detail-grid">
        <div className="panel">
          <h3>Información</h3>
          <p>Pago ofrecido: <b>${Number(task.pago_ofrecido_tarea).toLocaleString('es-CL')}</b></p>
          <p>Inicio: {new Date(task.fecha_inicio_tarea).toLocaleString('es-CL')}</p>
          <p>Ubicación: {task.calle_direccion} {task.numero_direccion}, {task.nombre_comuna}, {task.nombre_region}</p>
          <p>Estado: <b>{task.nombre_estado}</b></p>
          <p>Plazo de aprobación: {new Date(task.fecha_limite_aprobacion).toLocaleString('es-CL')}</p>
          {user?.role === 'Estudiante' && !myApplication && <button className="primary" disabled={working} onClick={() => act(`/tasks/${id}/apply`)}>{working ? 'Enviando...' : 'Postular'}</button>}
          {user?.role === 'Estudiante' && myApplication &&
            <p className="notice">Estado: <b>{['Finalizada', 'Vencida'].includes(task.nombre_estado) ? task.nombre_estado : myApplication.nombre_estadopostulacion}</b></p>}
          {user?.role === 'Estudiante' && task.nombre_estado === 'Asignada' && <button className="secondary" onClick={() => act(`/tasks/${id}/complete`)}>Marcar finalizada</button>}
          {user?.role === 'Cliente' && task.nombre_estado === 'Finalizada' && !task.id_pago &&
            <button className="primary" disabled={working} onClick={() => act(`/tasks/${id}/pay`)}>
              {working ? 'Procesando pago...' : `Pagar $${Number(task.pago_ofrecido_tarea).toLocaleString('es-CL')}`}
            </button>}
          {user?.role === 'Cliente' && task.id_pago &&
            <p className="notice">Tarea pagada. El estudiante recibió ${Number(task.monto_total_pago).toLocaleString('es-CL')}.</p>}
        </div>
        <div className="panel">
          <h3>Cliente</h3>
          <p>{task.cliente}</p>
          <p>La selección final la realiza el dueño de hogar.</p>
        </div>
      </div>
    </div>

    {user?.role === 'Cliente' && applications.length > 0 && <div className="panel app-list">
      <h2>Postulaciones</h2>
      {applications.map(application => <div className="app-row" key={application.id_postulacion}>
        <div>
          <b>{application.nombre1_estudiante} {application.apellido1_estudiante}</b>
          <span>{application.universidad_estudiante} · {application.carrera_estudiante}</span>
          <small>{application.nombre_estadopostulacion}</small>
        </div>
        {application.nombre_estadopostulacion === 'Pendiente' &&
          <button className="primary" onClick={() => act(`/applications/${application.id_postulacion}/accept`)}>Aceptar</button>}
        {application.nombre_estadopostulacion === 'Aceptada' &&
          <button className="secondary" onClick={() => setChatStudent(application.id_estudiante)}>Abrir chat</button>}
      </div>)}
    </div>}

    {user?.role === 'Cliente' && chatStudent && acceptedStudent &&
      <div className="panel"><h2>Chat con estudiante</h2><Chat taskId={Number(id)} studentId={chatStudent}/></div>}

    {user?.role === 'Estudiante' && accepted &&
      <div className="panel"><h2>Chat</h2>
        <p>El chat está disponible porque el cliente aceptó tu postulación.</p>
        <Chat taskId={Number(id)} studentId={user.id_estudiante}/>
      </div>}

    {user?.role === 'Estudiante' && !accepted &&
      <div className="panel"><h2>Chat</h2>
        <p>El chat estará disponible cuando el cliente acepte la postulación.</p>
      </div>}
  </main>;
}
