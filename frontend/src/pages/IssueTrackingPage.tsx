import React, { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { citizenService } from '../services/api';
import { Issue, IssueStatus } from '../types';
import { PriorityBadge } from '../components/common/PriorityBadge';
import { StatusBadge } from '../components/common/StatusBadge';
import {
  ArrowLeft, Clock, CheckCircle2, ShieldCheck, MapPin, Building2,
  AlertTriangle, CheckSquare, XCircle, Users, RefreshCw
} from 'lucide-react';

const TRACKING_FLOW = [
  IssueStatus.SUBMITTED,
  IssueStatus.AI_ANALYZED,
  IssueStatus.UNDER_REVIEW,
  IssueStatus.ASSIGNED,
  IssueStatus.IN_PROGRESS,
  IssueStatus.RESOLUTION_SUBMITTED,
  IssueStatus.RESOLVED,
];

export const IssueTrackingPage: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const [issue, setIssue] = useState<Issue | null>(null);
  const [timeline, setTimeline] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [verifying, setVerifying] = useState(false);
  const [feedback, setFeedback] = useState('');

  const loadTracking = () => {
    if (!id) return;
    setLoading(true);
    Promise.all([citizenService.details(+id), citizenService.timeline(+id)])
      .then(([i, t]) => {
        setIssue(i);
        setTimeline(t || []);
      })
      .catch(() => setError('Unable to load this complaint tracking timeline.'))
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    loadTracking();
  }, [id]);

  const handleVerify = async (confirmed: boolean) => {
    if (!issue) return;
    setVerifying(true);
    try {
      await citizenService.verify(issue.id, confirmed, feedback, feedback);
      loadTracking();
      setFeedback('');
    } catch {
      alert('Verification action failed.');
    } finally {
      setVerifying(false);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-sky-50 flex items-center justify-center text-slate-500">
        <div className="flex items-center gap-3">
          <RefreshCw className="w-5 h-5 text-teal-500 animate-spin" />
          <span>Tracking complaint resolution lifecycle...</span>
        </div>
      </div>
    );
  }

  if (error || !issue) {
    return (
      <div className="max-w-4xl mx-auto p-12 text-center space-y-4">
        <p className="text-red-500 font-semibold">{error || 'Complaint not found'}</p>
        <Link to="/dashboard" className="text-teal-500 text-sm font-semibold hover:underline">
          Return to Citizen Dashboard
        </Link>
      </div>
    );
  }

  const currentIdx = TRACKING_FLOW.indexOf(issue.status);

  return (
    <div className="min-h-screen bg-sky-50 text-slate-900 py-8 px-4 sm:px-6 lg:px-8 font-sans">
      <div className="max-w-4xl mx-auto space-y-8">
        <Link
          to={`/issue/${issue.id}`}
          className="inline-flex items-center gap-1.5 text-xs font-semibold text-teal-500 hover:underline"
        >
          <ArrowLeft className="w-4 h-4" /> Back to Issue Details
        </Link>

        {/* Header */}
        <div className="p-6 rounded-2xl bg-slate-50/70 border border-slate-200 space-y-3">
          <div className="flex flex-wrap items-center justify-between gap-3">
            <div className="flex items-center gap-2">
              <span className="text-xs font-mono text-teal-500 font-bold uppercase">
                Ticket #{issue.id}
              </span>
              <PriorityBadge score={issue.priority_score} severity={issue.severity} />
              <StatusBadge status={issue.status} />
            </div>
            <span className="text-xs text-slate-500">
              Lodged: {new Date(issue.created_at).toLocaleDateString('en-IN', { day: 'numeric', month: 'short', year: 'numeric' })}
            </span>
          </div>

          <h1 className="text-2xl font-bold text-white">{issue.title}</h1>
          <p className="text-xs text-slate-500 flex items-center gap-1.5">
            <MapPin className="w-3.5 h-3.5 text-teal-500" />
            {issue.address || `GPS (${issue.latitude}, ${issue.longitude})`}
          </p>

          <div className="pt-2 border-t border-slate-200 flex flex-wrap items-center justify-between gap-4 text-xs">
            <span className="text-slate-600">
              Department: <strong className="text-white">{issue.department?.name || 'Road Maintenance'}</strong>
            </span>
            <span className="text-teal-300 font-mono font-semibold">
              SLA Commitment: {issue.sla_hours || 48} Hours
            </span>
          </div>
        </div>

        {/* Citizen Verification Prompt if resolution submitted */}
        {issue.status === IssueStatus.RESOLUTION_SUBMITTED && (
          <div className="p-6 rounded-2xl bg-teal-50/40 border border-teal-500/60 shadow-xl space-y-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2 text-teal-300 font-bold">
                <CheckSquare className="w-5 h-5 text-teal-400" />
                <span>Ground Repair Verification Required</span>
              </div>
              <span className="text-xs bg-teal-900 text-teal-200 px-3 py-1 rounded-full font-mono font-bold">
                Awaiting Your Confirmation
              </span>
            </div>
            <p className="text-xs text-slate-600">
              The municipal team has uploaded repair photos. Does the fix meet your satisfaction?
            </p>

            <div className="space-y-3">
              <input
                type="text"
                value={feedback}
                onChange={(e) => setFeedback(e.target.value)}
                placeholder="Ground confirmation feedback or reopen reason..."
                className="w-full bg-sky-50 border border-slate-200 rounded-xl px-4 py-2 text-xs text-slate-700 focus:outline-none focus:border-teal-500"
              />
              <div className="flex items-center gap-3">
                <button
                  onClick={() => handleVerify(true)}
                  disabled={verifying}
                  className="px-4 py-2 rounded-xl bg-emerald-500 hover:bg-emerald-400 text-slate-950 font-bold text-xs flex items-center gap-1.5 shadow-md"
                >
                  <CheckCircle2 className="w-4 h-4" /> Confirm Ground Fix & Close
                </button>
                <button
                  onClick={() => handleVerify(false)}
                  disabled={verifying}
                  className="px-4 py-2 rounded-xl bg-rose-900/60 hover:bg-rose-800 text-rose-200 font-bold text-xs flex items-center gap-1.5 border border-rose-700"
                >
                  <XCircle className="w-4 h-4" /> Reopen Complaint
                </button>
              </div>
            </div>
          </div>
        )}

        {/* Milestone Stepper */}
        <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-6">
          <h3 className="text-sm font-bold text-white flex items-center gap-2">
            <Clock className="w-4 h-4 text-teal-500" /> Resolution Milestone Tracking
          </h3>

          <div className="space-y-6 relative before:absolute before:left-3.5 before:top-3 before:bottom-3 before:w-0.5 before:bg-slate-100">
            {TRACKING_FLOW.map((step, idx) => {
              const histMatch = [...timeline].reverse().find((t) => t.new_status === step);
              const isCurrent = issue.status === step;
              const isPassed = histMatch !== undefined || (currentIdx !== -1 && idx < currentIdx);

              return (
                <div key={step} className="relative pl-10 space-y-1">
                  <div
                    className={`absolute left-1.5 top-1 w-5 h-5 rounded-full flex items-center justify-center text-[10px] font-bold ring-4 ring-slate-950 ${
                      isCurrent
                        ? 'bg-cyan-400 text-slate-950 shadow-md shadow-cyan-400/50'
                        : isPassed
                        ? 'bg-emerald-500 text-slate-950'
                        : 'bg-slate-100 text-slate-500 border border-slate-700'
                    }`}
                  >
                    {isPassed ? '✓' : idx + 1}
                  </div>

                  <div className="flex items-center justify-between text-xs">
                    <span className={`font-bold ${isCurrent ? 'text-teal-600' : isPassed ? 'text-slate-700' : 'text-slate-500'}`}>
                      {step.replace(/_/g, ' ')}
                    </span>
                    {histMatch && (
                      <span className="text-slate-500 font-mono">
                        {new Date(histMatch.created_at).toLocaleString()}
                      </span>
                    )}
                  </div>

                  {histMatch ? (
                    <p className="text-xs text-slate-600 bg-sky-50/60 p-2 rounded-lg border border-slate-200">
                      {histMatch.notes || 'Status updated.'}
                    </p>
                  ) : isCurrent ? (
                    <p className="text-xs text-teal-600 bg-teal-50/40 p-2 rounded-lg border border-teal-200/60">
                      Current Active Stage: {issue.latest_update || 'Under departmental action.'}
                    </p>
                  ) : (
                    <p className="text-xs text-slate-600 italic">Pending next operational phase</p>
                  )}
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </div>
  );
};
