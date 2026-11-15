import { useCallback, useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { api } from '../services/api';

const emptyCategory = { nombre_categoria: '', descripcion_categoria: '' };
const emptyName = { nombre_tarea: '', descripcion_nombre_tarea: '', id_categoria_nombre_tarea: '' };

export default function AdminPage() {
  const [categories, setCategories] = useState([]);
  const [names, setNames] = useState([]);
  const [tasks, setTasks] = useState([]);
  const [category, setCategory] = useState(emptyCategory);
  const [taskName, setTaskName] = useState(emptyName);
  const [errors, setErrors] = useState({});
  const [notice, setNotice] = useState('');
  const [saving, setSaving] = useState('');

  const loadSection = useCallback(async (key, path, setter) => {
    try {
      setter(await api(path));
      setErrors((current) => ({ ...current, [key]: '' }));
    } catch (err) {
      setErrors((current) => ({ ...current, [key]: err.message }));
    }
  }, []);

  const loadAll = useCallback(() => {
    loadSection('categories', '/admin/categories', setCategories);
    loadSection('names', '/admin/task-names', setNames);
    loadSection('tasks', '/admin/tasks', setTasks);
  }, [loadSection]);

  useEffect(() => { loadAll(); }, [loadAll]);

  async function addCategory(event) {
    event.preventDefault();
    if (!category.nombre_categoria.trim()) return setErrors((current) => ({ ...current, categoryForm: 'Escribe un nombre para la categoría.' }));
    try {
      setSaving('category');
      await api('/admin/categories', { method: 'POST', body: JSON.stringify({ ...category, nombre_categoria: category.nombre_categoria.trim() }) });
      setCategory(emptyCategory);
      setNotice('Categoría creada correctamente.');
      loadSection('categories', '/admin/categories', setCategories);
    } catch (err) {
      setErrors((current) => ({ ...current, categoryForm: err.message }));
    } finally { setSaving(''); }
  }

  async function addName(event) {
    event.preventDefault();
    if (!taskName.nombre_tarea.trim() || !taskName.id_categoria_nombre_tarea) {
      return setErrors((current) => ({ ...current, nameForm: 'Completa el nombre y selecciona una categoría.' }));
    }
    try {
      setSaving('name');
      await api('/admin/task-names', { method: 'POST', body: JSON.stringify({
        ...taskName, nombre_tarea: taskName.nombre_tarea.trim(),
        id_categoria_nombre_tarea: Number(taskName.id_categoria_nombre_tarea),
      }) });
      setTaskName(emptyName);
      setNotice('Nombre de tarea creado correctamente.');
      loadSection('names', '/admin/task-names', setNames);
    } catch (err) {
      setErrors((current) => ({ ...current, nameForm: err.message }));
    } finally { setSaving(''); }
  }

  async function toggle(path) {
    try { await api(path, { method: 'PATCH' }); loadAll(); }
    catch (err) { setNotice(err.message); }
  }

  async function editCategory(item) {
    const name = prompt('Nombre de categoría', item.nombre_categoria);
    if (!name?.trim()) return;
    const description = prompt('Descripción', item.descripcion_categoria || '') || '';
    try {
      await api(`/admin/categories/${item.id_categoria}`, { method: 'PUT', body: JSON.stringify({ nombre_categoria: name.trim(), descripcion_categoria: description }) });
      loadSection('categories', '/admin/categories', setCategories);
    } catch (err) { setNotice(err.message); }
  }

  async function editName(item) {
    const name = prompt('Nombre de tarea', item.nombre_tarea);
    if (!name?.trim()) return;
    const description = prompt('Descripción', item.descripcion_nombre_tarea || '') || '';
    try {
      await api(`/admin/task-names/${item.id_nombre_tarea}`, { method: 'PUT', body: JSON.stringify({ nombre_tarea: name.trim(), descripcion_nombre_tarea: description, id_categoria_nombre_tarea: item.id_categoria_nombre_tarea }) });
      loadSection('names', '/admin/task-names', setNames);
    } catch (err) { setNotice(err.message); }
  }

  async function cancelTask(id) {
    if (!confirm('¿Cancelar esta tarea?')) return;
    try { await api(`/tasks/${id}`, { method: 'DELETE' }); loadSection('tasks', '/admin/tasks', setTasks); }
    catch (err) { setNotice(err.message); }
  }

  return <main className="section admin-page">
    <span className="eyebrow">ADMINISTRACIÓN</span>
    <div className="admin-title-row"><div><h1>Control del marketplace</h1><p className="meta">Administra categorías, tipos de tarea y publicaciones.</p></div><button className="secondary" onClick={loadAll}>Actualizar</button></div>
    {notice && <p className="notice">{notice}</p>}
    <div className="admin-grid">
      <section className="panel admin-panel">
        <div className="panel-heading"><div><span className="eyebrow">CLASIFICACIÓN</span><h2>Categorías</h2></div><span className="count">{categories.length}</span></div>
        <form className="admin-form" onSubmit={addCategory}>
          <input required placeholder="Nombre de categoría" value={category.nombre_categoria} onChange={(event) => setCategory({ ...category, nombre_categoria: event.target.value })} />
          <input placeholder="Descripción (opcional)" value={category.descripcion_categoria} onChange={(event) => setCategory({ ...category, descripcion_categoria: event.target.value })} />
          <button className="primary" disabled={saving === 'category'}>{saving === 'category' ? 'Guardando...' : '+ Crear categoría'}</button>
          {errors.categoryForm && <p className="error">{errors.categoryForm}</p>}
        </form>
        {errors.categories && <p className="error">{errors.categories}</p>}
        <div className="admin-list">{categories.map((item) => <div className="admin-row" key={item.id_categoria}><span><strong>{item.nombre_categoria}</strong><small>{item.descripcion_categoria || 'Sin descripción'} · {item.estado_categoria ? 'Activa' : 'Inactiva'}</small></span><div className="row-actions"><button className="secondary" onClick={() => editCategory(item)}>Editar</button><button className="secondary" onClick={() => toggle(`/admin/categories/${item.id_categoria}/toggle`)}>{item.estado_categoria ? 'Desactivar' : 'Activar'}</button></div></div>)}</div>
      </section>
      <section className="panel admin-panel">
        <div className="panel-heading"><div><span className="eyebrow">CATÁLOGO</span><h2>Nombres de tareas</h2></div><span className="count">{names.length}</span></div>
        <form className="admin-form" onSubmit={addName}>
          <input required placeholder="Nombre de tarea" value={taskName.nombre_tarea} onChange={(event) => setTaskName({ ...taskName, nombre_tarea: event.target.value })} />
          <input placeholder="Descripción (opcional)" value={taskName.descripcion_nombre_tarea} onChange={(event) => setTaskName({ ...taskName, descripcion_nombre_tarea: event.target.value })} />
          <select required value={taskName.id_categoria_nombre_tarea} onChange={(event) => setTaskName({ ...taskName, id_categoria_nombre_tarea: event.target.value })}><option value="">Selecciona una categoría</option>{categories.filter((item) => item.estado_categoria).map((item) => <option key={item.id_categoria} value={item.id_categoria}>{item.nombre_categoria}</option>)}</select>
          <button className="primary" disabled={saving === 'name'}>{saving === 'name' ? 'Guardando...' : '+ Crear nombre de tarea'}</button>
          {errors.nameForm && <p className="error">{errors.nameForm}</p>}
        </form>
        {errors.names && <p className="error">{errors.names}</p>}
        <div className="admin-list">{names.map((item) => <div className="admin-row" key={item.id_nombre_tarea}><span><strong>{item.nombre_tarea}</strong><small>{item.nombre_categoria} · {item.estado_nombre_tarea ? 'Activo' : 'Inactivo'}</small></span><div className="row-actions"><button className="secondary" onClick={() => editName(item)}>Editar</button><button className="secondary" onClick={() => toggle(`/admin/task-names/${item.id_nombre_tarea}/toggle`)}>{item.estado_nombre_tarea ? 'Desactivar' : 'Activar'}</button></div></div>)}</div>
      </section>
    </div>
    <section className="panel admin-panel tasks-panel">
      <div className="panel-heading"><div><span className="eyebrow">PUBLICACIONES</span><h2>Tareas creadas</h2></div><span className="count">{tasks.length}</span></div>
      {errors.tasks && <p className="error">{errors.tasks}</p>}
      {!errors.tasks && !tasks.length && <p className="empty-state">Todavía no hay tareas publicadas.</p>}
      {!!tasks.length && <div className="table-wrap"><table><thead><tr><th>ID</th><th>Título</th><th>Categoría</th><th>Estado</th><th>Cliente</th><th>Inicio</th><th>Acciones</th></tr></thead><tbody>{tasks.map((item) => <tr key={item.id_tarea}><td>#{item.id_tarea}</td><td><strong>{item.titulo_tarea}</strong><small>{item.nombre_tarea || 'Sin tipo'}</small></td><td>{item.nombre_categoria}</td><td><span className="status">{item.nombre_estado}</span></td><td>{item.nombre1_cliente} {item.apellido1_cliente}</td><td>{new Date(item.fecha_inicio_tarea).toLocaleString('es-CL')}</td><td><div className="row-actions"><Link className="secondary btn" to={`/admin/tareas/${item.id_tarea}/editar`}>Editar</Link><button className="danger" disabled={['Finalizada', 'Cancelada', 'Vencida'].includes(item.nombre_estado)} onClick={() => cancelTask(item.id_tarea)}>Cancelar</button></div></td></tr>)}</tbody></table></div>}
    </section>
  </main>;
}
