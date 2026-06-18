import { NavLink, Outlet } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

export default function Layout() {
  const { user, logout } = useAuth();

  return (
    <div className="layout">
      <aside className="sidebar">
        <div className="brand">MHC CMS</div>
        <nav>
          <NavLink to="/devotion">Daily Devotion</NavLink>
          <NavLink to="/events" className="nav-muted">Events</NavLink>
          <NavLink to="/ministries" className="nav-muted">Ministries</NavLink>
          <NavLink to="/sermons" className="nav-muted">Sermons</NavLink>
          <NavLink to="/settings" className="nav-muted">Settings</NavLink>
        </nav>
        <div className="sidebar-footer">
          <span className="muted">{user?.email}</span>
          <button type="button" className="link-btn" onClick={() => logout()}>
            Sign out
          </button>
        </div>
      </aside>
      <main className="content">
        <Outlet />
      </main>
    </div>
  );
}
