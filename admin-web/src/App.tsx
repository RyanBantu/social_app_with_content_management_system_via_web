import { Navigate, Route, Routes } from 'react-router-dom';
import { useAuth } from './context/AuthContext';
import Layout from './components/Layout';
import LoginPage from './pages/LoginPage';
import DevotionPage from './pages/DevotionPage';
import EventsPage from './pages/EventsPage';
import MinistriesPage from './pages/MinistriesPage';
import SermonsPage from './pages/SermonsPage';
import SettingsPage from './pages/SettingsPage';

function Protected({ children }: { children: React.ReactNode }) {
  const { user, loading } = useAuth();
  if (loading) return <div className="center">Loading…</div>;
  if (!user) return <Navigate to="/login" replace />;
  return children;
}

export default function App() {
  return (
    <Routes>
      <Route path="/login" element={<LoginPage />} />
      <Route
        path="/"
        element={
          <Protected>
            <Layout />
          </Protected>
        }
      >
        <Route index element={<Navigate to="/devotion" replace />} />
        <Route path="devotion" element={<DevotionPage />} />
        <Route path="events" element={<EventsPage />} />
        <Route path="ministries" element={<MinistriesPage />} />
        <Route path="sermons" element={<SermonsPage />} />
        <Route path="settings" element={<SettingsPage />} />
      </Route>
    </Routes>
  );
}
