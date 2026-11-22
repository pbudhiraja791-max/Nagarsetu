import React, { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { Mail, Lock, AlertCircle, ArrowRight, Eye, EyeOff, Shield, Building2, User as UserIcon, Loader2 } from 'lucide-react';

export const LoginPage: React.FC = () => {
  const { login } = useAuth();
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(''); setLoading(true);
    try {
      await login(email.trim().toLowerCase(), password);
      const raw = localStorage.getItem('nagarsetu_user') || localStorage.getItem('civic_user');
      const u = raw ? JSON.parse(raw) : null;
      if (u?.role === 'ADMIN') navigate('/admin');
      else if (u?.role === 'OFFICER') navigate('/officer');
      else navigate('/dashboard');
    } catch (err: any) {
      let msg = 'Invalid email or password.';
      if (err.response?.data?.detail) {
        const d = err.response.data.detail;
        msg = Array.isArray(d) ? d.map((x: any) => x.msg).join(', ') : typeof d === 'string' ? d : JSON.stringify(d);
      } else if (err.message?.includes('Network Error')) msg = 'Cannot connect to backend. Is the server running?';
      setError(msg);
    } finally { setLoading(false); }
  };

  const fillDemo = (e: string, p: string) => { setEmail(e); setPassword(p); setError(''); };

  return (
    <div className="min-h-[90vh] flex items-center justify-center p-6 bg-[#f3f6fb]">
      <div className="w-full max-w-sm">
        {/* Card */}
        <div className="bg-white rounded-2xl shadow-lg border border-slate-100 overflow-hidden">
          {/* Top bar */}
          <div className="h-1.5 bg-gradient-to-r from-[#1a2b6b] via-blue-500 to-teal-500" />
          <div className="p-7 space-y-5">
            {/* Logo */}
            <div className="text-center space-y-1.5">
              <div className="inline-flex items-center justify-center w-14 h-14 rounded-2xl bg-[#1a2b6b] shadow-lg mb-1">
                <svg className="w-8 h-8 text-white" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M3 19h18"/><path d="M4 19V11a8 8 0 0 1 16 0v8"/>
                  <path d="M12 11v8"/><path d="M8 14v5"/><path d="M16 14v5"/>
                </svg>
              </div>
              <h2 className="text-xl font-extrabold text-slate-900">Welcome back</h2>
              <p className="text-xs text-slate-500">Sign in to NagarSetu</p>
            </div>

            {/* Demo logins */}
            <div className="p-3 rounded-xl bg-blue-50 border border-blue-100 space-y-2">
              <p className="text-[10px] font-bold text-blue-600 uppercase tracking-widest">Quick Demo</p>
              <div className="grid grid-cols-3 gap-1.5">
                {[
                  { e: 'citizen@nagarsetu.gov.in', p: 'citizen123', icon: <UserIcon className="w-3.5 h-3.5"/>, label: 'Citizen', cls: 'text-teal-700 border-teal-200 hover:bg-teal-50' },
                  { e: 'road.officer@nagarsetu.gov.in', p: 'officer123', icon: <Building2 className="w-3.5 h-3.5"/>, label: 'Officer', cls: 'text-indigo-700 border-indigo-200 hover:bg-indigo-50' },
                  { e: 'admin@nagarsetu.gov.in', p: 'admin123', icon: <Shield className="w-3.5 h-3.5"/>, label: 'Admin', cls: 'text-purple-700 border-purple-200 hover:bg-purple-50' },
                ].map(({ e, p, icon, label, cls }) => (
                  <button key={label} type="button" onClick={() => fillDemo(e, p)}
                    className={`flex items-center justify-center gap-1 py-1.5 rounded-lg bg-white border text-xs font-semibold transition-all ${cls}`}>
                    {icon} {label}
                  </button>
                ))}
              </div>
            </div>

            {error && (
              <div className="p-3 bg-red-50 border border-red-200 rounded-xl text-red-700 text-xs flex items-start gap-2">
                <AlertCircle className="w-4 h-4 shrink-0 mt-0.5"/><span>{error}</span>
              </div>
            )}

            <form onSubmit={handleSubmit} className="space-y-3.5">
              <div>
                <label className="block text-xs font-semibold text-slate-700 mb-1.5">Email Address</label>
                <div className="relative">
                  <Mail className="w-4 h-4 text-slate-400 absolute left-3 top-3"/>
                  <input type="email" required value={email} onChange={e => setEmail(e.target.value)}
                    placeholder="citizen@nagarsetu.gov.in"
                    className="w-full bg-slate-50 border border-slate-200 rounded-xl pl-9 pr-4 py-2.5 text-sm text-slate-900 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all"/>
                </div>
              </div>
              <div>
                <label className="block text-xs font-semibold text-slate-700 mb-1.5">Password</label>
                <div className="relative">
                  <Lock className="w-4 h-4 text-slate-400 absolute left-3 top-3"/>
                  <input type={showPassword ? 'text' : 'password'} required value={password} onChange={e => setPassword(e.target.value)}
                    placeholder="••••••••"
                    className="w-full bg-slate-50 border border-slate-200 rounded-xl pl-9 pr-10 py-2.5 text-sm text-slate-900 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all"/>
                  <button type="button" onClick={() => setShowPassword(!showPassword)} className="absolute right-3 top-3 text-slate-400 hover:text-slate-600">
                    {showPassword ? <EyeOff className="w-4 h-4"/> : <Eye className="w-4 h-4"/>}
                  </button>
                </div>
              </div>
              <button type="submit" disabled={loading}
                className="w-full py-3 rounded-xl font-bold text-sm bg-[#1a2b6b] hover:bg-blue-800 text-white shadow-md flex items-center justify-center gap-2 transition-all disabled:opacity-60 active:scale-[0.98]">
                {loading ? <><Loader2 className="w-4 h-4 animate-spin"/> Signing in...</> : <><span>Sign In</span><ArrowRight className="w-4 h-4"/></>}
              </button>
            </form>

            <p className="text-center text-xs text-slate-500 pt-1 border-t border-slate-100">
              No account?{' '}
              <Link to="/register" className="text-blue-600 font-semibold hover:text-blue-800">Register here</Link>
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};
