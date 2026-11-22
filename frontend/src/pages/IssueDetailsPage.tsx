import React, { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import { issueService, departmentService, citizenService } from '../services/api';
import { Issue, IssueStatus, Department, UserRole, CitizenReport, IssueAIAnalysis, IssueActivityLogItem } from '../types';
import { useAuth } from '../context/AuthContext';
import { PriorityBadge } from '../components/common/PriorityBadge';
import { StatusBadge } from '../components/common/StatusBadge';
import {
  MapPin, Cpu, Clock, Building2, Shield, CheckCircle2, ArrowLeft,
  Users, CheckSquare, XCircle, Camera, AlertTriangle, Sparkles,
  MessageSquare, ShieldAlert, FileText, Layers, Activity, HelpCircle,
  TrendingUp, Check, AlertOctagon, RefreshCw, Eye
} from 'lucide-react';

export const IssueDetailsPage: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const { user } = useAuth();

  const [issue, setIssue] = useState<Issue | null>(null);
  const [departments, setDepartments] = useState<Department[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  // Active Tab: 'overview' | 'reports' | 'ai_analysis' | 'activity_log'
  const [activeTab, setActiveTab] = useState<'overview' | 'reports' | 'ai_analysis' | 'activity_log'>('overview');

  // Sub-data states
  const [reports, setReports] = useState<CitizenReport[]>([]);
  const [loadingReports, setLoadingReports] = useState(false);
  const [aiAnalysis, setAiAnalysis] = useState<IssueAIAnalysis | null>(null);
  const [loadingAi, setLoadingAi] = useState(false);
  const [activityLogs, setActivityLogs] = useState<IssueActivityLogItem[]>([]);
  const [loadingLogs, setLoadingLogs] = useState(false);

  // Priority override modal
  const [showOverrideModal, setShowOverrideModal] = useState(false);
  const [newPriority, setNewPriority] = useState<number>(75);
  const [overrideReason, setOverrideReason] = useState('');
  const [overrideSubmitting, setOverrideSubmitting] = useState(false);

  // Verification
  const [verifying, setVerifying] = useState(false);
  const [feedback, setFeedback] = useState('');

  // Support / Upvote
  const [supporting, setSupporting] = useState(false);

  const fetchIssue = async () => {
    if (!id) return;
    setLoading(true);
    try {
      const data = await issueService.getIssueById(parseInt(id));
      setIssue(data);
      setNewPriority(data.priority_score || 50);
    } catch {
      setError('Failed to fetch complaint details.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchIssue();
    departmentService.listDepartments().then(setDepartments).catch(console.error);
  }, [id]);

  // Load Tab Content dynamically
  useEffect(() => {
    if (!id) return;
    const issueId = parseInt(id);

    if (activeTab === 'reports' && reports.length === 0) {
      setLoadingReports(true);
      issueService.getIssueReports(issueId)
        .then(setReports)
        .catch(console.error)
        .finally(() => setLoadingReports(false));
    } else if (activeTab === 'ai_analysis' && !aiAnalysis) {
      setLoadingAi(true);
      issueService.getIssueAIAnalysis(issueId)
        .then(setAiAnalysis)
        .catch(console.error)
        .finally(() => setLoadingAi(false));
    } else if (activeTab === 'activity_log' && activityLogs.length === 0) {
      setLoadingLogs(true);
      issueService.getIssueActivityLog(issueId)
        .then(setActivityLogs)
        .catch(console.error)
        .finally(() => setLoadingLogs(false));
    }
  }, [activeTab, id]);

  const handleSupport = async () => {
    if (!issue) return;
    setSupporting(true);
    try {
      await citizenService.support(issue.id);
      await fetchIssue();
    } catch {
      alert('Could not add support endorsement.');
    } finally {
      setSupporting(false);
    }
  };

  const [verifySuccessMsg, setVerifySuccessMsg] = useState('');

  const handleVerify = async (statusChoice: 'YES' | 'NO' | 'PARTIALLY_RESOLVED') => {
    if (!issue) return;
    setVerifying(true);
    setVerifySuccessMsg('');
    try {
      const res = await citizenService.verify(
        issue.id,
        statusChoice === 'YES',
        feedback,
        feedback
      );
      if (statusChoice === 'YES') {
        setVerifySuccessMsg('Thank you for confirming! Your feedback helps us improve public services.');
      } else if (statusChoice === 'NO') {
        setVerifySuccessMsg('Thank you for reporting this. We will notify the responsible department that the issue still persists.');
      } else {
        setVerifySuccessMsg('Thank you for reporting this. We will notify the responsible department that further work is required.');
      }
      await fetchIssue();
      setFeedback('');
    } catch {
      alert('Verification action failed.');
    } finally {
      setVerifying(false);
    }
  };

  const handleOverridePriority = async () => {
    if (!issue) return;
    if (!overrideReason || overrideReason.length < 5) {
      alert('Please state a valid reason for adjusting the priority score.');
      return;
    }
    setOverrideSubmitting(true);
    try {
      await issueService.overridePriority(issue.id, newPriority, overrideReason);
      setShowOverrideModal(false);
      setOverrideReason('');
      await fetchIssue();
    } catch (err: any) {
      alert(err.response?.data?.detail || 'Failed to override priority.');
    } finally {
      setOverrideSubmitting(false);
    }
  };

  const handleRequestInspection = async () => {
    if (!issue) return;
    try {
      await issueService.requestInspection(issue.id, 'Ground inspection requested via ticket details.');
      alert('Independent municipal inspection queued.');
      await fetchIssue();
    } catch {
      alert('Could not schedule inspection.');
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-sky-50 flex items-center justify-center text-slate-500">
        <div className="flex items-center gap-3">
          <RefreshCw className="w-5 h-5 text-teal-500 animate-spin" />
          <span>Loading NagarSetu Civic Intelligence audit details...</span>
        </div>
      </div>
    );
  }

  if (error || !issue) {
    return (
      <div className="max-w-5xl mx-auto px-4 py-20 text-center space-y-4">
        <p className="text-red-500 font-semibold">{error || 'Complaint not found'}</p>
        <Link to="/map" className="inline-flex items-center gap-2 text-teal-500 text-sm font-semibold">
          <ArrowLeft className="w-4 h-4" /> Back to Smart Map
        </Link>
      </div>
    );
  }

  // Parse AI comparison JSON if present
  let aiComparisonObj = null;
  if (issue.resolution_ai_comparison) {
    try {
      aiComparisonObj = JSON.parse(issue.resolution_ai_comparison);
    } catch {
      // ignore parse
    }
  }

  const displayId = issue.display_id || `NG-${issue.id}`;
  const totalReportsCount = issue.total_reports || (issue as any).report_count || 1;
  const uniqueCitizensCount = issue.unique_citizens || (issue as any).unique_reporters || 1;

  return (
    <div className="min-h-screen bg-sky-50 text-slate-900 py-8 px-4 sm:px-6 lg:px-8 font-sans">
      <div className="max-w-6xl mx-auto space-y-8">
        {/* Back Link */}
        <Link to="/map" className="inline-flex items-center gap-2 text-xs font-semibold text-teal-500 hover:underline">
          <ArrowLeft className="w-4 h-4" /> Back to Smart Map
        </Link>

        {/* Header Block */}
        <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-4 shadow-xl">
          <div className="flex flex-wrap items-start justify-between gap-4 border-b border-slate-200 pb-5">
            <div className="space-y-2">
              <div className="flex flex-wrap items-center gap-2.5">
                <span className="text-sm font-mono font-extrabold text-teal-500 bg-teal-50/80 px-2.5 py-1 rounded-md border border-teal-200">
                  {displayId}
                </span>
                <span className="text-xs font-medium text-slate-600 bg-slate-100 px-2.5 py-1 rounded-md">
                  {issue.issue_type}
                </span>
                <StatusBadge status={issue.status} />

                {/* Severity Badge */}
                <span className={`text-xs font-bold px-2.5 py-1 rounded-md border ${
                  issue.severity_level === 'CRITICAL' ? 'bg-red-50 text-red-600 border-red-200' :
                  issue.severity_level === 'HIGH' ? 'bg-amber-50 text-amber-600 border-amber-200' :
                  issue.severity_level === 'MEDIUM' ? 'bg-sky-50 text-sky-700 border-sky-200' :
                  'bg-emerald-50 text-emerald-600 border-emerald-200'
                }`}>
                  Severity: {issue.severity_score !== undefined ? `${issue.severity_score}/100` : issue.severity} ({issue.severity_level || issue.severity})
                </span>

                {/* Priority Badge */}
                <PriorityBadge score={issue.priority_score} severity={issue.severity} />

                {issue.sla_hours && (
                  <span className="text-xs font-mono text-slate-500 bg-slate-50 px-2.5 py-1 rounded-md border border-slate-200">
                    SLA: {issue.sla_hours}h
                  </span>
                )}
              </div>

              <h1 className="text-2xl sm:text-3xl font-extrabold text-slate-900 tracking-tight">{issue.title}</h1>
              <p className="text-sm text-slate-500 flex items-center gap-1.5">
                <MapPin className="w-4 h-4 text-teal-500 shrink-0" />
                {issue.address || `GPS Coordinates (${issue.latitude}, ${issue.longitude})`}
              </p>
            </div>

            <div className="flex flex-wrap items-center gap-3">
              <button
                onClick={handleSupport}
                disabled={supporting}
                className="px-4 py-2.5 rounded-xl bg-slate-50 hover:bg-slate-100 text-teal-600 border border-teal-200 text-xs font-bold flex items-center gap-1.5 transition-colors"
              >
                <Users className="w-4 h-4" />
                Support Issue ({issue.support_count || 1})
              </button>

              <Link
                to={`/issue/${issue.id}/track`}
                className="px-4 py-2.5 rounded-xl bg-emerald-500 hover:bg-emerald-400 text-slate-950 font-extrabold text-xs flex items-center gap-1.5 shadow-md transition-all"
              >
                <Clock className="w-4 h-4" /> Live Tracking
              </Link>

              {(user?.role === UserRole.ADMIN || user?.role === UserRole.OFFICER) && (
                <button
                  onClick={() => setShowOverrideModal(true)}
                  className="px-3.5 py-2.5 rounded-xl bg-slate-50 hover:bg-slate-100 text-amber-600 border border-amber-200 text-xs font-bold transition-colors"
                >
                  Adjust Priority
                </button>
              )}
            </div>
          </div>

          {/* Quick Metrics Bar */}
          <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 pt-1">
            <div className="bg-sky-50/80 p-3 rounded-xl border border-slate-200">
              <span className="text-[11px] text-slate-500 block font-medium">Total Citizen Reports</span>
              <div className="flex items-center gap-2 mt-0.5">
                <span className="text-xl font-extrabold text-teal-500 font-mono">{totalReportsCount}</span>
                <span className="text-[10px] text-slate-500 bg-slate-100 px-1.5 py-0.5 rounded">
                  {uniqueCitizensCount} unique {uniqueCitizensCount === 1 ? 'citizen' : 'citizens'}
                </span>
              </div>
            </div>

            <div className="bg-sky-50/80 p-3 rounded-xl border border-slate-200">
              <span className="text-[11px] text-slate-500 block font-medium">AI Physical Severity</span>
              <div className="flex items-center gap-2 mt-0.5">
                <span className="text-xl font-extrabold text-amber-400 font-mono">{issue.severity_score || 50}/100</span>
                <span className="text-[10px] text-amber-600 bg-amber-50 px-1.5 py-0.5 rounded border border-amber-200">
                  {issue.severity_level || 'EVALUATED'}
                </span>
              </div>
            </div>

            <div className="bg-sky-50/80 p-3 rounded-xl border border-slate-200">
              <span className="text-[11px] text-slate-500 block font-medium">Dynamic Priority Score</span>
              <div className="flex items-center gap-2 mt-0.5">
                <span className="text-xl font-extrabold text-purple-600 font-mono">{issue.priority_score || 50}/100</span>
                <span className="text-[10px] text-purple-600 bg-purple-50 px-1.5 py-0.5 rounded border border-purple-200">
                  {issue.priority_level || 'ACTIVE'}
                </span>
              </div>
            </div>

            <div className="bg-sky-50/80 p-3 rounded-xl border border-slate-200">
              <span className="text-[11px] text-slate-500 block font-medium">Assigned Department</span>
              <div className="mt-0.5">
                <span className="text-sm font-bold text-slate-900 block truncate">
                  {issue.assigned_department || issue.department?.name || 'Municipal Routing'}
                </span>
                <span className="text-[10px] text-slate-500">
                  {issue.assigned_officer_name || issue.assigned_officer?.full_name || 'Field Officer Pending'}
                </span>
              </div>
            </div>
          </div>
        </div>

        {/* 1. CITIZEN GROUND RESOLUTION VERIFICATION CALLOUT */}
        {(issue.status === IssueStatus.RESOLUTION_SUBMITTED || issue.status === IssueStatus.RESOLVED) && (
          <div className="p-6 rounded-2xl bg-teal-50/60 border border-teal-500/60 shadow-xl space-y-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2 text-teal-800 font-bold text-base">
                <CheckSquare className="w-5 h-5 text-teal-600" />
                <span>Smart Feedback: Issue Resolution Verification</span>
              </div>
              <span className="text-xs bg-teal-800 text-teal-100 px-3 py-1 rounded-full font-mono font-bold">
                {issue.citizen_verified_at ? 'Citizen Verified' : 'Awaiting Citizen Feedback'}
              </span>
            </div>

            <p className="text-sm font-semibold text-slate-800">
              Your reported issue has been marked as resolved. Is the problem actually fixed?
            </p>

            {verifySuccessMsg && (
              <div className="p-3 bg-emerald-100 border border-emerald-300 rounded-xl text-emerald-900 text-xs font-bold flex items-center gap-2">
                <CheckCircle2 className="w-4 h-4 text-emerald-700 shrink-0" />
                <span>{verifySuccessMsg}</span>
              </div>
            )}

            {user?.role === UserRole.CITIZEN && (
              <div className="space-y-3 pt-2">
                <input
                  type="text"
                  value={feedback}
                  onChange={(e) => setFeedback(e.target.value)}
                  placeholder="Citizen feedback note (e.g. Cleanly repaired / debris left / hole still visible)"
                  className="w-full bg-white border border-slate-300 rounded-xl px-4 py-2.5 text-xs text-slate-800 focus:outline-none focus:ring-2 focus:ring-teal-400"
                />
                <div className="flex flex-wrap items-center gap-2.5">
                  <button
                    onClick={() => handleVerify('YES')}
                    disabled={verifying}
                    className="px-4 py-2.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs flex items-center gap-1.5 shadow-md transition-all active:scale-95"
                  >
                    <CheckCircle2 className="w-4 h-4" /> 1. Yes, the problem is resolved
                  </button>
                  <button
                    onClick={() => handleVerify('NO')}
                    disabled={verifying}
                    className="px-4 py-2.5 rounded-xl bg-rose-600 hover:bg-rose-700 text-white font-bold text-xs flex items-center gap-1.5 shadow-md transition-all active:scale-95"
                  >
                    <XCircle className="w-4 h-4" /> 2. No, I am still facing this problem
                  </button>
                  <button
                    onClick={() => handleVerify('PARTIALLY_RESOLVED')}
                    disabled={verifying}
                    className="px-4 py-2.5 rounded-xl bg-amber-500 hover:bg-amber-600 text-white font-bold text-xs flex items-center gap-1.5 shadow-md transition-all active:scale-95"
                  >
                    <AlertTriangle className="w-4 h-4" /> 3. Partially resolved
                  </button>
                </div>
              </div>
            )}
          </div>
        )}

        {/* Tab Navigation */}
        <div className="flex items-center gap-2 border-b border-slate-200 pb-2">
          <button
            onClick={() => setActiveTab('overview')}
            className={`px-4 py-2 rounded-xl text-xs font-bold flex items-center gap-2 transition-all ${
              activeTab === 'overview'
                ? 'bg-cyan-500 text-slate-950 shadow-md'
                : 'bg-white text-slate-500 hover:text-white hover:bg-slate-100'
            }`}
          >
            <Camera className="w-3.5 h-3.5" /> Overview & Evidence
          </button>

          <button
            onClick={() => setActiveTab('reports')}
            className={`px-4 py-2 rounded-xl text-xs font-bold flex items-center gap-2 transition-all ${
              activeTab === 'reports'
                ? 'bg-cyan-500 text-slate-950 shadow-md'
                : 'bg-white text-slate-500 hover:text-white hover:bg-slate-100'
            }`}
          >
            <Users className="w-3.5 h-3.5" /> Citizen Reports ({totalReportsCount})
          </button>

          <button
            onClick={() => setActiveTab('ai_analysis')}
            className={`px-4 py-2 rounded-xl text-xs font-bold flex items-center gap-2 transition-all ${
              activeTab === 'ai_analysis'
                ? 'bg-cyan-500 text-slate-950 shadow-md'
                : 'bg-white text-slate-500 hover:text-white hover:bg-slate-100'
            }`}
          >
            <Sparkles className="w-3.5 h-3.5" /> AI Intelligence & Priority Breakdown
          </button>

          <button
            onClick={() => setActiveTab('activity_log')}
            className={`px-4 py-2 rounded-xl text-xs font-bold flex items-center gap-2 transition-all ${
              activeTab === 'activity_log'
                ? 'bg-cyan-500 text-slate-950 shadow-md'
                : 'bg-white text-slate-500 hover:text-white hover:bg-slate-100'
            }`}
          >
            <Activity className="w-3.5 h-3.5" /> Immutable Audit Trail
          </button>
        </div>

        {/* TAB 1: OVERVIEW & EVIDENCE */}
        {activeTab === 'overview' && (
          <div className="space-y-8">
            {/* Photographic Evidence Comparison */}
            <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-5">
              <h3 className="text-base font-bold text-slate-900 flex items-center gap-2">
                <Camera className="w-5 h-5 text-teal-500" />
                Ground Photographic Evidence & AI Verification
              </h3>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {/* Before Photo */}
                <div className="space-y-2">
                  <div className="flex items-center justify-between text-xs">
                    <span className="font-bold text-red-500">Original Defect Photograph</span>
                    <span className="text-slate-500 font-mono">Reported Frame</span>
                  </div>
                  <div className="h-64 rounded-xl overflow-hidden bg-sky-50 border border-slate-200 relative">
                    <img
                      src={issue.images?.[0]?.annotated_image_path || issue.images?.[0]?.original_image_path || '/uploads/original/sample_infra.jpg'}
                      alt="Original Defect"
                      className="w-full h-full object-cover"
                    />
                    {issue.ai_confidence && (
                      <div className="absolute top-3 left-3 bg-sky-50/90 text-teal-600 text-xs px-2.5 py-1 rounded-md border border-teal-200 font-mono">
                        Detection: {intToPct(issue.ai_confidence)}%
                      </div>
                    )}
                  </div>
                </div>

                {/* After Photo */}
                <div className="space-y-2">
                  <div className="flex items-center justify-between text-xs">
                    <span className="font-bold text-emerald-400">After-Repair Remediation Photo</span>
                    <span className="text-slate-500 font-mono">Officer Proof</span>
                  </div>
                  <div className="h-64 rounded-xl overflow-hidden bg-sky-50 border border-slate-200 flex items-center justify-center relative">
                    {issue.resolution_image_path ? (
                      <img
                        src={issue.resolution_image_path}
                        alt="Remediation Proof"
                        className="w-full h-full object-cover"
                      />
                    ) : (
                      <div className="text-center p-6 text-slate-500 space-y-2">
                        <Clock className="w-8 h-8 mx-auto text-slate-600" />
                        <p className="text-xs">Remediation in progress. Department repair photograph pending upload.</p>
                      </div>
                    )}
                  </div>
                </div>
              </div>

              {/* AI Comparison Assessment Callout */}
              {aiComparisonObj && (
                <div className="p-4 rounded-xl bg-sky-50 border border-slate-200 text-xs space-y-2">
                  <div className="flex items-center justify-between font-bold">
                    <span className="text-teal-400 flex items-center gap-1.5">
                      <Sparkles className="w-4 h-4" /> AI Ground Remediation Assessment
                    </span>
                    <span className="text-teal-600 font-mono font-bold">
                      Remediation Confidence: {intToPct(aiComparisonObj.repair_confidence)}%
                    </span>
                  </div>
                  <p className="text-slate-600">{aiComparisonObj.ai_assessment_notes}</p>
                  <div className="text-[11px] text-slate-500 italic">
                    * Note: AI evidence assessment assists decision making; citizen ground sign-off is the final authority.
                  </div>
                </div>
              )}

              {issue.resolution_notes && (
                <div className="p-3.5 rounded-xl bg-sky-50/70 border border-slate-200 text-xs space-y-1">
                  <strong className="text-slate-600">Department Repair Log:</strong>
                  <p className="text-slate-500">{issue.resolution_notes}</p>
                </div>
              )}
            </div>

            {/* Details & Routing */}
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
              {/* Left: Summary & Description */}
              <div className="lg:col-span-2 space-y-6">
                <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-4">
                  <h3 className="text-base font-bold text-slate-900 flex items-center gap-2">
                    <FileText className="w-4 h-4 text-teal-500" />
                    Problem Summary & Description
                  </h3>

                  {issue.summary && (
                    <div className="p-3.5 rounded-xl bg-teal-50/30 border border-teal-200/60 text-xs text-cyan-200">
                      <strong className="block font-semibold mb-1 text-teal-600">AI Synthesized Issue Summary:</strong>
                      {issue.summary}
                    </div>
                  )}

                  <div className="p-4 rounded-xl bg-sky-50 border border-slate-200 text-xs text-slate-600 whitespace-pre-line leading-relaxed">
                    {issue.description || 'No direct description submitted.'}
                  </div>

                  {issue.priority_explanation && (
                    <div className="p-3.5 rounded-xl bg-sky-50/60 border border-slate-200 text-xs text-slate-500">
                      <strong className="block text-slate-600 mb-0.5">Priority Justification:</strong>
                      {issue.priority_explanation}
                    </div>
                  )}
                </div>
              </div>

              {/* Right: Department & Officer Card */}
              <div className="space-y-6">
                <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-4">
                  <h3 className="text-base font-bold text-slate-900 flex items-center gap-2">
                    <Building2 className="w-4 h-4 text-purple-600" />
                    Assigned Municipal Unit
                  </h3>

                  <div className="p-3.5 rounded-xl bg-sky-50 border border-slate-200 space-y-1 text-xs">
                    <span className="text-slate-500">Department:</span>
                    <p className="font-bold text-slate-900 text-sm">{issue.assigned_department || issue.department?.name || 'Pending Route'}</p>
                    <p className="text-teal-500 font-mono">{issue.department?.code}</p>
                  </div>

                  <div className="p-3.5 rounded-xl bg-sky-50 border border-slate-200 space-y-1 text-xs">
                    <span className="text-slate-500">Assigned Officer / Field Engineer:</span>
                    <p className="font-bold text-slate-900">{issue.assigned_officer_name || issue.assigned_officer?.full_name || 'Dispatch Pending'}</p>
                    {issue.assigned_officer?.email && <p className="text-slate-500">{issue.assigned_officer.email}</p>}
                  </div>

                  <button
                    onClick={handleRequestInspection}
                    className="w-full py-2.5 rounded-xl bg-sky-50 hover:bg-slate-50 border border-slate-200 text-xs font-semibold text-slate-600 flex items-center justify-center gap-2 transition-colors"
                  >
                    <ShieldAlert className="w-4 h-4 text-amber-400" /> Request Independent Physical Audit
                  </button>
                </div>
              </div>
            </div>
          </div>
        )}

        {/* TAB 2: CITIZEN REPORTS */}
        {activeTab === 'reports' && (
          <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-6">
            <div className="flex flex-wrap items-center justify-between gap-3 border-b border-slate-200 pb-4">
              <div>
                <h3 className="text-base font-bold text-slate-900 flex items-center gap-2">
                  <Users className="w-5 h-5 text-teal-500" />
                  Individual Citizen Reports Linked to {displayId}
                </h3>
                <p className="text-xs text-slate-500 mt-1">
                  Each report represents a unique citizen submission consolidated under this civic problem.
                </p>
              </div>
              <div className="flex items-center gap-2 text-xs">
                <span className="px-3 py-1 bg-teal-50 border border-teal-200 text-teal-600 rounded-full font-mono font-bold">
                  Total: {totalReportsCount} Reports
                </span>
                <span className="px-3 py-1 bg-purple-50 border border-purple-200 text-purple-600 rounded-full font-mono font-bold">
                  {uniqueCitizensCount} Unique Citizens
                </span>
              </div>
            </div>

            {loadingReports ? (
              <div className="text-center py-12 text-slate-500 flex items-center justify-center gap-2 text-xs">
                <RefreshCw className="w-4 h-4 animate-spin text-teal-500" /> Loading citizen reports...
              </div>
            ) : reports.length === 0 ? (
              <div className="text-center py-12 text-slate-500 text-xs">
                No individual report details found. The primary complaint description is stored on the issue.
              </div>
            ) : (
              <div className="space-y-4">
                {reports.map((rep, idx) => {
                  const repStatus = rep.status || 'accepted';
                  const repImg = (rep.images && rep.images[0]) || (rep.media && rep.media[0]?.image_url);

                  return (
                    <div
                      key={rep.id || idx}
                      className="p-4 rounded-xl bg-sky-50 border border-slate-200 space-y-3 hover:border-slate-700 transition-colors"
                    >
                      <div className="flex flex-wrap items-center justify-between gap-2 border-b border-slate-200 pb-2.5">
                        <div className="flex items-center gap-2">
                          <span className="text-xs font-mono font-bold text-teal-500">
                            {rep.report_tracking_id || `REP-${rep.id}`}
                          </span>
                          <span className={`text-[10px] font-semibold px-2 py-0.5 rounded-full border ${
                            rep.link_method === 'auto_ai' ? 'bg-emerald-50 text-emerald-600 border-emerald-200' :
                            rep.link_method === 'manual_admin' ? 'bg-purple-50/70 text-purple-600 border-purple-200' :
                            'bg-teal-50 text-teal-600 border-teal-200'
                          }`}>
                            {rep.link_method === 'auto_ai' ? 'AI Linked' :
                             rep.link_method === 'manual_admin' ? 'Admin Linked' : 'Original Report'}
                          </span>
                          <span className={`text-[10px] font-semibold px-2 py-0.5 rounded-full ${
                            repStatus === 'accepted' ? 'bg-teal-50 text-teal-600 border border-teal-200' :
                            repStatus === 'pending_review' ? 'bg-amber-50 text-amber-600 border border-amber-200' :
                            'bg-red-50 text-red-600 border border-red-200'
                          }`}>
                            {repStatus.toUpperCase()}
                          </span>
                        </div>
                        <span className="text-[11px] text-slate-500 font-mono">
                          {new Date(rep.created_at).toLocaleString()}
                        </span>
                      </div>

                      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 text-xs">
                        <div className="md:col-span-3 space-y-2">
                          <p className="text-slate-600 leading-relaxed bg-slate-50/50 p-2.5 rounded-lg border border-slate-200/50">
                            "{rep.description || 'No additional note provided'}"
                          </p>
                          <div className="flex flex-wrap items-center gap-4 text-[11px] text-slate-500">
                            <span><strong>Reporter:</strong> {rep.reporter_name || 'Anonymous Citizen'}</span>
                            {rep.reporter_phone && <span><strong>Contact:</strong> {rep.reporter_phone}</span>}
                            {rep.gps_accuracy && <span><strong>GPS Accuracy:</strong> ±{rep.gps_accuracy.toFixed(1)}m</span>}
                            {rep.repeat_reporter && (
                              <span className="text-amber-400 bg-amber-50/60 px-1.5 py-0.5 rounded border border-amber-200">
                                Recurring Reporter
                              </span>
                            )}
                          </div>
                        </div>

                        {/* Photo evidence if any */}
                        <div className="flex items-center justify-end">
                          {repImg ? (
                            <div className="w-20 h-20 rounded-lg overflow-hidden border border-slate-200 bg-slate-50 shrink-0">
                              <img
                                src={repImg}
                                alt="Citizen Evidence"
                                className="w-full h-full object-cover"
                              />
                            </div>
                          ) : (
                            <div className="w-20 h-20 rounded-lg border border-slate-200 bg-white flex items-center justify-center text-[10px] text-slate-600 shrink-0">
                              No Photo
                            </div>
                          )}
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        )}

        {/* TAB 3: AI INTELLIGENCE & PRIORITY BREAKDOWN */}
        {activeTab === 'ai_analysis' && (
          <div className="space-y-6">
            {loadingAi ? (
              <div className="text-center py-12 text-slate-500 flex items-center justify-center gap-2 text-xs">
                <RefreshCw className="w-4 h-4 animate-spin text-purple-600" /> Loading AI Intelligence telemetry...
              </div>
            ) : (() => {
              const priorityScore = aiAnalysis?.current_priority?.score ?? aiAnalysis?.priority_score ?? issue.priority_score ?? 50;
              const priorityLevel = aiAnalysis?.current_priority?.level ?? aiAnalysis?.priority_level ?? issue.priority_level ?? 'MEDIUM';
              const priorityBreakdown = aiAnalysis?.current_priority?.breakdown ?? aiAnalysis?.priority_breakdown;
              const severityObj = aiAnalysis?.current_severity ?? aiAnalysis?.severity_assessment;
              const duplicateMatches = aiAnalysis?.duplicate_detection_matches ?? aiAnalysis?.duplicate_matches ?? [];

              return (
                <>
                  {/* 1. Dynamic Priority Formula 0-100 Breakdown */}
                  <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-4">
                    <div className="flex flex-wrap items-center justify-between gap-3 border-b border-slate-200 pb-3">
                      <div>
                        <h3 className="text-base font-bold text-slate-900 flex items-center gap-2">
                          <TrendingUp className="w-5 h-5 text-purple-600" />
                          Dynamic Priority Calculation (0–100 Scale)
                        </h3>
                        <p className="text-xs text-slate-500 mt-0.5">
                          Formula: (Severity × 0.35) + (Safety × 0.25) + (Population × 0.15) + (Duration × 0.10) + (Citizens × 0.10) + (Trend × 0.05)
                        </p>
                      </div>
                      <div className="text-right">
                        <span className="text-2xl font-black text-purple-600 font-mono">
                          {priorityScore}
                        </span>
                        <span className="text-xs text-slate-500 font-medium block">
                          Rank: {priorityLevel}
                        </span>
                      </div>
                    </div>

                    {/* Factor Breakdown Bars */}
                    {priorityBreakdown ? (
                      <div className="grid grid-cols-1 md:grid-cols-2 gap-4 pt-2">
                        {Object.entries(priorityBreakdown).map(([factorKey, factorData]: [string, any]) => {
                          const score = factorData.score || 0;
                          const weightPct = Math.round((factorData.weight || 0.1) * 100);
                          const points = factorData.weighted_points || 0;

                          return (
                            <div key={factorKey} className="p-3 rounded-xl bg-sky-50 border border-slate-200 space-y-1.5">
                              <div className="flex items-center justify-between text-xs font-semibold">
                                <span className="text-slate-600 capitalize">
                                  {factorKey.replace(/_/g, ' ')} ({weightPct}%)
                                </span>
                                <span className="text-teal-500 font-mono">
                                  +{points} pts <span className="text-slate-500 font-normal">({score}/100)</span>
                                </span>
                              </div>
                              <div className="w-full h-2 bg-slate-50 rounded-full overflow-hidden">
                                <div
                                  className="h-full bg-gradient-to-r from-cyan-500 to-purple-500 rounded-full transition-all duration-700"
                                  style={{ width: `${Math.min(100, Math.max(0, score))}%` }}
                                />
                              </div>
                            </div>
                          );
                        })}
                      </div>
                    ) : (
                      <div className="p-4 rounded-xl bg-sky-50 border border-slate-200 text-xs text-slate-500">
                        Standard multi-factor score active. Priority updates automatically on new citizen reports and SLA aging.
                      </div>
                    )}
                  </div>

                  {/* 2. Evidence-Based Severity Assessment */}
                  <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-4">
                    <div className="flex items-center justify-between border-b border-slate-200 pb-3">
                      <h3 className="text-base font-bold text-slate-900 flex items-center gap-2">
                        <AlertOctagon className="w-5 h-5 text-amber-400" />
                        Physical Severity Assessment
                      </h3>
                      <span className="text-xs font-mono font-bold bg-amber-50 text-amber-600 border border-amber-200 px-3 py-1 rounded-full">
                        Score: {severityObj?.score || severityObj?.severity_score || issue.severity_score || 50}/100 ({severityObj?.level || severityObj?.severity_level || issue.severity_level || 'MEDIUM'})
                      </span>
                    </div>

                    {severityObj ? (
                      <div className="space-y-4 text-xs">
                        <div className="p-3.5 rounded-xl bg-sky-50 border border-slate-200 space-y-2">
                          <strong className="text-slate-600 block">AI Severity Justification & Reasoning:</strong>
                          <p className="text-slate-500 leading-relaxed">
                            {severityObj.explanation || severityObj.ai_reasoning || 'Severity computed via computer vision analysis and municipal hazard matrices.'}
                          </p>
                        </div>

                        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
                          <div className="p-3 rounded-xl bg-sky-50 border border-slate-200">
                            <span className="text-slate-500 block text-[10px]">Hazard Factors</span>
                            <span className="text-slate-600 font-semibold mt-0.5 block truncate">
                              {Array.isArray(severityObj.risk_factors)
                                ? severityObj.risk_factors.join(', ')
                                : Array.isArray(severityObj.hazard_factors)
                                ? severityObj.hazard_factors.join(', ')
                                : 'Standard Obstruction'}
                            </span>
                          </div>

                          <div className="p-3 rounded-xl bg-sky-50 border border-slate-200">
                            <span className="text-slate-500 block text-[10px]">Physical Scale</span>
                            <span className="text-slate-600 font-semibold mt-0.5 block">
                              {severityObj.physical_dimensions
                                ? JSON.stringify(severityObj.physical_dimensions)
                                : 'Substantial Area'}
                            </span>
                          </div>

                          <div className="p-3 rounded-xl bg-sky-50 border border-slate-200">
                            <span className="text-slate-500 block text-[10px]">Escalation Status</span>
                            <span className="text-slate-600 font-semibold mt-0.5 block capitalize">
                              {severityObj.escalation_status || 'Stable'}
                            </span>
                          </div>

                          <div className="p-3 rounded-xl bg-sky-50 border border-slate-200">
                            <span className="text-slate-500 block text-[10px]">AI Model Used</span>
                            <span className="text-teal-500 font-mono text-[11px] mt-0.5 block truncate">
                              {severityObj.model_name || 'NagarSetu Vision Engine'}
                            </span>
                          </div>
                        </div>
                      </div>
                    ) : (
                      <div className="p-4 rounded-xl bg-sky-50 border border-slate-200 text-xs text-slate-500">
                        Standard severity evaluation assigned. Assessed against municipal safety benchmarks.
                      </div>
                    )}
                  </div>

                  {/* 3. Duplicate Detection Matches & Similarity */}
                  {duplicateMatches && duplicateMatches.length > 0 && (
                    <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-4">
                      <h3 className="text-base font-bold text-slate-900 flex items-center gap-2">
                        <Layers className="w-5 h-5 text-teal-500" />
                        Multi-Factor Similarity Records
                      </h3>

                      <div className="space-y-3">
                        {duplicateMatches.map((match: any, idx: number) => (
                          <div key={idx} className="p-3.5 rounded-xl bg-sky-50 border border-slate-200 text-xs space-y-2">
                            <div className="flex items-center justify-between font-semibold">
                              <span className="text-slate-900">Report #{match.report_id} Link Assessment</span>
                              <span className="text-teal-500 font-mono font-bold">
                                Final Similarity: {(match.final_score * 100).toFixed(1)}%
                              </span>
                            </div>

                            <div className="grid grid-cols-4 gap-2 text-[11px] text-slate-500 font-mono pt-1">
                              <div>Geo: {(match.geo_similarity * 100).toFixed(0)}%</div>
                              <div>Visual: {(match.visual_similarity * 100).toFixed(0)}%</div>
                              <div>Text: {(match.text_similarity * 100).toFixed(0)}%</div>
                              <div>Context: {(match.context_similarity * 100).toFixed(0)}%</div>
                            </div>

                            {match.ai_reasoning && (
                              <p className="text-slate-500 italic text-[11px] bg-slate-50 p-2 rounded">
                                "{match.ai_reasoning}"
                              </p>
                            )}
                          </div>
                        ))}
                      </div>
                    </div>
                  )}
                </>
              );
            })()}
          </div>
        )}

        {/* TAB 4: IMMUTABLE AUDIT TRAIL */}
        {activeTab === 'activity_log' && (
          <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-6">
            <div className="border-b border-slate-200 pb-3">
              <h3 className="text-base font-bold text-slate-900 flex items-center gap-2">
                <Activity className="w-5 h-5 text-indigo-400" />
                Immutable NagarSetu Activity Audit Log
              </h3>
              <p className="text-xs text-slate-500 mt-0.5">
                Complete traceability of report submissions, AI duplicate links, severity recalculations, and administrative decisions.
              </p>
            </div>

            {loadingLogs ? (
              <div className="text-center py-12 text-slate-500 flex items-center justify-center gap-2 text-xs">
                <RefreshCw className="w-4 h-4 animate-spin text-indigo-400" /> Loading audit trail...
              </div>
            ) : activityLogs.length === 0 ? (
              <div className="text-center py-12 text-slate-500 text-xs">
                No special activity log items recorded yet. Standard issue history available in overview.
              </div>
            ) : (
              <div className="space-y-4 relative before:absolute before:left-3 before:top-3 before:bottom-3 before:w-0.5 before:bg-slate-100">
                {activityLogs.map((log) => {
                  const actionName = (log.action || log.action_type || 'ACTIVITY').replace(/_/g, ' ');
                  const logDesc = log.notes || log.description || 'Audit event logged.';
                  const actor = log.actor_name || log.actor_role || log.actor_type || 'System';

                  return (
                    <div key={log.id} className="relative pl-8 space-y-1">
                      <div className="absolute left-1.5 top-1.5 w-3 h-3 rounded-full bg-cyan-400 ring-4 ring-slate-950" />
                      <div className="flex flex-wrap items-center justify-between text-xs gap-2">
                        <span className="font-semibold text-teal-600 font-mono capitalize">
                          {actionName}
                        </span>
                        <span className="text-slate-500 font-mono text-[11px]">
                          {new Date(log.created_at).toLocaleString()}
                        </span>
                      </div>
                      <p className="text-xs text-slate-600">{logDesc}</p>
                      <div className="flex items-center gap-3 text-[10px] text-slate-500 font-mono">
                        <span>Actor: {actor}</span>
                        {log.actor_id && <span>(ID #{log.actor_id})</span>}
                      </div>
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        )}

        {/* 4. PRIORITY OVERRIDE MODAL */}
        {showOverrideModal && (
          <div className="fixed inset-0 z-50 bg-sky-50/80 backdrop-blur-sm flex items-center justify-center p-4">
            <div className="bg-slate-50 border border-amber-600/60 rounded-2xl max-w-md w-full p-6 space-y-4 shadow-2xl">
              <h4 className="text-base font-bold text-slate-900 flex items-center gap-2">
                <AlertTriangle className="w-5 h-5 text-amber-400" />
                Override Priority Score
              </h4>
              <p className="text-xs text-slate-500">
                Adjust priority based on special conditions (e.g. VVIP route, school peak hours). Recorded in audit trail.
              </p>

              <div className="space-y-1">
                <label className="text-xs text-slate-600 font-medium">New Score (0-100): {newPriority}</label>
                <input
                  type="range"
                  min="0"
                  max="100"
                  value={newPriority}
                  onChange={(e) => setNewPriority(Number(e.target.value))}
                  className="w-full accent-cyan-500"
                />
              </div>

              <div className="space-y-1">
                <label className="text-xs text-slate-600 font-medium">Official Justification (Mandatory):</label>
                <textarea
                  rows={2}
                  value={overrideReason}
                  onChange={(e) => setOverrideReason(e.target.value)}
                  placeholder="State reason for overriding AI priority..."
                  className="w-full bg-sky-50 border border-slate-200 rounded-xl p-2.5 text-xs text-slate-700"
                />
              </div>

              <div className="flex justify-end gap-2 pt-2 border-t border-slate-200">
                <button
                  type="button"
                  onClick={() => setShowOverrideModal(false)}
                  className="px-3 py-1.5 rounded-lg bg-slate-100 text-xs font-semibold text-slate-600"
                >
                  Cancel
                </button>
                <button
                  type="button"
                  onClick={handleOverridePriority}
                  disabled={overrideSubmitting}
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

function intToPct(val: number): number {
  return Math.round(val <= 1.0 ? val * 100 : val);
}

