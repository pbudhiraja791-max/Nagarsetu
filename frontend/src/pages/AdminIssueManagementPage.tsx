import React, { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { issueService, departmentService } from '../services/api';
import { Issue, Department, IssueStatus, IssueType } from '../types';
import { PriorityBadge } from '../components/common/PriorityBadge';
import { StatusBadge } from '../components/common/StatusBadge';
import { Search, Filter, Shield, Eye, Building2, RefreshCw, Users, Clock, AlertTriangle, Layers, ArrowUpDown, CheckCircle } from 'lucide-react';

export const AdminIssueManagementPage: React.FC = () => {
  const [issues, setIssues] = useState<Issue[]>([]);
  const [departments, setDepartments] = useState<Department[]>([]);
  const [loading, setLoading] = useState(true);

  // Filters
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState<string>('ALL');
  const [typeFilter, setTypeFilter] = useState<string>('ALL');
  const [sortBy, setSortBy] = useState<string>('PRIORITY_DESC');
  const [multiReportOnly, setMultiReportOnly] = useState(false);

  const fetchIssues = async () => {
    setLoading(true);
    try {
      const data = await issueService.listIssues({
        search: search.trim() || undefined,
        status_filter: statusFilter !== 'ALL' ? statusFilter : undefined,
        type_filter: typeFilter !== 'ALL' ? typeFilter : undefined,
      });
      setIssues(data || []);
    } catch (err) {
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchIssues();
    departmentService.listDepartments().then(setDepartments).catch(console.error);
  }, []);

  const now = new Date().getTime();

  // Filter & Sort issues
  let displayedIssues = [...issues];

  if (multiReportOnly) {
    displayedIssues = displayedIssues.filter((i) => (i.total_reports || 1) > 1);
  }

  displayedIssues.sort((a, b) => {
    if (sortBy === 'PRIORITY_DESC') {
      return (b.priority_score || 0) - (a.priority_score || 0);
    } else if (sortBy === 'SEVERITY_DESC') {
      return (b.severity_score || 0) - (a.severity_score || 0);
    } else if (sortBy === 'REPORTS_DESC') {
      return (b.total_reports || 1) - (a.total_reports || 1);
    } else if (sortBy === 'CITIZENS_DESC') {
      return (b.unique_citizens || 1) - (a.unique_citizens || 1);
    } else if (sortBy === 'NEWEST') {
      return new Date(b.created_at).getTime() - new Date(a.created_at).getTime();
    } else if (sortBy === 'OLDEST') {
      return new Date(a.created_at).getTime() - new Date(b.created_at).getTime();
    }
    return 0;
  });

  return (
    <div className="min-h-screen bg-sky-50 text-slate-900 py-8 px-4 sm:px-6 lg:px-8 font-sans">
      <div className="max-w-7xl mx-auto space-y-6">
        <div className="flex flex-wrap items-center justify-between gap-4">
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-purple-50/70 border border-purple-200 text-purple-300 text-xs font-semibold mb-2">
              <Shield className="w-3.5 h-3.5 text-purple-400" /> NAGARSETU MUNICIPAL COMMAND
            </div>
            <h1 className="text-3xl font-extrabold text-white tracking-tight">
              Municipal Complaint Oversight & SLA Management
            </h1>
            <p className="text-slate-500 text-sm mt-1">
              Audit priority scores, inspect multi-report duplicate clusters, monitor department response times, and resolve ground escalations.
            </p>
          </div>

          <div className="flex items-center gap-3">
            <Link
              to="/admin"
              className="px-4 py-2.5 rounded-xl bg-purple-900/60 hover:bg-purple-800 text-purple-200 border border-purple-700 text-xs font-bold flex items-center gap-2 transition-colors"
            >
              <Layers className="w-4 h-4" /> AI Command Hub & Queues
            </Link>
          </div>
        </div>

        {/* Filter Bar */}
        <div className="p-4 rounded-2xl bg-white border border-slate-200 flex flex-wrap items-center justify-between gap-4">
          <div className="flex flex-wrap items-center gap-3 flex-1">
            <div className="relative flex-1 min-w-[200px]">
              <Search className="w-4 h-4 text-slate-500 absolute left-3 top-2.5" />
              <input
                type="text"
                placeholder="Search display ID, title, landmark, address..."
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                onKeyDown={(e) => e.key === 'Enter' && fetchIssues()}
                className="w-full bg-sky-50 border border-slate-200 rounded-xl pl-9 pr-3 py-2 text-xs text-white focus:outline-none focus:border-cyan-500"
              />
            </div>

            <select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
              className="bg-sky-50 border border-slate-200 rounded-xl px-3 py-2 text-xs text-white focus:outline-none focus:border-cyan-500"
            >
              <option value="ALL">All Statuses</option>
              {Object.values(IssueStatus).map((s) => (
                <option key={s} value={s}>{s.replace(/_/g, ' ')}</option>
              ))}
            </select>

            <select
              value={typeFilter}
              onChange={(e) => setTypeFilter(e.target.value)}
              className="bg-sky-50 border border-slate-200 rounded-xl px-3 py-2 text-xs text-white focus:outline-none focus:border-cyan-500"
            >
              <option value="ALL">All AI Categories</option>
              {Object.values(IssueType).map((t) => (
                <option key={t} value={t}>{t}</option>
              ))}
            </select>

            <div className="flex items-center gap-1.5 bg-sky-50 border border-slate-200 rounded-xl px-3 py-1.5 text-xs text-slate-600">
              <ArrowUpDown className="w-3.5 h-3.5 text-slate-500" />
              <select
                value={sortBy}
                onChange={(e) => setSortBy(e.target.value)}
                className="bg-transparent text-xs text-white focus:outline-none cursor-pointer"
              >
                <option value="PRIORITY_DESC" className="bg-sky-50">Highest Priority</option>
                <option value="SEVERITY_DESC" className="bg-sky-50">Highest Severity</option>
                <option value="REPORTS_DESC" className="bg-sky-50">Most Citizen Reports</option>
                <option value="CITIZENS_DESC" className="bg-sky-50">Most Unique Citizens</option>
                <option value="NEWEST" className="bg-sky-50">Newest First</option>
                <option value="OLDEST" className="bg-sky-50">Oldest First</option>
              </select>
            </div>

            <label className="flex items-center gap-2 cursor-pointer bg-sky-50 border border-slate-200 rounded-xl px-3 py-2 text-xs text-slate-600 select-none">
              <input
                type="checkbox"
                checked={multiReportOnly}
                onChange={(e) => setMultiReportOnly(e.target.checked)}
                className="rounded accent-cyan-500"
              />
              <span>Multi-Report Issues ({'>'}1)</span>
            </label>

            <button
              onClick={fetchIssues}
              className="px-4 py-2 bg-purple-600 hover:bg-purple-500 text-white rounded-xl text-xs font-semibold flex items-center gap-1.5 transition-colors"
            >
              <RefreshCw className={`w-3.5 h-3.5 ${loading ? 'animate-spin' : ''}`} /> Apply Filters
            </button>
          </div>
        </div>

        {/* Issues Management Table */}
        <div className="rounded-2xl border border-slate-200 bg-white overflow-hidden shadow-xl">
          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm">
              <thead className="bg-sky-50 text-xs uppercase font-semibold text-slate-500 border-b border-slate-200">
                <tr>
                  <th className="py-3.5 px-4">Display ID & Category</th>
                  <th className="py-3.5 px-4">Title & Address</th>
                  <th className="py-3.5 px-4">Citizen Reports</th>
                  <th className="py-3.5 px-4">Severity & Priority</th>
                  <th className="py-3.5 px-4">Department & SLA</th>
                  <th className="py-3.5 px-4">Status</th>
                  <th className="py-3.5 px-4 text-right">Audit</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-800/80 text-slate-700">
                {loading ? (
                  <tr>
                    <td colSpan={7} className="text-center py-12 text-slate-500">Loading complaints...</td>
                  </tr>
                ) : displayedIssues.length === 0 ? (
                  <tr>
                    <td colSpan={7} className="text-center py-12 text-slate-500">No complaints found matching criteria.</td>
                  </tr>
                ) : (
                  displayedIssues.map((issue) => {
                    const isOverdue =
                      issue.sla_deadline &&
                      new Date(issue.sla_deadline).getTime() < now &&
                      issue.status !== IssueStatus.RESOLVED &&
                      issue.status !== IssueStatus.CLOSED;

                    const displayId = issue.display_id || `NG-${issue.id}`;
                    const totalReps = issue.total_reports || (issue as any).report_count || 1;
                    const uniqueCits = issue.unique_citizens || (issue as any).unique_reporters || 1;

                    return (
                      <tr key={issue.id} className="hover:bg-slate-50/50 transition-colors">
                        <td className="py-3.5 px-4">
                          <div className="text-xs font-bold text-teal-500 font-mono flex items-center gap-1.5">
                            {displayId}
                          </div>
                          <div className="text-[11px] text-slate-500 font-medium">{issue.issue_type}</div>
                        </td>

                        <td className="py-3.5 px-4 max-w-xs">
                          <div className="font-semibold text-white truncate">{issue.title}</div>
                          <div className="text-xs text-slate-500 truncate flex items-center gap-1">
                            {issue.address || `GPS (${issue.latitude}, ${issue.longitude})`}
                          </div>
                          {issue.summary && (
                            <div className="text-[10px] text-slate-500 truncate italic mt-0.5">
                              {issue.summary}
                            </div>
                          )}
                        </td>

                        <td className="py-3.5 px-4">
                          <div className="flex items-center gap-1.5">
                            <span className={`text-xs font-extrabold font-mono px-2 py-0.5 rounded ${
                              totalReps > 1 ? 'bg-teal-50 text-teal-600 border border-teal-200' : 'bg-slate-100 text-slate-600'
                            }`}>
                              {totalReps} {totalReps === 1 ? 'report' : 'reports'}
                            </span>
                          </div>
                          <div className="text-[10px] text-slate-500 mt-0.5">
                            {uniqueCits} unique {uniqueCits === 1 ? 'citizen' : 'citizens'}
                          </div>
                        </td>

                        <td className="py-3.5 px-4">
                          <div className="space-y-1">
                            <div className="flex items-center gap-1.5">
                              <span className="text-[10px] text-slate-500 font-medium">Sev:</span>
                              <span className={`text-xs font-mono font-bold ${
                                (issue.severity_score || 0) >= 76 ? 'text-red-500' :
                                (issue.severity_score || 0) >= 51 ? 'text-amber-400' :
                                'text-teal-500'
                              }`}>
                                {issue.severity_score || issue.severity || 50}/100
                              </span>
                            </div>
                            <PriorityBadge score={issue.priority_score} severity={issue.severity} />
                          </div>
                        </td>

                        <td className="py-3.5 px-4">
                          <div className="text-xs font-semibold text-purple-300 truncate">
                            {issue.assigned_department || (issue.department ? issue.department.name : 'Route Pending')}
                          </div>
                          {isOverdue && (
                            <div className="text-[10px] text-red-500 font-bold bg-red-50/60 px-1.5 py-0.5 rounded border border-red-200 w-fit mt-0.5">
                              SLA Overdue
                            </div>
                          )}
                        </td>

                        <td className="py-3.5 px-4">
                          <div className="space-y-1">
                            <StatusBadge status={issue.status} />
                            {issue.resolution_image_path && (
                              <div className="text-[10px] text-emerald-400 font-medium">✓ Proof Uploaded</div>
                            )}
                          </div>
                        </td>

                        <td className="py-3.5 px-4 text-right">
                          <Link
                            to={`/issue/${issue.id}`}
                            className="inline-flex items-center gap-1 px-3 py-1.5 rounded-lg bg-sky-50 hover:bg-slate-100 text-teal-500 text-xs font-semibold border border-slate-200 transition-colors"
                          >
                            Audit <Eye className="w-3.5 h-3.5" />
                          </Link>
                        </td>
                      </tr>
                    );
                  })
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
};
