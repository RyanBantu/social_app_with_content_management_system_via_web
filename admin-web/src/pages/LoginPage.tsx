import { useState, type FormEvent } from 'react';
import { FirebaseError } from 'firebase/app';
import { Navigate, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

function authErrorMessage(err: unknown): string {
  if (err instanceof FirebaseError) {
    switch (err.code) {
      case 'auth/configuration-not-found':
        return (
          'Firebase Auth is not enabled yet. Open Firebase Console → Authentication → ' +
          'Get started → Sign-in method → enable Email/Password, then add a user under Users.'
        );
      case 'auth/invalid-credential':
      case 'auth/wrong-password':
      case 'auth/user-not-found':
      case 'auth/invalid-email':
        return 'Wrong email or password. Use the exact user from Firebase Console → Authentication → Users.';
      case 'auth/too-many-requests':
        return 'Too many attempts. Wait a minute and try again.';
      case 'auth/network-request-failed':
        return 'Network error. Check your internet connection and try again.';
      default:
        return `${err.code}: ${err.message}`;
    }
  }
  if (err instanceof Error) return err.message;
  return 'Login failed';
}

export default function LoginPage() {
  const { login, user, loading } = useAuth();
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [busy, setBusy] = useState(false);

  if (loading) {
    return <div className="center">Loading…</div>;
  }

  if (user) {
    return <Navigate to="/devotion" replace />;
  }

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    setError('');
    setBusy(true);
    try {
      const trimmedEmail = email.trim();
      await Promise.race([
        login(trimmedEmail, password),
        new Promise<never>((_, reject) =>
          setTimeout(
            () =>
              reject(
                new Error(
                  'Login timed out. Enable Email/Password in Firebase Console → Authentication → Sign-in method.',
                ),
              ),
            15000,
          ),
        ),
      ]);
      navigate('/devotion', { replace: true });
    } catch (err) {
      setError(authErrorMessage(err));
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="login-page">
      <form className="card login-card" onSubmit={handleSubmit}>
        <h1>MHC Admin</h1>
        <p className="muted">Sign in with your church staff account</p>
        {error && <div className="toast error">{error}</div>}
        <label>
          Email
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            autoComplete="username"
          />
        </label>
        <label>
          Password
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
            autoComplete="current-password"
          />
        </label>
        <button type="submit" disabled={busy}>
          {busy ? 'Signing in…' : 'Sign in'}
        </button>
      </form>
    </div>
  );
}
