import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { citizenService } from '../services/api';
import { Issue, IssueStatus } from '../types';
import { PriorityBadge } from '../components/common/PriorityBadge';
import { StatusBadge } from '../components/common/StatusBadge';
import {
  PlusCircle, CheckCircle2, Clock, AlertTriangle, ArrowRight,
  ShieldCheck, Eye, RefreshCw, MapPin, Sparkles, XCircle, CheckSquare
} from 'lucide-react';

const formatDate = (d?: string | null) => (d ? new Date(d).toLocaleDateString('en-IN', { day: 'numeric', month: 'short', year: 'numeric' }) : '—');

export const CitizenDashboardPage: React.FC = () => {
  const [stats, setStats] = useState<any>(null);
  const [reports, setReports] = useState<Issue[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  // Verification Modal State
  const [verifyingIssue, setVerifyingIssue] = useState<Issue | null>(null);
  const [feedbackNotes, setFeedbackNotes] = useState('');
  const [reopenReason, setReopenReason] = useState('');
  const [actionLoading, setActionLoading] = useState(false);

  const fetchDashboardData = () => {
    setLoading(true);
    Promise.all([citizenService.stats(), citizenService.reports({ limit: 8 })])
      .then(([s, r]) => {
        setStats(s);
        setReports(r);
      })
      .catch(() => setError('Unable to load your citizen dashboard. Please try again.'))
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    fetchDashboardData();
  }, []);

  const handleConfirmResolution = async (confirmed: boolean) => {
    if (!verifyingIssue) return;
    setActionLoading(true);
    try {
      await citizenService.verify(verifyingIssue.id, confirmed, feedbackNotes, reopenReason);
      setVerifyingIssue(null);
      setFeedbackNotes('');
      setReopenReason('');
      fetchDashboardData();
    } catch {
      alert('Failed to process verification response. Please try again.');
    } finally {
      setActionLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-sky-50 flex items-center justify-center">
        <div className="flex items-center gap-3">
          <RefreshCw className="w-5 h-5 text-teal-500 animate-spin" />
          <span>Loading your NagarSetu Citizen Workspace...</span>
        </div>
      </div>
    );
  }

  // Find any complaints currently awaiting citizen verification
  const pendingVerifications = reports.filter(
    (i) => i.status === IssueStatus.RESOLUTION_SUBMITTED || i.status === IssueStatus.CITIZEN_VERIFICATION
  );

  return (
    <div className="min-h-screen bg-sky-50 py-8 px-4 sm:px-6 lg:px-8">
      <div className="max-w-7xl mx-auto space-y-8">
        {/* Header */}
        <div className="flex flex-wrap items-center justify-between gap-4 border-b border-slate-200 pb-6">
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-teal-50 border border-teal-200 text-teal-600 text-xs font-semibold mb-2">
              <Sparkles className="w-3.5 h-3.5 text-teal-500" /> NAGARSETU CITIZEN PORTAL
            </div>
            <h1 className="text-3xl font-extrabold text-slate-900 tracking-tight">Citizen Dashboard</h1>
            <p className="text-sm text-slate-500 mt-1">
              Track your reported infrastructure issues, endorse community reports, and verify official ground repairs.
            </p>
          </div>
          <Link
            to="/report"
            className="px-5 py-3 rounded-xl bg-gradient-to-r from-cyan-500 to-emerald-500 hover:from-cyan-400 hover:to-emerald-400 text-slate-950 font-bold text-sm flex items-center gap-2 shadow-lg shadow-cyan-950 transition-all transform hover:-translate-y-0.5"
          >
            <PlusCircle className="w-4 h-4" /> Report New Issue
          </Link>
        </div>

        {error && (
          <div className="p-4 rounded-xl bg-red-50/40 border border-red-200 text-red-600 text-sm">
            {error}
          </div>
        )}

        {/* 1. CITIZEN-VERIFIED RESOLUTION ACTION BANNER */}
        {pendingVerifications.length > 0 && (
          <div className="p-6 rounded-2xl bg-gradient-to-r from-teal-950/60 via-slate-900 to-cyan-950/60 border border-teal-500/50 shadow-xl space-y-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2.5 text-teal-300 font-bold text-base">
                <CheckSquare className="w-5 h-5 text-teal-400" />
                <span>Action Required: Official Repair Submitted for Ground Verification</span>
              </div>
              <span className="text-xs bg-teal-900 text-teal-200 px-3 py-1 rounded-full font-mono font-bold">
                {pendingVerifications.length} Awaiting Your Sign-Off
              </span>
            </div>
            <p className="text-sm text-slate-600">
              Department officers have uploaded after-repair evidence for your complaint. NagarSetu will <strong>not close this ticket</strong> until you confirm the fix on ground.
            </p>
            <div className="grid sm:grid-cols-2 gap-4 pt-1">
              {pendingVerifications.map((item) => (
                <div key={item.id} className="p-4 rounded-xl bg-sky-50/80 border border-teal-200/80 flex items-center justify-between gap-4">
                  <div className="min-w-0">
                    <div className="text-sm font-bold text-slate-900 truncate">{item.title}</div>
                    <div className="text-xs text-slate-500 mt-1 flex items-center gap-2">
                      <span>{item.department?.name || 'Department'}</span>
                      <span>•</span>
                      <span className="text-teal-300 font-medium">Repair photos uploaded</span>
                    </div>
                  </div>
                  <button
                    type="button"
                    onClick={() => setVerifyingIssue(item)}
                    className="px-4 py-2 rounded-lg bg-teal-500 hover:bg-teal-400 text-slate-950 font-bold text-xs flex-shrink-0 shadow-md transition-colors"
                  >
                    Inspect & Verify
                  </button>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* 2. STATS OVERVIEW CARDS */}
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-4">
          <div className="p-4 rounded-2xl bg-white border border-slate-200">
            <div className="text-xs text-slate-500 font-medium">Total Reports</div>
            <div className="text-2xl sm:text-3xl font-extrabold text-teal-500 font-mono mt-1">
              {stats?.total_issues || 0}
            </div>
          </div>
          <div className="p-4 rounded-2xl bg-white border border-slate-200">
            <div className="text-xs text-slate-500 font-medium">Under Review</div>
            <div className="text-2xl sm:text-3xl font-extrabold text-purple-400 font-mono mt-1">
              {stats?.under_review || 0}
            </div>
          </div>
          <div className="p-4 rounded-2xl bg-white border border-slate-200">
            <div className="text-xs text-slate-500 font-medium">Assigned / In Progress</div>
            <div className="text-2xl sm:text-3xl font-extrabold text-teal-600 font-mono mt-1">
              {(stats?.assigned || 0) + (stats?.in_progress || 0)}
            </div>
          </div>
          <div className="p-4 rounded-2xl bg-white border border-slate-200">
            <div className="text-xs text-slate-500 font-medium">Awaiting Verification</div>
            <div className="text-2xl sm:text-3xl font-extrabold text-teal-400 font-mono mt-1">
              {stats?.awaiting_verification || pendingVerifications.length}
            </div>
          </div>
          <div className="p-4 rounded-2xl bg-white border border-slate-200">
            <div className="text-xs text-slate-500 font-medium">Confirmed Resolved</div>
            <div className="text-2xl sm:text-3xl font-extrabold text-emerald-400 font-mono mt-1">
              {stats?.resolved || 0}
            </div>
          </div>
          <div className="p-4 rounded-2xl bg-white border border-slate-200">
            <div className="text-xs text-slate-500 font-medium">Critical / High</div>
            <div className="text-2xl sm:text-3xl font-extrabold text-red-500 font-mono mt-1">
              {stats?.high_priority || 0}
            </div>
          </div>
        </div>

        {/* 3. RECENT COMPLAINTS TABLE & CARDS */}
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <h2 className="text-xl font-bold text-slate-900 flex items-center gap-2">
              <Clock className="w-5 h-5 text-teal-500" />
              <span>Your Reported Complaints</span>
            </h2>
            <Link to="/my-reports" className="text-sm font-semibold text-teal-500 hover:text-teal-600 flex items-center gap-1">
              View All Reports ({stats?.total_issues || 0}) <ArrowRight className="w-4 h-4" />
            </Link>
          </div>

          {reports.length === 0 ? (
            <div className="p-12 text-center rounded-2xl bg-white border border-slate-200 space-y-3">
              <CheckCircle2 className="w-12 h-12 text-slate-600 mx-auto" />
              <p className="text-base text-slate-600">No civic complaints reported yet.</p>
              <Link
                to="/report"
                className="inline-flex items-center gap-2 px-4 py-2 rounded-xl bg-cyan-600 text-slate-900 font-semibold text-sm"
              >
                <PlusCircle className="w-4 h-4" /> Report Your First Defect
              </Link>
            </div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {reports.map((issue) => (
                <div
                  key={issue.id}
                  className="rounded-2xl border border-slate-200 bg-slate-50/70 hover:border-slate-700 transition-all p-5 flex flex-col justify-between space-y-4"
                >
                  <div className="space-y-3">
                    <div className="flex items-start justify-between gap-3">
                      <div>
                        <span className="text-xs font-mono text-slate-500">Ticket #{issue.id}</span>
                        <h3 className="font-bold text-base text-slate-900 hover:text-teal-600 transition-colors">
                          <Link to={`/issue/${issue.id}`}>{issue.title}</Link>
                        </h3>
                      </div>
                      <StatusBadge status={issue.status} />
                    </div>

                    <div className="flex flex-wrap items-center gap-3 text-xs text-slate-500">
                      <PriorityBadge score={issue.priority_score} severity={issue.severity} />
                      <span className="flex items-center gap-1 text-slate-600">
                        <MapPin className="w-3.5 h-3.5 text-teal-500" />
                        {issue.address ? issue.address.split(',')[0] : 'GPS Mapped'}
                      </span>
                      <span>Filed: {formatDate(issue.created_at)}</span>
                    </div>

                    {/* Progress Bar */}
                    <div className="space-y-1">
                      <div className="flex justify-between text-xs text-slate-500">
                        <span>Resolution Progress</span>
                        <span className="font-mono text-teal-600 font-bold">{issue.progress_percentage || 0}%</span>
                      </div>
                      <div className="h-2 w-full bg-sky-50 rounded-full overflow-hidden border border-slate-200">
                        <div
                          className="h-full bg-gradient-to-r from-cyan-500 to-emerald-400 rounded-full transition-all duration-500"
                          style={{ width: `${issue.progress_percentage || 0}%` }}
                        />
                      </div>
                    </div>

                    <p className="text-xs text-slate-500 bg-sky-50/60 p-2.5 rounded-xl border border-slate-200">
                      <strong className="text-slate-600">Latest Action:</strong> {issue.latest_update || 'Complaint routed to department lead.'}
                    </p>
                  </div>

                  {/* Actions Bar */}
                  <div className="flex items-center justify-between pt-2 border-t border-slate-200 text-xs">
                    <span className="text-slate-500">
                      {issue.support_count || 1} community endorsement(s)
                    </span>
                    <div className="flex items-center gap-3">
                      {(issue.status === IssueStatus.RESOLUTION_SUBMITTED || issue.status === IssueStatus.CITIZEN_VERIFICATION) && (
                        <button
                          type="button"
                          onClick={() => setVerifyingIssue(issue)}
                          className="text-teal-400 font-bold hover:underline flex items-center gap-1"
                        >
                          <CheckSquare className="w-3.5 h-3.5" /> Verify Repair
                        </button>
                      )}
                      <Link to={`/issue/${issue.id}`} className="text-teal-500 font-semibold hover:underline">
                        Details
                      </Link>
                      <Link to={`/issue/${issue.id}/track`} className="text-emerald-400 font-semibold hover:underline">
                        Live Tracking
                      </Link>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* 4. VERIFICATION MODAL */}
        {verifyingIssue && (
          <div className="fixed inset-0 z-50 bg-sky-50/80 backdrop-blur-sm flex items-center justify-center p-4">
            <div className="bg-slate-50 border border-teal-500/50 rounded-2xl max-w-2xl w-full p-6 space-y-5 shadow-2xl overflow-y-auto max-h-[90vh]">
              <div className="flex items-center justify-between border-b border-slate-200 pb-3">
                <div className="flex items-center gap-2 text-teal-400 font-bold">
                  <CheckSquare className="w-5 h-5" />
                  <span>Ground Repair Verification — Ticket #{verifyingIssue.id}</span>
                </div>
                <button
                  type="button"
                  onClick={() => setVerifyingIssue(null)}
                  className="text-slate-500 hover:text-slate-900"
                >
                  <XCircle className="w-5 h-5" />
                </button>
              </div>

              <div>
                <h4 className="text-base font-bold text-slate-900">{verifyingIssue.title}</h4>
                <p className="text-xs text-slate-500 mt-0.5">{verifyingIssue.address}</p>
              </div>

              {/* Before vs After Photos */}
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <span className="text-xs font-semibold text-red-500">Original Defect Photo</span>
                  <div className="h-44 rounded-xl overflow-hidden bg-sky-50 border border-slate-200">
                    <img
                      src={verifyingIssue.images?.[0]?.original_image_path || '/uploads/original/sample_infra.jpg'}
                      alt="Before Repair"
                      className="w-full h-full object-cover"
                    />
                  </div>
                </div>
                <div className="space-y-1.5">
                  <span className="text-xs font-semibold text-emerald-400">Official After-Repair Photo</span>
                  <div className="h-44 rounded-xl overflow-hidden bg-sky-50 border border-slate-200">
                    <img
                      src={verifyingIssue.resolution_image_path || '/uploads/original/sample_infra.jpg'}
                      alt="After Repair"
                      className="w-full h-full object-cover"
                    />
                  </div>
                </div>
              </div>

              {/* Officer Notes & AI Verification */}
              {verifyingIssue.resolution_notes && (
                <div className="p-3.5 rounded-xl bg-sky-50 border border-slate-200 text-xs space-y-1">
                  <span className="text-slate-500 font-semibold">Department Officer Notes:</span>
                  <p className="text-slate-700">{verifyingIssue.resolution_notes}</p>
                </div>
              )}

              {/* Feedback Inputs */}
              <div className="space-y-3 pt-2">
                <label className="text-xs font-semibold text-slate-600">
                  Citizen Ground Feedback (Optional if confirming) / Reopen Reason (Required if rejecting):
                </label>
                <textarea
                  rows={2}
                  value={feedbackNotes}
                  onChange={(e) => setFeedbackNotes(e.target.value)}
                  placeholder="e.g. Cleanly repaired, no potholes remain / Pothole only half filled, debris on road..."
                  className="w-full bg-sky-50 border border-slate-200 rounded-xl p-3 text-xs text-slate-700 focus:outline-none focus:border-cyan-500"
                />
              </div>

              {/* Decision Buttons */}
              <div className="flex flex-wrap items-center justify-end gap-3 pt-3 border-t border-slate-200">
                <button
                  type="button"
                  onClick={() => handleConfirmResolution(false)}
                  disabled={actionLoading}
                  className="px-4 py-2.5 rounded-xl bg-rose-900/60 hover:bg-rose-800 text-rose-200 font-bold text-xs flex items-center gap-1.5 border border-rose-700 transition-colors"
                >
                  <XCircle className="w-4 h-4" /> Reject & Reopen Complaint
                </button>
                <button
                  type="button"
                  onClick={() => handleConfirmResolution(true)}
                  disabled={actionLoading}
                  className="px-5 py-2.5 rounded-xl bg-emerald-500 hover:bg-emerald-400 text-slate-950 font-extrabold text-xs flex items-center gap-1.5 shadow-lg shadow-emerald-950 transition-colors"
                >
                  <CheckCircle2 className="w-4 h-4" /> Confirm Ground Fix & Resolve
                </button>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
