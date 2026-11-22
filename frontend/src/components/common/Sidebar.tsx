import React from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import { useCity } from '../../context/CityContext';
import { UserRole } from '../../types';
import {
  Home, PlusCircle, Search, Calendar, Users, HelpCircle,
  Building2, LayoutDashboard
} from 'lucide-react';

export const Sidebar: React.FC = () => {
  const { user, isAuthenticated } = useAuth();
  const { selectedCity } = useCity();
  const location = useLocation();

  const isActive = (path: string) =>
    path === '/' ? location.pathname === '/' : location.pathname.startsWith(path);

  const navItems = [
    { to: '/', icon: <Home className="w-5 h-5 fill-current" />, label: 'Home' },
    { to: '/report', icon: <PlusCircle className="w-5 h-5" />, label: 'Report Issue' },
    { to: '/map', icon: <Search className="w-5 h-5" />, label: 'Track Status' },
    { to: '/accountability', icon: <Calendar className="w-5 h-5" />, label: 'City Updates' },
    { to: '/about', icon: <Users className="w-5 h-5" />, label: 'About Us' },
    { to: '/help', icon: <HelpCircle className="w-5 h-5" />, label: 'Help' },
  ];

  return (
    <>
      {/* ── DESKTOP SIDEBAR (Matches Reference Image) ──────────────── */}
      <aside className="hidden md:flex fixed left-0 top-0 h-full w-56 bg-white border-r border-[#E2E8F0] flex-col z-40 shadow-xs justify-between">
        <div>
          {/* Logo Section */}
          <div className="flex flex-col items-center pt-8 pb-7 px-4">
            <div className="w-16 h-14 mb-2.5 flex items-center justify-center">
              <svg viewBox="0 0 100 70" fill="none" xmlns="http://www.w3.org/2000/svg" className="w-full h-full drop-shadow-xs">
                {/* Modern city skyline */}
                <rect x="12" y="34" width="10" height="32" fill="#3B82F6" rx="1.5"/>
                <rect x="24" y="22" width="11" height="44" fill="#2563EB" rx="1.5"/>
                <rect x="37" y="14" width="13" height="52" fill="#1D4ED8" rx="1.5"/>
                <rect x="52" y="26" width="11" height="40" fill="#2563EB" rx="1.5"/>
                <rect x="65" y="18" width="12" height="48" fill="#1D4ED8" rx="1.5"/>
                <rect x="79" y="30" width="10" height="36" fill="#3B82F6" rx="1.5"/>
                {/* Bridge arch */}
                <path d="M5 64 Q50 14 95 64" stroke="#60A5FA" strokeWidth="4" fill="none" strokeLinecap="round"/>
                <line x1="28" y1="64" x2="28" y2="44" stroke="#60A5FA" strokeWidth="2" strokeOpacity="0.8"/>
                <line x1="50" y1="64" x2="50" y2="34" stroke="#60A5FA" strokeWidth="2" strokeOpacity="0.8"/>
                <line x1="72" y1="64" x2="72" y2="44" stroke="#60A5FA" strokeWidth="2" strokeOpacity="0.8"/>
                <rect x="2" y="64" width="96" height="3" fill="#2563EB" rx="1.5"/>
              </svg>
            </div>
            <h1 className="text-[#0B2454] font-black text-xl tracking-tight leading-none">NagarSetu</h1>
            <p className="text-slate-400 text-[10px] font-medium text-center leading-tight mt-1.5 tracking-normal">
              Bridging Citizens &amp; Authorities
            </p>
          </div>

          {/* Navigation Links */}
          <nav className="px-3.5 space-y-1">
            {navItems.map(({ to, icon, label }) => {
              const active = isActive(to);
              return (
                <Link
                  key={to + label}
                  to={to}
                  className={`flex items-center gap-3.5 px-4 py-2.5 rounded-xl text-sm font-semibold transition-all ${
                    active
                      ? 'bg-[#EAF4FF] text-[#1677F5] shadow-xs'
                      : 'text-slate-600 hover:bg-slate-50 hover:text-[#0B2454]'
                  }`}
                >
                  <span className={active ? 'text-[#1677F5]' : 'text-slate-500'}>
                    {icon}
                  </span>
                  <span>{label}</span>
                </Link>
              );
            })}

            {/* Role Links if logged in as Officer/Admin */}
            {isAuthenticated && user?.role === UserRole.OFFICER && (
              <Link
                to="/officer"
                className={`flex items-center gap-3.5 px-4 py-2.5 rounded-xl text-sm font-semibold transition-all ${
                  isActive('/officer') ? 'bg-[#EAF4FF] text-[#1677F5]' : 'text-slate-600 hover:bg-slate-50'
                }`}
              >
                <Building2 className="w-5 h-5 text-purple-600" />
                <span>Field Queue</span>
              </Link>
            )}

            {isAuthenticated && user?.role === UserRole.ADMIN && (
              <Link
                to="/admin"
                className={`flex items-center gap-3.5 px-4 py-2.5 rounded-xl text-sm font-semibold transition-all ${
                  isActive('/admin') ? 'bg-[#EAF4FF] text-[#1677F5]' : 'text-slate-600 hover:bg-slate-50'
                }`}
              >
                <LayoutDashboard className="w-5 h-5 text-indigo-600" />
                <span>Admin Panel</span>
              </Link>
            )}
          </nav>
        </div>

        {/* Bottom Section: City Skyline Illustration & Handwritten Slogan */}
        <div className="p-4 space-y-3">
          {/* Subtle City Skyline sketch */}
          <div className="w-full h-14 flex items-center justify-center opacity-65">
            <svg viewBox="0 0 120 50" className="w-full h-full text-blue-400" fill="none">
              <rect x="6" y="20" width="10" height="28" fill="#93C5FD" rx="1"/>
              <rect x="18" y="14" width="14" height="34" fill="#60A5FA" rx="1"/>
              <rect x="34" y="8" width="12" height="40" fill="#3B82F6" rx="1"/>
              <rect x="48" y="16" width="13" height="32" fill="#60A5FA" rx="1"/>
              <rect x="63" y="10" width="14" height="38" fill="#2563EB" rx="1"/>
              <rect x="79" y="18" width="11" height="30" fill="#60A5FA" rx="1"/>
              <rect x="92" y="12" width="13" height="36" fill="#3B82F6" rx="1"/>
              <rect x="107" y="22" width="8" height="26" fill="#93C5FD" rx="1"/>
              <line x1="0" y1="48" x2="120" y2="48" stroke="#93C5FD" strokeWidth="2"/>
            </svg>
          </div>

          {/* Handwritten Slogan matching universal requirement */}
          <div className="text-left px-1">
            <p className="text-[#0B2454] text-xs font-semibold leading-tight font-handwritten text-base">
              A cleaner, safer and better tomorrow —
            </p>
            <p className="text-[#1677F5] text-base font-extrabold italic tracking-tight font-handwritten">
              Together!
            </p>
          </div>

          {/* Dynamic City Initiative Pill */}
          <div className="flex items-center gap-2 pt-2 border-t border-slate-100 text-[11px] text-slate-500">
            <span className="w-2 h-2 rounded-full bg-emerald-500 shrink-0 animate-pulse" />
            <div className="min-w-0">
              <p className="font-bold text-[#0B2454] leading-tight text-[11px] truncate">{selectedCity}</p>
              <p className="text-[10px] text-slate-400 leading-tight">Civic Grievance Cell</p>
            </div>
          </div>
        </div>
      </aside>

      {/* ── MOBILE BOTTOM NAVIGATION ─────────────────────────────────── */}
      <nav className="md:hidden fixed bottom-0 left-0 right-0 z-50 bg-white border-t border-slate-200 flex items-center justify-around h-16 shadow-2xl px-2">
        <Link
          to="/"
          className={`flex flex-col items-center justify-center py-1 px-3 rounded-lg transition-all ${
            isActive('/') ? 'text-[#1677F5] font-bold' : 'text-slate-500 hover:text-slate-900'
          }`}
        >
          <Home className="w-5 h-5" />
          <span className="text-[10px] mt-0.5">Home</span>
        </Link>

        <Link
          to="/report"
          className={`flex flex-col items-center justify-center py-1 px-3 rounded-lg transition-all ${
            isActive('/report') ? 'text-[#1677F5] font-bold' : 'text-slate-500 hover:text-slate-900'
          }`}
        >
          <PlusCircle className="w-5 h-5" />
          <span className="text-[10px] mt-0.5">Report</span>
        </Link>

        <Link
          to="/map"
          className={`flex flex-col items-center justify-center py-1 px-3 rounded-lg transition-all ${
            isActive('/map') ? 'text-[#1677F5] font-bold' : 'text-slate-500 hover:text-slate-900'
          }`}
        >
          <Search className="w-5 h-5" />
          <span className="text-[10px] mt-0.5">Track</span>
        </Link>

        <Link
          to="/accountability"
          className={`flex flex-col items-center justify-center py-1 px-3 rounded-lg transition-all ${
            isActive('/accountability') ? 'text-[#1677F5] font-bold' : 'text-slate-500 hover:text-slate-900'
          }`}
        >
          <Calendar className="w-5 h-5" />
          <span className="text-[10px] mt-0.5">Updates</span>
        </Link>

        <Link
          to={isAuthenticated ? (user?.role === UserRole.ADMIN ? '/admin' : user?.role === UserRole.OFFICER ? '/officer' : '/dashboard') : '/login'}
          className={`flex flex-col items-center justify-center py-1 px-3 rounded-lg transition-all ${
            isActive('/dashboard') || isActive('/admin') || isActive('/officer') || isActive('/login')
              ? 'text-[#1677F5] font-bold'
              : 'text-slate-500 hover:text-slate-900'
          }`}
        >
          <Users className="w-5 h-5" />
          <span className="text-[10px] mt-0.5">{isAuthenticated ? 'Account' : 'Login'}</span>
        </Link>
      </nav>
    </>
  );
};
