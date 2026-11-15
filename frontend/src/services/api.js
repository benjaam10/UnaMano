const API = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000';

function errorMessage(detail) {
  if (typeof detail === 'string') return detail;
  if (Array.isArray(detail)) {
    return detail.map((item) => item?.msg || String(item)).join(', ');
  }
  if (detail && typeof detail === 'object') return detail.msg || JSON.stringify(detail);
  return 'Error en la solicitud';
}

export async function api(path, options = {}) {
  const token = localStorage.getItem('unamano_token');
  const headers = { 'Content-Type': 'application/json', ...(options.headers || {}) };
  if (token) headers.Authorization = 'Bearer ' + token;

  let res;
  try {
    res = await fetch(`${API}${path}`, { ...options, headers });
  } catch {
    throw new Error(`No se puede conectar con el backend (${API}). Verifica que FastAPI esté iniciado.`);
  }
  let data = null;
  try {
    data = await res.json();
  } catch {
    // Some error responses do not include JSON.
  }
  if (!res.ok) throw new Error(errorMessage(data?.detail) || `Error HTTP ${res.status}`);
  return data;
}

export { API };
