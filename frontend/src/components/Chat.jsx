import {useEffect, useState} from 'react';
import {api} from '../services/api';

export default function Chat({taskId, studentId}) {
  const [messages, setMessages] = useState([]);
  const [text, setText] = useState('');
  const [error, setError] = useState('');
  const [sending, setSending] = useState(false);

  async function load() {
    try {
      setError('');
      setMessages(await api(`/chat/${taskId}/${studentId}/messages`));
    } catch (err) {
      setError(err.message);
    }
  }

  useEffect(() => {
    load();
    const interval = window.setInterval(load, 5000);
    return () => window.clearInterval(interval);
  }, [taskId, studentId]);

  async function send(event) {
    event?.preventDefault();
    const content = text.trim();
    if (!content || sending) return;

    try {
      setSending(true);
      setError('');
      await api(`/chat/${taskId}/${studentId}/messages`, {
        method: 'POST',
        body: JSON.stringify({contenido_mensaje: content}),
      });
      setText('');
      await load();
    } catch (err) {
      setError(err.message);
    } finally {
      setSending(false);
    }
  }

  const currentUser = JSON.parse(localStorage.getItem('unamano_user') || '{}');

  return <div className="panel chat">
    <div className="messages">
      {messages.map((message) =>
        <div
          key={message.id_mensaje}
          className={message.id_usuario_emisor_mensaje === currentUser.id_usuario ? 'bubble mine' : 'bubble other'}
        >
          {message.contenido_mensaje}
        </div>
      )}
    </div>
    <form className="composer" onSubmit={send}>
      <input
        value={text}
        onChange={(event) => setText(event.target.value)}
        placeholder="Escribe un mensaje..."
        maxLength="2000"
        disabled={sending}
      />
      <button className="primary" type="submit" disabled={sending || !text.trim()}>
        {sending ? 'Enviando...' : 'Enviar'}
      </button>
    </form>
    {error && <p className="error">{error}</p>}
  </div>;
}
