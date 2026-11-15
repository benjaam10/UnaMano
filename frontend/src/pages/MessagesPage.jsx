import {useEffect, useState} from 'react';
import {Link} from 'react-router-dom';
import {api} from '../services/api';

export default function MessagesPage({user}) {
  const [chats, setChats] = useState([]);
  const [error, setError] = useState('');

  useEffect(() => {
    api('/chat/conversations').then(setChats).catch((err) => setError(err.message));
  }, []);

  return <main className="section">
    <span className="eyebrow">COMUNICACIÓN</span>
    <h1>Mensajes</h1>
    <div className="panel">
      {error && <p className="error">{error}</p>}
      {!error && chats.length === 0 && <p className="meta">No tienes chats disponibles. Aparecerán cuando el cliente acepte una postulación.</p>}
      {chats.map((chat) => <div className="app-row" key={`${chat.id_tarea}-${chat.id_estudiante}`}>
        <div>
          <b>{chat.contacto}</b>
          <span>{chat.titulo_tarea}</span>
          <small>Chat con {chat.tipo_contacto.toLowerCase()}</small>
        </div>
        <Link className="primary btn" to={`/tareas/${chat.id_tarea}${user.role === 'Cliente' ? `?chat=${chat.id_estudiante}` : ''}`}>
          Abrir chat
        </Link>
      </div>)}
    </div>
  </main>;
}
