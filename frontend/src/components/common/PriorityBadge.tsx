import React from 'react';
import { SeverityLevel } from '../../types';

interface PriorityBadgeProps {
  score: number;
  severity: SeverityLevel | string;
  showScore?: boolean;
}

export const PriorityBadge: React.FC<PriorityBadgeProps> = ({ score, severity, showScore = true }) => {
  const getBadgeStyle = () => {
    const sevStr = String(severity).toUpperCase();
    switch (sevStr) {
      case 'CRITICAL':
        return 'bg-red-50 text-red-700 border-red-200';
      case 'HIGH':
        return 'bg-amber-50 text-amber-700 border-amber-200';
      case 'MODERATE':
      case 'MEDIUM':
        return 'bg-sky-50 text-sky-700 border-sky-200';
      case 'LOW':
      default:
        return 'bg-emerald-50 text-emerald-700 border-emerald-200';
    }
  };

  return (
    <div className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-semibold border ${getBadgeStyle()}`}>
      <span className="w-1.5 h-1.5 rounded-full bg-current" />
      <span>{severity}</span>
      {showScore && <span className="opacity-75 font-mono">({score.toFixed(0)})</span>}
    </div>
  );
};
