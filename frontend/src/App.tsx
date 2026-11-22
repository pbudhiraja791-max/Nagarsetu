import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';
import { CityProvider } from './context/CityContext';
import { UserRole } from './types';

import { Sidebar } from './components/common/Sidebar';
import { TopBar } from './components/common/TopBar';
import { LandingPage } from './pages/LandingPage';
import { LoginPage } from './pages/LoginPage';
import { RegisterPage } from './pages/RegisterPage';
import { ReportIssuePage } from './pages/ReportIssuePage';
import { PublicIssueMapPage } from './pages/PublicIssueMapPage';
import { PublicAccountabilityPage } from './pages/PublicAccountabilityPage';
import { MyReportsPage } from './pages/MyReportsPage';
import { IssueDetailsPage } from './pages/IssueDetailsPage';
import { AdminDashboardPage } from './pages/AdminDashboardPage';
import { AdminIssueManagementPage } from './pages/AdminIssueManagementPage';
import { OfficerDashboardPage } from './pages/OfficerDashboardPage';
import { CitizenDashboardPage } from './pages/CitizenDashboardPage';
import { IssueTrackingPage } from './pages/IssueTrackingPage';

const ProtectedRoute: React.FC<{ children: React.ReactNode; roles?: UserRole[] }> = ({ children, roles }) => {
  const { isAuthenticated, user, loading } = useAuth();

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-center space-y-3">
          <div className="w-10 h-10 rounded-full border-4 border-blue-200 border-t-blue-600 animate-spin mx-auto" />
          <p className="text-sm text-slate-500 font-medium">Loading...</p>
        </div>
      </div>
    );
  }

  if (!isAuthenticated) return <Navigate to="/login" replace />;
  if (roles && user && !roles.includes(user.role)) return <Navigate to="/" replace />;
  return <>{children}</>;
};

// Pages that use full-screen layout (no sidebar/topbar)
const FullScreenPage: React.FC<{ children: React.ReactNode }> = ({ children }) => (
  <div className="min-h-screen bg-[#f3f6fb]">{children}</div>
);

export const AppContent: React.FC = () => {
  return (
    <div className="flex min-h-screen bg-[#f3f6fb]">
      {/* Fixed Left Sidebar (desktop) & Bottom Nav (mobile) */}
      <Sidebar />

      {/* Main content — full width on mobile, offset on desktop */}
      <div className="flex-1 ml-0 md:ml-56 pb-16 md:pb-0 flex flex-col min-h-screen overflow-x-hidden bg-[#EEF3FB]">
        {/* Sticky top bar */}
        <TopBar />

        {/* Page content */}
        <main className="flex-1 overflow-auto">
          <Routes>
            {/* Public pages */}
            <Route path="/" element={<LandingPage />} />
            <Route path="/map" element={<PublicIssueMapPage />} />
            <Route path="/accountability" element={<PublicAccountabilityPage />} />
            <Route path="/issue/:id" element={<IssueDetailsPage />} />

            {/* Auth pages (full-screen) */}
            <Route path="/login" element={<LoginPage />} />
            <Route path="/register" element={<RegisterPage />} />

            {/* Protected: Citizen */}
            <Route path="/dashboard" element={<ProtectedRoute roles={[UserRole.CITIZEN]}><CitizenDashboardPage /></ProtectedRoute>} />
            <Route path="/report" element={<ProtectedRoute roles={[UserRole.CITIZEN, UserRole.ADMIN]}><ReportIssuePage /></ProtectedRoute>} />
            <Route path="/my-reports" element={<ProtectedRoute roles={[UserRole.CITIZEN]}><MyReportsPage /></ProtectedRoute>} />
            <Route path="/issue/:id/track" element={<ProtectedRoute roles={[UserRole.CITIZEN]}><IssueTrackingPage /></ProtectedRoute>} />

            {/* Protected: Admin */}
            <Route path="/admin" element={<ProtectedRoute roles={[UserRole.ADMIN]}><AdminDashboardPage /></ProtectedRoute>} />
            <Route path="/admin/issues" element={<ProtectedRoute roles={[UserRole.ADMIN]}><AdminIssueManagementPage /></ProtectedRoute>} />

            {/* Protected: Officer */}
            <Route path="/officer" element={<ProtectedRoute roles={[UserRole.OFFICER]}><OfficerDashboardPage /></ProtectedRoute>} />

            <Route path="*" element={<Navigate to="/" replace />} />
          </Routes>
        </main>

        {/* Footer */}
        <footer className="bg-transparent border-t border-slate-200/60 py-3 px-6 text-xs text-slate-400 flex flex-wrap items-center justify-between gap-2">
          <span className="font-medium text-slate-500">© 2026 NagarSetu — Bridging Citizens &amp; Cities</span>
          <div className="flex gap-3 items-center">
            <span className="text-blue-600 font-semibold">FastAPI Backend</span>
            <span className="text-slate-200">•</span>
            <span className="text-teal-600 font-semibold">AI Civic Intelligence</span>
          </div>
        </footer>
      </div>
    </div>
  );
};

export const App: React.FC = () => (
  <Router>
    <AuthProvider>
      <CityProvider>
        <AppContent />
      </CityProvider>
    </AuthProvider>
  </Router>
);

export default App;
