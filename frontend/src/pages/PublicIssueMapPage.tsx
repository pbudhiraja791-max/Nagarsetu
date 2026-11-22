import React, { useState, useEffect } from 'react';
import { MapContainer, TileLayer, Marker, Popup, Circle } from 'react-leaflet';
import L from 'leaflet';
import { issueService, analyticsService } from '../services/api';
import { MapPoint, IssueType, IssueStatus, PredictiveHotspot } from '../types';
import { PriorityBadge } from '../components/common/PriorityBadge';
import { StatusBadge } from '../components/common/StatusBadge';
import { MapPin, Filter, Search, Eye, Cpu, RefreshCw, Flame, Users, Clock, AlertTriangle } from 'lucide-react';
import { Link } from 'react-router-dom';

const createCustomIcon = (color: string, isOverdue: boolean) => {
  const borderCol = isOverdue ? '#ef4444' : 'white';
  const anim = isOverdue ? 'animation: pulse 1s infinite;' : '';
  return L.divIcon({
    className: 'custom-map-marker',
    html: `<div style="background-color: ${color}; width: 20px; height: 20px; border-radius: 50%; border: 3px solid ${borderCol}; box-shadow: 0 0 12px ${color}; ${anim}"></div>`,
    iconSize: [20, 20],
    iconAnchor: [10, 10],
  });
};

const categoryColors: Record<string, string> = {
  'Pothole': '#f97316',
  'Damaged Road': '#ea580c',
  'Garbage Accumulation': '#eab308',
  'Overflowing Dustbin': '#ca8a04',
  'Water Leakage': '#06b6d4',
  'Drainage Blockage': '#a855f7',
  'Waterlogging': '#3b82f6',
  'Damaged Streetlight': '#facc15',
  'Exposed Electrical Wire': '#ef4444',
  'Open Manhole': '#dc2626',
  'Broken Public Infrastructure': '#14b8a6',
  'Other Civic Problem': '#64748b'
};

