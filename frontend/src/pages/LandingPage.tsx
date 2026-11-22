import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useCity } from '../context/CityContext';
import {
  Camera, Search, MapPin, ArrowRight, CheckCircle2,
  Clock, AlertCircle, Info, ChevronRight, FileText, Check,
  Flame, X, Upload, Sparkles, ChevronLeft, AlertTriangle
} from 'lucide-react';

interface CustomReport {
  id: string;
  title: string;
  category: string;
  city: string;
  locality: string;
  description: string;
  status: 'open' | 'in_progress' | 'resolved';
  photo: string | null;
  submittedAt: string;
}

const QUICK_CATEGORIES = [
  {
    id: 'potholes',
    label: 'Potholes',
    icon: (
      <svg viewBox="0 0 36 36" className="w-8 h-8" fill="none">
        <path d="M10 6 L4 30 M26 6 L32 30" stroke="#EF4444" strokeWidth="2.5" strokeLinecap="round" />
        <rect x="5" y="10" width="26" height="6" rx="1.5" fill="#EF4444" />
        <line x1="10" y1="10" x2="14" y2="16" stroke="white" strokeWidth="1.5" />
        <line x1="18" y1="10" x2="22" y2="16" stroke="white" strokeWidth="1.5" />
        <rect x="6" y="20" width="24" height="5" rx="1.5" fill="#EF4444" />
      </svg>
    ),
  },
  {
    id: 'garbage',
    label: 'Garbage',
    icon: (
      <svg viewBox="0 0 36 36" className="w-8 h-8" fill="none">
        <rect x="9" y="11" width="18" height="20" rx="2" fill="#10B981" />
        <rect x="7" y="8" width="22" height="3.5" rx="1" fill="#059669" />
        <line x1="14" y1="15" x2="14" y2="27" stroke="white" strokeWidth="1.5" strokeLinecap="round" />
        <line x1="18" y1="15" x2="18" y2="27" stroke="white" strokeWidth="1.5" strokeLinecap="round" />
        <line x1="22" y1="15" x2="22" y2="27" stroke="white" strokeWidth="1.5" strokeLinecap="round" />
      </svg>
    ),
  },
  {
    id: 'drainage',
    label: 'Drainage',
    icon: (
      <svg viewBox="0 0 36 36" className="w-8 h-8" fill="none">
        <path d="M6 13 Q18 7 30 13" stroke="#6366F1" strokeWidth="2.5" strokeLinecap="round" />
        <path d="M6 19 Q18 13 30 19" stroke="#6366F1" strokeWidth="2.5" strokeLinecap="round" />
        <path d="M6 25 Q18 19 30 25" stroke="#6366F1" strokeWidth="2.5" strokeLinecap="round" />
      </svg>
    ),
  },
];

