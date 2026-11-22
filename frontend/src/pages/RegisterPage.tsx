import React, { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { UserRole } from '../types';
import { Mail, Lock, User as UserIcon, AlertCircle, ArrowRight, Eye, EyeOff, Building2, Shield, Loader2 } from 'lucide-react';

export const RegisterPage: React.FC = () => {
  const { register } = useAuth();
  const navigate = useNavigate();
  const [fullName, setFullName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [role, setRole] = useState<UserRole>(UserRole.CITIZEN);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError(''); setLoading(true);
    try {
      await register(fullName.trim(), email.trim().toLowerCase(), password, role);
      if (role === UserRole.ADMIN) navigate('/admin');
      else if (role === UserRole.OFFICER) navigate('/officer');
      else navigate('/dashboard');
    } catch (err: any) {
      let msg = 'Failed to create account.';
      if (err.response?.data?.detail) {
        const d = err.response.data.detail;
        msg = Array.isArray(d) ? d.map((x: any) => x.msg).join(', ') : typeof d === 'string' ? d : JSON.stringify(d);
      } else if (err.message?.includes('Network Error')) msg = 'Cannot connect to backend.';
      setError(msg);
    } finally { setLoading(false); }
  };

  const fillDemo = (r: UserRole) => {
    const rand = Math.floor(1000 + Math.random() * 9000);
    setRole(r);
    if (r === UserRole.CITIZEN) { setFullName('Aarav Sharma'); setEmail(`aarav_${rand}@nagarsetu.org`); setPassword('citizen123'); }
    else if (r === UserRole.OFFICER) { setFullName('Officer R. K. Singla'); setEmail(`officer_${rand}@nagarsetu.gov.in`); setPassword('officer123'); }
    else { setFullName('Administrator Verma'); setEmail(`admin_${rand}@nagarsetu.gov.in`); setPassword('admin123'); }
    setError('');
  };

  const roles = [
    { r: UserRole.CITIZEN, label: 'Citizen', icon: <UserIcon className="w-4 h-4"/>, active: 'bg-teal-500 text-white' },
    { r: UserRole.OFFICER, label: 'Officer', icon: <Building2 className="w-4 h-4"/>, active: 'bg-indigo-500 text-white' },
    { r: UserRole.ADMIN, label: 'Admin', icon: <Shield className="w-4 h-4"/>, active: 'bg-[#1a2b6b] text-white' },
  ];

  return (
    <div className="min-h-[90vh] flex items-center justify-center p-6 bg-[#f3f6fb]">
      <div className="w-full max-w-sm">
        <div className="bg-white rounded-2xl shadow-lg border border-slate-100 overflow-hidden">
          <div className="h-1.5 bg-gradient-to-r from-[#1a2b6b] via-blue-500 to-teal-500" />
          <div className="p-7 space-y-5">
            <div className="text-center space-y-1.5">
              <div className="inline-flex items-center justify-center w-14 h-14 rounded-2xl bg-[#1a2b6b] shadow-lg mb-1">
                <svg className="w-8 h-8 text-white" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
                  <path d="M3 19h18"/><path d="M4 19V11a8 8 0 0 1 16 0v8"/>
                  <path d="M12 11v8"/><path d="M8 14v5"/><path d="M16 14v5"/>
                </svg>
              </div>
              <h2 className="text-xl font-extrabold text-slate-900">Create Account</h2>
              <p className="text-xs text-slate-500">Join NagarSetu civic platform</p>
            </div>

            {/* Demo fill */}
            <div className="p-3 rounded-xl bg-blue-50 border border-blue-100 space-y-2">
              <p className="text-[10px] font-bold text-blue-600 uppercase tracking-widest">Fast-track Demo</p>
              <div className="grid grid-cols-3 gap-1.5">
                {roles.map(({ r, label, icon }) => (
                  <button key={r} type="button" onClick={() => fillDemo(r)}
                    className="flex items-center justify-center gap-1 py-1.5 rounded-lg bg-white border border-slate-200 text-xs font-semibold text-slate-600 hover:border-blue-300 hover:text-blue-700 transition-all">
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
              {/* Role selector */}
              <div>
                <label className="block text-xs font-semibold text-slate-700 mb-1.5">Your Role</label>
                <div className="grid grid-cols-3 gap-1.5 p-1 bg-slate-100 rounded-xl">
                  {roles.map(({ r, label, icon, active }) => (
                    <button key={r} type="button" onClick={() => setRole(r)}
                      className={`flex items-center justify-center gap-1 py-2 rounded-lg text-xs font-bold transition-all ${role === r ? active + ' shadow-sm' : 'text-slate-500 hover:text-slate-800'}`}>
                      {icon} {label}
                    </button>
                  ))}
                </div>
              </div>

              {[
                { label: 'Full Name', value: fullName, setter: setFullName, type: 'text', placeholder: 'Ananya Verma', Icon: UserIcon },
                { label: 'Email Address', value: email, setter: setEmail, type: 'email', placeholder: 'ananya@example.com', Icon: Mail },
              ].map(({ label, value, setter, type, placeholder, Icon }) => (
                <div key={label}>
                  <label className="block text-xs font-semibold text-slate-700 mb-1.5">{label}</label>
                  <div className="relative">
                    <Icon className="w-4 h-4 text-slate-400 absolute left-3 top-3"/>
                    <input type={type} required value={value} onChange={e => setter(e.target.value)} placeholder={placeholder}
                      className="w-full bg-slate-50 border border-slate-200 rounded-xl pl-9 pr-4 py-2.5 text-sm text-slate-900 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all"/>
                  </div>
                </div>
              ))}

              <div>
                <label className="block text-xs font-semibold text-slate-700 mb-1.5">Password</label>
                <div className="relative">
                  <Lock className="w-4 h-4 text-slate-400 absolute left-3 top-3"/>
                  <input type={showPassword ? 'text' : 'password'} required value={password} onChange={e => setPassword(e.target.value)} placeholder="Min. 6 characters"
                    className="w-full bg-slate-50 border border-slate-200 rounded-xl pl-9 pr-10 py-2.5 text-sm text-slate-900 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-blue-400 focus:border-transparent transition-all"/>
                  <button type="button" onClick={() => setShowPassword(!showPassword)} className="absolute right-3 top-3 text-slate-400 hover:text-slate-600">
                    {showPassword ? <EyeOff className="w-4 h-4"/> : <Eye className="w-4 h-4"/>}
                  </button>
                </div>
              </div>

              <button type="submit" disabled={loading}
                className="w-full py-3 rounded-xl font-bold text-sm bg-[#1a2b6b] hover:bg-blue-800 text-white shadow-md flex items-center justify-center gap-2 transition-all disabled:opacity-60 active:scale-[0.98]">
                {loading ? <><Loader2 className="w-4 h-4 animate-spin"/> Creating Account...</> : <><span>Create Account</span><ArrowRight className="w-4 h-4"/></>}
              </button>
            </form>

            <p className="text-center text-xs text-slate-500 pt-1 border-t border-slate-100">
              Already have an account?{' '}
              <Link to="/login" className="text-blue-600 font-semibold hover:text-blue-800">Log in</Link>
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};