export const PublicIssueMapPage: React.FC = () => {
  const [points, setPoints] = useState<MapPoint[]>([]);
  const [hotspots, setHotspots] = useState<PredictiveHotspot[]>([]);
  const [showHotspots, setShowHotspots] = useState(true);
  const [loading, setLoading] = useState(true);

  // Filters
  const [selectedType, setSelectedType] = useState<string>('ALL');
  const [selectedStatus, setSelectedStatus] = useState<string>('ALL');
  const [searchQuery, setSearchQuery] = useState<string>('');

  const loadMapData = async () => {
    setLoading(true);
    try {
      const [pts, hots] = await Promise.all([
        issueService.getMapData(),
        analyticsService.getPredictiveHotspots()
      ]);
      setPoints(pts);
      setHotspots(hots || []);
    } catch (err) {
      console.error('Failed to load map data:', err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadMapData();
  }, []);

  const filteredPoints = points.filter((pt) => {
    if (selectedType !== 'ALL' && pt.issue_type !== selectedType) return false;
    if (selectedStatus !== 'ALL' && pt.status !== selectedStatus) return false;
    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase();
      const matchTitle = pt.title.toLowerCase().includes(q);
      const matchAddress = pt.address?.toLowerCase().includes(q) || false;
      if (!matchTitle && !matchAddress) return false;
    }
    return true;
  });

  return (
    <div className="h-[calc(100vh-4rem)] flex flex-col relative overflow-hidden bg-sky-50 font-sans">
      {/* Filter Header Bar */}
      <div className="bg-slate-50/95 backdrop-blur-md border-b border-slate-200 p-4 z-20">
        <div className="max-w-7xl mx-auto flex flex-wrap items-center justify-between gap-4">
          <div className="flex items-center gap-2.5">
            <div className="w-9 h-9 rounded-xl bg-cyan-500/10 flex items-center justify-center text-teal-500 border border-cyan-500/30">
              <MapPin className="w-5 h-5" />
            </div>
            <div>
              <h1 className="text-base font-extrabold text-slate-900 leading-tight flex items-center gap-2">
                NagarSetu Smart Infrastructure Map
                <span className="text-[10px] bg-teal-50 text-teal-600 px-2 py-0.5 rounded-full border border-teal-200 font-mono">
                  {filteredPoints.length} Live Points
                </span>
              </h1>
              <p className="text-xs text-slate-500">Geospatial civic tracking with predictive recurrence hotspot analytics</p>
            </div>
          </div>

          <div className="flex flex-wrap items-center gap-3">
            {/* Toggle Predictive Hotspots */}
            <button
              onClick={() => setShowHotspots(!showHotspots)}
              className={`px-3 py-1.5 rounded-xl text-xs font-bold flex items-center gap-1.5 transition-all ${
                showHotspots
                  ? 'bg-purple-900/60 text-purple-200 border border-purple-600'
                  : 'bg-sky-50 text-slate-500 border border-slate-200'
              }`}
            >
              <Flame className="w-3.5 h-3.5 text-purple-400" />
              {showHotspots ? 'Predictive Clusters Active' : 'Show Predictive Clusters'}
            </button>

            {/* Search Input */}
            <div className="relative">
              <Search className="w-4 h-4 text-slate-500 absolute left-3 top-2.5" />
              <input
                type="text"
                placeholder="Search area/landmark..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="bg-sky-50 border border-slate-200 rounded-xl pl-9 pr-3 py-1.5 text-xs text-slate-900 focus:outline-none focus:border-cyan-500 w-40 sm:w-52"
              />
            </div>

            {/* Category Filter */}
            <select
              value={selectedType}
              onChange={(e) => setSelectedType(e.target.value)}
              className="bg-sky-50 border border-slate-200 rounded-xl px-3 py-1.5 text-xs text-slate-900 focus:outline-none focus:border-cyan-500"
            >
              <option value="ALL">All Civic Categories</option>
              {Object.values(IssueType).map((t) => (
                <option key={t} value={t}>{t}</option>
              ))}
            </select>

            {/* Status Filter */}
            <select
              value={selectedStatus}
              onChange={(e) => setSelectedStatus(e.target.value)}
              className="bg-sky-50 border border-slate-200 rounded-xl px-3 py-1.5 text-xs text-slate-900 focus:outline-none focus:border-cyan-500"
            >
              <option value="ALL">All Statuses</option>
              {Object.values(IssueStatus).map((s) => (
                <option key={s} value={s}>{s}</option>
              ))}
            </select>

            <button
              onClick={loadMapData}
              className="p-2 rounded-xl bg-slate-100 hover:bg-slate-700 text-slate-600 border border-slate-700 transition-colors"
              title="Refresh Map Data"
            >
              <RefreshCw className={`w-4 h-4 ${loading ? 'animate-spin' : ''}`} />
            </button>
          </div>
        </div>
      </div>

      {/* Map Canvas Container */}
      <div className="flex-1 relative z-10">
        <MapContainer
          center={[28.6180, 77.2140]}
          zoom={13}
          scrollWheelZoom={true}
          style={{ width: '100%', height: '100%' }}
        >
          <TileLayer
            attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
            url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
          />

          {/* Predictive Hotspot Density Rings */}
          {showHotspots &&
            hotspots.map((h) => (
              <Circle
                key={h.cluster_id}
                center={[h.latitude, h.longitude]}
                radius={220}
                pathOptions={{
                  fillColor: h.risk_color,
                  fillOpacity: 0.18,
                  color: h.risk_color,
                  weight: 2,
                  dashArray: '4, 6',
                }}
              >
                <Popup minWidth={240}>
                  <div className="p-1 space-y-1.5 text-xs">
                    <div className="font-bold text-slate-900 flex items-center justify-between">
                      <span>Predictive Defect Hotspot</span>
                      <span
                        className="px-2 py-0.5 rounded text-[10px] font-black uppercase"
                        style={{ backgroundColor: `${h.risk_color}30`, color: h.risk_color }}
                      >
                        {h.risk_level} Risk
                      </span>
                    </div>
                    <p className="text-slate-600 font-medium">{h.address}</p>
                    <div className="text-[11px] text-slate-500">
                      Recurrence probability: <strong className="text-slate-900">{h.recurrence_probability}</strong> ({h.forecast_period})
                    </div>
                    <div className="p-2 rounded bg-slate-50 border border-slate-200 text-[10px] text-purple-300">
                      <strong>Recommendation:</strong> {h.preventive_action}
                    </div>
                  </div>
                </Popup>
              </Circle>
            ))}

          {/* Issue Markers */}
          {filteredPoints.map((pt) => {
            const markerColor = categoryColors[pt.issue_type] || '#10b981';
            return (
              <Marker
                key={pt.id}
                position={[pt.latitude, pt.longitude]}
                icon={createCustomIcon(markerColor, Boolean(pt.is_overdue))}
              >
                <Popup minWidth={270} maxWidth={320}>
                  <div className="p-1 space-y-2">
                    {pt.image_url && (
                      <div className="rounded-lg overflow-hidden max-h-32 bg-sky-50">
                        <img src={pt.image_url} alt={pt.title} className="w-full h-full object-cover" />
                      </div>
                    )}
                    <div>
                      <div className="flex items-center justify-between mb-1">
                        <span className="text-[10px] font-bold text-teal-500 uppercase tracking-wide">
                          {pt.issue_type}
                        </span>
                        <StatusBadge status={pt.status} />
                      </div>
                      <h4 className="text-xs font-bold text-slate-900 line-clamp-1">{pt.title}</h4>
                      <p className="text-[11px] text-slate-500 line-clamp-1 mt-0.5">{pt.address}</p>
                      <div className="text-[10px] text-slate-500 flex items-center gap-2 mt-1">
                        <span>{pt.department || 'Dept Assigned'}</span>
                        <span>•</span>
                        <span className="text-emerald-400 font-medium">{pt.support_count || 1} Citizen Endorsements</span>
                      </div>
                      {pt.is_overdue && (
                        <div className="mt-1 text-[10px] text-red-500 font-bold bg-red-50/60 p-1 rounded border border-red-200">
                          ⚠️ Department SLA Overdue
                        </div>
                      )}
                    </div>

                    <div className="flex items-center justify-between pt-1 border-t border-slate-700">
                      <PriorityBadge score={pt.priority_score} severity={pt.severity} />
                      <Link
                        to={`/issue/${pt.id}`}
                        className="inline-flex items-center gap-1 text-xs font-semibold text-teal-500 hover:underline"
                      >
                        Inspect Evidence <Eye className="w-3 h-3" />
                      </Link>
                    </div>
                  </div>
                </Popup>
              </Marker>
            );
          })}
        </MapContainer>

        {/* Floating Map Legend */}
        <div className="absolute bottom-6 right-6 z-20 bg-sky-50/95 backdrop-blur-md p-4 rounded-2xl border border-slate-200 hidden sm:block max-w-xs shadow-xl">
          <h4 className="text-xs font-extrabold text-slate-700 mb-2 flex items-center gap-1.5">
            <MapPin className="w-3.5 h-3.5 text-teal-500" />
            Infrastructure Legend
          </h4>
          <div className="grid grid-cols-2 gap-2 text-[11px] text-slate-500">
            {Object.entries(categoryColors).slice(0, 8).map(([cat, col]) => (
              <div key={cat} className="flex items-center gap-1.5">
                <span className="w-2.5 h-2.5 rounded-full flex-shrink-0" style={{ backgroundColor: col }} />
                <span className="truncate">{cat}</span>
              </div>
            ))}
          </div>
          <div className="mt-2.5 pt-2 border-t border-slate-200 text-[10px] text-slate-500 space-y-1">
            <div className="flex items-center gap-1.5">
              <span className="w-2.5 h-2.5 rounded-full bg-rose-500 border border-white" />
              <span>Red Border: Overdue SLA</span>
            </div>
            <div className="flex items-center gap-1.5">
              <span className="w-2.5 h-2.5 rounded-full border border-purple-400 border-dashed" />
              <span>Dashed Ring: Predicted Defect Hotspot</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
