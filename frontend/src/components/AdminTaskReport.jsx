import {useEffect, useState} from 'react';
import {API, api} from '../services/api';

const initialFilters = {
  categoria: '',
  estado: '',
  fecha_desde: '',
  fecha_hasta: '',
  precio_minimo: '',
  precio_maximo: '',
  region: '',
  comuna: '',
};

function responseError(data) {
  const detail = data?.detail;
  if (typeof detail === 'string') return detail;
  if (Array.isArray(detail)) return detail.map(item => item?.msg || String(item)).join(', ');
  return 'No se pudo generar el reporte.';
}

export default function AdminTaskReport() {
  const [filters, setFilters] = useState(initialFilters);
  const [categories, setCategories] = useState([]);
  const [regions, setRegions] = useState([]);
  const [communes, setCommunes] = useState([]);
  const [loadingOptions, setLoadingOptions] = useState(true);
  const [downloading, setDownloading] = useState(false);
  const [error, setError] = useState('');
  const [notice, setNotice] = useState('');

  useEffect(() => {
    let active = true;
    Promise.all([api('/admin/categories'), api('/locations/regions')])
      .then(([categoryList, regionList]) => {
        if (active) {
          setCategories(categoryList);
          setRegions(regionList);
        }
      })
      .catch(err => {
        if (active) setError(err.message);
      })
      .finally(() => {
        if (active) setLoadingOptions(false);
      });
    return () => { active = false; };
  }, []);

  async function changeRegion(region) {
    setFilters(current => ({...current, region, comuna: ''}));
    setCommunes([]);
    setError('');
    if (!region) return;
    try {
      setCommunes(await api(`/locations/regions/${region}/communes`));
    } catch (err) {
      setError(err.message);
    }
  }

  async function downloadReport(event) {
    event.preventDefault();
    setError('');
    setNotice('');
    if (filters.fecha_desde && filters.fecha_hasta && filters.fecha_desde > filters.fecha_hasta) {
      setError('La fecha inicial no puede ser posterior a la fecha final.');
      return;
    }
    if (filters.estado === 'Finalizada' && filters.precio_minimo && filters.precio_maximo &&
        Number(filters.precio_minimo) > Number(filters.precio_maximo)) {
      setError('El pago mínimo no puede superar el pago máximo.');
      return;
    }

    const params = new URLSearchParams();
    Object.entries(filters).forEach(([key, value]) => {
      if (value) params.set(key, value);
    });

    setDownloading(true);
    try {
      const token = localStorage.getItem('unamano_token');
      const response = await fetch(`${API}/admin/reports/tasks.xlsx?${params}`, {
        headers: token ? {Authorization: `Bearer ${token}`} : {},
      });
      if (!response.ok) {
        let data;
        try {
          data = await response.json();
        } catch {
          data = null;
        }
        throw new Error(responseError(data));
      }

      const file = await response.blob();
      const url = window.URL.createObjectURL(file);
      const link = document.createElement('a');
      link.href = url;
      link.download = `reporte_tareas_${new Date().toISOString().slice(0, 10)}.xlsx`;
      document.body.appendChild(link);
      link.click();
      link.remove();
      window.setTimeout(() => window.URL.revokeObjectURL(url), 1000);
      setNotice('El reporte Excel se descargó correctamente.');
    } catch (err) {
      setError(err.message);
    } finally {
      setDownloading(false);
    }
  }

  return <section className="panel admin-report">
    <h3>Reporte de tareas y comisiones</h3>
    <p className="meta">Descarga tareas, pagos y comisiones en Excel. Los rangos de pago se habilitan para tareas finalizadas.</p>
    <form className="task-form admin-report-form" onSubmit={downloadReport}>
      <div className="two">
        <label>Categoría
          <select value={filters.categoria} onChange={event => setFilters(current => ({...current, categoria: event.target.value}))} disabled={loadingOptions}>
            <option value="">Todas</option>
            {categories.map(category => <option key={category.id_categoria} value={category.id_categoria}>{category.nombre_categoria}</option>)}
          </select>
        </label>
        <label>Estado
          <select value={filters.estado} onChange={event => setFilters(current => ({
            ...current,
            estado: event.target.value,
            ...(event.target.value === 'Finalizada' ? {} : {precio_minimo: '', precio_maximo: ''}),
          }))}>
            <option value="">Todos</option>
            <option value="Disponible">Disponible</option>
            <option value="Asignada">Asignada</option>
            <option value="Finalizada">Finalizada</option>
            <option value="Cancelada">Cancelada</option>
            <option value="Vencida">Vencida</option>
          </select>
        </label>
      </div>
      <div className="two">
        <label>Fecha de inicio desde
          <input type="date" value={filters.fecha_desde} onChange={event => setFilters(current => ({...current, fecha_desde: event.target.value}))}/>
        </label>
        <label>Fecha de inicio hasta
          <input type="date" value={filters.fecha_hasta} onChange={event => setFilters(current => ({...current, fecha_hasta: event.target.value}))}/>
        </label>
      </div>
      {filters.estado === 'Finalizada' && <div className="two">
        <label>Pago mínimo
          <input type="number" min="0" step="1" value={filters.precio_minimo} onChange={event => setFilters(current => ({...current, precio_minimo: event.target.value}))} placeholder="$"/>
        </label>
        <label>Pago máximo
          <input type="number" min="0" step="1" value={filters.precio_maximo} onChange={event => setFilters(current => ({...current, precio_maximo: event.target.value}))} placeholder="$"/>
        </label>
      </div>}
      <div className="two">
        <label>Región
          <select value={filters.region} onChange={event => changeRegion(event.target.value)} disabled={loadingOptions}>
            <option value="">Todas</option>
            {regions.map(region => <option key={region.id_region} value={region.id_region}>{region.nombre_region}</option>)}
          </select>
        </label>
        <label>Comuna
          <select value={filters.comuna} onChange={event => setFilters(current => ({...current, comuna: event.target.value}))} disabled={!filters.region}>
            <option value="">Todas</option>
            {communes.map(commune => <option key={commune.id_comuna} value={commune.id_comuna}>{commune.nombre_comuna}</option>)}
          </select>
        </label>
      </div>
      <button className="primary" type="submit" disabled={downloading || loadingOptions}>
        {downloading ? 'Generando Excel...' : 'Descargar reporte Excel'}
      </button>
    </form>
    {notice && <p className="notice">{notice}</p>}
    {error && <p className="error">{error}</p>}
  </section>;
}
