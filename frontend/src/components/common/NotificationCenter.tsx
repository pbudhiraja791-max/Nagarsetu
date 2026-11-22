import React, { useState, useEffect } from 'react';
import { notificationService } from '../../services/api';
import {
  Bell, X, CheckCircle2, AlertTriangle, Clock, RefreshCw, MessageSquare,
  HelpCircle, ChevronRight, Check, AlertOctagon, Send
} from 'lucide-react';

interface NotificationItem {
  id: number;
  issue_id: number | null;
  title: string;
  message: string;
  type: string;
  is_read: boolean;
  follow_up_status: string | null;
  follow_up_note: string | null;
  created_at: string;
}

interface Props {
  isOpen: boolean;
  onClose: () => void;
  onCountUpdate?: (count: number) => void;
}

export const NotificationCenter: React.FC<Props> = ({ isOpen, onClose, onCountUpdate }) => {
  const [notifications, setNotifications] = useState<NotificationItem[]>([]);
  const [loading, setLoading] = useState(false);
  const [selectedNotif, setSelectedNotif] = useState<NotificationItem | null>(null);
  
  // Follow-up interaction state
  const [followUpChoice, setFollowUpChoice] = useState<string>('');
  const [followUpNote, setFollowUpNote] = useState<string>('');
  const [submittingAction, setSubmittingAction] = useState(false);
  const [actionFeedback, setActionFeedback] = useState<string>('');

  const fetchNotifs = async () => {
    setLoading(true);
    try {
      const data = await notificationService.getNotifications();
      setNotifications(data.notifications);
      onCountUpdate?.(data.unread_count);
    } catch {
      // ignore
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (isOpen) {
      fetchNotifs();
      setActionFeedback('');
      setSelectedNotif(null);
    }
  }, [isOpen]);

  const handleMarkRead = async (id: number) => {
    try {
      await notificationService.markRead(id);
      setNotifications(prev => prev.map(n => n.id === id ? { ...n, is_read: true } : n));
      const newUnread = notifications.filter(n => n.id !== id && !n.is_read).length;
      onCountUpdate?.(newUnread);
    } catch {
      // ignore
    }
  };

  const submitFollowUp = async (notifId: number, choice: string) => {
    setSubmittingAction(true);
    try {
      const res = await notificationService.respondFollowUp({
        notification_id: notifId,
        response: choice,
        note: followUpNote,
      });
      setActionFeedback(res.message);
      setNotifications(prev => prev.map(n => n.id === notifId ? { ...n, follow_up_status: choice, is_read: true } : n));
      setFollowUpChoice('');
      setFollowUpNote('');
    } catch {
      setActionFeedback('Failed to record response. Please try again.');
    } finally {
      setSubmittingAction(false);
    }
  };

  const submitResolutionVerification = async (issueId: number, status: 'YES' | 'NO' | 'PARTIALLY_RESOLVED') => {
    setSubmittingAction(true);
    try {
      const res = await notificationService.verifyResolution({
        issue_id: issueId,
        status,
        feedback_notes: followUpNote,
      });
      setActionFeedback(res.message);
      setFollowUpNote('');
    } catch {
      setActionFeedback('Failed to record resolution feedback.');
    } finally {
      setSubmittingAction(false);
    }
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 overflow-hidden bg-slate-900/40 backdrop-blur-sm flex justify-end animate-fadeIn">
      <div className="w-full max-w-md bg-white h-full shadow-2xl flex flex-col">
        {/* Header */}
        <div className="p-4 border-b border-slate-100 flex items-center justify-between bg-[#1a2b6b] text-white">
          <div className="flex items-center gap-2">
            <Bell className="w-5 h-5 text-yellow-300" />
            <h2 className="font-black text-base">Civic Notification Center</h2>
          </div>
          <button
            onClick={onClose}
            className="w-8 h-8 rounded-full bg-white/10 flex items-center justify-center hover:bg-white/20 transition-colors"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        {/* Action feedback banner if any */}
        {actionFeedback && (
          <div className="p-3 bg-emerald-50 border-b border-emerald-200 text-emerald-800 text-xs font-semibold flex items-center gap-2">
            <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0" />
            <span>{actionFeedback}</span>
          </div>
        )}

        {/* Notifications List */}
        <div className="flex-1 overflow-y-auto p-4 space-y-3">
          {loading && (
            <div className="flex items-center justify-center py-12 text-slate-400 gap-2">
              <RefreshCw className="w-5 h-5 animate-spin" />
              <span className="text-sm">Loading alerts…</span>
            </div>
          )}

          {!loading && notifications.length === 0 && (
            <div className="text-center py-16 space-y-2">
              <div className="w-12 h-12 rounded-full bg-blue-50 text-blue-600 flex items-center justify-center mx-auto">
                <Bell className="w-6 h-6" />
              </div>
              <p className="text-sm font-bold text-slate-800">No new notifications</p>
              <p className="text-xs text-slate-500">You're all caught up on city updates!</p>
            </div>
          )}

          {!loading && notifications.map((n) => (
            <div
              key={n.id}
              className={`p-4 rounded-2xl border transition-all ${
                !n.is_read
                  ? 'bg-blue-50/60 border-blue-200 shadow-sm'
                  : 'bg-white border-slate-200'
              }`}
            >
              <div className="flex items-start justify-between gap-2">
                <div className="flex items-center gap-2">
                  {n.type === 'RESOLUTION_VERIFICATION' && (
                    <span className="w-2 h-2 rounded-full bg-emerald-500" />
                  )}
                  {n.type === 'RECURRING_FOLLOW_UP' && (
                    <span className="w-2 h-2 rounded-full bg-amber-500" />
                  )}
                  {n.type === 'STATUS_UPDATE' && (
                    <span className="w-2 h-2 rounded-full bg-blue-500" />
                  )}
                  <h3 className="text-sm font-bold text-slate-900">{n.title}</h3>
                </div>
                {!n.is_read && (
                  <button
                    onClick={() => handleMarkRead(n.id)}
                    className="text-[10px] text-blue-600 font-semibold hover:underline"
                  >
                    Mark read
                  </button>
                )}
              </div>

              <p className="text-xs text-slate-600 mt-1.5 leading-relaxed">{n.message}</p>

              {/* ── INTERACTIVE: RESOLUTION VERIFICATION ──────────────── */}
              {n.type === 'RESOLUTION_VERIFICATION' && n.issue_id && (
                <div className="mt-3 pt-3 border-t border-slate-200/80 space-y-2">
                  <p className="text-[11px] font-bold text-slate-800">Is the problem actually fixed?</p>
                  <div className="grid grid-cols-3 gap-1.5">
                    <button
                      onClick={() => submitResolutionVerification(n.issue_id!, 'YES')}
                      disabled={submittingAction}
                      className="py-1.5 px-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg text-[10px] font-bold text-center transition-all"
                    >
                      ✓ Yes, Resolved
                    </button>
                    <button
                      onClick={() => submitResolutionVerification(n.issue_id!, 'NO')}
                      disabled={submittingAction}
                      className="py-1.5 px-2 bg-rose-600 hover:bg-rose-700 text-white rounded-lg text-[10px] font-bold text-center transition-all"
                    >
                      ✗ Still Facing
                    </button>
                    <button
                      onClick={() => submitResolutionVerification(n.issue_id!, 'PARTIALLY_RESOLVED')}
                      disabled={submittingAction}
                      className="py-1.5 px-2 bg-amber-500 hover:bg-amber-600 text-white rounded-lg text-[10px] font-bold text-center transition-all"
                    >
                      ~ Partially
                    </button>
                  </div>
                </div>
              )}

              {/* ── INTERACTIVE: RECURRING ISSUE FOLLOW-UP ────────────── */}
              {n.type === 'RECURRING_FOLLOW_UP' && (
                <div className="mt-3 pt-3 border-t border-slate-200/80 space-y-2">
                  <p className="text-[11px] font-bold text-slate-800">Are you still facing the same issue?</p>
                  {n.follow_up_status ? (
                    <div className="text-[11px] text-emerald-700 bg-emerald-50 p-2 rounded-lg font-semibold">
                      Your answer: {n.follow_up_status.replace('_', ' ')}
                    </div>
                  ) : (
                    <div className="grid grid-cols-2 gap-1.5">
                      <button
                        onClick={() => submitFollowUp(n.id, 'STILL_EXISTS')}
                        disabled={submittingAction}
                        className="py-1.5 px-2 bg-rose-50 border border-rose-200 text-rose-700 hover:bg-rose-100 rounded-lg text-[10px] font-bold text-left transition-all"
                      >
                        ⚠️ Still exists
                      </button>
                      <button
                        onClick={() => submitFollowUp(n.id, 'RESOLVED')}
                        disabled={submittingAction}
                        className="py-1.5 px-2 bg-emerald-50 border border-emerald-200 text-emerald-700 hover:bg-emerald-100 rounded-lg text-[10px] font-bold text-left transition-all"
                      >
                        ✓ Issue resolved
                      </button>
                      <button
                        onClick={() => submitFollowUp(n.id, 'RETURNED')}
                        disabled={submittingAction}
                        className="py-1.5 px-2 bg-amber-50 border border-amber-200 text-amber-700 hover:bg-amber-100 rounded-lg text-[10px] font-bold text-left transition-all"
                      >
                        🔄 Problem returned
                      </button>
                      <button
                        onClick={() => submitFollowUp(n.id, 'NOT_SURE')}
                        disabled={submittingAction}
                        className="py-1.5 px-2 bg-slate-50 border border-slate-200 text-slate-600 hover:bg-slate-100 rounded-lg text-[10px] font-bold text-left transition-all"
                      >
                        ❓ Not sure
                      </button>
                    </div>
                  )}
                </div>
              )}

              <div className="mt-2 text-[10px] text-slate-400">
                {new Date(n.created_at).toLocaleDateString()} at {new Date(n.created_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};
