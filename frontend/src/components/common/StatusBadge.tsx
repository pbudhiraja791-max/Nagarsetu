import React from 'react';
import { IssueStatus } from '../../types';

interface StatusBadgeProps {
  status: IssueStatus | string;
}

export const StatusBadge: React.FC<StatusBadgeProps> = ({ status }) => {
  const getStyle = () => {
    const s = String(status).toUpperCase();
    switch (s) {
      case 'RESOLVED':
        return 'bg-emerald-50 text-emerald-700 border-emerald-200';
      case 'RESOLUTION_SUBMITTED':
      case 'CITIZEN_VERIFICATION':
        return 'bg-teal-50 text-teal-700 border-teal-200 animate-pulse';
      case 'IN_PROGRESS':
        return 'bg-blue-50 text-blue-700 border-blue-200';
      case 'ACCEPTED':
        return 'bg-sky-50 text-sky-700 border-sky-200';
      case 'ASSIGNED':
        return 'bg-indigo-50 text-indigo-700 border-indigo-200';
      case 'UNDER_REVIEW':
        return 'bg-purple-50 text-purple-700 border-purple-200';
      case 'AWAITING_INSPECTION':
        return 'bg-amber-50 text-amber-700 border-amber-200';
      case 'REOPENED':
        return 'bg-red-50 text-red-700 border-red-200 font-bold';
      case 'REJECTED':
      case 'CLOSED':
        return 'bg-slate-100 text-slate-500 border-slate-200';
      case 'AI_ANALYZED':
        return 'bg-violet-50 text-violet-700 border-violet-200';
      case 'SUBMITTED':
      case 'REPORTED':
      default:
        return 'bg-slate-50 text-slate-600 border-slate-200';
    }
  };

  const getLabel = () => {
    const s = String(status).toUpperCase();
    switch (s) {
      case 'RESOLUTION_SUBMITTED': return 'Verify Ground Repair';
      case 'CITIZEN_VERIFICATION': return 'Awaiting Citizen Confirm';
      case 'AWAITING_INSPECTION': return 'Inspection Queued';
      default: return s.replace(/_/g, ' ');
    }
  };

  return (
    <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full border text-xs font-semibold tracking-wide ${getStyle()}`}>
      {getLabel()}
    </span>
  );
};
