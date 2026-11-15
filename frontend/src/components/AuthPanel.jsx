import { useEffect, useState } from 'react';
import { api } from '../services/api';

const emptyForm = {
  email: '', password: '', rut: '', nombre1: '', nombre2: '', apellido1: '',
  apellido2: '', fecha_nacimiento: '', telefono: '', universidad: '',
  carrera: '', calle: '', numero: '', dpto: '', referencia: '',
  id_region: '', id_comuna: '', id_ciudad: '',
};

export default function AuthPanel({ onLogged }) {
  const [mode, setMode] = useState('login');
  const [role, setRole] = useState('Cliente');
  const [form, setForm] = useState(emptyForm);
  const [regions, setRegions] = useState([]);
  const [communes, setCommunes] = useState([]);
  const [city, setCity] = useState(null);
  const [error, setError] = useState('');
  const set = (key, value) => setForm((current) => ({ ...current, [key]: value }));
  const isAdmin = role === 'Admin';

  useEffect(() => {
    if (mode === 'register') {
      api('/locations/regions').then(setRegions).catch((err) => setError(err.message));
    }
  }, [mode]);

  async function selectRegion(value) {
    try {
      setError('');
      set('id_region', value);
      set('id_comuna', '');
      set('id_ciudad', '');
      setCity(null);
      setCommunes(value ? await api(`/locations/regions/${value}/communes`) : []);
    } catch (err) {
      setError(err.message);
    }
  }

  async function selectCommune(value) {
    try {
      setError('');
      set('id_comuna', value);
      if (!value) {
        set('id_ciudad', '');
        setCity(null);
        return;
      }
      const selectedCity = await api(`/locations/communes/${value}/city`);
      set('id_ciudad', selectedCity.id_ciudad);
      setCity(selectedCity);
    } catch (err) {
      setError(err.message);
    }
  }

  function changeRole(value) {
    setRole(value);
    setCommunes([]);
    setCity(null);
    setForm((current) => ({ ...current, id_region: '', id_comuna: '', id_ciudad: '' }));
  }

  async function submit(event) {
    event.preventDefault();
    setError('');
    try {
      const body = mode === 'login'
        ? { email: form.email, password: form.password }
        : isAdmin
          ? { role, email: form.email, password: form.password }
          : {
              role,
              email: form.email,
              password: form.password,
              rut: form.rut,
              nombre1: form.nombre1,
              nombre2: form.nombre2 || null,
              apellido1: form.apellido1,
              apellido2: form.apellido2 || null,
              fecha_nacimiento: form.fecha_nacimiento || null,
              telefono: form.telefono,
              ...(role === 'Estudiante' ? { universidad: form.universidad, carrera: form.carrera } : {}),
              calle: form.calle,
              numero: form.numero,
              dpto: form.dpto || null,
              referencia: form.referencia || null,
              id_region: Number(form.id_region),
              id_comuna: Number(form.id_comuna),
            };
      const response = await api(`/auth/${mode === 'login' ? 'login' : 'register'}`, {
        method: 'POST',
        body: JSON.stringify(body),
      });
      localStorage.setItem('unamano_token', response.access_token);
      onLogged({ role: response.role });
    } catch (err) {
      setError(err.message);
    }
  }

  return <form className="auth-card" onSubmit={submit}>
    <div className="tabs">
      <button type="button" className={mode === 'login' ? 'active' : ''} onClick={() => setMode('login')}>Iniciar sesión</button>
      <button type="button" className={mode === 'register' ? 'active' : ''} onClick={() => setMode('register')}>Registrarse</button>
    </div>
    {mode === 'register' && <>
      <label>Perfil<select value={role} onChange={(event) => changeRole(event.target.value)}>
        <option>Cliente</option><option>Estudiante</option><option>Admin</option>
      </select></label>
      {!isAdmin && <>
        <div className="two">
          <input required placeholder="RUT" value={form.rut} onChange={(event) => set('rut', event.target.value)} />
          <input required placeholder="Teléfono" value={form.telefono} onChange={(event) => set('telefono', event.target.value)} />
        </div>
        <div className="two">
          <input required placeholder="Primer nombre" value={form.nombre1} onChange={(event) => set('nombre1', event.target.value)} />
          <input placeholder="Segundo nombre (opcional)" value={form.nombre2} onChange={(event) => set('nombre2', event.target.value)} />
        </div>
        <div className="two">
          <input required placeholder="Primer apellido" value={form.apellido1} onChange={(event) => set('apellido1', event.target.value)} />
          <input placeholder="Segundo apellido (opcional)" value={form.apellido2} onChange={(event) => set('apellido2', event.target.value)} />
        </div>
        <label>Fecha de nacimiento<input required={role === 'Estudiante'} type="date" value={form.fecha_nacimiento} onChange={(event) => set('fecha_nacimiento', event.target.value)} /></label>
        {role === 'Estudiante' && <div className="two">
          <input required placeholder="Universidad" value={form.universidad} onChange={(event) => set('universidad', event.target.value)} />
          <input required placeholder="Carrera" value={form.carrera} onChange={(event) => set('carrera', event.target.value)} />
        </div>}
        <h3 className="form-subtitle">Dirección</h3>
        <div className="two">
          <label>Región<select required value={form.id_region} onChange={(event) => selectRegion(event.target.value)}>
            <option value="">Selecciona una región</option>
            {regions.map((item) => <option key={item.id_region} value={item.id_region}>{item.nombre_region}</option>)}
          </select></label>
          <label>Comuna<select required value={form.id_comuna} onChange={(event) => selectCommune(event.target.value)} disabled={!form.id_region}>
            <option value="">Selecciona una comuna</option>
            {communes.map((item) => <option key={item.id_comuna} value={item.id_comuna}>{item.nombre_comuna}</option>)}
          </select></label>
        </div>
        <label>Ciudad<select required value={form.id_ciudad} disabled={!city}>
          <option value="">{city ? 'Selecciona una ciudad' : 'Selecciona primero una comuna'}</option>
          {city && <option value={city.id_ciudad}>{city.nombre_ciudad}</option>}
        </select></label>
        <input required placeholder="Calle" value={form.calle} onChange={(event) => set('calle', event.target.value)} />
        <input required placeholder="Número" value={form.numero} onChange={(event) => set('numero', event.target.value)} />
      </>}
    </>}
    <input required placeholder="Correo" type="text" value={form.email} onChange={(event) => set('email', event.target.value)} />
    <input required placeholder="Contraseña" type="password" value={form.password} onChange={(event) => set('password', event.target.value)} />
    <button className="primary wide-btn">{mode === 'login' ? 'Iniciar sesión' : 'Registrarse'}</button>
    {error && <p className="error">{error}</p>}
  </form>;
}
