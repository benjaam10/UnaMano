import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { api } from '../services/api';
import TaskCard from '../components/TaskCard';

export default function HomePage({ user }) {
  const [tasks, setTasks] = useState([]);
  const [categories, setCategories] = useState([]);
  const [regions, setRegions] = useState([]);
  const [communes, setCommunes] = useState([]);
  const [region, setRegion] = useState('');
  const [comuna, setComuna] = useState('');
  const [categoria, setCategoria] = useState('');
  const [error, setError] = useState('');

  useEffect(() => {
    Promise.all([api('/locations/categories'), api('/locations/regions')])
      .then(([loadedCategories, loadedRegions]) => {
        setCategories(loadedCategories);
        setRegions(loadedRegions);
      })
      .catch((err) => setError(err.message));
    load();
  }, []);

  async function load() {
    try {
      setError('');
      const params = new URLSearchParams();
      if (region) params.set('region', region);
      if (comuna) params.set('comuna', comuna);
      if (categoria) params.set('categoria', categoria);
      setTasks(await api(`/tasks?${params}`));
    } catch (err) {
      setError(err.message);
    }
  }

  async function selectRegion(value) {
    setRegion(value);
    setComuna('');
    setCommunes(value ? await api(`/locations/regions/${value}/communes`) : []);
  }

  return <main className="marketplace">
    <aside className="filter-card">
      <h3>Filtros</h3>
      <label>Región<select value={region} onChange={(event) => selectRegion(event.target.value)}>
        <option value="">Todas las regiones</option>
        {regions.map((item) => <option key={item.id_region} value={item.id_region}>{item.nombre_region}</option>)}
      </select></label>
      <label>Comuna<select value={comuna} disabled={!region} onChange={(event) => setComuna(event.target.value)}>
        <option value="">Todas las comunas</option>
        {communes.map((item) => <option key={item.id_comuna} value={item.id_comuna}>{item.nombre_comuna}</option>)}
      </select></label>
      <label>Categoría<select value={categoria} onChange={(event) => setCategoria(event.target.value)}>
        <option value="">Todas las categorías</option>
        {categories.map((item) => <option key={item.id_categoria} value={item.id_categoria}>{item.nombre_categoria}</option>)}
      </select></label>
      <button className="primary filter-button" onClick={load}>Aplicar filtros</button>
    </aside>
    <section className="market-results">
      <div className="section-head market-heading">
        <div><h1>Tareas disponibles</h1><p className="meta">Encuentra trabajos cerca de ti</p></div>
        <span className="results-count">Mostrando {tasks.length} resultados</span>
        {user?.role === 'Cliente' && <Link className="primary btn" to="/publicar">+ Publicar tarea</Link>}
      </div>
      {error && <p className="error">{error}</p>}
      <div className="task-grid">{tasks.map((task) => <TaskCard task={task} key={task.id_tarea} />)}</div>
      {!tasks.length && !error && <p className="empty-state">No hay tareas disponibles con estos filtros.</p>}
    </section>
  </main>;
}
