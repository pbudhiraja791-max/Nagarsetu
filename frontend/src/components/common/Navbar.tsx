import React, { useState } from 'react';
import { Link, useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import { UserRole } from '../../types';
import {
  Shield, MapPin, PlusCircle, LayoutDashboard, UserCheck, LogOut,
  Activity, BarChart3, Building2, Menu, X
} from 'lucide-react';

export const Navbar: React.FC = () => {
  const { user, logout, isAuthenticated } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const [mobileOpen, setMobileOpen] = useState(false);

  const isActive = (path: string) => location.pathname === path || location.pathname.startsWith(path + '/');

  const linkBase = 'flex items-center gap-1.5 px-3.5 py-2 rounded-full text-sm font-medium transition-all';
  const linkActive = 'bg-teal-50 text-teal-700 border border-teal-200';
  const linkIdle = 'text-slate-600 hover:text-slate-900 hover:bg-slate-100';

  return (
    <nav className="sticky top-0 z-50 bg-white/90 backdrop-blur-xl border-b border-slate-200 shadow-sm">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">

          {/* Logo */}
          <Link to="/" className="flex items-center gap-2.5 group">
            <div className="w-9 h-9 rounded-xl bg-gradient-to-tr from-teal-500 to-sky-500 p-0.5 shadow-md shadow-teal-200 group-hover:scale-105 transition-all">
              <div className="w-full h-full bg-white rounded-[10px] flex items-center justify-center">
                <svg className="w-5 h-5 text-teal-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M3 19h18" />
                  <path d="M4 19V11a8 8 0 0 1 16 0v8" />
                  <path d="M12 11v8" />
                  <path d="M8 14v5" />
                  <path d="M16 14v5" />
                </svg>
              </div>
            </div>
            <div>
              <div className="flex items-center gap-1.5">
                <span className="text-base font-black tracking-tight text-slate-900 group-hover:text-teal-600 transition-colors">
                  NagarSetu
                </span>
                <span className="hidden sm:inline text-[10px] font-bold text-teal-600 bg-teal-50 px-2 py-0.5 rounded-full border border-teal-200">
                  नगरसेतु
                </span>
              </div>
              <p className="hidden md:block text-[10px] text-slate-400 font-medium">AI Civic Intelligence</p>
            </div>
          </Link>

          {/* Desktop Nav */}
          <div className="hidden md:flex items-center gap-1">
            <Link to="/map" className={`${linkBase} ${isActive('/map') ? linkActive : linkIdle}`}>
              <MapPin className="w-3.5 h-3.5" /> Smart Map
            </Link>
            <Link to="/accountability" className={`${linkBase} ${isActive('/accountability') ? linkActive : linkIdle}`}>
              <BarChart3 className="w-3.5 h-3.5" /> Accountability
            </Link>

            {isAuthenticated && user?.role === UserRole.CITIZEN && (
              <>
                <Link to="/dashboard" className={`${linkBase} ${isActive('/dashboard') ? linkActive : linkIdle}`}>
                  <LayoutDashboard className="w-3.5 h-3.5" /> My Dashboard
                </Link>
                <Link to="/my-reports" className={`${linkBase} ${isActive('/my-reports') ? linkActive : linkIdle}`}>
                  <UserCheck className="w-3.5 h-3.5" /> My Reports
                </Link>
              </>
            )}

            {isAuthenticated && user?.role === UserRole.ADMIN && (
              <>
                <Link to="/admin" className={`${linkBase} ${isActive('/admin') ? 'bg-purple-50 text-purple-700 border border-purple-200' : linkIdle}`}>
                  <Activity className="w-3.5 h-3.5" /> Command Center
                </Link>
                <Link to="/admin/issues" className={`${linkBase} ${isActive('/admin/issues') ? 'bg-purple-50 text-purple-700 border border-purple-200' : linkIdle}`}>
                  <Shield className="w-3.5 h-3.5" /> Issue SLA
                </Link>
              </>
            )}

            {isAuthenticated && user?.role === UserRole.OFFICER && (
              <Link to="/officer" className={`${linkBase} ${isActive('/officer') ? 'bg-indigo-50 text-indigo-700 border border-indigo-200' : linkIdle}`}>
                <Building2 className="w-3.5 h-3.5" /> Field Queue
              </Link>
            )}
          </div>

          {/* Right Actions */}
          <div className="flex items-center gap-2">
            <Link
              to="/report"
              className="hidden sm:inline-flex items-center gap-1.5 px-4 py-2 rounded-full text-xs font-bold bg-teal-500 hover:bg-teal-400 text-white shadow-sm shadow-teal-200 transition-all active:scale-95"
            >
              <PlusCircle className="w-3.5 h-3.5" /> Report Issue
            </Link>

            {isAuthenticated ? (
              <div className="flex items-center gap-2">
                <div className="hidden lg:block text-right">
                  <div className="text-xs font-bold text-slate-800 truncate max-w-[130px]">{user?.full_name}</div>
                  <div className="text-[10px] text-teal-600 font-medium">
                    {user?.role === UserRole.OFFICER ? 'Field Officer' : user?.role === UserRole.ADMIN ? 'Administrator' : 'Citizen'}
                  </div>
                </div>
                <button
                  onClick={() => { logout(); navigate('/login'); }}
                  className="flex items-center gap-1.5 px-3 py-2 rounded-full text-xs font-semibold text-slate-500 hover:text-slate-800 hover:bg-slate-100 border border-slate-200 transition-all"
                >
                  <LogOut className="w-3.5 h-3.5" />
                  <span className="hidden sm:inline">Logout</span>
                </button>
              </div>
            ) : (
              <div className="flex items-center gap-2">
                <Link
                  to="/login"
                  className="px-4 py-2 rounded-full text-xs font-bold text-slate-600 hover:text-slate-900 hover:bg-slate-100 border border-slate-200 transition-all"
                >
                  LOG IN
                </Link>
                <Link
                  to="/register"
                  className="px-4 py-2 rounded-full text-xs font-bold bg-teal-500 hover:bg-teal-400 text-white shadow-sm transition-all"
                >
                  SIGN UP
                </Link>
              </div>
            )}

            {/* Mobile menu button */}
            <button
              className="md:hidden p-2 rounded-full text-slate-500 hover:bg-slate-100 transition-all"
              onClick={() => setMobileOpen(!mobileOpen)}
            >
              {mobileOpen ? <X className="w-5 h-5" /> : <Menu className="w-5 h-5" />}
            </button>
          </div>
        </div>

        {/* Mobile Menu */}
        {mobileOpen && (
          <div className="md:hidden border-t border-slate-100 py-3 space-y-1">
            {[
              { to: '/map', label: 'Smart Map', icon: <MapPin className="w-4 h-4" /> },
              { to: '/accountability', label: 'Accountability', icon: <BarChart3 className="w-4 h-4" /> },
              { to: '/report', label: 'Report Issue', icon: <PlusCircle className="w-4 h-4" /> },
              ...(isAuthenticated && user?.role === UserRole.CITIZEN ? [
                { to: '/dashboard', label: 'My Dashboard', icon: <LayoutDashboard className="w-4 h-4" /> },
                { to: '/my-reports', label: 'My Reports', icon: <UserCheck className="w-4 h-4" /> },
              ] : []),
              ...(isAuthenticated && user?.role === UserRole.ADMIN ? [
                { to: '/admin', label: 'Command Center', icon: <Activity className="w-4 h-4" /> },
                { to: '/admin/issues', label: 'Issue SLA', icon: <Shield className="w-4 h-4" /> },
              ] : []),
              ...(isAuthenticated && user?.role === UserRole.OFFICER ? [
                { to: '/officer', label: 'Field Queue', icon: <Building2 className="w-4 h-4" /> },
              ] : []),
            ].map(({ to, label, icon }) => (
              <Link
                key={to}
                to={to}
                onClick={() => setMobileOpen(false)}
                className={`flex items-center gap-3 px-4 py-2.5 rounded-xl text-sm font-medium ${isActive(to) ? 'bg-teal-50 text-teal-700' : 'text-slate-600 hover:bg-slate-50'}`}
              >
                {icon} {label}
              </Link>
            ))}
          </div>
        )}
      </div>
    </nav>
  );
};
