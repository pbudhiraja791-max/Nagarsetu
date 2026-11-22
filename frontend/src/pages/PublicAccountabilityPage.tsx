import React, { useState, useEffect } from 'react';
import { analyticsService } from '../services/api';
import { PublicAccountabilitySummary } from '../types';
import {
  BarChart3, CheckCircle2, Clock, AlertTriangle, ShieldCheck,
  Building2, TrendingUp, Sparkles, RefreshCw, Users, FileCheck
} from 'lucide-react';
import { Link } from 'react-router-dom';

export const PublicAccountabilityPage: React.FC = () => {
  const [data, setData] = useState<PublicAccountabilitySummary | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    analyticsService.getPublicSummary()
      .then(setData)
      .catch(console.error)
      .finally(() => setLoading(false));
  }, []);

  if (loading || !data) {
    return (
      <div className="min-h-screen bg-sky-50 flex items-center justify-center text-slate-500">
        <div className="flex items-center gap-3">
          <RefreshCw className="w-5 h-5 text-teal-400 animate-spin" />
          <span>Loading NagarSetu Public Accountability Scorecards...</span>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-sky-50 text-slate-900 py-10 px-4 sm:px-6 lg:px-8 font-sans">
      <div className="max-w-7xl mx-auto space-y-10">
        {/* Header */}
        <div className="flex flex-wrap items-center justify-between gap-4 border-b border-slate-200 pb-6">
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-teal-50 border border-teal-200 text-teal-300 text-xs font-semibold mb-2">
              <ShieldCheck className="w-3.5 h-3.5 text-teal-400" /> OPEN MUNICIPAL GOVERNANCE INITIATIVE
            </div>
            <h1 className="text-3xl sm:text-4xl font-extrabold text-white tracking-tight">
              Public Accountability Dashboard
            </h1>
            <p className="text-sm text-slate-500 mt-1 max-w-3xl">
              Transparent, open-data metrics tracking municipal response times, departmental resolution rates, and ground citizen verifications. Citizen personal identifiers are strictly protected.
            </p>
          </div>

          <Link
            to="/report"
            className="px-5 py-3 rounded-xl bg-gradient-to-r from-teal-500 to-emerald-500 hover:from-teal-400 hover:to-emerald-400 text-slate-950 font-bold text-sm shadow-lg shadow-teal-950 transition-all"
          >
            Lodge a Civic Report
          </Link>
        </div>

        {/* 1. TOP METRICS STRIP */}
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-4">
          <div className="p-5 rounded-2xl bg-slate-50/70 border border-slate-200 space-y-1">
            <div className="text-xs text-slate-500 font-medium">Total Received</div>
            <div className="text-3xl font-extrabold text-white font-mono">{data.total_complaints}</div>
            <div className="text-[11px] text-slate-500">Public issues lodged</div>
          </div>

          <div className="p-5 rounded-2xl bg-slate-50/70 border border-slate-200 space-y-1">
            <div className="text-xs text-slate-500 font-medium">Ground Resolved</div>
            <div className="text-3xl font-extrabold text-emerald-400 font-mono">{data.resolved_complaints}</div>
            <div className="text-[11px] text-emerald-500/80 font-medium">With repair proof</div>
          </div>

          <div className="p-5 rounded-2xl bg-slate-50/70 border border-slate-200 space-y-1">
            <div className="text-xs text-slate-500 font-medium">Citizen Verified</div>
            <div className="text-3xl font-extrabold text-teal-400 font-mono">{data.citizen_verified_count}</div>
            <div className="text-[11px] text-slate-500">Citizen confirmed fixes</div>
          </div>

          <div className="p-5 rounded-2xl bg-slate-50/70 border border-slate-200 space-y-1">
            <div className="text-xs text-slate-500 font-medium">Success Rate</div>
            <div className="text-3xl font-extrabold text-teal-500 font-mono">{data.resolution_rate}%</div>
            <div className="text-[11px] text-slate-500">Resolution benchmark</div>
          </div>

          <div className="p-5 rounded-2xl bg-slate-50/70 border border-slate-200 space-y-1">
            <div className="text-xs text-slate-500 font-medium">Avg. Response Time</div>
            <div className="text-3xl font-extrabold text-amber-400 font-mono">{data.avg_resolution_hours}h</div>
            <div className="text-[11px] text-slate-500">From filing to completion</div>
          </div>

          <div className="p-5 rounded-2xl bg-slate-50/70 border border-slate-200 space-y-1">
            <div className="text-xs text-slate-500 font-medium">Citizen Reopened</div>
            <div className="text-3xl font-extrabold text-red-500 font-mono">{data.reopened_complaints}</div>
            <div className="text-[11px] text-red-500">Rejected repair claims</div>
          </div>
        </div>

        {/* 2. DEPARTMENT PERFORMANCE SCORECARDS */}
        <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-5">
          <div className="flex items-center justify-between border-b border-slate-200 pb-3">
            <div className="flex items-center gap-2 text-white font-bold text-base">
              <Building2 className="w-5 h-5 text-teal-400" />
              <span>Departmental Resolution Benchmarks</span>
            </div>
            <span className="text-xs text-slate-500">Updated in Real-Time</span>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
            {data.department_metrics.map((dept) => (
              <div
                key={dept.department_id}
                className="p-5 rounded-xl bg-sky-50 border border-slate-200 space-y-4 hover:border-teal-500/40 transition-all"
              >
                <div>
                  <span className="text-[10px] font-mono text-teal-500 font-bold uppercase">{dept.department_code}</span>
                  <h4 className="text-base font-bold text-white mt-0.5">{dept.department_name}</h4>
                </div>

                <div className="space-y-1.5">
                  <div className="flex justify-between text-xs">
                    <span className="text-slate-500">Resolution Rate</span>
                    <span className="font-bold text-emerald-400 font-mono">{dept.resolution_rate}%</span>
                  </div>
                  <div className="w-full h-2 bg-slate-50 rounded-full overflow-hidden">
                    <div
                      className="h-full bg-gradient-to-r from-teal-500 to-emerald-400 rounded-full"
                      style={{ width: `${dept.resolution_rate}%` }}
                    />
                  </div>
                </div>

                <div className="grid grid-cols-3 gap-2 text-center text-xs pt-1 border-t border-slate-200">
                  <div className="p-2 rounded bg-white">
                    <span className="text-[10px] text-slate-500 block">Total</span>
                    <strong className="text-white font-mono">{dept.total_assigned}</strong>
                  </div>
                  <div className="p-2 rounded bg-white">
                    <span className="text-[10px] text-slate-500 block">Active</span>
                    <strong className="text-amber-400 font-mono">{dept.active_count}</strong>
                  </div>
                  <div className="p-2 rounded bg-white">
                    <span className="text-[10px] text-slate-500 block">Overdue</span>
                    <strong className={(dept.overdue_count || 0) > 0 ? 'text-red-500 font-mono' : 'text-emerald-400 font-mono'}>
                      {dept.overdue_count || 0}
                    </strong>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* 3. MONTHLY CIVIC RESOLUTION TRENDS */}
        {data.monthly_trends && data.monthly_trends.length > 0 && (
          <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-4">
            <div className="flex items-center justify-between">
              <h3 className="text-base font-bold text-white flex items-center gap-2">
                <TrendingUp className="w-5 h-5 text-teal-500" />
                Monthly Civic Intake vs Resolution Trends
              </h3>
              <span className="text-xs text-slate-500">Past 6 Months Activity</span>
            </div>

            <div className="grid grid-cols-2 sm:grid-cols-6 gap-3">
              {data.monthly_trends.map((t) => (
                <div key={t.month} className="p-4 rounded-xl bg-sky-50 border border-slate-200 text-center space-y-2">
                  <div className="text-xs font-bold text-slate-600">{t.month}</div>
                  <div className="space-y-1">
                    <div className="text-xs text-teal-500 font-mono">
                      Filed: <strong>{t.submitted}</strong>
                    </div>
                    <div className="text-xs text-emerald-400 font-mono">
                      Fixed: <strong>{t.resolved}</strong>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        )}

        {/* Privacy & Governance Notice */}
        <div className="p-5 rounded-2xl bg-slate-50/30 border border-slate-200 text-xs text-slate-500 space-y-1 text-center">
          <p className="font-semibold text-slate-600">Public Civic Transparency Guarantee</p>
          <p>
            NagarSetu adheres to the highest data protection standards. Citizen phone numbers, physical house addresses, and private contact credentials are redacted in all public views.
          </p>
        </div>
      </div>
    </div>
  );
};
