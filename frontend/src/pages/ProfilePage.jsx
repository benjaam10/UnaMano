import {useEffect, useState} from 'react';
import {api} from '../services/api';
import AdminTaskReport from '../components/AdminTaskReport';

export default function ProfilePage({onLogout}) {
  const [p, setP] = useState(null);
  const [skills, setSkills] = useState([]);
  const [options, setOptions] = useState(null);
  const [skill, setSkill] = useState({id_habilidad: '', id_niveldominio: ''});
  const [skillsLoading, setSkillsLoading] = useState(false);
  const [savingSkill, setSavingSkill] = useState(false);
  const [skillsError, setSkillsError] = useState('');
  const [skillsMessage, setSkillsMessage] = useState('');
  const [editingLocation, setEditingLocation] = useState(false);
  const [regions, setRegions] = useState([]);
  const [communes, setCommunes] = useState([]);
  const [loc, setLoc] = useState({id_region: '', id_comuna: '', calle: '', numero: '', dpto: '', referencia: ''});

  useEffect(() => {
    api('/profile').then(setP);
  }, []);

  useEffect(() => {
    if (!p?.id_estudiante) return;
    let active = true;

    async function loadSkills() {
      setSkillsLoading(true);
      setSkillsError('');
      try {
        const [currentSkills, skillOptions] = await Promise.all([
          api('/profile/skills'),
          api('/profile/skills/options'),
        ]);
        if (active) {
          setSkills(currentSkills);
          setOptions(skillOptions);
        }
      } catch (error) {
        if (active) setSkillsError(error.message);
      } finally {
        if (active) setSkillsLoading(false);
      }
    }

    loadSkills();
    return () => { active = false; };
  }, [p?.id_estudiante]);

  if (!p) return <main className="section">Cargando...</main>;

  const student = Boolean(p.id_estudiante);
  const admin = p.nombre_rol === 'Admin';

  async function validate() {
    await api('/profile/student/validate', {method: 'POST'});
    setP(await api('/profile'));
  }

  async function deactivate() {
    if (confirm('¿Desactivar cuenta?')) {
      await api('/profile/deactivate', {method: 'POST'});
      localStorage.removeItem('unamano_token');
      onLogout();
    }
  }

  async function saveSkill(event) {
    event.preventDefault();
    setSkillsError('');
    setSkillsMessage('');
    setSavingSkill(true);
    try {
      const updatedSkills = await api('/profile/skills', {
        method: 'POST',
        body: JSON.stringify({
          id_habilidad: Number(skill.id_habilidad),
          id_niveldominio: Number(skill.id_niveldominio),
        }),
      });
      setSkills(updatedSkills);
      setSkill({id_habilidad: '', id_niveldominio: ''});
      setSkillsMessage('Habilidad guardada correctamente.');
    } catch (error) {
      setSkillsError(error.message);
    } finally {
      setSavingSkill(false);
    }
  }

  return <main className="section">
    <div className="profile-head">
      <div className="avatar">{admin ? 'AD' : `${(p.nombre1_cliente || p.nombre1_estudiante || 'U')[0]}${(p.apellido1_cliente || p.apellido1_estudiante || '')[0]}`}</div>
      <div>
        <span className="eyebrow">PERFIL</span>
        <h1>{admin ? 'Administrador' : `${p.nombre1_cliente || p.nombre1_estudiante} ${p.apellido1_cliente || p.apellido1_estudiante}`}</h1>
        <p>{admin ? p.email_usuario : `${p.nombre_comuna || 'Sin comuna'} · ${p.nombre_region || 'Sin región'}`}</p>
      </div>
    </div>

    {admin && <div className="panel admin-earnings">
      <h3>Ganancias por comisiones</h3>
      <p className="commission-total">${Number(p.ganancias_comisiones || 0).toLocaleString('es-CL')}</p>
      <p className="meta">Comisiones acumuladas de {Number(p.cantidad_pagos || 0).toLocaleString('es-CL')} pagos registrados.</p>
    </div>}

    {admin && <AdminTaskReport/>}

    {student && <div className="panel">
      <h3>Saldo acumulado</h3>
      <p><b>${Number(p.saldo_acumulado || 0).toLocaleString('es-CL')}</b></p>
      <small>Ganancias recibidas luego de descontar las comisiones.</small>
    </div>}

    {!admin && <div className="panel">
      <h3>Ubicación</h3>
      <p>{p.calle_direccion} {p.numero_direccion}{p.dpto_direccion ? ` · Depto ${p.dpto_direccion}` : ''}</p>
      <p>{p.nombre_comuna || 'Sin comuna'} · {p.nombre_ciudad || 'Sin ciudad'} · {p.nombre_region || 'Sin región'}</p>
      {!editingLocation
        ? <button className="secondary" onClick={async () => {
          setRegions(await api('/locations/regions'));
          setLoc({
            id_region: p.id_region_direccion || '',
            id_comuna: p.id_comuna_direccion || '',
            calle: p.calle_direccion || '',
            numero: p.numero_direccion || '',
            dpto: p.dpto_direccion || '',
            referencia: p.referencia_direccion || '',
          });
          setEditingLocation(true);
        }}>Editar ubicación</button>
        : <div className="task-form">
          <select value={loc.id_region} onChange={async event => {
            setLoc({...loc, id_region: event.target.value, id_comuna: ''});
            setCommunes(await api(`/locations/regions/${event.target.value}/communes`));
          }}>
            <option value="">Región</option>
            {regions.map(region => <option key={region.id_region} value={region.id_region}>{region.nombre_region}</option>)}
          </select>
          <select value={loc.id_comuna} onChange={event => setLoc({...loc, id_comuna: event.target.value})}>
            <option value="">Comuna</option>
            {communes.map(commune => <option key={commune.id_comuna} value={commune.id_comuna}>{commune.nombre_comuna}</option>)}
          </select>
          <div className="two">
            <input value={loc.calle} placeholder="Calle" onChange={event => setLoc({...loc, calle: event.target.value})}/>
            <input value={loc.numero} placeholder="Número" onChange={event => setLoc({...loc, numero: event.target.value})}/>
          </div>
          <div className="two">
            <input value={loc.dpto} placeholder="Depto" onChange={event => setLoc({...loc, dpto: event.target.value})}/>
            <input value={loc.referencia} placeholder="Referencia" onChange={event => setLoc({...loc, referencia: event.target.value})}/>
          </div>
          <button className="primary" onClick={async () => {
            await api('/profile/address', {
              method: 'PUT',
              body: JSON.stringify({...loc, id_region: Number(loc.id_region), id_comuna: Number(loc.id_comuna)}),
            });
            setP(await api('/profile'));
            setEditingLocation(false);
          }}>Guardar ubicación</button>
        </div>}
    </div>}

    {!admin && <div className="profile-grid">
      <div className="panel">
        <h3>Datos</h3>
        <p><b>RUT:</b> {p.rut_cliente || p.rut_estudiante}</p>
        <p><b>Correo:</b> {p.email_cliente || p.email_estudiante}</p>
        <p><b>Teléfono:</b> {p.telefono_cliente || p.telefono_estudiante}</p>
        {student && <>
          <p><b>Universidad:</b> {p.universidad_estudiante}</p>
          <p><b>Carrera:</b> {p.carrera_estudiante}</p>
        </>}
      </div>

      <div className="panel">
        {student && <>
          <h3>Validación académica</h3>
          {p.estado_alumno
            ? <span className="ok">✓ Estudiante regular validado</span>
            : <>
              <p>En este prototipo se valida con un botón, sin subir certificado.</p>
              <button className="primary" onClick={validate}>Validar que soy estudiante</button>
            </>}
        </>}
        <h3>Cuenta</h3>
        <button className="danger" onClick={deactivate}>Desactivar cuenta</button>
      </div>
    </div>}

    {student && <div className="panel student-skills">
      <h3>Habilidades</h3>
      <p className="meta">Agrega tus habilidades y el nivel que tienes en cada una.</p>
      {skillsLoading
        ? <p className="meta">Cargando habilidades...</p>
        : skills.length
          ? <div className="skill-list">
            {skills.map(item => <span className="tag" key={item.id_eh}>{item.nombre_habilidad} · {item.nombre_niveldominio}</span>)}
          </div>
          : <p className="meta">Aún no has agregado habilidades.</p>}

      {options && (!options.habilidades.length || !options.niveles.length)
        ? <p className="error">No hay habilidades o niveles disponibles para seleccionar.</p>
        : options && <form className="task-form student-skills-form" onSubmit={saveSkill}>
          <div className="two">
            <label>Habilidad
              <select
                value={skill.id_habilidad}
                onChange={event => setSkill(current => ({...current, id_habilidad: event.target.value}))}
                required
              >
                <option value="">Selecciona una habilidad</option>
                {options.habilidades.map(item =>
                  <option key={item.id_habilidad} value={item.id_habilidad}>{item.nombre_habilidad}</option>
                )}
              </select>
            </label>
            <label>Nivel
              <select
                value={skill.id_niveldominio}
                onChange={event => setSkill(current => ({...current, id_niveldominio: event.target.value}))}
                required
              >
                <option value="">Selecciona un nivel</option>
                {options.niveles.map(item =>
                  <option key={item.id_niveldominio} value={item.id_niveldominio}>{item.nombre_niveldominio}</option>
                )}
              </select>
            </label>
          </div>
          <button className="primary" type="submit" disabled={savingSkill || skillsLoading}>
            {savingSkill ? 'Guardando...' : 'Agregar / actualizar habilidad'}
          </button>
        </form>}
      {skillsMessage && <p className="notice">{skillsMessage}</p>}
      {skillsError && <p className="error">{skillsError}</p>}
    </div>}
  </main>;
}