export const LandingPage: React.FC = () => {
  const navigate = useNavigate();
  const { selectedCity, cityData, setIsCityModalOpen } = useCity();

  // Search & Filter States
  const [trackId, setTrackId] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string>('Potholes');
  const [mapFilter, setMapFilter] = useState<'all' | 'open' | 'in_progress' | 'resolved'>('all');
  const [selectedMapIssue, setSelectedMapIssue] = useState<any | null>(null);
  const [zoomLevel, setZoomLevel] = useState(1);

  // Tracking Modal State
  const [trackingModalData, setTrackingModalData] = useState<{
    id: string;
    status: 'Submitted' | 'Open' | 'In Progress' | 'Resolved';
    title: string;
    category: string;
    location: string;
    date: string;
    authority: string;
    step: number;
    timeline: { title: string; time: string; done: boolean }[];
  } | null>(null);

  // Quick Report & Upload Modal State
  const [quickReportModalOpen, setQuickReportModalOpen] = useState(false);
  const [reportTitle, setReportTitle] = useState('');
  const [reportDesc, setReportDesc] = useState('');
  const [reportLocality, setReportLocality] = useState('');
  const [reportPhoto, setReportPhoto] = useState<string | null>(null);
  const [isSubmittingReport, setIsSubmittingReport] = useState(false);
  const [reportSuccessModal, setReportSuccessModal] = useState<{ id: string; title: string; locality: string } | null>(null);

  // Local storage persisted user reports
  const [userReports, setUserReports] = useState<CustomReport[]>(() => {
    try {
      const saved = localStorage.getItem('nagarsetu_custom_reports');
      return saved ? JSON.parse(saved) : [];
    } catch {
      return [];
    }
  });

  // Handle Track ID submission
  const handleTrackSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const query = trackId.trim();
    if (!query) {
      navigate('/map');
      return;
    }

    const uppercaseQuery = query.toUpperCase();
    const existing = userReports.find(r => r.id.toUpperCase() === uppercaseQuery);

    if (existing) {
      setTrackingModalData({
        id: existing.id,
        status: existing.status === 'resolved' ? 'Resolved' : existing.status === 'in_progress' ? 'In Progress' : 'Open',
        title: existing.title,
        category: existing.category,
        location: `${existing.locality}, ${existing.city}`,
        date: existing.submittedAt,
        authority: `${existing.city} Municipal Authority`,
        step: existing.status === 'resolved' ? 4 : existing.status === 'in_progress' ? 3 : 2,
        timeline: [
          { title: 'Report Submitted & Acknowledged', time: 'Just now', done: true },
          { title: 'Location Verified by Local Team', time: 'Verified', done: true },
          { title: 'Assigned to Municipal Field Crew', time: 'In Progress', done: existing.status !== 'open' },
          { title: 'Field Action Completed & Verified', time: 'Pending', done: existing.status === 'resolved' },
        ],
      });
      return;
    }

    // Friendly realistic simulation for demo ID
    const isResolved = uppercaseQuery.endsWith('5') || uppercaseQuery.endsWith('7');
    const isInProgress = uppercaseQuery.endsWith('2') || uppercaseQuery.endsWith('4');

    setTrackingModalData({
      id: uppercaseQuery.startsWith('NS') ? uppercaseQuery : `NS${uppercaseQuery}`,
      status: isResolved ? 'Resolved' : isInProgress ? 'In Progress' : 'Open',
      title: isResolved
        ? 'Public road repair & asphalt leveling'
        : 'Civic issue complaint filed by neighborhood citizen',
      category: 'Urban Infrastructure',
      location: `Central Ward, ${selectedCity}`,
      date: 'Today, 09:30 AM',
      authority: cityData.authorityName,
      step: isResolved ? 4 : isInProgress ? 3 : 2,
      timeline: [
        { title: 'Citizen Report Filed & Received', time: '09:30 AM', done: true },
        { title: 'Acknowledged by Ward Desk', time: '10:15 AM', done: true },
        { title: `Assigned to ${selectedCity} Field Crew`, time: '11:00 AM', done: isInProgress || isResolved },
        { title: 'Field Action Completed & Fixed', time: isResolved ? 'Completed' : 'Expected soon', done: isResolved },
      ],
    });
  };

  // Submit new report
  const handleCreateReport = (e: React.FormEvent) => {
    e.preventDefault();
    if (!reportTitle.trim()) return;

    setIsSubmittingReport(true);
    setTimeout(() => {
      const generatedId = `NS${Math.floor(10000 + Math.random() * 90000)}`;
      const newReport: CustomReport = {
        id: generatedId,
        title: reportTitle.trim(),
        category: selectedCategory,
        city: selectedCity,
        locality: reportLocality.trim() || 'Central Zone',
        description: reportDesc.trim() || 'Reported via NagarSetu Quick Report.',
        status: 'open',
        photo: reportPhoto,
        submittedAt: new Date().toLocaleDateString('en-IN', { day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit' }),
      };

      const updated = [newReport, ...userReports];
      setUserReports(updated);
      localStorage.setItem('nagarsetu_custom_reports', JSON.stringify(updated));

      setIsSubmittingReport(false);
      setQuickReportModalOpen(false);
      setReportTitle('');
      setReportDesc('');
      setReportLocality('');
      setReportPhoto(null);
      setReportSuccessModal({ id: generatedId, title: newReport.title, locality: newReport.locality });
    }, 600);
  };

  // Merge default city map issues with user created reports for this city
  const cityUserMapIssues = userReports
    .filter(r => r.city.toLowerCase() === selectedCity.toLowerCase())
    .map(r => ({
      id: r.id,
      title: r.title,
      category: r.category,
      status: r.status,
      location: `${r.locality}, ${r.city}`,
      x: 35 + Math.floor(Math.random() * 30),
      y: 35 + Math.floor(Math.random() * 30),
      timeAgo: 'Just now',
    }));

  const allCityMapIssues = [...cityUserMapIssues, ...cityData.mapIssues];

  const filteredMapIssues = allCityMapIssues.filter(issue => {
    if (mapFilter === 'all') return true;
    return issue.status === mapFilter;
  });

  // Friendly neighborhood updates
  const communityUpdates = [
    { id: '1', title: `Road pothole near Main Market in ${selectedCity} has been fixed.`, status: 'Fixed', timeAgo: '2h ago', type: 'fixed' },
    { id: '2', title: `Garbage has been reported near a residential area.`, status: 'Reported', timeAgo: '3h ago', type: 'reported' },
    { id: '3', title: `A blocked drain has been reported nearby.`, status: 'In Progress', timeAgo: '5h ago', type: 'in_progress' },
    { id: '4', title: `Streetlight repair completed on Park Avenue.`, status: 'Fixed', timeAgo: '6h ago', type: 'fixed' },
    { id: '5', title: `Neighborhood cleanliness drive completed.`, status: 'Fixed', timeAgo: '8h ago', type: 'fixed' },
  ];

  return (
    <div className="bg-[#F2F7FF] min-h-screen pb-12 pt-2 px-3 sm:px-6 md:px-8">
      {/* ─────────────────────────────────────────────────────────────
          UNIVERSAL MAIN DASHBOARD: 2 MAJOR COLUMNS (Center Grid + Right Sidebar)
         ───────────────────────────────────────────────────────────── */}
      <div className="max-w-[1580px] mx-auto grid grid-cols-1 xl:grid-cols-12 gap-5 md:gap-6">

        {/* ═══════════════════════════════════════════════════════════
            LEFT / CENTER COLUMN (Width ~72% on XL screens: 8 or 9 cols)
           ═══════════════════════════════════════════════════════════ */}
        <div className="xl:col-span-8 2xl:col-span-9 space-y-5 md:space-y-6">

          {/* ── 1. CINEMATIC HERO BANNER ──────────────────────────────── */}
          <div
            className="relative rounded-3xl overflow-hidden min-h-[260px] md:h-72 flex flex-col justify-between p-6 md:p-9 shadow-xs"
            style={{
              background: `
                linear-gradient(90deg, rgba(11,36,84,0.96) 0%, rgba(11,36,84,0.85) 45%, rgba(11,36,84,0.4) 70%, rgba(11,36,84,0.15) 100%),
                url("https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?w=1600&auto=format&fit=crop&q=80") center/cover no-repeat
              `,
            }}
          >
            {/* Top Small Heading */}
            <div className="relative z-10 flex items-center justify-between">
              <span className="text-[11px] font-extrabold tracking-widest uppercase text-slate-300 font-mono flex items-center gap-1.5">
                <span className="w-2 h-2 rounded-full bg-[#1677F5] inline-block animate-pulse" />
                YOUR CITY. YOUR VOICE.
              </span>
              <span className="text-xs text-slate-300/80 font-medium hidden sm:block">
                Connecting Citizens &amp; Communities
              </span>
            </div>

            {/* Main Content */}
            <div className="relative z-10 max-w-xl space-y-2.5 my-auto">
              <h1 className="text-3xl sm:text-4xl md:text-[42px] font-black text-white tracking-tight leading-tight">
                Report. Track.{' '}
                <span className="text-[#38BDF8] drop-shadow-xs">Resolve.</span>
              </h1>
              <p className="text-xs sm:text-sm text-slate-200 font-normal leading-relaxed max-w-md">
                Together, we can build cleaner, safer, and better communities — one report at a time.
              </p>

              {/* Action Buttons */}
              <div className="pt-2 flex flex-wrap items-center gap-3">
                <button
                  type="button"
                  onClick={() => setQuickReportModalOpen(true)}
                  className="inline-flex items-center gap-2.5 px-5 py-2.5 bg-[#1677F5] hover:bg-blue-600 text-white font-bold text-xs sm:text-sm rounded-xl shadow-md transition-all active:scale-95 group"
                >
                  <Camera className="w-4 h-4 transition-transform group-hover:scale-110" />
                  <span>Report an Issue</span>
                  <ArrowRight className="w-4 h-4 transition-transform group-hover:translate-x-0.5" />
                </button>

                <button
                  type="button"
                  onClick={() => {
                    const el = document.getElementById('track-report-input');
                    el?.focus();
                  }}
                  className="inline-flex items-center gap-2 px-5 py-2.5 bg-white/10 hover:bg-white/20 text-white font-semibold text-xs sm:text-sm rounded-xl border border-white/25 backdrop-blur-xs transition-all active:scale-95"
                >
                  <Search className="w-4 h-4 text-slate-300" />
                  <span>Track Status</span>
                </button>
              </div>
            </div>

            {/* Handwritten Note on Right Side */}
            <div className="hidden lg:flex absolute top-6 right-8 md:right-16 z-10 flex-col items-end pointer-events-none select-none">
              <div className="text-right text-white font-handwritten text-2xl md:text-3xl leading-snug drop-shadow-md rotate-[-2deg]">
                <p>See a problem?</p>
                <p className="text-yellow-300 font-bold">Let's fix it!</p>
              </div>
              {/* Curved chalk arrow pointing towards the road problem */}
              <div className="w-20 h-16 -mr-4 mt-1">
                <svg viewBox="0 0 100 80" fill="none" className="w-full h-full text-white/90 drop-shadow">
                  <path
                    d="M 80 5 Q 40 25 25 70"
                    stroke="currentColor"
                    strokeWidth="2.5"
                    strokeLinecap="round"
                    strokeDasharray="4 2"
                    fill="none"
                  />
                  <path
                    d="M 18 55 L 25 72 L 38 65"
                    stroke="currentColor"
                    strokeWidth="2.5"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    fill="none"
                  />
                </svg>
              </div>
            </div>
          </div>

          {/* ── 2. ROW 1 BELOW HERO: Quick Report + Track Your Report ────── */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-5 md:gap-6">

            {/* CARD A: QUICK REPORT (3 Minimal Categories, No Descriptions, No View All) */}
            <div className="bg-white rounded-3xl p-6 shadow-xs border border-slate-100/90 flex flex-col justify-between">
              <div>
                {/* Header */}
                <div className="flex items-center gap-2 mb-1">
                  <div className="w-6 h-6 rounded-lg bg-blue-50 text-[#1677F5] flex items-center justify-center">
                    <Sparkles className="w-4 h-4 fill-current" />
                  </div>
                  <h2 className="text-[#0B2454] font-black text-base">Quick Report</h2>
                </div>
                <p className="text-xs text-slate-400 font-medium mb-4">
                  Choose an issue to report in your area ({selectedCity}).
                </p>

                {/* Exactly 3 Categories Grid: Evenly sized, horizontally aligned, clean with only icon & label */}
                <div className="grid grid-cols-3 gap-2.5 sm:gap-3.5 mb-4">
                  {QUICK_CATEGORIES.map((cat) => {
                    const isSelected = selectedCategory === cat.label;
                    return (
                      <button
                        key={cat.id}
                        type="button"
                        onClick={() => {
                          setSelectedCategory(cat.label);
                          setReportTitle(`${cat.label} issue in ${selectedCity}`);
                        }}
                        className={`flex flex-col items-center justify-center py-4 px-2 sm:px-3 rounded-2xl transition-all cursor-pointer text-center group ${
                          isSelected
                            ? 'border-2 border-[#1677F5] bg-[#EAF4FF] shadow-xs'
                            : 'border border-slate-200/80 bg-white hover:bg-slate-50 hover:border-blue-200 hover:shadow-xs'
                        }`}
                      >
                        <div className="w-9 h-9 sm:w-10 sm:h-10 flex items-center justify-center mb-2 transition-transform duration-200 group-hover:scale-110">
                          {cat.icon}
                        </div>
                        <span className={`text-xs sm:text-sm font-bold tracking-tight block ${
                          isSelected ? 'text-[#1677F5]' : 'text-[#0B2454]'
                        }`}>
                          {cat.label}
                        </span>
                      </button>
                    );
                  })}
                </div>
              </div>

              {/* Upload Photo / Take Photo Banner Strip */}
              <button
                type="button"
                onClick={() => setQuickReportModalOpen(true)}
                className="w-full bg-[#EAF4FF] hover:bg-[#d8eaff] border border-[#BFDBFE] rounded-2xl py-3 px-4 flex items-center justify-between text-left transition-all active:scale-[0.99] group shadow-2xs"
              >
                <ChevronLeft className="w-4 h-4 text-slate-400 group-hover:text-[#1677F5] transition-colors" />
                <div className="flex items-center gap-3">
                  <div className="w-8 h-8 rounded-xl bg-[#1677F5] text-white flex items-center justify-center shadow-xs">
                    <Camera className="w-4 h-4" />
                  </div>
                  <div>
                    <p className="text-xs font-bold text-[#1677F5] leading-tight">
                      Upload Photo / Take Photo
                    </p>
                    <p className="text-[10px] text-slate-500 font-medium leading-tight">
                      Add a photo to help authorities locate the issue faster
                    </p>
                  </div>
                </div>
                <ChevronRight className="w-4 h-4 text-slate-400 group-hover:text-[#1677F5] transition-colors" />
              </button>
            </div>

            {/* CARD B: TRACK YOUR REPORT (Clean & Simple, No Duplicate Stats) */}
            <div className="bg-white rounded-3xl p-6 shadow-xs border border-slate-100/90 flex flex-col justify-between">
              <div>
                {/* Header */}
                <div className="flex items-center gap-2 mb-1">
                  <div className="w-6 h-6 rounded-lg bg-blue-50 text-[#1677F5] flex items-center justify-center">
                    <Search className="w-4 h-4 stroke-[2.5]" />
                  </div>
                  <h2 className="text-[#0B2454] font-black text-base">Track Your Report</h2>
                </div>
                <p className="text-xs text-slate-400 font-medium mb-4">
                  Enter your report ID to check its current status.
                </p>

                {/* Form Input & Button */}
                <form onSubmit={handleTrackSubmit} className="flex gap-2">
                  <div className="relative flex-1">
                    <input
                      id="track-report-input"
                      type="text"
                      value={trackId}
                      onChange={e => setTrackId(e.target.value)}
                      placeholder="e.g. NS12345"
                      className="w-full px-4 py-2.5 rounded-xl border border-slate-200 bg-[#F8FAFC] text-xs sm:text-sm text-[#0B2454] placeholder-slate-400 font-semibold focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-200 focus:border-[#1677F5] transition-all"
                    />
                  </div>
                  <button
                    type="submit"
                    className="px-6 py-2.5 rounded-xl bg-[#1677F5] hover:bg-blue-600 text-white font-bold text-xs sm:text-sm shadow-xs transition-all active:scale-95 whitespace-nowrap"
                  >
                    Track
                  </button>
                </form>
              </div>

              {/* Simple helpful citizen hint */}
              <div className="pt-4 border-t border-slate-100 flex items-center gap-2.5 text-xs text-slate-500">
                <div className="w-6 h-6 rounded-full bg-blue-50 text-[#1677F5] flex items-center justify-center shrink-0">
                  <Info className="w-3.5 h-3.5" />
                </div>
                <span>Check resolution updates, field inspection notes, and fixes anytime.</span>
              </div>
            </div>
          </div>

          {/* ── 3. ROW 2 BELOW HERO: Problems Around You + Recently Reported & Fixed ── */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-5 md:gap-6">

            {/* CARD C: PROBLEMS AROUND YOU (Renamed from Live Issue Map, No View Full Map link) */}
            <div className="bg-white rounded-3xl p-6 shadow-xs border border-slate-100/90 flex flex-col justify-between">
              <div>
                {/* Header with Title and Filter Pills */}
                <div className="flex flex-wrap items-center justify-between gap-2 mb-3">
                  <div className="flex items-center gap-2">
                    <div className="w-6 h-6 rounded-lg bg-blue-50 text-[#1677F5] flex items-center justify-center">
                      <MapPin className="w-4 h-4 fill-current" />
                    </div>
                    <h2 className="text-[#0B2454] font-black text-base">Problems Around You</h2>
                  </div>

                  {/* Filter Pills */}
                  <div className="flex items-center gap-1 bg-slate-100/90 p-0.5 rounded-full text-[11px] font-semibold">
                    <button
                      type="button"
                      onClick={() => setMapFilter('all')}
                      className={`px-2.5 py-0.5 rounded-full transition-all ${
                        mapFilter === 'all'
                          ? 'bg-[#1677F5] text-white shadow-2xs'
                          : 'text-slate-600 hover:text-[#0B2454]'
                      }`}
                    >
                      All
                    </button>
                    <button
                      type="button"
                      onClick={() => setMapFilter('open')}
                      className={`px-2 py-0.5 rounded-full flex items-center gap-1 transition-all ${
                        mapFilter === 'open'
                          ? 'bg-red-500 text-white shadow-2xs'
                          : 'text-slate-600 hover:text-red-600'
                      }`}
                    >
                      <span className="w-1.5 h-1.5 rounded-full bg-red-500 inline-block" />
                      <span>Open</span>
                    </button>
                    <button
                      type="button"
                      onClick={() => setMapFilter('in_progress')}
                      className={`px-2 py-0.5 rounded-full flex items-center gap-1 transition-all ${
                        mapFilter === 'in_progress'
                          ? 'bg-amber-500 text-white shadow-2xs'
                          : 'text-slate-600 hover:text-amber-600'
                      }`}
                    >
                      <span className="w-1.5 h-1.5 rounded-full bg-amber-500 inline-block" />
                      <span>In Progress</span>
                    </button>
                    <button
                      type="button"
                      onClick={() => setMapFilter('resolved')}
                      className={`px-2 py-0.5 rounded-full flex items-center gap-1 transition-all ${
                        mapFilter === 'resolved'
                          ? 'bg-emerald-500 text-white shadow-2xs'
                          : 'text-slate-600 hover:text-emerald-600'
                      }`}
                    >
                      <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 inline-block" />
                      <span>Resolved</span>
                    </button>
                  </div>
                </div>
              </div>

              {/* Dynamic Interactive Neighborhood Map Canvas */}
              <div className="relative rounded-2xl overflow-hidden h-52 bg-[#E6F0FA] border border-slate-200/80 shadow-2xs select-none">
                <svg
                  className="w-full h-full"
                  viewBox="0 0 600 300"
                  fill="none"
                  preserveAspectRatio="xMidYMid slice"
                  style={{ transform: `scale(${zoomLevel})`, transition: 'transform 0.3s ease' }}
                >
                  {/* City Land & Parks */}
                  <rect width="600" height="300" fill="#EBF3EB" />
                  <rect x="30" y="25" width="160" height="90" rx="12" fill="#D7EBD3" />
                  <rect x="220" y="30" width="130" height="80" rx="10" fill="#DFF0DB" />
                  <rect x="420" y="20" width="150" height="100" rx="12" fill="#D7EBD3" />
                  <rect x="40" y="160" width="140" height="110" rx="12" fill="#DFF0DB" />
                  <rect x="230" y="150" width="150" height="120" rx="10" fill="#D7EBD3" />
                  <rect x="430" y="160" width="140" height="110" rx="12" fill="#E4F5E0" />

                  {/* Water Canal Ribbon */}
                  <path
                    d="M 150 0 Q 230 110 210 180 T 290 300"
                    stroke="#BFDBFE"
                    strokeWidth="28"
                    strokeLinecap="round"
                    fill="none"
                  />
                  <path
                    d="M 150 0 Q 230 110 210 180 T 290 300"
                    stroke="#93C5FD"
                    strokeWidth="14"
                    strokeLinecap="round"
                    fill="none"
                  />

                  {/* Road Grid */}
                  <line x1="0" y1="140" x2="600" y2="140" stroke="#FFFFFF" strokeWidth="12" />
                  <line x1="0" y1="140" x2="600" y2="140" stroke="#E2E8F0" strokeWidth="2" strokeDasharray="6 6" />
                  <line x1="390" y1="0" x2="390" y2="300" stroke="#FFFFFF" strokeWidth="12" />
                  <line x1="0" y1="60" x2="600" y2="220" stroke="#FFFFFF" strokeWidth="7" />
                  <line x1="0" y1="240" x2="600" y2="70" stroke="#FFFFFF" strokeWidth="7" />

                  {/* City Name Tag */}
                  <text x="320" y="132" fill="#0B2454" fontSize="13" fontWeight="800" letterSpacing="0.5">
                    {selectedCity}
                  </text>

                  {/* Pulsating User Location Pin */}
                  <circle cx="340" cy="155" r="14" fill="#3B82F6" fillOpacity="0.2" className="animate-ping" />
                  <circle cx="340" cy="155" r="7" fill="#1677F5" stroke="#FFFFFF" strokeWidth="2" />
                </svg>

                {/* Map Markers */}
                <div className="absolute inset-0 pointer-events-none">
                  {filteredMapIssues.map((issue, idx) => {
                    const isSelected = selectedMapIssue?.id === issue.id;
                    const colorBg =
                      issue.status === 'open'
                        ? 'bg-red-500'
                        : issue.status === 'in_progress'
                        ? 'bg-amber-500'
                        : 'bg-emerald-500';
                    const icon = issue.status === 'resolved' ? '✓' : '!';

                    return (
                      <div
                        key={issue.id + idx}
                        style={{ left: `${issue.x}%`, top: `${issue.y}%` }}
                        className="absolute -translate-x-1/2 -translate-y-1/2 pointer-events-auto cursor-pointer transition-transform hover:scale-125 z-10"
                        onClick={() => setSelectedMapIssue(issue)}
                      >
                        <div
                          className={`w-5 h-5 rounded-full ${colorBg} text-white font-bold text-[10px] flex items-center justify-center shadow-md border-2 border-white ${
                            isSelected ? 'ring-4 ring-blue-300 scale-125' : ''
                          }`}
                        >
                          {icon}
                        </div>
                      </div>
                    );
                  })}
                </div>

                {/* Selected Marker Details Popup */}
                {selectedMapIssue && (
                  <div className="absolute top-2 left-2 right-2 sm:right-auto sm:max-w-xs bg-white rounded-2xl p-3 shadow-xl border border-slate-200 z-30 animate-fadeIn">
                    <div className="flex items-start justify-between gap-2">
                      <div>
                        <span className={`inline-block px-1.5 py-0.5 rounded text-[9px] font-bold ${
                          selectedMapIssue.status === 'open'
                            ? 'bg-red-50 text-red-600'
                            : selectedMapIssue.status === 'in_progress'
                            ? 'bg-amber-50 text-amber-600'
                            : 'bg-emerald-50 text-emerald-600'
                        }`}>
                          {selectedMapIssue.id} • {selectedMapIssue.status.toUpperCase()}
                        </span>
                        <h4 className="text-xs font-bold text-[#0B2454] mt-1 leading-snug">
                          {selectedMapIssue.title}
                        </h4>
                        <p className="text-[10px] text-slate-500 mt-0.5 flex items-center gap-1">
                          <MapPin className="w-3 h-3 text-slate-400" />
                          <span>{selectedMapIssue.location}</span>
                        </p>
                      </div>
                      <button
                        type="button"
                        onClick={() => setSelectedMapIssue(null)}
                        className="p-1 text-slate-400 hover:text-slate-600 rounded"
                      >
                        <X className="w-3.5 h-3.5" />
                      </button>
                    </div>
                    <div className="mt-2.5 pt-2 border-t border-slate-100 flex items-center justify-between">
                      <span className="text-[10px] text-slate-400">{selectedMapIssue.timeAgo}</span>
                      <button
                        type="button"
                        onClick={() => {
                          setTrackId(selectedMapIssue.id);
                          setSelectedMapIssue(null);
                          const el = document.getElementById('track-report-input');
                          el?.focus();
                        }}
                        className="text-[10px] font-bold text-[#1677F5] hover:underline flex items-center gap-0.5"
                      >
                        <span>Track Status</span>
                        <ArrowRight className="w-3 h-3" />
                      </button>
                    </div>
                  </div>
                )}

                {/* Bottom Left Legend Pill */}
                <div className="absolute bottom-3 left-3 bg-white/95 backdrop-blur-xs rounded-full px-3 py-1 shadow-xs flex items-center gap-3 text-[10px] font-bold text-[#0B2454] border border-slate-200/90 z-20">
                  <span className="flex items-center gap-1.5">
                    <span className="w-2 h-2 rounded-full bg-red-500 inline-block" />
                    <span>Open</span>
                  </span>
                  <span className="flex items-center gap-1.5">
                    <span className="w-2 h-2 rounded-full bg-amber-500 inline-block" />
                    <span>In Progress</span>
                  </span>
                  <span className="flex items-center gap-1.5">
                    <span className="w-2 h-2 rounded-full bg-emerald-500 inline-block" />
                    <span>Resolved</span>
                  </span>
                </div>

                {/* Bottom Right Zoom Controls */}
                <div className="absolute bottom-3 right-3 bg-white/95 rounded-xl shadow-xs border border-slate-200/90 flex flex-col z-20 overflow-hidden">
                  <button
                    type="button"
                    onClick={() => setZoomLevel(prev => Math.min(prev + 0.25, 2))}
                    className="w-7 h-7 flex items-center justify-center text-slate-700 hover:bg-slate-100 font-bold text-sm border-b border-slate-100 transition-colors"
                  >
                    +
                  </button>
                  <button
                    type="button"
                    onClick={() => setZoomLevel(prev => Math.max(prev - 0.25, 1))}
                    className="w-7 h-7 flex items-center justify-center text-slate-700 hover:bg-slate-100 font-bold text-sm transition-colors"
                  >
                    -
                  </button>
                </div>
              </div>
            </div>

            {/* CARD D: RECENTLY REPORTED & FIXED (Friendly Community Activity Feed) */}
            <div className="bg-white rounded-3xl p-6 shadow-xs border border-slate-100/90 flex flex-col justify-between">
              <div>
                {/* Header: Friendly Title, NO View All */}
                <div className="flex items-center gap-2 mb-3">
                  <div className="w-6 h-6 rounded-lg bg-blue-50 text-[#1677F5] flex items-center justify-center">
                    <CheckCircle2 className="w-4 h-4 fill-current text-white bg-[#1677F5] rounded-full" />
                  </div>
                  <h2 className="text-[#0B2454] font-black text-base">Recently Reported &amp; Fixed</h2>
                </div>

                {/* Clean, Human-Readable Activity Feed */}
                <div className="space-y-3 pt-1">
                  {communityUpdates.map((item) => {
                    const isFixed = item.status === 'Fixed';
                    const isInProgress = item.status === 'In Progress';

                    return (
                      <div key={item.id} className="flex items-center justify-between gap-3 pb-2.5 border-b border-slate-100 last:border-b-0">
                        <div className="flex items-center gap-3 min-w-0">
                          <div className={`w-6 h-6 rounded-full flex items-center justify-center shrink-0 shadow-2xs ${
                            isFixed
                              ? 'bg-emerald-100 text-emerald-600'
                              : isInProgress
                              ? 'bg-amber-100 text-amber-600'
                              : 'bg-blue-100 text-[#1677F5]'
                          }`}>
                            {isFixed ? (
                              <Check className="w-3.5 h-3.5 stroke-[3]" />
                            ) : isInProgress ? (
                              <Clock className="w-3.5 h-3.5 stroke-[2.5]" />
                            ) : (
                              <AlertCircle className="w-3.5 h-3.5 stroke-[2.5]" />
                            )}
                          </div>
                          <div className="min-w-0">
                            <p className="text-xs font-semibold text-[#0B2454] truncate">
                              {item.title}
                            </p>
                            <p className="text-[10px] text-slate-400">{item.timeAgo}</p>
                          </div>
                        </div>

                        {/* Minimal Friendly Status Indicator */}
                        <span className={`shrink-0 px-2 py-0.5 rounded-full text-[10px] font-bold ${
                          isFixed
                            ? 'bg-emerald-50 text-emerald-600 border border-emerald-100'
                            : isInProgress
                            ? 'bg-amber-50 text-amber-600 border border-amber-100'
                            : 'bg-slate-100 text-slate-600 border border-slate-200'
                        }`}>
                          {item.status}
                        </span>
                      </div>
                    );
                  })}
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* ═══════════════════════════════════════════════════════════
            RIGHT SIDEBAR: Minimal Location, Simple Stats, Promo, Popular
           ═══════════════════════════════════════════════════════════ */}
        <div className="xl:col-span-4 2xl:col-span-3 space-y-5 md:space-y-6">

          {/* ── CARD 1: MINIMAL YOUR LOCATION CARD (Replaces Weather Card) ── */}
          <div className="bg-white rounded-3xl p-5 shadow-xs border border-slate-100/90 flex items-center justify-between">
            <div className="flex items-center gap-3.5 min-w-0">
              <div className="w-10 h-10 rounded-2xl bg-[#EAF4FF] text-[#1677F5] flex items-center justify-center shrink-0">
                <MapPin className="w-5 h-5 fill-[#1677F5]" />
              </div>
              <div className="min-w-0">
                <p className="text-[11px] text-slate-400 font-semibold leading-tight">Your Location</p>
                <h3 className="text-base sm:text-lg font-black text-[#0B2454] leading-tight mt-0.5 truncate">
                  {selectedCity}
                </h3>
              </div>
            </div>
            <button
              type="button"
              onClick={() => setIsCityModalOpen(true)}
              className="px-3.5 py-1.5 rounded-xl bg-blue-50 hover:bg-blue-100 text-[#1677F5] font-bold text-xs transition-colors shrink-0"
            >
              Change Location
            </button>
          </div>

          {/* ── CARD 2: SIMPLIFIED STATISTICS (Total Reports, Resolved, Needs Attention) ── */}
          <div className="bg-white rounded-3xl p-5 shadow-xs border border-slate-100/90 space-y-3">
            {/* Row 1: Total Reports */}
            <div className="flex items-center gap-3.5 p-3 rounded-2xl bg-[#F8FAFC] border border-slate-100">
              <div className="w-9 h-9 rounded-xl bg-blue-50 text-[#1677F5] flex items-center justify-center shrink-0">
                <FileText className="w-4 h-4" />
              </div>
              <div>
                <p className="text-xl font-black text-[#0B2454] leading-tight">
                  {cityData.stats.total + userReports.length}
                </p>
                <p className="text-xs text-slate-500 font-medium leading-tight mt-0.5">Total Reports</p>
              </div>
            </div>

            {/* Row 2: Resolved */}
            <div className="flex items-center gap-3.5 p-3 rounded-2xl bg-[#F8FAFC] border border-slate-100">
              <div className="w-9 h-9 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center shrink-0">
                <CheckCircle2 className="w-4 h-4" />
              </div>
              <div>
                <p className="text-xl font-black text-[#0B2454] leading-tight">
                  {cityData.stats.resolved}
                </p>
                <p className="text-xs text-slate-500 font-medium leading-tight mt-0.5">Resolved</p>
              </div>
            </div>

            {/* Row 3: Needs Attention */}
            <div className="flex items-center gap-3.5 p-3 rounded-2xl bg-[#F8FAFC] border border-slate-100">
              <div className="w-9 h-9 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center shrink-0">
                <AlertTriangle className="w-4 h-4" />
              </div>
              <div>
                <p className="text-xl font-black text-[#0B2454] leading-tight">
                  {Math.max(1, (cityData.stats.total + userReports.length) - cityData.stats.resolved)}
                </p>
                <p className="text-xs text-slate-500 font-medium leading-tight mt-0.5">Needs Attention</p>
              </div>
            </div>
          </div>

          {/* ── CARD 3: PROMOTIONAL CALL TO ACTION CARD ─────────────── */}
          <div
            className="rounded-3xl p-6 relative overflow-hidden shadow-xs flex flex-col justify-between min-h-[175px]"
            style={{
              background: `
                linear-gradient(135deg, rgba(11,36,84,0.94) 0%, rgba(22,119,245,0.85) 100%),
                url("https://images.unsplash.com/photo-1515162816999-a0c47dc192f7?w=600&auto=format&fit=crop&q=80") center/cover no-repeat
              `,
            }}
          >
            <div className="relative z-10 space-y-1">
              <p className="text-white/80 font-handwritten text-xl">See it.</p>
              <h3 className="text-white font-black text-2xl tracking-tight leading-tight">
                Report it.<br />
                <span className="text-[#38BDF8]">Fix it!</span>
              </h3>
            </div>

            <div className="relative z-10 pt-4">
              <button
                type="button"
                onClick={() => setQuickReportModalOpen(true)}
                className="inline-flex items-center gap-2 px-5 py-2.5 rounded-full bg-white hover:bg-slate-100 text-[#1677F5] font-black text-xs shadow-md transition-all active:scale-95"
              >
                <span>Report Now</span>
                <ArrowRight className="w-3.5 h-3.5" />
              </button>
            </div>
          </div>

          {/* ── CARD 4: POPULAR ISSUES (No View All Link) ────────────── */}
          <div className="bg-white rounded-3xl p-5 shadow-xs border border-slate-100/90 space-y-4">
            {/* Header: No View All */}
            <div className="flex items-center gap-2">
              <Flame className="w-4 h-4 text-orange-500 fill-orange-500" />
              <h3 className="text-[#0B2454] font-black text-sm">Popular Issues</h3>
              <span className="text-[11px] font-bold text-slate-400 ml-auto">
                in {selectedCity}
              </span>
            </div>

            {/* List with clean progress bars */}
            <div className="space-y-3 pt-1">
              {cityData.popularIssues.slice(0, 4).map((item, idx) => (
                <div key={item.category + idx} className="flex items-center gap-3">
                  <div className="w-7 h-7 rounded-xl bg-slate-50 text-slate-600 flex items-center justify-center shrink-0 border border-slate-100">
                    <span className="w-2 h-2 rounded-full" style={{ backgroundColor: item.color }} />
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center justify-between text-xs mb-1">
                      <span className="font-bold text-[#0B2454] truncate">{item.category}</span>
                      <span className="font-bold text-slate-500 ml-2">{item.count}</span>
                    </div>
                    <div className="w-full bg-slate-100 rounded-full h-1.5 overflow-hidden">
                      <div
                        className="h-full rounded-full transition-all duration-500"
                        style={{ width: `${item.percentage}%`, backgroundColor: item.color }}
                      />
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* ── BOTTOM UNIVERSAL SLOGAN STRIP ────────────────────────────── */}
      <div className="mt-8 text-center text-xs font-semibold text-slate-400 tracking-wide select-none">
        Better Citizens &nbsp;•&nbsp; Cleaner Communities &nbsp;•&nbsp; Stronger Nation
      </div>

      {/* ── MODAL: INTERACTIVE REPORT STATUS & LIFECYCLE TRACKER ──────── */}
      {trackingModalData && (
        <div className="fixed inset-0 bg-black/40 backdrop-blur-xs flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-3xl p-6 max-w-md w-full shadow-2xl border border-slate-100 space-y-4 animate-fadeIn">
            <div className="flex items-center justify-between">
              <span className="px-3 py-1 rounded-full text-xs font-bold bg-[#EAF4FF] text-[#1677F5]">
                {trackingModalData.id}
              </span>
              <button
                type="button"
                onClick={() => setTrackingModalData(null)}
                className="w-7 h-7 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-500 flex items-center justify-center"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            <div>
              <span className={`inline-block px-2 py-0.5 rounded text-[10px] font-bold ${
                trackingModalData.status === 'Resolved'
                  ? 'bg-emerald-50 text-emerald-600'
                  : trackingModalData.status === 'In Progress'
                  ? 'bg-amber-50 text-amber-600'
                  : 'bg-red-50 text-red-600'
              }`}>
                {trackingModalData.status.toUpperCase()}
              </span>
              <h3 className="text-base font-black text-[#0B2454] mt-1">
                {trackingModalData.title}
              </h3>
              <p className="text-xs text-slate-500 mt-1 flex items-center gap-1">
                <MapPin className="w-3.5 h-3.5 text-slate-400 shrink-0" />
                <span>{trackingModalData.location}</span>
              </p>
            </div>

            {/* Lifecycle Timeline */}
            <div className="space-y-3 pt-2 border-t border-slate-100">
              {trackingModalData.timeline.map((step, idx) => (
                <div key={idx} className="flex items-center gap-3">
                  <div className={`w-6 h-6 rounded-full flex items-center justify-center text-xs font-bold ${
                    step.done ? 'bg-emerald-500 text-white' : 'bg-slate-200 text-slate-500'
                  }`}>
                    {step.done ? '✓' : idx + 1}
                  </div>
                  <div className="text-xs flex-1">
                    <p className="font-bold text-[#0B2454]">{step.title}</p>
                    <p className="text-[10px] text-slate-400">{step.time}</p>
                  </div>
                </div>
              ))}
            </div>

            <div className="pt-3 border-t border-slate-100 flex gap-2">
              <Link
                to={`/map?search=${trackingModalData.id}`}
                className="flex-1 py-2.5 rounded-xl bg-[#1677F5] hover:bg-blue-600 text-white text-center font-bold text-xs shadow-xs"
              >
                View on Live Map
              </Link>
              <button
                type="button"
                onClick={() => setTrackingModalData(null)}
                className="px-4 py-2.5 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-xs"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ── MODAL: FUNCTIONAL QUICK REPORT FORM ─────────────────────── */}
      {quickReportModalOpen && (
        <div className="fixed inset-0 bg-black/40 backdrop-blur-xs flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-3xl p-6 max-w-lg w-full shadow-2xl border border-slate-100 space-y-4 max-h-[90vh] overflow-y-auto animate-fadeIn">
            {/* Header */}
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <div className="w-8 h-8 rounded-xl bg-blue-50 text-[#1677F5] flex items-center justify-center">
                  <Camera className="w-4 h-4" />
                </div>
                <div>
                  <h3 className="text-base font-black text-[#0B2454]">
                    Report a Civic Issue
                  </h3>
                  <p className="text-[11px] text-slate-400">
                    City: <span className="font-bold text-[#1677F5]">{selectedCity}</span>
                  </p>
                </div>
              </div>
              <button
                type="button"
                onClick={() => setQuickReportModalOpen(false)}
                className="w-8 h-8 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-500 flex items-center justify-center"
              >
                <X className="w-4 h-4" />
              </button>
            </div>

            <form onSubmit={handleCreateReport} className="space-y-3.5">
              {/* Category Picker */}
              <div>
                <label className="block text-[11px] font-bold text-[#0B2454] uppercase tracking-wider mb-1.5">
                  Category
                </label>
                <select
                  value={selectedCategory}
                  onChange={e => setSelectedCategory(e.target.value)}
                  className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 bg-[#F8FAFC] text-xs font-semibold text-[#0B2454] focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-200"
                >
                  {QUICK_CATEGORIES.map(c => (
                    <option key={c.id} value={c.label}>
                      {c.label}
                    </option>
                  ))}
                </select>
              </div>

              {/* Title */}
              <div>
                <label className="block text-[11px] font-bold text-[#0B2454] uppercase tracking-wider mb-1.5">
                  Issue Title
                </label>
                <input
                  type="text"
                  required
                  value={reportTitle}
                  onChange={e => setReportTitle(e.target.value)}
                  placeholder="e.g. Broken pavement slab near market exit"
                  className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 bg-[#F8FAFC] text-xs font-medium text-[#0B2454] focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-200"
                />
              </div>

              {/* Location / Area / Locality */}
              <div className="grid grid-cols-2 gap-2">
                <div>
                  <label className="block text-[11px] font-bold text-[#0B2454] uppercase tracking-wider mb-1.5">
                    City
                  </label>
                  <input
                    type="text"
                    disabled
                    value={selectedCity}
                    className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 bg-slate-100 text-xs font-bold text-slate-600"
                  />
                </div>
                <div>
                  <label className="block text-[11px] font-bold text-[#0B2454] uppercase tracking-wider mb-1.5">
                    Area / Locality
                  </label>
                  <input
                    type="text"
                    required
                    value={reportLocality}
                    onChange={e => setReportLocality(e.target.value)}
                    placeholder="e.g. Main Market Road"
                    className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 bg-[#F8FAFC] text-xs font-medium text-[#0B2454] focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-200"
                  />
                </div>
              </div>

              {/* Description */}
              <div>
                <label className="block text-[11px] font-bold text-[#0B2454] uppercase tracking-wider mb-1.5">
                  Description
                </label>
                <textarea
                  rows={2}
                  value={reportDesc}
                  onChange={e => setReportDesc(e.target.value)}
                  placeholder="Provide additional details to assist the local team..."
                  className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 bg-[#F8FAFC] text-xs font-medium text-[#0B2454] focus:bg-white focus:outline-none focus:ring-2 focus:ring-blue-200 resize-none"
                />
              </div>

              {/* Photo Upload / Preview */}
              <div>
                <label className="block text-[11px] font-bold text-[#0B2454] uppercase tracking-wider mb-1.5">
                  Photo Evidence
                </label>
                {reportPhoto ? (
                  <div className="relative rounded-2xl overflow-hidden h-36 border border-slate-200">
                    <img src={reportPhoto} alt="Upload preview" className="w-full h-full object-cover" />
                    <button
                      type="button"
                      onClick={() => setReportPhoto(null)}
                      className="absolute top-2 right-2 p-1.5 rounded-full bg-black/60 text-white hover:bg-black transition-colors"
                    >
                      <X className="w-4 h-4" />
                    </button>
                  </div>
                ) : (
                  <label className="border-2 border-dashed border-blue-200 bg-[#F8FAFC] hover:bg-[#EAF4FF] rounded-2xl h-32 flex flex-col items-center justify-center cursor-pointer transition-colors p-3 text-center">
                    <input
                      type="file"
                      accept="image/*"
                      className="hidden"
                      onChange={e => {
                        const file = e.target.files?.[0];
                        if (file) {
                          const reader = new FileReader();
                          reader.onload = () => setReportPhoto(reader.result as string);
                          reader.readAsDataURL(file);
                        }
                      }}
                    />
                    <Upload className="w-5 h-5 text-[#1677F5] mb-1" />
                    <p className="text-xs font-bold text-[#0B2454]">
                      Upload Photo / Take Photo
                    </p>
                    <p className="text-[10px] text-slate-400 mt-0.5">
                      JPG, PNG, WEBP supported
                    </p>
                  </label>
                )}
              </div>

              {/* Action Buttons */}
              <div className="pt-2 flex gap-2">
                <button
                  type="submit"
                  disabled={isSubmittingReport}
                  className="w-full py-2.5 rounded-xl bg-[#1677F5] hover:bg-blue-600 text-white text-center font-bold text-xs flex items-center justify-center gap-1.5 shadow-xs transition-all active:scale-95 disabled:opacity-50"
                >
                  {isSubmittingReport ? (
                    <span>Submitting report...</span>
                  ) : (
                    <>
                      <span>Submit Grievance</span>
                      <ArrowRight className="w-4 h-4" />
                    </>
                  )}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* ── MODAL: REPORT CREATED SUCCESS TOAST ───────────────────────── */}
      {reportSuccessModal && (
        <div className="fixed inset-0 bg-black/40 backdrop-blur-xs flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-3xl p-6 max-w-sm w-full shadow-2xl border border-slate-100 text-center space-y-4 animate-fadeIn">
            <div className="w-12 h-12 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center mx-auto">
              <Check className="w-6 h-6 stroke-[3]" />
            </div>
            <div>
              <span className="px-3 py-1 rounded-full text-xs font-black bg-[#EAF4FF] text-[#1677F5]">
                {reportSuccessModal.id}
              </span>
              <h3 className="text-base font-black text-[#0B2454] mt-2">
                Report Submitted Successfully!
              </h3>
              <p className="text-xs text-slate-500 mt-1">
                Your report for <span className="font-bold text-[#0B2454]">{reportSuccessModal.locality}, {selectedCity}</span> has been logged and sent to the local authority.
              </p>
            </div>

            <div className="pt-2 flex gap-2">
              <button
                type="button"
                onClick={() => {
                  setTrackId(reportSuccessModal.id);
                  setReportSuccessModal(null);
                  const el = document.getElementById('track-report-input');
                  el?.focus();
                }}
                className="flex-1 py-2.5 rounded-xl bg-[#1677F5] hover:bg-blue-600 text-white font-bold text-xs"
              >
                Track Now
              </button>
              <button
                type="button"
                onClick={() => setReportSuccessModal(null)}
                className="px-4 py-2.5 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-xs"
              >
                Done
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
