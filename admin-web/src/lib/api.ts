import { auth } from './firebase';

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000';

async function authHeaders(): Promise<HeadersInit> {
  const user = auth.currentUser;
  if (!user) throw new Error('Not signed in');
  const token = await user.getIdToken();
  return {
    Authorization: `Bearer ${token}`,
    'Content-Type': 'application/json',
  };
}

async function handleResponse(res: Response) {
  if (!res.ok) {
    const text = await res.text();
    throw new Error(text || res.statusText);
  }
  if (res.status === 204) return null;
  return res.json();
}

function wrapFetchError(err: unknown): Error {
  if (err instanceof TypeError && String(err.message).includes('fetch')) {
    return new Error(
      'Cannot reach the API. Start the backend: cd backend && source .venv/bin/activate && uvicorn app.main:app --reload --port 8000',
    );
  }
  if (err instanceof Error) return err;
  return new Error('Request failed');
}

async function request(path: string, init?: RequestInit) {
  try {
    const headers = await authHeaders();
    const res = await fetch(`${API_URL}${path}`, { ...init, headers: { ...headers, ...init?.headers } });
    return handleResponse(res);
  } catch (err) {
    throw wrapFetchError(err);
  }
}

export const api = {
  get: async (path: string) => request(path),

  put: async (path: string, body: unknown) =>
    request(path, { method: 'PUT', body: JSON.stringify(body) }),

  post: async (path: string, body?: unknown) =>
    request(path, {
      method: 'POST',
      body: body ? JSON.stringify(body) : undefined,
    }),

  delete: async (path: string) => request(path, { method: 'DELETE' }),

  uploadImage: async (file: File, folder: string) => {
    const user = auth.currentUser;
    if (!user) throw new Error('Not signed in');
    const token = await user.getIdToken();
    const form = new FormData();
    form.append('file', file);
    form.append('folder', folder);
    const res = await fetch(`${API_URL}/admin/upload/image`, {
      method: 'POST',
      headers: { Authorization: `Bearer ${token}` },
      body: form,
    });
    return handleResponse(res) as Promise<{ url: string; path: string }>;
  },

  uploadSermon: async (file: File) => {
    const user = auth.currentUser;
    if (!user) throw new Error('Not signed in');
    const token = await user.getIdToken();
    const form = new FormData();
    form.append('file', file);
    const res = await fetch(`${API_URL}/admin/upload/sermon`, {
      method: 'POST',
      headers: { Authorization: `Bearer ${token}` },
      body: form,
    });
    return handleResponse(res) as Promise<{
      docxUrl: string;
      fileName: string;
      bodyText: string;
    }>;
  },
};
