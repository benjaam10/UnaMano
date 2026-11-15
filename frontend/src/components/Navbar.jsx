import {Link, NavLink} from 'react-router-dom';

function initials(user) {
  const first = user?.firstName?.trim()?.[0] || '';
  const last = user?.lastName?.trim()?.[0] || '';
  return (first + last || 'U').toUpperCase();
}

export default function Navbar({user, onLogout, onToggleTheme, dark}) {
  const logged = Boolean(user);
  const taskPath = !logged ? '/' : user.role === 'Cliente' ? '/mis-tareas' : user.role === 'Estudiante' ? '/mis-postulaciones' : '/admin';
  return <header className="topbar marketplace-topbar">
    <Link className="brand" to="/">UnaMano</Link>
    <div className="top-search">⌕ <span>Buscar tareas...</span></div>
    <nav className="main-nav">
      <NavLink to="/" end title="Inicio">⌂<span>Inicio</span></NavLink>
      <NavLink to={taskPath} end title="Tareas">▣<span>Tareas</span></NavLink>
      <NavLink to={logged ? '/mensajes' : '/auth'} end title="Mensajes">◌<span>Mensajes</span></NavLink>
      <NavLink to={logged ? '/perfil' : '/auth'} end title="Perfil">♙<span>Perfil</span></NavLink>
    </nav>
    <div className="top-actions">
      <button className="icon-btn" onClick={onToggleTheme} title="Cambiar tema">{dark ? '☀' : '☾'}</button>
      {logged ? <><div className="profile-avatar" title={user.firstName || 'Perfil'}>{initials(user)}</div><button className="secondary logout-button" onClick={onLogout}>Cerrar sesión</button></>
        : <Link className="primary btn login-button" to="/auth">Iniciar sesión / Registrarse</Link>}
    </div>
  </header>;
}
