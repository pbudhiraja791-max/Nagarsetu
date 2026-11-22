import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import { useCity } from '../../context/CityContext';
import { MapPin, ChevronDown, Bell, Navigation, Check, X, Loader2 } from 'lucide-react';
import { NotificationCenter } from './NotificationCenter';
import { notificationService } from '../../services/api';

export const TopBar: React.FC = () => {
  const { user, isAuthenticated, logout } = useAuth();
  const {
    selectedCity,
    setSelectedCity,
    availableCities,
    detectLocation,
    isLocating,
    isCityModalOpen,
    setIsCityModalOpen,
  } = useCity();
  const navigate = useNavigate();

  const [notifOpen, setNotifOpen] = useState(false);
  const [unreadCount, setUnreadCount] = useState(3);
  const [profileDropdownOpen, setProfileDropdownOpen] = useState(false);
  const [cityFilterInput, setCityFilterInput] = useState('');

  useEffect(() => {
    if (isAuthenticated) {
      notificationService.getNotifications()
        .then(res => setUnreadCount(res.unread_count || 3))
        .catch(() => {});
    }
  }, [isAuthenticated]);

  const handleCitySelect = (cityName: string) => {
    setSelectedCity(cityName);
    setIsCityModalOpen(false);
    setCityFilterInput('');
  };

  const handleDetectLocation = async () => {
    const detected = await detectLocation();
    if (detected) {
      setIsCityModalOpen(false);
    }
  };

  const filteredCities = availableCities.filter(c =>
    c.toLowerCase().includes(cityFilterInput.toLowerCase().trim())
  );

  return (
    <>
      <header className="h-16 bg-transparent flex items-center justify-between px-4 sm:px-6 md:px-8 pt-3 sticky top-0 z-30">
        {/* Left: Mobile Brand Badge & Clean Greeting */}
        <div className="flex items-center gap-3">
          {/* Mobile brand badge */}
          <div className="flex md:hidden items-center gap-2">
            <div className="w-8 h-8 rounded-xl bg-[#1677F5] flex items-center justify-center text-white font-black text-xs shadow-xs">
              NS
            </div>
            <span className="font-black text-[#0B2454] text-lg tracking-tight">NagarSetu</span>
          </div>
        </div>

        {/* Right: Dynamic City Selector + Notifications + User Profile */}
        <div className="flex items-center gap-2.5 sm:gap-4 ml-auto">
          {/* Notification Bell with unread counter badge '3' */}
          <button
            onClick={() => setNotifOpen(true)}
            className="relative w-9 h-9 rounded-full bg-white border border-slate-200/90 flex items-center justify-center hover:bg-slate-50 transition-colors shadow-xs"
            title="Notifications"
          >
            <Bell className="w-4 h-4 text-slate-700" />
            <span className="absolute -top-1 -right-1 w-4 h-4 rounded-full bg-[#EF4444] text-white text-[9px] font-black flex items-center justify-center shadow-xs">
              {unreadCount > 0 ? unreadCount : 3}
            </span>
          </button>

          {/* Dynamic City Selector Pill */}
          <div className="relative">
            <button
              onClick={() => setIsCityModalOpen(true)}
              className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-white border border-slate-200/90 hover:border-blue-400 text-xs sm:text-sm font-bold text-[#0B2454] transition-all shadow-xs group"
              title="Change your city"
            >
              <MapPin className="w-4 h-4 text-[#1677F5] fill-[#1677F5] shrink-0" />
              <span className="max-w-[100px] sm:max-w-[140px] truncate">{selectedCity}</span>
              <ChevronDown className="w-3.5 h-3.5 text-slate-400 group-hover:text-slate-600 transition-colors shrink-0" />
            </button>
          </div>

          {/* User Profile Avatar with Name */}
          <div className="relative">
            <button
              onClick={() => setProfileDropdownOpen(prev => !prev)}
              className="flex items-center gap-2 pl-1 pr-2.5 py-1 rounded-full bg-white/80 hover:bg-white border border-slate-200/80 transition-all shadow-xs"
            >
              <div className="w-8 h-8 rounded-full bg-[#1677F5] text-white font-bold text-xs flex items-center justify-center shadow-xs">
                {isAuthenticated ? (user?.full_name ? user.full_name.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase() : 'PB') : 'PB'}
              </div>
              <span className="hidden lg:block text-xs font-bold text-[#0B2454] whitespace-nowrap">
                {isAuthenticated && user?.full_name ? user.full_name : 'Parth Budhiraja'}
              </span>
              <ChevronDown className="w-3.5 h-3.5 text-slate-400" />
            </button>

            {/* Profile Dropdown Menu */}
            {profileDropdownOpen && (
              <div className="absolute right-0 mt-2 w-48 bg-white rounded-2xl shadow-xl border border-slate-100 py-2 z-50 text-xs font-medium animate-fadeIn">
                <div className="px-4 py-2 border-b border-slate-100">
                  <p className="font-bold text-[#0B2454] truncate">
                    {isAuthenticated && user?.full_name ? user.full_name : 'Parth Budhiraja'}
                  </p>
                  <p className="text-slate-400 text-[10px] truncate">
                    {isAuthenticated && user?.email ? user.email : 'citizen@nagarsetu.gov.in'}
                  </p>
                </div>
                {isAuthenticated ? (
                  <>
                    <button
                      onClick={() => { setProfileDropdownOpen(false); navigate('/dashboard'); }}
                      className="w-full text-left px-4 py-2 text-slate-700 hover:bg-blue-50 hover:text-[#1677F5] transition-colors"
                    >
                      My Dashboard
                    </button>
                    <button
                      onClick={() => { setProfileDropdownOpen(false); navigate('/my-reports'); }}
                      className="w-full text-left px-4 py-2 text-slate-700 hover:bg-blue-50 hover:text-[#1677F5] transition-colors"
                    >
                      Track My Reports
                    </button>
                    <button
                      onClick={() => { setProfileDropdownOpen(false); logout(); navigate('/login'); }}
                      className="w-full text-left px-4 py-2 text-red-600 hover:bg-red-50 transition-colors border-t border-slate-100 mt-1"
                    >
                      Sign Out
                    </button>
                  </>
                ) : (
                  <>
                    <button
                      onClick={() => { setProfileDropdownOpen(false); navigate('/login'); }}
                      className="w-full text-left px-4 py-2 text-slate-700 hover:bg-blue-50 hover:text-[#1677F5] transition-colors"
                    >
                      Sign In / Register
                    </button>
                    <button
                      onClick={() => { setProfileDropdownOpen(false); navigate('/about'); }}
                      className="w-full text-left px-4 py-2 text-slate-700 hover:bg-slate-50 transition-colors"
                    >
                      About Platform
                    </button>
                  </>
                )}
              </div>
            )}
          </div>
        </div>
      </header>

      {/* ── DYNAMIC CITY SELECTOR MODAL ─────────────────────────────── */}
      {isCityModalOpen && (
        <div className="fixed inset-0 bg-black/40 backdrop-blur-xs flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-3xl p-6 max-w-lg w-full shadow-2xl border border-slate-100 space-y-4 animate-fadeIn">
            {/* Modal Header */}
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <div className="w-8 h-8 rounded-xl bg-blue-50 text-[#1677F5] flex items-center justify-center">
                  <MapPin className="w-4 h-4 fill-current" />
                </div>
                <div>
                  <h3 className="text-base font-black text-[#0B2454]">Select Your City</h3>
                  <p className="text-[11px] text-slate-400 font-medium">NagarSetu serves citizens across all cities in India</p>
                </div>
              </div>
              <button
                type="button"
                onClick={() => setIsCityModalOpen(false)}
                className="w-8 h-8 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-500 flex items-center justify-center transition-colors"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            {/* GPS Auto-Detect Button */}
            <button
              type="button"
              onClick={handleDetectLocation}
              disabled={isLocating}
              className="w-full py-3 px-4 rounded-2xl bg-[#EAF4FF] hover:bg-[#d8eaff] border border-blue-200 flex items-center justify-between text-left transition-all active:scale-[0.99] group shadow-2xs"
            >
              <div className="flex items-center gap-3">
                <div className="w-8 h-8 rounded-xl bg-[#1677F5] text-white flex items-center justify-center shadow-xs">
                  {isLocating ? (
                    <Loader2 className="w-4 h-4 animate-spin" />
                  ) : (
                    <Navigation className="w-4 h-4 fill-current" />
                  )}
                </div>
                <div>
                  <p className="text-xs font-black text-[#1677F5]">
                    {isLocating ? 'Detecting your city...' : 'Detect My Current Location'}
                  </p>
                  <p className="text-[10px] text-slate-500 font-medium">
                    Auto-detect via GPS or Wi-Fi location
                  </p>
                </div>
              </div>
              <span className="text-xs font-bold text-[#1677F5] group-hover:translate-x-0.5 transition-transform">
                Detect →
              </span>
            </button>

            {/* Search Input for manual city entry */}
            <div className="relative">
              <input
                type="text"
                value={cityFilterInput}
                onChange={e => setCityFilterInput(e.target.value)}
                onKeyDown={e => {
                  if (e.key === 'Enter' && cityFilterInput.trim()) {
                    handleCitySelect(cityFilterInput.trim());
                  }
                }}
                placeholder="Search or type any city name (e.g. Pune, Lucknow, Kochi)..."
                className="w-full px-4 py-2.5 rounded-xl border border-slate-200 bg-[#F8FAFC] text-xs sm:text-sm text-[#0B2454] placeholder-slate-400 focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-200 focus:border-[#1677F5] transition-all"
              />
            </div>

            {/* List of Popular Cities Grid */}
            <div>
              <p className="text-[11px] font-bold text-slate-400 uppercase tracking-wider mb-2">
                Popular Cities
              </p>
              <div className="grid grid-cols-2 sm:grid-cols-3 gap-2 max-h-56 overflow-y-auto pr-1">
                {filteredCities.map(c => {
                  const isSelected = selectedCity.toLowerCase() === c.toLowerCase();
                  return (
                    <button
                      key={c}
                      type="button"
                      onClick={() => handleCitySelect(c)}
                      className={`flex items-center justify-between px-3 py-2.5 rounded-xl text-xs font-bold transition-all text-left ${
                        isSelected
                          ? 'bg-[#1677F5] text-white shadow-xs'
                          : 'bg-[#F8FAFC] text-slate-700 hover:bg-blue-50 hover:text-[#1677F5] border border-slate-100'
                      }`}
                    >
                      <span className="truncate">{c}</span>
                      {isSelected && <Check className="w-3.5 h-3.5 shrink-0 stroke-[3]" />}
                    </button>
                  );
                })}
              </div>

              {/* If user typed a custom city not in popular list */}
              {cityFilterInput.trim() && !filteredCities.some(c => c.toLowerCase() === cityFilterInput.trim().toLowerCase()) && (
                <div className="mt-3 pt-3 border-t border-slate-100">
                  <button
                    type="button"
                    onClick={() => handleCitySelect(cityFilterInput.trim())}
                    className="w-full py-2.5 px-4 rounded-xl bg-blue-50 hover:bg-blue-100 text-[#1677F5] font-bold text-xs flex items-center justify-between transition-colors"
                  >
                    <span>Use &ldquo;{cityFilterInput.trim()}&rdquo; as my city</span>
                    <span>Select →</span>
                  </button>
                </div>
              )}
            </div>
          </div>
        </div>
      )}

      {/* Real-time Notification Center Drawer */}
      <NotificationCenter isOpen={notifOpen} onClose={() => setNotifOpen(false)} />
    </>
  );
};
