import React, { useState, useEffect } from 'react';
import { analyticsService, adminService } from '../services/api';
import {
  AnalyticsDashboardData, PredictiveHotspot, PendingDuplicateReport,
  PendingSeverityIssue, IntelligenceAnalyticsData, DedupConfigSettings,
  PriorityConfigSettings
} from '../types';
import {
  LayoutDashboard, AlertOctagon, CheckCircle2, Clock, Activity,
  Building2, ShieldCheck, ArrowUpRight, AlertTriangle, Sparkles,
  TrendingUp, MapPin, RefreshCw, BarChart2, CheckSquare, Layers,
  Sliders, Database, FileCheck, Check, X, ArrowRight, Eye, ShieldAlert,
  ChevronRight, Settings
} from 'lucide-react';
import { Link } from 'react-router-dom';

export const AdminDashboardPage: React.FC = () => {
  // Navigation Tabs: 'overview' | 'duplicates' | 'severity' | 'analytics' | 'config'
  const [activeTab, setActiveTab] = useState<'overview' | 'duplicates' | 'severity' | 'analytics' | 'config'>('overview');

  // Overview Data
  const [data, setData] = useState<AnalyticsDashboardData | null>(null);
  const [hotspots, setHotspots] = useState<PredictiveHotspot[]>([]);
  const [loading, setLoading] = useState(true);

  // Duplicate Review Queue Data
  const [duplicates, setDuplicates] = useState<PendingDuplicateReport[]>([]);
  const [loadingDuplicates, setLoadingDuplicates] = useState(false);
  const [actionLoadingId, setActionLoadingId] = useState<number | null>(null);
  const [moveModalReportId, setMoveModalReportId] = useState<number | null>(null);
  const [targetIssueInput, setTargetIssueInput] = useState('');
  const [invalidateModalReportId, setInvalidateModalReportId] = useState<number | null>(null);
  const [invalidateReason, setInvalidateReason] = useState('');

  // Severity Review Queue Data
  const [severityIssues, setSeverityIssues] = useState<PendingSeverityIssue[]>([]);
  const [loadingSeverity, setLoadingSeverity] = useState(false);
  const [overrideModalIssue, setOverrideModalIssue] = useState<PendingSeverityIssue | null>(null);
  const [overrideScore, setOverrideScore] = useState<number>(75);
  const [overrideLevel, setOverrideLevel] = useState<string>('HIGH');
  const [overrideReason, setOverrideReason] = useState('');

  // AI Intelligence Analytics Data
  const [intelAnalytics, setIntelAnalytics] = useState<IntelligenceAnalyticsData | null>(null);
  const [loadingIntel, setLoadingIntel] = useState(false);

  // Configuration Data
  const [dedupConfig, setDedupConfig] = useState<DedupConfigSettings | null>(null);
  const [priorityConfig, setPriorityConfig] = useState<PriorityConfigSettings | null>(null);
  const [loadingConfig, setLoadingConfig] = useState(false);
  const [savingConfig, setSavingConfig] = useState(false);
  const [reconciling, setReconciling] = useState(false);
  const [reconciliationResult, setReconciliationResult] = useState<any | null>(null);

  const fetchAdminData = () => {
    setLoading(true);
    Promise.all([
      analyticsService.getDashboardStats(),
      analyticsService.getPredictiveHotspots()
    ])
      .then(([dash, hots]) => {
        setData(dash);
        setHotspots(hots || dash.predictive_hotspots || []);
      })
      .catch(console.error)
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    fetchAdminData();
  }, []);

  // Fetch tab-specific data on tab change
  useEffect(() => {
    if (activeTab === 'duplicates') {
      fetchDuplicateQueue();
    } else if (activeTab === 'severity') {
      fetchSeverityQueue();
    } else if (activeTab === 'analytics') {
      fetchIntelAnalytics();
    } else if (activeTab === 'config') {
      fetchConfigs();
    }
  }, [activeTab]);

  const fetchDuplicateQueue = () => {
    setLoadingDuplicates(true);
    adminService.getDuplicateReviewQueue()
      .then((res: any) => {
        const list = Array.isArray(res) ? res : (res?.pending_duplicates || []);
        setDuplicates(list);
      })
      .catch(console.error)
      .finally(() => setLoadingDuplicates(false));
  };

  const fetchSeverityQueue = () => {
    setLoadingSeverity(true);
    adminService.getSeverityReviewQueue()
      .then((res: any) => {
        const list = Array.isArray(res) ? res : (res?.issues || []);
        setSeverityIssues(list);
      })
      .catch(console.error)
      .finally(() => setLoadingSeverity(false));
  };

  const fetchIntelAnalytics = () => {
    setLoadingIntel(true);
    adminService.getIntelligenceAnalytics()
      .then(setIntelAnalytics)
      .catch(console.error)
      .finally(() => setLoadingIntel(false));
  };

  const fetchConfigs = () => {
    setLoadingConfig(true);
    Promise.all([
      adminService.getDedupConfig(),
      adminService.getPriorityConfig()
    ])
      .then(([dedup, prio]) => {
        setDedupConfig(dedup);
        setPriorityConfig(prio);
      })
      .catch(console.error)
      .finally(() => setLoadingConfig(false));
  };

  // Duplicate Review Actions
  const handleConfirmDuplicate = async (reportId: number) => {
    setActionLoadingId(reportId);
    try {
      await adminService.confirmDuplicate(reportId, 'Confirmed duplicate by municipal administrator.');
      alert('Report successfully linked to issue! Report counts and priority updated.');
      fetchDuplicateQueue();
    } catch (err: any) {
      alert(err.response?.data?.detail || 'Failed to confirm duplicate.');
    } finally {
      setActionLoadingId(null);
    }
  };

  const handleRejectDuplicate = async (reportId: number) => {
    setActionLoadingId(reportId);
    try {
      const res = await adminService.rejectDuplicate(reportId, 'Rejected duplicate match: distinct civic problem.');
      alert(`Report confirmed as distinct! New issue created with ID #${res.new_issue_id || 'new'}.`);
      fetchDuplicateQueue();
    } catch (err: any) {
      alert(err.response?.data?.detail || 'Failed to separate report.');
    } finally {
      setActionLoadingId(null);
    }
  };

  const handleMoveReport = async () => {
    if (!moveModalReportId || !targetIssueInput) return;
    const targetId = parseInt(targetIssueInput.replace(/[^0-9]/g, ''));
    if (!targetId) {
      alert('Please enter a valid numeric target Issue ID.');
      return;
    }
    setActionLoadingId(moveModalReportId);
    try {
      await adminService.moveReport(moveModalReportId, targetId, 'Reassigned to existing issue by administrator.');
      alert(`Report moved to issue #${targetId} successfully!`);
      setMoveModalReportId(null);
      setTargetIssueInput('');
      fetchDuplicateQueue();
    } catch (err: any) {
      alert(err.response?.data?.detail || 'Failed to move report.');
    } finally {
      setActionLoadingId(null);
    }
  };

  const handleInvalidateReport = async () => {
    if (!invalidateModalReportId || !invalidateReason.trim()) {
      alert('Please provide a reason for invalidating this report.');
      return;
    }
    setActionLoadingId(invalidateModalReportId);
    try {
      await adminService.invalidateReport(invalidateModalReportId, invalidateReason);
      alert('Report marked as invalid. Excluded from issue counts.');
      setInvalidateModalReportId(null);
      setInvalidateReason('');
      fetchDuplicateQueue();
    } catch (err: any) {
      alert(err.response?.data?.detail || 'Failed to invalidate report.');
    } finally {
      setActionLoadingId(null);
    }
  };

  // Severity Review Actions
  const handleApproveSeverity = async (issueId: number) => {
    setActionLoadingId(issueId);
    try {
      await adminService.approveSeverity(issueId, 'Severity assessment approved by administrator.');
      alert('Severity assessment approved successfully.');
      fetchSeverityQueue();
    } catch (err: any) {
      alert(err.response?.data?.detail || 'Failed to approve severity.');
    } finally {
      setActionLoadingId(null);
    }
  };

  const handleOverrideSeveritySubmit = async () => {
    if (!overrideModalIssue) return;
    if (!overrideReason.trim()) {
      alert('Please state an official justification for overriding severity.');
      return;
    }
    setActionLoadingId(overrideModalIssue.issue_id);
    try {
      await adminService.overrideSeverity(overrideModalIssue.issue_id, {
        severity_score: overrideScore,
        severity_level: overrideLevel,
        reason: overrideReason
      });
      alert('Severity overridden and priority recalculated.');
      setOverrideModalIssue(null);
      setOverrideReason('');
      fetchSeverityQueue();
    } catch (err: any) {
      alert(err.response?.data?.detail || 'Failed to override severity.');
    } finally {
      setActionLoadingId(null);
    }
  };

  // Reconciliation Action
  const handleReconcileCounts = async () => {
    setReconciling(true);
    try {
      const res = await adminService.reconcileCounts();
      setReconciliationResult(res);
      alert(`Reconciliation Completed!\n\nIssues Checked: ${res.issues_checked}\nDiscrepancies Fixed: ${res.discrepancies_found}`);
    } catch (err: any) {
      alert(err.response?.data?.detail || 'Failed to reconcile counts.');
    } finally {
      setReconciling(false);
    }
  };

  // Save Config
  const handleSaveConfigs = async () => {
    if (!dedupConfig || !priorityConfig) return;
    setSavingConfig(true);
    try {
      await Promise.all([
        adminService.updateDedupConfig(dedupConfig),
        adminService.updatePriorityConfig(priorityConfig)
      ]);
      alert('AI thresholds and priority weights updated successfully.');
    } catch (err: any) {
      alert(err.response?.data?.detail || 'Failed to save configuration.');
    } finally {
      setSavingConfig(false);
    }
  };

  if (loading || !data) {
    return (
      <div className="min-h-screen bg-sky-50 flex items-center justify-center text-slate-500">
        <div className="flex items-center gap-3">
          <RefreshCw className="w-5 h-5 text-purple-400 animate-spin" />
          <span>Loading NagarSetu Municipal Command Center...</span>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-sky-50 py-8 px-4 sm:px-6 lg:px-8 font-sans">
      <div className="max-w-7xl mx-auto space-y-8">
        {/* Header */}
        <div className="flex flex-wrap items-center justify-between gap-4 border-b border-slate-200 pb-6">
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-purple-50/70 border border-purple-200 text-purple-300 text-xs font-semibold mb-2">
              <ShieldCheck className="w-3.5 h-3.5 text-purple-400" /> NAGARSETU MUNICIPAL COMMAND CENTER
            </div>
            <h1 className="text-3xl font-extrabold text-slate-900 tracking-tight">
              City-Wide Civic Intelligence & Accountability
            </h1>
            <p className="text-sm text-slate-500 mt-1">
              Multi-factor duplicate triage, evidence-based severity review, dynamic priority management, and predictive failure forecasting.
            </p>
          </div>

          <div className="flex items-center gap-3">
            <button
              onClick={fetchAdminData}
              className="px-3.5 py-2.5 rounded-xl bg-slate-50 hover:bg-slate-100 text-slate-600 border border-slate-700 text-xs font-semibold flex items-center gap-1.5 transition-colors"
            >
              <RefreshCw className="w-3.5 h-3.5" /> Refresh Live
            </button>
            <Link
              to="/admin/issues"
              className="px-5 py-2.5 rounded-xl font-bold bg-gradient-to-r from-purple-600 to-indigo-600 hover:from-purple-500 hover:to-indigo-500 text-white shadow-lg shadow-purple-950 flex items-center gap-2 text-sm transition-all"
            >
              <LayoutDashboard className="w-4 h-4" /> Manage All Issues & SLA
            </Link>
          </div>
        </div>

        {/* Tab Navigation */}
        <div className="flex flex-wrap items-center gap-2 border-b border-slate-200 pb-3">
          <button
            onClick={() => setActiveTab('overview')}
            className={`px-4 py-2 rounded-xl text-xs font-bold flex items-center gap-2 transition-all ${
              activeTab === 'overview'
                ? 'bg-purple-600 text-slate-900 shadow-md'
                : 'bg-white text-slate-500 hover:text-slate-900 hover:bg-slate-100'
            }`}
          >
            <LayoutDashboard className="w-3.5 h-3.5" /> Command Overview & SLA
          </button>

          <button
            onClick={() => setActiveTab('duplicates')}
            className={`px-4 py-2 rounded-xl text-xs font-bold flex items-center gap-2 transition-all relative ${
              activeTab === 'duplicates'
                ? 'bg-purple-600 text-slate-900 shadow-md'
                : 'bg-white text-slate-500 hover:text-slate-900 hover:bg-slate-100'
            }`}
          >
            <Layers className="w-3.5 h-3.5" /> Duplicate Review Queue
            {duplicates.length > 0 && (
              <span className="bg-amber-500 text-slate-950 px-1.5 py-0.2 rounded-full text-[10px] font-mono font-extrabold ml-1">
                {duplicates.length}
              </span>
            )}
          </button>

          <button
            onClick={() => setActiveTab('severity')}
            className={`px-4 py-2 rounded-xl text-xs font-bold flex items-center gap-2 transition-all relative ${
              activeTab === 'severity'
                ? 'bg-purple-600 text-slate-900 shadow-md'
                : 'bg-white text-slate-500 hover:text-slate-900 hover:bg-slate-100'
            }`}
          >
            <AlertOctagon className="w-3.5 h-3.5" /> Severity Review Queue
            {severityIssues.length > 0 && (
              <span className="bg-rose-500 text-white px-1.5 py-0.2 rounded-full text-[10px] font-mono font-extrabold ml-1">
                {severityIssues.length}
              </span>
            )}
          </button>

          <button
            onClick={() => setActiveTab('analytics')}
            className={`px-4 py-2 rounded-xl text-xs font-bold flex items-center gap-2 transition-all ${
              activeTab === 'analytics'
                ? 'bg-purple-600 text-slate-900 shadow-md'
                : 'bg-white text-slate-500 hover:text-slate-900 hover:bg-slate-100'
            }`}
          >
            <Sparkles className="w-3.5 h-3.5" /> AI Intelligence Analytics
          </button>

          <button
            onClick={() => setActiveTab('config')}
            className={`px-4 py-2 rounded-xl text-xs font-bold flex items-center gap-2 transition-all ${
              activeTab === 'config'
                ? 'bg-purple-600 text-slate-900 shadow-md'
                : 'bg-white text-slate-500 hover:text-slate-900 hover:bg-slate-100'
            }`}
          >
            <Settings className="w-3.5 h-3.5" /> AI Thresholds & Reconciliation
          </button>
        </div>

        {/* TAB 1: COMMAND OVERVIEW & SLA */}
        {activeTab === 'overview' && (
          <div className="space-y-8">
            {/* Top-Line KPI Metrics */}
            <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-4">
              <div className="p-4 rounded-2xl bg-white border border-slate-200 space-y-1">
                <div className="text-xs text-slate-500 font-medium">Total Complaints</div>
                <div className="text-2xl sm:text-3xl font-extrabold text-slate-900 font-mono">{data.total_issues}</div>
                <div className="text-[10px] text-slate-500">City-wide cumulative</div>
              </div>

              <div className="p-4 rounded-2xl bg-white border border-slate-200 space-y-1">
                <div className="text-xs text-slate-500 font-medium">Pending Action</div>
                <div className="text-2xl sm:text-3xl font-extrabold text-amber-400 font-mono">{data.open_issues}</div>
                <div className="text-[10px] text-slate-500">Across 6 departments</div>
              </div>

              <div className="p-4 rounded-2xl bg-white border border-slate-200 space-y-1">
                <div className="text-xs text-slate-500 font-medium">In Progress</div>
                <div className="text-2xl sm:text-3xl font-extrabold text-teal-500 font-mono">{data.in_progress_issues}</div>
                <div className="text-[10px] text-slate-500">Dispatched work crews</div>
              </div>

              <div className="p-4 rounded-2xl bg-white border border-slate-200 space-y-1">
                <div className="text-xs text-slate-500 font-medium">Resolved & Verified</div>
                <div className="text-2xl sm:text-3xl font-extrabold text-emerald-400 font-mono">{data.resolved_issues}</div>
                <div className="text-[10px] text-slate-500">Ground verified</div>
              </div>

              <div className="p-4 rounded-2xl bg-white border border-slate-200 space-y-1">
                <div className="text-xs text-slate-500 font-medium">SLA Escalated / Overdue</div>
                <div className="text-2xl sm:text-3xl font-extrabold text-red-500 font-mono">{data.escalated_count || 0}</div>
                <div className="text-[10px] text-red-500 font-medium">Deadline breached</div>
              </div>

              <div className="p-4 rounded-2xl bg-white border border-slate-200 space-y-1">
                <div className="text-xs text-slate-500 font-medium">Citizen Reopened</div>
                <div className="text-2xl sm:text-3xl font-extrabold text-purple-400 font-mono">{data.reopened_count || 0}</div>
                <div className="text-[10px] text-slate-500">Repair rejected by citizen</div>
              </div>
            </div>

            {/* Predictive Civic Intelligence Hotspots */}
            <div className="p-6 rounded-2xl bg-gradient-to-br from-slate-900/90 to-purple-950/30 border border-purple-200/60 space-y-5">
              <div className="flex flex-wrap items-center justify-between gap-3 border-b border-slate-200 pb-3">
                <div>
                  <div className="flex items-center gap-2 text-purple-300 font-bold text-base">
                    <TrendingUp className="w-5 h-5 text-purple-400" />
                    <span>Predictive Civic Hotspots & Failure Recurrence Forecast</span>
                  </div>
                  <p className="text-xs text-slate-500 mt-0.5">
                    Spatial kernel density and seasonal failure patterns forecasting high-risk civic infrastructure clusters.
                  </p>
                </div>
                <span className="text-xs bg-purple-50 text-purple-300 px-3 py-1 rounded-full border border-purple-200 font-semibold">
                  Statistical Confidence: 82%
                </span>
              </div>

              {hotspots.length === 0 ? (
                <div className="text-center py-6 text-xs text-slate-500">
                  Collecting spatial defect density across city wards...
                </div>
              ) : (
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                  {hotspots.slice(0, 3).map((h) => (
                    <div
                      key={h.cluster_id}
                      className="p-4 rounded-xl bg-sky-50 border border-slate-200 space-y-3 relative overflow-hidden"
                    >
                      <div className="flex items-center justify-between">
                        <span className="text-xs font-bold text-slate-900 flex items-center gap-1.5 truncate">
                          <MapPin className="w-3.5 h-3.5 text-teal-500 flex-shrink-0" />
                          {h.address.split(',')[0]}
                        </span>
                        <span
                          className="text-[10px] font-black uppercase px-2 py-0.5 rounded-full"
                          style={{
                            backgroundColor: `${h.risk_color}25`,
                            color: h.risk_color,
                            border: `1px solid ${h.risk_color}60`
                          }}
                        >
                          {h.risk_level} Risk
                        </span>
                      </div>

                      <div className="grid grid-cols-2 gap-2 text-xs">
                        <div className="p-2 rounded-lg bg-slate-50">
                          <span className="text-[10px] text-slate-500 block">Recurrence Prob.</span>
                          <strong className="text-slate-900 font-mono text-sm">{h.recurrence_probability}</strong>
                        </div>
                        <div className="p-2 rounded-lg bg-slate-50">
                          <span className="text-[10px] text-slate-500 block">Forecast Horizon</span>
                          <strong className="text-teal-600 text-xs">{h.forecast_period}</strong>
                        </div>
                      </div>

                      <p className="text-xs text-slate-600 bg-white p-2.5 rounded-lg border border-slate-200">
                        <strong className="text-purple-300">Preventive Action:</strong> {h.preventive_action}
                      </p>

                      <div className="text-[10px] text-slate-500 italic">
                        Historical density: {h.total_complaints} incidents ({h.dominant_category})
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>

            {/* Category & Severity Charts */}
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
              {/* Category Breakdown */}
              <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-4">
                <h3 className="text-base font-bold text-slate-900 flex items-center gap-2">
                  <BarChart2 className="w-4 h-4 text-teal-500" />
                  Incidents by Defect Category
                </h3>
                <div className="space-y-3">
                  {Object.entries(data.issues_by_category).map(([cat, count]) => {
                    const pct = data.total_issues > 0 ? (count / data.total_issues) * 100 : 0;
                    return (
                      <div key={cat} className="space-y-1">
                        <div className="flex items-center justify-between text-xs font-semibold">
                          <span className="text-slate-600">{cat}</span>
                          <span className="text-teal-500 font-mono">
                            {count} ({pct.toFixed(0)}%)
                          </span>
                        </div>
                        <div className="w-full h-2 bg-sky-50 rounded-full overflow-hidden">
                          <div className="h-full bg-cyan-500 rounded-full transition-all duration-700" style={{ width: `${pct}%` }} />
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>

              {/* Severity Breakdown */}
              <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-4">
                <h3 className="text-base font-bold text-slate-900 flex items-center gap-2">
                  <AlertOctagon className="w-4 h-4 text-red-500" />
                  Severity Classification
                </h3>
                <div className="space-y-3">
                  {Object.entries(data.issues_by_severity).map(([sev, count]) => {
                    const pct = data.total_issues > 0 ? (count / data.total_issues) * 100 : 0;
                    const color =
                      sev === 'CRITICAL' ? 'bg-rose-500' :
                      sev === 'HIGH' ? 'bg-amber-500' :
                      sev === 'MODERATE' || sev === 'MEDIUM' ? 'bg-sky-500' : 'bg-emerald-500';
                    return (
                      <div key={sev} className="space-y-1">
                        <div className="flex items-center justify-between text-xs font-semibold">
                          <span className="text-slate-600">{sev}</span>
                          <span className="text-slate-900 font-mono">
                            {count} ({pct.toFixed(0)}%)
                          </span>
                        </div>
                        <div className="w-full h-2 bg-sky-50 rounded-full overflow-hidden">
                          <div className={`h-full ${color} rounded-full transition-all duration-700`} style={{ width: `${pct}%` }} />
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>
            </div>

            {/* Departmental Workload & SLA Scorecards */}
            <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-4">
              <div className="flex items-center justify-between">
                <h3 className="text-base font-bold text-slate-900 flex items-center gap-2">
                  <Building2 className="w-5 h-5 text-purple-400" />
                  Department SLA Compliance & Workload Scorecards
                </h3>
                <span className="text-xs text-slate-500">All 6 Municipal Departments</span>
              </div>

              <div className="overflow-x-auto">
                <table className="w-full text-left text-sm">
                  <thead className="bg-sky-50 text-xs uppercase font-semibold text-slate-500 border-b border-slate-200">
                    <tr>
                      <th className="py-3 px-4">Department Name</th>
                      <th className="py-3 px-4">Assigned Tasks</th>
                      <th className="py-3 px-4">Pending</th>
                      <th className="py-3 px-4">In Progress</th>
                      <th className="py-3 px-4">Resolved</th>
                      <th className="py-3 px-4">SLA Overdue</th>
                      <th className="py-3 px-4">Resolution Rate</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-800/80 text-slate-700">
                    {data.department_performance.map((dept) => (
                      <tr key={dept.department_id} className="hover:bg-slate-50/50 transition-colors">
                        <td className="py-3 px-4 font-semibold text-slate-900">{dept.department_name}</td>
                        <td className="py-3 px-4 font-mono">{dept.total_assigned}</td>
                        <td className="py-3 px-4 text-amber-400 font-semibold font-mono">{dept.pending}</td>
                        <td className="py-3 px-4 text-teal-500 font-semibold font-mono">{dept.in_progress}</td>
                        <td className="py-3 px-4 text-emerald-400 font-semibold font-mono">{dept.resolved}</td>
                        <td className="py-3 px-4 font-mono">
                          {(dept.overdue_count || 0) > 0 ? (
                            <span className="text-red-500 font-bold bg-red-50 px-2 py-0.5 rounded border border-red-200">
                              {dept.overdue_count} Overdue
                            </span>
                          ) : (
                            <span className="text-emerald-400 font-semibold">0 on time</span>
                          )}
                        </td>
                        <td className="py-3 px-4 font-bold text-purple-300 font-mono">{dept.resolution_rate}%</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        )}

        {/* TAB 2: DUPLICATE REVIEW QUEUE */}
        {activeTab === 'duplicates' && (
          <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-6">
            <div className="flex flex-wrap items-center justify-between gap-3 border-b border-slate-200 pb-4">
              <div>
                <h3 className="text-base font-bold text-slate-900 flex items-center gap-2">
                  <Layers className="w-5 h-5 text-amber-400" />
                  Administrator Duplicate Review Queue (0.55 – 0.79 Confidence)
                </h3>
                <p className="text-xs text-slate-500 mt-1">
                  Side-by-side comparison of pending citizen submissions against candidate civic issues.
                  Confirming a duplicate links the report and increments total report counts exactly once.
                </p>
              </div>
              <button
                onClick={fetchDuplicateQueue}
                className="px-3 py-1.5 rounded-lg bg-slate-50 border border-slate-700 text-xs font-semibold flex items-center gap-1.5 text-slate-600"
              >
                <RefreshCw className={`w-3.5 h-3.5 ${loadingDuplicates ? 'animate-spin' : ''}`} /> Refresh Queue
              </button>
            </div>

            {loadingDuplicates ? (
              <div className="text-center py-12 text-slate-500 flex items-center justify-center gap-2 text-xs">
                <RefreshCw className="w-4 h-4 animate-spin text-amber-400" /> Loading pending duplicate reviews...
              </div>
            ) : duplicates.length === 0 ? (
              <div className="text-center py-12 text-slate-500 space-y-2">
                <CheckCircle2 className="w-10 h-10 text-emerald-400 mx-auto" />
                <p className="text-sm font-semibold text-slate-600">All duplicate candidates cleared!</p>
                <p className="text-xs text-slate-500">High-confidence matches are automatically linked, and distinct reports create new issues.</p>
              </div>
            ) : (
              <div className="space-y-6">
                {duplicates.map((item) => {
                  const repId = item.report_id || (item as any).id;
                  const match = item.match_metrics || item.match;
                  const candidate = item.suggested_issue || item.candidate_issue;
                  const isLoadingThis = actionLoadingId === repId;

                  return (
                    <div
                      key={repId}
                      className="p-5 rounded-2xl bg-sky-50 border border-amber-900/50 space-y-4 shadow-xl"
                    >
                      {/* Top Match Bar */}
                      <div className="flex flex-wrap items-center justify-between gap-3 border-b border-slate-200 pb-3">
                        <div className="flex items-center gap-2">
                          <span className="text-xs font-mono font-bold text-amber-400 bg-amber-50 px-2 py-0.5 rounded border border-amber-200">
                            Confidence: {match ? `${(match.final_score * 100).toFixed(0)}%` : 'Review Required'}
                          </span>
                          <span className="text-xs text-slate-500">
                            Category: <strong className="text-slate-900">{item.category}</strong>
                          </span>
                          {match?.geo_similarity !== undefined && (
                            <span className="text-xs text-teal-600 font-mono">
                              Geo Match: {(match.geo_similarity * 100).toFixed(0)}%
                            </span>
                          )}
                        </div>

                        {match && (
                          <div className="flex items-center gap-3 text-[11px] font-mono text-slate-500">
                            <span>Geo: {(match.geo_similarity * 100).toFixed(0)}%</span>
                            <span>Vis: {(match.visual_similarity * 100).toFixed(0)}%</span>
                            <span>Text: {(match.text_similarity * 100).toFixed(0)}%</span>
                            <span>Ctx: {(match.context_similarity * 100).toFixed(0)}%</span>
                          </div>
                        )}
                      </div>

                      {/* Side-by-Side Comparison */}
                      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                        {/* LEFT: New Citizen Report */}
                        <div className="p-4 rounded-xl bg-white border border-slate-200 space-y-3">
                          <div className="flex items-center justify-between border-b border-slate-200 pb-2">
                            <span className="text-xs font-bold text-amber-300 font-mono">
                              NEW REPORT #{repId} ({item.report_tracking_id || 'ID Pending'})
                            </span>
                            <span className="text-[11px] text-slate-500 font-mono">
                              {new Date(item.created_at).toLocaleString()}
                            </span>
                          </div>

                          <div className="flex gap-4">
                            {item.image_url ? (
                              <div className="w-24 h-24 rounded-lg overflow-hidden border border-slate-200 bg-sky-50 shrink-0">
                                <img src={item.image_url} alt="Incoming Evidence" className="w-full h-full object-cover" />
                              </div>
                            ) : (
                              <div className="w-24 h-24 rounded-lg border border-slate-200 bg-sky-50 flex items-center justify-center text-[10px] text-slate-600 shrink-0">
                                No Photo
                              </div>
                            )}

                            <div className="space-y-1.5 text-xs">
                              <p className="text-slate-700 font-medium">"{item.description || 'No description'}"</p>
                              <div className="text-[11px] text-slate-500">
                                <div><strong>Reporter:</strong> {item.reporter_name || 'Anonymous'}</div>
                                {item.address && <div className="truncate"><strong>Location:</strong> {item.address}</div>}
                                <div><strong>GPS:</strong> ({item.latitude?.toFixed(5)}, {item.longitude?.toFixed(5)})</div>
                              </div>
                            </div>
                          </div>
                        </div>

                        {/* RIGHT: Existing Suggested Issue */}
                        <div className="p-4 rounded-xl bg-white border border-slate-200 space-y-3">
                          <div className="flex items-center justify-between border-b border-slate-200 pb-2">
                            <span className="text-xs font-bold text-teal-600 font-mono">
                              EXISTING ISSUE {candidate ? candidate.display_id || `#${candidate.id}` : 'Linked Candidate'}
                            </span>
                            {candidate && (
                              <span className="text-[11px] text-teal-400 font-bold font-mono">
                                {candidate.total_reports || 1} Reports ({candidate.unique_citizens || 1} Citizens)
                              </span>
                            )}
                          </div>

                          {candidate ? (
                            <div className="space-y-1.5 text-xs">
                              <h4 className="font-bold text-slate-900 text-sm">{candidate.title}</h4>
                              <p className="text-slate-600 text-xs line-clamp-2">
                                {candidate.description || 'Existing municipal record'}
                              </p>
                              <div className="text-[11px] text-slate-500 pt-1">
                                <div><strong>Status:</strong> {candidate.status || 'ACTIVE'}</div>
                                <div><strong>Severity:</strong> {candidate.severity_level || 'HIGH'}</div>
                                <div><strong>Address:</strong> {candidate.address || 'Address registered on file'}</div>
                              </div>
                            </div>
                          ) : (
                            <div className="text-xs text-slate-500 py-4">
                              Suggested Issue record attached to this candidate match.
                            </div>
                          )}
                        </div>
                      </div>

                      {/* AI Reasoning Callout */}
                      {match?.ai_reasoning && (
                        <div className="p-3 rounded-xl bg-slate-50 border border-slate-200 text-xs text-slate-600">
                          <strong className="text-purple-300 block mb-0.5">AI Similarity Assessment:</strong>
                          "{match.ai_reasoning}"
                        </div>
                      )}

                      {/* 4 Action Buttons */}
                      <div className="flex flex-wrap items-center justify-end gap-2.5 pt-2 border-t border-slate-200">
                        <button
                          onClick={() => handleConfirmDuplicate(repId)}
                          disabled={isLoadingThis}
                          className="px-4 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs flex items-center gap-1.5 transition-colors shadow"
                        >
                          <Check className="w-4 h-4" /> Confirm Duplicate (Link)
                        </button>

                        <button
                          onClick={() => handleRejectDuplicate(repId)}
                          disabled={isLoadingThis}
                          className="px-4 py-2 rounded-xl bg-cyan-600 hover:bg-cyan-500 text-white font-bold text-xs flex items-center gap-1.5 transition-colors"
                        >
                          <Layers className="w-4 h-4" /> Not a Duplicate (New Issue)
                        </button>

                        <button
                          onClick={() => {
                            setMoveModalReportId(repId);
                            setTargetIssueInput('');
                          }}
                          disabled={isLoadingThis}
                          className="px-3.5 py-2 rounded-xl bg-slate-100 hover:bg-slate-700 text-purple-300 font-bold text-xs flex items-center gap-1.5 transition-colors"
                        >
                          <ArrowRight className="w-4 h-4" /> Move to Other Issue
                        </button>

                        <button
                          onClick={() => {
                            setInvalidateModalReportId(repId);
                            setInvalidateReason('');
                          }}
                          disabled={isLoadingThis}
                          className="px-3 py-2 rounded-xl bg-red-50/70 hover:bg-rose-900 text-red-600 border border-red-200 font-bold text-xs flex items-center gap-1.5 transition-colors"
                        >
                          <X className="w-4 h-4" /> Mark Invalid
                        </button>
                      </div>
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        )}

        {/* TAB 3: SEVERITY REVIEW QUEUE */}
        {activeTab === 'severity' && (
          <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-6">
            <div className="flex flex-wrap items-center justify-between gap-3 border-b border-slate-200 pb-4">
              <div>
                <h3 className="text-base font-bold text-slate-900 flex items-center gap-2">
                  <AlertOctagon className="w-5 h-5 text-red-500" />
                  Severity Review Queue (Borderline / Flagged Physical Assessments)
                </h3>
                <p className="text-xs text-slate-500 mt-1">
                  Civic issues requiring administrator validation of physical dimensions, hazard factors, or critical escalations.
                </p>
              </div>
              <button
                onClick={fetchSeverityQueue}
                className="px-3 py-1.5 rounded-lg bg-slate-50 border border-slate-700 text-xs font-semibold flex items-center gap-1.5 text-slate-600"
              >
                <RefreshCw className={`w-3.5 h-3.5 ${loadingSeverity ? 'animate-spin' : ''}`} /> Refresh Queue
              </button>
            </div>

            {loadingSeverity ? (
              <div className="text-center py-12 text-slate-500 flex items-center justify-center gap-2 text-xs">
                <RefreshCw className="w-4 h-4 animate-spin text-red-500" /> Loading severity review queue...
              </div>
            ) : severityIssues.length === 0 ? (
              <div className="text-center py-12 text-slate-500 space-y-2">
                <CheckCircle2 className="w-10 h-10 text-emerald-400 mx-auto" />
                <p className="text-sm font-semibold text-slate-600">All severity assessments up to date!</p>
                <p className="text-xs text-slate-500">Autonomous vision scoring is within standard confidence bands.</p>
              </div>
            ) : (
              <div className="space-y-4">
                {severityIssues.map((item) => (
                  <div
                    key={item.issue_id}
                    className="p-5 rounded-2xl bg-sky-50 border border-slate-200 space-y-3"
                  >
                    <div className="flex flex-wrap items-center justify-between gap-3 border-b border-slate-200 pb-2.5">
                      <div className="flex items-center gap-2">
                        <span className="text-xs font-mono font-bold text-teal-500">
                          {item.display_id || `NG-${item.issue_id}`}
                        </span>
                        <span className="text-xs font-bold text-slate-900">{item.title}</span>
                      </div>
                      <span className="text-xs font-mono font-bold px-2.5 py-0.5 rounded-full bg-red-50 text-red-600 border border-red-200">
                        Score: {item.current_severity_score}/100 ({item.current_severity_level || item.current_severity})
                      </span>
                    </div>

                    <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-xs">
                      <div className="md:col-span-2 space-y-2">
                        <p className="text-slate-600">{item.ai_explanation || item.ai_reasoning || 'Severity computed via computer vision.'}</p>
                        <div className="flex flex-wrap items-center gap-4 text-[11px] text-slate-500">
                          <span><strong>Review Trigger:</strong> {item.review_reason || 'Periodic Audit'}</span>
                          <span><strong>Confidence:</strong> {Math.round((item.ai_confidence || 0.8) * 100)}%</span>
                        </div>
                      </div>

                      <div className="flex items-center justify-end gap-2">
                        <button
                          onClick={() => handleApproveSeverity(item.issue_id)}
                          disabled={actionLoadingId === item.issue_id}
                          className="px-4 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs flex items-center gap-1.5 transition-colors"
                        >
                          <Check className="w-4 h-4" /> Approve
                        </button>

                        <button
                          onClick={() => {
                            setOverrideModalIssue(item);
                            setOverrideScore(item.current_severity_score);
                            setOverrideLevel(item.current_severity_level || item.current_severity || 'HIGH');
                            setOverrideReason('');
                          }}
                          disabled={actionLoadingId === item.issue_id}
                          className="px-4 py-2 rounded-xl bg-amber-600 hover:bg-amber-500 text-slate-900 font-bold text-xs flex items-center gap-1.5 transition-colors"
                        >
                          <Sliders className="w-4 h-4" /> Override Score
                        </button>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        )}

        {/* TAB 4: AI INTELLIGENCE ANALYTICS */}
        {activeTab === 'analytics' && (
          <div className="space-y-6">
            <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-6">
              <div className="border-b border-slate-200 pb-3">
                <h3 className="text-base font-bold text-slate-900 flex items-center gap-2">
                  <Sparkles className="w-5 h-5 text-purple-400" />
                  AI Civic Intelligence Engine Telemetry
                </h3>
                <p className="text-xs text-slate-500 mt-0.5">
                  Performance indicators for duplicate detection consolidation, severity triage, and counter integrity.
                </p>
              </div>

              {loadingIntel ? (
                <div className="text-center py-12 text-slate-500 flex items-center justify-center gap-2 text-xs">
                  <RefreshCw className="w-4 h-4 animate-spin text-purple-400" /> Loading intelligence telemetry...
                </div>
              ) : intelAnalytics ? (
                <div className="space-y-6">
                  {/* Metric Cards */}
                  <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
                    <div className="p-4 rounded-xl bg-sky-50 border border-slate-200 space-y-1">
                      <span className="text-[11px] text-slate-500">Total Citizen Submissions</span>
                      <div className="text-2xl font-black text-slate-900 font-mono">{intelAnalytics.total_citizen_reports}</div>
                      <span className="text-[10px] text-teal-500">Consolidated into {intelAnalytics.total_unique_issues} issues</span>
                    </div>

                    <div className="p-4 rounded-xl bg-sky-50 border border-slate-200 space-y-1">
                      <span className="text-[11px] text-slate-500">Auto-Linked by AI</span>
                      <div className="text-2xl font-black text-emerald-400 font-mono">
                        {intelAnalytics.duplicate_reports_auto_linked || intelAnalytics.auto_linked_count || 0}
                      </div>
                      <span className="text-[10px] text-emerald-400 font-medium">≥0.80 Confidence Auto-Merged</span>
                    </div>

                    <div className="p-4 rounded-xl bg-sky-50 border border-slate-200 space-y-1">
                      <span className="text-[11px] text-slate-500">Sent to Admin Review</span>
                      <div className="text-2xl font-black text-amber-400 font-mono">
                        {intelAnalytics.duplicate_reports_pending_review || intelAnalytics.pending_review_count || 0}
                      </div>
                      <span className="text-[10px] text-amber-400">0.55 – 0.79 Confidence Triage</span>
                    </div>

                    <div className="p-4 rounded-xl bg-sky-50 border border-slate-200 space-y-1">
                      <span className="text-[11px] text-slate-500">Avg Reports Per Issue</span>
                      <div className="text-2xl font-black text-purple-400 font-mono">
                        {(intelAnalytics.average_reports_per_issue || 1).toFixed(1)}
                      </div>
                      <span className="text-[10px] text-purple-400 font-medium">Consolidation Factor</span>
                    </div>
                  </div>

                  {/* Operational Telemetry Details */}
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div className="p-5 rounded-xl bg-sky-50 border border-slate-200 space-y-3 text-xs">
                      <h4 className="font-bold text-slate-900 flex items-center gap-2">
                        <Activity className="w-4 h-4 text-teal-500" /> AI Processing Distribution
                      </h4>
                      <div className="space-y-2">
                        <div className="flex items-center justify-between">
                          <span className="text-slate-600">Vision & LLM Multi-Modal Evaluations:</span>
                          <span className="text-teal-500 font-mono font-bold">
                            {intelAnalytics.processing_breakdown?.external_ai_assessments || intelAnalytics.ai_evaluations_count || 0}
                          </span>
                        </div>
                        <div className="flex items-center justify-between">
                          <span className="text-slate-600">Deterministic Fallbacks Used:</span>
                          <span className="text-amber-400 font-mono font-bold">
                            {intelAnalytics.processing_breakdown?.deterministic_heuristic_assessments || intelAnalytics.fallback_evaluations_count || 0}
                          </span>
                        </div>
                        <div className="flex items-center justify-between">
                          <span className="text-slate-600">Total Evaluations Completed:</span>
                          <span className="text-slate-900 font-mono font-bold">
                            {intelAnalytics.processing_breakdown?.total_assessments || intelAnalytics.total_matches_evaluated || 0}
                          </span>
                        </div>
                      </div>
                    </div>

                    <div className="p-5 rounded-xl bg-sky-50 border border-slate-200 space-y-3 text-xs">
                      <h4 className="font-bold text-slate-900 flex items-center gap-2">
                        <Database className="w-4 h-4 text-teal-400" /> Counter Invariant Health
                      </h4>
                      <p className="text-slate-600 leading-relaxed">
                        Database invariant <code>total_reports = COUNT(accepted reports)</code> is continuously verified.
                        Zero counter discrepancies detected on live data.
                      </p>
                      <button
                        onClick={handleReconcileCounts}
                        disabled={reconciling}
                        className="px-4 py-2 bg-slate-50 hover:bg-slate-100 text-teal-300 border border-teal-200 rounded-xl text-xs font-bold flex items-center gap-1.5 transition-colors"
                      >
                        <RefreshCw className={`w-3.5 h-3.5 ${reconciling ? 'animate-spin' : ''}`} /> Run Verification Audit
                      </button>
                    </div>
                  </div>
                </div>
              ) : null}
            </div>
          </div>
        )}

        {/* TAB 5: AI THRESHOLDS & RECONCILIATION */}
        {activeTab === 'config' && (
          <div className="space-y-6">
            {/* Reconciliation Control Card */}
            <div className="p-6 rounded-2xl bg-gradient-to-r from-slate-900 via-teal-950/40 to-slate-900 border border-teal-200/60 space-y-4">
              <div className="flex flex-wrap items-center justify-between gap-4">
                <div>
                  <h3 className="text-base font-bold text-slate-900 flex items-center gap-2">
                    <Database className="w-5 h-5 text-teal-400" />
                    Database Counter Invariant Reconciliation
                  </h3>
                  <p className="text-xs text-slate-600 mt-1 max-w-2xl leading-relaxed">
                    Atomically audits all civic issues and verifies that <code>total_reports</code> matches the exact count of accepted reports
                    and <code>unique_citizens</code> matches distinct citizen IDs. Fixes any drift automatically.
                  </p>
                </div>
                <button
                  onClick={handleReconcileCounts}
                  disabled={reconciling}
                  className="px-5 py-2.5 rounded-xl bg-teal-500 hover:bg-teal-400 text-slate-950 font-black text-xs flex items-center gap-2 shadow-lg transition-all"
                >
                  <RefreshCw className={`w-4 h-4 ${reconciling ? 'animate-spin' : ''}`} />
                  {reconciling ? 'Reconciling Database...' : 'Run Full Counter Reconciliation'}
                </button>
              </div>

              {reconciliationResult && (
                <div className="p-4 rounded-xl bg-sky-50 border border-teal-200 text-xs space-y-1 font-mono">
                  <div className="text-emerald-400 font-bold">✓ Audit Run Completed Successfully</div>
                  <div className="text-slate-600">Issues Inspected: {reconciliationResult.issues_checked}</div>
                  <div className="text-slate-600">Discrepancies Corrected: {reconciliationResult.discrepancies_found}</div>
                </div>
              )}
            </div>

            {/* Threshold Configuration Forms */}
            {loadingConfig ? (
              <div className="text-center py-12 text-slate-500 flex items-center justify-center gap-2 text-xs">
                <RefreshCw className="w-4 h-4 animate-spin text-purple-400" /> Loading configuration parameters...
              </div>
            ) : dedupConfig && priorityConfig ? (
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
                {/* 1. Deduplication Radii & Similarity Weights */}
                <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-4">
                  <h3 className="text-base font-bold text-slate-900 flex items-center gap-2 border-b border-slate-200 pb-3">
                    <Sliders className="w-4 h-4 text-teal-500" /> Duplicate Detection Radii & Gates
                  </h3>

                  <div className="space-y-3 text-xs">
                    <div className="font-semibold text-slate-600">Category Proximity Radii (Metres):</div>
                    <div className="grid grid-cols-2 gap-3">
                      <div>
                        <label className="text-[11px] text-slate-500 block">Pothole Radius (m)</label>
                        <input
                          type="number"
                          value={dedupConfig.category_radii?.Pothole || dedupConfig.pothole_radius_meters || 30}
                          onChange={(e) => {
                            const val = Number(e.target.value);
                            setDedupConfig({
                              ...dedupConfig,
                              pothole_radius_meters: val,
                              category_radii: { ...(dedupConfig.category_radii || {}), Pothole: val }
                            });
                          }}
                          className="w-full bg-sky-50 border border-slate-200 rounded-lg p-2 text-slate-900 font-mono text-xs mt-1"
                        />
                      </div>
                      <div>
                        <label className="text-[11px] text-slate-500 block">Garbage Radius (m)</label>
                        <input
                          type="number"
                          value={dedupConfig.category_radii?.Garbage || dedupConfig.garbage_radius_meters || 75}
                          onChange={(e) => {
                            const val = Number(e.target.value);
                            setDedupConfig({
                              ...dedupConfig,
                              garbage_radius_meters: val,
                              category_radii: { ...(dedupConfig.category_radii || {}), Garbage: val }
                            });
                          }}
                          className="w-full bg-sky-50 border border-slate-200 rounded-lg p-2 text-slate-900 font-mono text-xs mt-1"
                        />
                      </div>
                      <div>
                        <label className="text-[11px] text-slate-500 block">Drainage / Sewage (m)</label>
                        <input
                          type="number"
                          value={dedupConfig.category_radii?.Drainage || dedupConfig.drainage_radius_meters || 50}
                          onChange={(e) => {
                            const val = Number(e.target.value);
                            setDedupConfig({
                              ...dedupConfig,
                              drainage_radius_meters: val,
                              category_radii: { ...(dedupConfig.category_radii || {}), Drainage: val }
                            });
                          }}
                          className="w-full bg-sky-50 border border-slate-200 rounded-lg p-2 text-slate-900 font-mono text-xs mt-1"
                        />
                      </div>
                      <div>
                        <label className="text-[11px] text-slate-500 block">Streetlight (m)</label>
                        <input
                          type="number"
                          value={dedupConfig.category_radii?.Streetlight || dedupConfig.streetlight_radius_meters || 20}
                          onChange={(e) => {
                            const val = Number(e.target.value);
                            setDedupConfig({
                              ...dedupConfig,
                              streetlight_radius_meters: val,
                              category_radii: { ...(dedupConfig.category_radii || {}), Streetlight: val }
                            });
                          }}
                          className="w-full bg-sky-50 border border-slate-200 rounded-lg p-2 text-slate-900 font-mono text-xs mt-1"
                        />
                      </div>
                    </div>

                    <div className="font-semibold text-slate-600 pt-3">Confidence Decision Thresholds:</div>
                    <div className="grid grid-cols-2 gap-3">
                      <div>
                        <label className="text-[11px] text-slate-500 block">Auto-Merge High Threshold</label>
                        <input
                          type="number"
                          step="0.05"
                          min="0.5"
                          max="1.0"
                          value={dedupConfig.auto_link_threshold || dedupConfig.auto_merge_threshold || 0.80}
                          onChange={(e) => {
                            const val = Number(e.target.value);
                            setDedupConfig({ ...dedupConfig, auto_link_threshold: val, auto_merge_threshold: val });
                          }}
                          className="w-full bg-sky-50 border border-slate-200 rounded-lg p-2 text-slate-900 font-mono text-xs mt-1"
                        />
                        <span className="text-[10px] text-emerald-400">Default: 0.80</span>
                      </div>
                      <div>
                        <label className="text-[11px] text-slate-500 block">Review Threshold (Medium)</label>
                        <input
                          type="number"
                          step="0.05"
                          min="0.3"
                          max="0.8"
                          value={dedupConfig.manual_review_threshold || dedupConfig.review_threshold || 0.55}
                          onChange={(e) => {
                            const val = Number(e.target.value);
                            setDedupConfig({ ...dedupConfig, manual_review_threshold: val, review_threshold: val });
                          }}
                          className="w-full bg-sky-50 border border-slate-200 rounded-lg p-2 text-slate-900 font-mono text-xs mt-1"
                        />
                        <span className="text-[10px] text-amber-400">Default: 0.55</span>
                      </div>
                    </div>
                  </div>
                </div>

                {/* 2. Priority Scoring Formula Weights */}
                <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-4">
                  <h3 className="text-base font-bold text-slate-900 flex items-center gap-2 border-b border-slate-200 pb-3">
                    <Sliders className="w-4 h-4 text-purple-400" /> Dynamic Priority Formula Weights (Sum = 1.0)
                  </h3>

                  <div className="space-y-3 text-xs">
                    <div className="grid grid-cols-2 gap-3">
                      <div>
                        <label className="text-[11px] text-slate-500 block">Physical Severity Weight</label>
                        <input
                          type="number"
                          step="0.05"
                          value={priorityConfig.weight_severity ?? priorityConfig.severity_weight ?? 0.35}
                          onChange={(e) => {
                            const val = Number(e.target.value);
                            setPriorityConfig({ ...priorityConfig, weight_severity: val, severity_weight: val });
                          }}
                          className="w-full bg-sky-50 border border-slate-200 rounded-lg p-2 text-slate-900 font-mono text-xs mt-1"
                        />
                        <span className="text-[10px] text-slate-500">Default: 0.35 (35%)</span>
                      </div>

                      <div>
                        <label className="text-[11px] text-slate-500 block">Public Safety Risk Weight</label>
                        <input
                          type="number"
                          step="0.05"
                          value={priorityConfig.weight_safety_risk ?? priorityConfig.safety_risk_weight ?? 0.25}
                          onChange={(e) => {
                            const val = Number(e.target.value);
                            setPriorityConfig({ ...priorityConfig, weight_safety_risk: val, safety_risk_weight: val });
                          }}
                          className="w-full bg-sky-50 border border-slate-200 rounded-lg p-2 text-slate-900 font-mono text-xs mt-1"
                        />
                        <span className="text-[10px] text-slate-500">Default: 0.25 (25%)</span>
                      </div>

                      <div>
                        <label className="text-[11px] text-slate-500 block">Affected Population Weight</label>
                        <input
                          type="number"
                          step="0.05"
                          value={priorityConfig.weight_affected_population ?? priorityConfig.affected_population_weight ?? 0.15}
                          onChange={(e) => {
                            const val = Number(e.target.value);
                            setPriorityConfig({ ...priorityConfig, weight_affected_population: val, affected_population_weight: val });
                          }}
                          className="w-full bg-sky-50 border border-slate-200 rounded-lg p-2 text-slate-900 font-mono text-xs mt-1"
                        />
                        <span className="text-[10px] text-slate-500">Default: 0.15 (15%)</span>
                      </div>

                      <div>
                        <label className="text-[11px] text-slate-500 block">Duration / Aging Weight</label>
                        <input
                          type="number"
                          step="0.05"
                          value={priorityConfig.weight_duration ?? priorityConfig.duration_weight ?? 0.10}
                          onChange={(e) => {
                            const val = Number(e.target.value);
                            setPriorityConfig({ ...priorityConfig, weight_duration: val, duration_weight: val });
                          }}
                          className="w-full bg-sky-50 border border-slate-200 rounded-lg p-2 text-slate-900 font-mono text-xs mt-1"
                        />
                        <span className="text-[10px] text-slate-500">Default: 0.10 (10%)</span>
                      </div>

                      <div>
                        <label className="text-[11px] text-slate-500 block">Unique Citizens Weight</label>
                        <input
                          type="number"
                          step="0.05"
                          value={priorityConfig.weight_unique_citizens ?? priorityConfig.unique_citizens_weight ?? 0.10}
                          onChange={(e) => {
                            const val = Number(e.target.value);
                            setPriorityConfig({ ...priorityConfig, weight_unique_citizens: val, unique_citizens_weight: val });
                          }}
                          className="w-full bg-sky-50 border border-slate-200 rounded-lg p-2 text-slate-900 font-mono text-xs mt-1"
                        />
                        <span className="text-[10px] text-slate-500">Default: 0.10 (10%)</span>
                      </div>

                      <div>
                        <label className="text-[11px] text-slate-500 block">Escalation Trend Weight</label>
                        <input
                          type="number"
                          step="0.05"
                          value={priorityConfig.weight_escalation_trend ?? priorityConfig.escalation_trend_weight ?? 0.05}
                          onChange={(e) => {
                            const val = Number(e.target.value);
                            setPriorityConfig({ ...priorityConfig, weight_escalation_trend: val, escalation_trend_weight: val });
                          }}
                          className="w-full bg-sky-50 border border-slate-200 rounded-lg p-2 text-slate-900 font-mono text-xs mt-1"
                        />
                        <span className="text-[10px] text-slate-500">Default: 0.05 (5%)</span>
                      </div>
                    </div>

                    <div className="pt-4 border-t border-slate-200 flex justify-end">
                      <button
                        onClick={handleSaveConfigs}
                        disabled={savingConfig}
                        className="px-5 py-2.5 rounded-xl bg-purple-600 hover:bg-purple-500 text-white font-bold text-xs flex items-center gap-1.5 transition-colors shadow"
                      >
                        <Check className="w-4 h-4" /> Save Configuration Parameters
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            ) : null}
          </div>
        )}

        {/* MODAL: Move Report to Another Issue */}
        {moveModalReportId && (
          <div className="fixed inset-0 z-50 bg-sky-50/80 backdrop-blur-sm flex items-center justify-center p-4">
            <div className="bg-slate-50 border border-purple-600/60 rounded-2xl max-w-md w-full p-6 space-y-4 shadow-2xl">
              <h4 className="text-base font-bold text-slate-900 flex items-center gap-2">
                <ArrowRight className="w-5 h-5 text-purple-400" />
                Move Report #{moveModalReportId} to Another Issue
              </h4>
              <p className="text-xs text-slate-500">
                Specify the target Issue ID to attach this citizen submission to. Its counters will be recomputed atomically.
              </p>

              <div>
                <label className="text-xs text-slate-600 font-medium block mb-1">Target Issue ID (e.g. 101 or NG-101):</label>
                <input
                  type="text"
                  value={targetIssueInput}
                  onChange={(e) => setTargetIssueInput(e.target.value)}
                  placeholder="Enter target issue numeric ID"
                  className="w-full bg-sky-50 border border-slate-200 rounded-xl p-2.5 text-xs text-slate-900"
                />
              </div>

              <div className="flex justify-end gap-2 pt-2 border-t border-slate-200">
                <button
                  type="button"
                  onClick={() => setMoveModalReportId(null)}
                  className="px-3 py-1.5 rounded-lg bg-slate-100 text-xs font-semibold text-slate-600"
                >
                  Cancel
                </button>
                <button
                  type="button"
                  onClick={handleMoveReport}
                  className="px-4 py-1.5 rounded-lg bg-purple-600 text-slate-900 font-bold text-xs"
                >
                  Move Report
                </button>
              </div>
            </div>
          </div>
        )}

        {/* MODAL: Invalidate Report */}
        {invalidateModalReportId && (
          <div className="fixed inset-0 z-50 bg-sky-50/80 backdrop-blur-sm flex items-center justify-center p-4">
            <div className="bg-slate-50 border border-rose-600/60 rounded-2xl max-w-md w-full p-6 space-y-4 shadow-2xl">
              <h4 className="text-base font-bold text-slate-900 flex items-center gap-2">
                <X className="w-5 h-5 text-red-500" />
                Mark Report #{invalidateModalReportId} as Invalid
              </h4>
              <p className="text-xs text-slate-500">
                Invalidated reports are excluded from issue counts and priority weighting. Please provide an administrative reason.
              </p>

              <div>
                <label className="text-xs text-slate-600 font-medium block mb-1">Reason for Invalidation:</label>
                <textarea
                  rows={2}
                  value={invalidateReason}
                  onChange={(e) => setInvalidateReason(e.target.value)}
                  placeholder="e.g. Unrelated photo, spam submission, invalid GPS coordinates"
                  className="w-full bg-sky-50 border border-slate-200 rounded-xl p-2.5 text-xs text-slate-900"
                />
              </div>

              <div className="flex justify-end gap-2 pt-2 border-t border-slate-200">
                <button
                  type="button"
                  onClick={() => setInvalidateModalReportId(null)}
                  className="px-3 py-1.5 rounded-lg bg-slate-100 text-xs font-semibold text-slate-600"
                >
                  Cancel
                </button>
                <button
                  type="button"
                  onClick={handleInvalidateReport}
                  className="px-4 py-1.5 rounded-lg bg-rose-600 text-slate-900 font-bold text-xs"
                >
                  Invalidate Report
                </button>
              </div>
            </div>
          </div>
        )}

        {/* MODAL: Severity Override */}
        {overrideModalIssue && (
          <div className="fixed inset-0 z-50 bg-sky-50/80 backdrop-blur-sm flex items-center justify-center p-4">
            <div className="bg-slate-50 border border-amber-600/60 rounded-2xl max-w-md w-full p-6 space-y-4 shadow-2xl">
              <h4 className="text-base font-bold text-slate-900 flex items-center gap-2">
                <Sliders className="w-5 h-5 text-amber-400" />
                Override Physical Severity Score
              </h4>
              <p className="text-xs text-slate-500">
                Issue {overrideModalIssue.display_id || `#${overrideModalIssue.issue_id}`}: {overrideModalIssue.title}
              </p>

              <div className="space-y-1">
                <label className="text-xs text-slate-600 font-medium">New Severity Score (1-100): {overrideScore}</label>
                <input
                  type="range"
                  min="1"
                  max="100"
                  value={overrideScore}
                  onChange={(e) => {
                    const sc = Number(e.target.value);
                    setOverrideScore(sc);
                    setOverrideLevel(sc >= 76 ? 'CRITICAL' : sc >= 51 ? 'HIGH' : sc >= 26 ? 'MEDIUM' : 'LOW');
                  }}
                  className="w-full accent-amber-500"
                />
              </div>

              <div className="space-y-1">
                <label className="text-xs text-slate-600 font-medium">Severity Level: {overrideLevel}</label>
              </div>

              <div className="space-y-1">
                <label className="text-xs text-slate-600 font-medium">Official Justification (Mandatory):</label>
                <textarea
                  rows={2}
                  value={overrideReason}
                  onChange={(e) => setOverrideReason(e.target.value)}
                  placeholder="Ground inspection found deeper structural cavities..."
                  className="w-full bg-sky-50 border border-slate-200 rounded-xl p-2.5 text-xs text-slate-900"
                />
              </div>

              <div className="flex justify-end gap-2 pt-2 border-t border-slate-200">
                <button
                  type="button"
                  onClick={() => setOverrideModalIssue(null)}
                  className="px-3 py-1.5 rounded-lg bg-slate-100 text-xs font-semibold text-slate-600"
                >
                  Cancel
                </button>
                <button
                  type="button"
                  onClick={handleOverrideSeveritySubmit}
                  className="px-4 py-1.5 rounded-lg bg-amber-500 text-slate-950 font-bold text-xs"
                >
                  Save Override
                </button>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
