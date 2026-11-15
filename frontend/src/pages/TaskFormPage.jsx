import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { api } from '../services/api';

const initialForm = {
  titulo_tarea: '',
  descripcion_tarea: '',
  pago_ofrecido_tarea: '',
  fecha_inicio_tarea: '',
  id_categoria_tarea: '',
  id_nombre_tarea: '',
  direccion: { calle: '', numero: '', dpto: '', referencia: '', id_region: '', id_comuna: '' },
};

export default function TaskFormPage() {
  const nav = useNavigate();
  const [form, setForm] = useState(initialForm);
  const [categories, setCategories] = useState([]);
  const [names, setNames] = useState([]);
  const [regions, setRegions] = useState([]);
  const [communes, setCommunes] = useState([]);
  const [error, setError] = useState('');
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    Promise.all([api('/locations/categories'), api('/locations/regions')])
      .then(([loadedCategories, loadedRegions]) => {
        setCategories(loadedCategories);
        setRegions(loadedRegions);
      })
      .catch((err) => setError(err.message));
  }, []);

  async function category(value) {
    try {
      setError('');
      setForm((current) => ({ ...current, id_categoria_tarea: value, id_nombre_tarea: '' }));
      setNames(value ? await api(`/locations/categories/${value}/names`) : []);
    } catch (err) {
      setError(err.message);
    }
  }

  async function region(value) {
    try {
      setError('');
      setForm((current) => ({
        ...current,
        direccion: { ...current.direccion, id_region: value, id_comuna: '' },
      }));
      setCommunes(value ? await api(`/locations/regions/${value}/communes`) : []);
    } catch (err) {
      setError(err.message);
    }
  }

  async function submit(event) {
    event.preventDefault();
    setError('');
    setSaving(true);
    try {
      const payload = {
        ...form,
        pago_ofrecido_tarea: Number(form.pago_ofrecido_tarea),
        id_categoria_tarea: Number(form.id_categoria_tarea),
        id_nombre_tarea: Number(form.id_nombre_tarea),
        direccion: {
          ...form.direccion,
          id_region: Number(form.direccion.id_region),
          id_comuna: Number(form.direccion.id_comuna),
        },
      };
      await api('/tasks', { method: 'POST', body: JSON.stringify(payload) });
      nav('/mis-tareas');
    } catch (err) {
      setError(err.message);
    } finally {
      setSaving(false);
    }
  }

  const update = (key, value) => setForm((current) => ({ ...current, [key]: value }));
  const updateAddress = (key, value) => setForm((current) => ({
    ...current,
    direccion: { ...current.direccion, [key]: value },
  }));

  return <main className="section">
    <div className="form-card task-form-card">
      <span className="eyebrow">CLIENTE</span>
      <h1>Publicar una tarea</h1>
      <p className="form-intro">Describe lo que necesitas y encuentra ayuda cerca de ti.</p>
      <form className="task-form" onSubmit={submit}>
        <div className="two">
          <label>Categoría<select required value={form.id_categoria_tarea} onChange={(event) => category(event.target.value)}>
            <option value="">Selecciona una categoría</option>
            {categories.map((item) => <option key={item.id_categoria} value={item.id_categoria}>{item.nombre_categoria}</option>)}
          </select></label>
          <label>Tipo de tarea<select required value={form.id_nombre_tarea} onChange={(event) => update('id_nombre_tarea', event.target.value)}>
            <option value="">Selecciona un tipo</option>
            {names.map((item) => <option key={item.id_nombre_tarea} value={item.id_nombre_tarea}>{item.nombre_tarea}</option>)}
          </select></label>
        </div>
        <div className="two">
          <label>Título<input required value={form.titulo_tarea} onChange={(event) => update('titulo_tarea', event.target.value)} /></label>
          <label>Monto ofrecido<input type="number" min="1" step="0.01" required value={form.pago_ofrecido_tarea} onChange={(event) => update('pago_ofrecido_tarea', event.target.value)} /></label>
        </div>
        <label>Fecha y hora de inicio<input type="datetime-local" required value={form.fecha_inicio_tarea} onChange={(event) => update('fecha_inicio_tarea', event.target.value)} /></label>
        <label>Descripción<textarea rows="4" required value={form.descripcion_tarea} onChange={(event) => update('descripcion_tarea', event.target.value)} /></label>
        <div className="two">
          <label>Región<select required value={form.direccion.id_region} onChange={(event) => region(event.target.value)}>
            <option value="">Selecciona una región</option>
            {regions.map((item) => <option key={item.id_region} value={item.id_region}>{item.nombre_region}</option>)}
          </select></label>
          <label>Comuna<select required value={form.direccion.id_comuna} disabled={!form.direccion.id_region} onChange={(event) => updateAddress('id_comuna', event.target.value)}>
            <option value="">Selecciona una comuna</option>
            {communes.map((item) => <option key={item.id_comuna} value={item.id_comuna}>{item.nombre_comuna}</option>)}
          </select></label>
        </div>
        <div className="two">
          <label>Calle<input required value={form.direccion.calle} onChange={(event) => updateAddress('calle', event.target.value)} /></label>
          <label>Número<input required value={form.direccion.numero} onChange={(event) => updateAddress('numero', event.target.value)} /></label>
        </div>
        <div className="two">
          <label>Departamento<input value={form.direccion.dpto} onChange={(event) => updateAddress('dpto', event.target.value)} /></label>
          <label>Referencia<input value={form.direccion.referencia} onChange={(event) => updateAddress('referencia', event.target.value)} /></label>
        </div>
        {error && <p className="error">{error}</p>}
        <button className="primary" type="submit" disabled={saving}>{saving ? 'Publicando...' : 'Publicar tarea'}</button>
      </form>
    </div>
  </main>;
}
