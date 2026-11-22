import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { citizenService } from '../services/api';
import { Issue, IssueStatus, IssueType, SeverityLevel } from '../types';
import { PriorityBadge } from '../components/common/PriorityBadge';
import { StatusBadge } from '../components/common/StatusBadge';
import {
  Search, Filter, MapPin, PlusCircle, ArrowRight, Clock,
  RefreshCw, CheckSquare
} from 'lucide-react';

export const MyReportsPage: React.FC = () => {
  const [items, setItems] = useState<Issue[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [status, setStatus] = useState('');
  const [category, setCategory] = useState('');
  const [severity, setSeverity] = useState('');
  const [sort, setSort] = useState('newest');

  const loadReports = () => {
    setLoading(true);
    citizenService
      .reports({
        search: search || undefined,
        status_filter: status || undefined,
        category: category || undefined,
        severity: severity || undefined,
        sort,
      })
      .then((data) => setItems(data || []))
      .catch(console.error)
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    loadReports();
  }, [status, category, severity, sort]);

  return (
    <div className="min-h-screen bg-sky-50 text-slate-900 py-8 px-4 sm:px-6 lg:px-8 font-sans">
      <div className="max-w-7xl mx-auto space-y-6">
        {/* Header */}
        <div className="flex flex-wrap items-center justify-between gap-4 border-b border-slate-200 pb-6">
          <div>
            <h1 className="text-3xl font-extrabold text-white tracking-tight">My Civic Reports</h1>
            <p className="text-sm text-slate-500 mt-1">
              Complete history of civic infrastructure issues filed from your NagarSetu account.
            </p>
          </div>
          <Link
            to="/report"
            className="px-5 py-2.5 rounded-xl bg-gradient-to-r from-cyan-500 to-emerald-500 hover:from-cyan-400 hover:to-emerald-400 text-slate-950 font-bold text-sm flex items-center gap-2 shadow-lg shadow-cyan-950 transition-all"
          >
            <PlusCircle className="w-4 h-4" /> Report New Issue
          </Link>
        </div>

        {/* Filter Controls Bar */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-3">
          <div className="relative">
            <Search className="w-4 h-4 text-slate-500 absolute left-3 top-3" />
            <input
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && loadReports()}
              placeholder="Search complaint title..."
              className="w-full bg-slate-50 border border-slate-200 rounded-xl pl-9 pr-3 py-2 text-xs text-white focus:outline-none focus:border-cyan-500"
            />
          </div>

          <select
            value={status}
            onChange={(e) => setStatus(e.target.value)}
            className="bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 text-xs text-white focus:outline-none focus:border-cyan-500"
          >
            <option value="">All Statuses</option>
            {Object.values(IssueStatus).map((v) => (
              <option key={v} value={v}>{v.replace(/_/g, ' ')}</option>
            ))}
          </select>

          <select
            value={category}
            onChange={(e) => setCategory(e.target.value)}
            className="bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 text-xs text-white focus:outline-none focus:border-cyan-500"
          >
            <option value="">All Categories</option>
            {Object.values(IssueType).map((v) => (
              <option key={v} value={v}>{v}</option>
            ))}
          </select>

          <select
            value={severity}
            onChange={(e) => setSeverity(e.target.value)}
            className="bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 text-xs text-white focus:outline-none focus:border-cyan-500"
          >
            <option value="">All Severities</option>
            {Object.values(SeverityLevel).map((v) => (
              <option key={v} value={v}>{v}</option>
            ))}
          </select>

          <select
            value={sort}
            onChange={(e) => setSort(e.target.value)}
            className="bg-slate-50 border border-slate-200 rounded-xl px-3 py-2 text-xs text-white focus:outline-none focus:border-cyan-500"
          >
            <option value="newest">Newest First</option>
            <option value="oldest">Oldest First</option>
          </select>
        </div>

        {/* Reports List */}
        {loading ? (
          <div className="py-16 text-center text-slate-500 flex items-center justify-center gap-2">
            <RefreshCw className="w-5 h-5 text-teal-500 animate-spin" />
            <span>Loading your reports...</span>
          </div>
        ) : items.length === 0 ? (
          <div className="p-12 rounded-2xl bg-white border border-slate-200 text-center space-y-3">
            <p className="text-slate-500 text-sm">No complaints match your active filter criteria.</p>
          </div>
        ) : (
          <div className="space-y-3">
            {items.map((i) => (
              <div
                key={i.id}
                className="p-5 rounded-2xl bg-slate-50/70 border border-slate-200 hover:border-slate-700 transition-all flex flex-col md:flex-row md:items-center justify-between gap-4"
              >
                <div className="space-y-1.5 flex-1 min-w-0">
                  <div className="flex flex-wrap items-center gap-2">
                    <span className="text-xs font-mono text-slate-500">Ticket #{i.id}</span>
                    <PriorityBadge score={i.priority_score} severity={i.severity} />
                    <StatusBadge status={i.status} />
                    {i.support_count && i.support_count > 1 && (
                      <span className="text-[10px] text-teal-300 font-semibold bg-teal-50 px-2 py-0.5 rounded border border-teal-200">
                        {i.support_count} Endorsements
                      </span>
                    )}
                  </div>
                  <h3 className="font-bold text-white text-base hover:text-teal-600 transition-colors truncate">
                    <Link to={`/issue/${i.id}`}>{i.title}</Link>
                  </h3>
                  <div className="flex flex-wrap items-center gap-3 text-xs text-slate-500">
                    <span className="text-teal-500">{i.issue_type}</span>
                    <span>•</span>
                    <span className="flex items-center gap-1">
                      <MapPin className="w-3.5 h-3.5 text-slate-500" />
                      {i.address || 'GPS Mapped'}
                    </span>
                    <span>•</span>
                    <span>Filed: {new Date(i.created_at).toLocaleDateString()}</span>
                  </div>
                </div>

                <div className="w-full md:w-44 space-y-1">
                  <div className="flex justify-between text-xs text-slate-500">
                    <span>Progress</span>
                    <span className="font-mono text-teal-600">{i.progress_percentage || 0}%</span>
                  </div>
                  <div className="h-2 bg-sky-50 rounded-full overflow-hidden border border-slate-200">
                    <div
                      className="h-full bg-gradient-to-r from-cyan-500 to-emerald-400 rounded-full"
                      style={{ width: `${i.progress_percentage || 0}%` }}
                    />
                  </div>
                </div>

                <div className="flex items-center gap-3 text-xs font-semibold shrink-0">
                  <Link
                    to={`/issue/${i.id}`}
                    className="px-3.5 py-2 rounded-xl bg-sky-50 hover:bg-slate-100 text-teal-600 border border-slate-200 transition-colors"
                  >
                    View Details
                  </Link>
                  <Link
                    to={`/issue/${i.id}/track`}
                    className="px-3.5 py-2 rounded-xl bg-emerald-500/20 hover:bg-emerald-500/30 text-emerald-300 border border-emerald-500/40 transition-colors"
                  >
                    Track Live
                  </Link>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};
