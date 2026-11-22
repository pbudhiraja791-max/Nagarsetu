import axios from 'axios';
import {
  User,
  Issue,
  Department,
  AIAnalysisResult,
  NLPAnalysisResult,
  DuplicateCandidate,
  MapPoint,
  AnalyticsDashboardData,
  PublicAccountabilitySummary,
  PredictiveHotspot,
  IssueStatus,
  IssueType
} from '../types';

const API_BASE_URL = '/api/v1';

export const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Interceptor to inject JWT token
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('nagarsetu_token') || localStorage.getItem('civic_token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export const authService = {
  login: async (email: string, password: string) => {
    const res = await api.post('/auth/login', { email, password });
    if (res.data.access_token) {
      localStorage.setItem('nagarsetu_token', res.data.access_token);
      localStorage.setItem('nagarsetu_user', JSON.stringify(res.data.user));
      // Backward compatibility keys
      localStorage.setItem('civic_token', res.data.access_token);
      localStorage.setItem('civic_user', JSON.stringify(res.data.user));
    }
    return res.data;
  },
  register: async (data: { full_name: string; email: string; password: string; role?: string; department_id?: number }) => {
    const res = await api.post('/auth/register', data);
    return res.data;
  },
  getMe: async () => {
    const res = await api.get('/auth/me');
    return res.data as User;
  },
  logout: () => {
    localStorage.removeItem('nagarsetu_token');
    localStorage.removeItem('nagarsetu_user');
    localStorage.removeItem('civic_token');
    localStorage.removeItem('civic_user');
  },
};

export const issueService = {
  analyzeImage: async (file: File) => {
    const formData = new FormData();
    formData.append('file', file);
    const res = await api.post<AIAnalysisResult>('/issues/analyze-image', formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    });
    return res.data;
  },

  parseNlp: async (transcript: string, language?: string) => {
    const res = await api.post<NLPAnalysisResult>('/issues/parse-nlp', {
      transcript,
      language: language || 'en',
    });
    return res.data;
  },

  checkDuplicates: async (data: {
    latitude: number;
    longitude: number;
    issue_type: string;
    title?: string;
    description?: string;
    radius_meters?: number;
  }) => {
    const res = await api.post<{
      duplicate_count: number;
      has_potential_duplicates: boolean;
      radius_meters: number;
      candidates: DuplicateCandidate[];
    }>('/issues/check-duplicates', data);
    return res.data;
  },

  createIssue: async (data: {
    title: string;
    description?: string;
    issue_type: string;
    latitude: number;
    longitude: number;
    address?: string;
    original_image_url: string;
    annotated_image_url?: string;
    ai_confidence: number;
    severity: string;
    priority_score: number;
    priority_explanation?: string;
    bounding_box_json?: string;
    voice_audio_url?: string;
    voice_transcript?: string;
    original_language?: string;
  }) => {
    const res = await api.post<Issue>('/issues', data);
    return res.data;
  },

  listIssues: async (params?: {
    status_filter?: string;
    type_filter?: string;
    dept_id?: number;
    min_priority?: number;
    search?: string;
  }) => {
    const res = await api.get<Issue[]>('/issues', { params });
    return res.data;
  },

  supportIssue: async (id: number) => {
    const res = await api.post<Issue>(`/issues/${id}/support`);
    return res.data;
  },

  submitResolution: async (id: number, resolution_image_url: string, notes: string) => {
    const res = await api.post<Issue>(`/issues/${id}/submit-resolution`, {
      resolution_image_url,
      notes,
    });
    return res.data;
  },

  verifyResolution: async (
    id: number,
    confirmed_resolved: boolean,
    feedback?: string,
    reopen_reason?: string
  ) => {
    const res = await api.post<Issue>(`/issues/${id}/verify-resolution`, {
      confirmed_resolved,
      feedback,
      reopen_reason,
    });
    return res.data;
  },

  requestInspection: async (id: number, notes?: string) => {
    const res = await api.post<Issue>(`/issues/${id}/request-inspection`, null, {
      params: { notes },
    });
    return res.data;
  },

  overridePriority: async (id: number, new_priority_score: number, reason: string) => {
    const res = await api.post<Issue>(`/issues/${id}/override-priority`, {
      new_priority_score,
      reason,
    });
    return res.data;
  },

  getMyReports: async (params?: Record<string, string | number | undefined>) => {
    const res = await api.get<Issue[]>('/issues/my-reports', { params });
    return res.data;
  },

  getMapData: async () => {
    const res = await api.get<MapPoint[]>('/issues/map-data');
    return res.data;
  },

  getIssueById: async (id: number) => {
    const res = await api.get<Issue>(`/issues/${id}`);
    return res.data;
  },

  getTimeline: async (id: number) => {
    const res = await api.get(`/issues/${id}/timeline`);
    return res.data;
  },

  updateStatus: async (id: number, status: string, notes?: string) => {
    const res = await api.patch<Issue>(`/issues/${id}/status`, { status, notes });
    return res.data;
  },

  assignOfficer: async (id: number, officer_id: number) => {
    const res = await api.post<Issue>(`/issues/${id}/assign`, { officer_id });
    return res.data;
  },

  acceptIssue: async (id: number) => {
    const res = await api.post<Issue>(`/issues/${id}/accept`);
    return res.data;
  },

  rejectIssue: async (id: number, reason: string) => {
    const res = await api.post<Issue>(`/issues/${id}/reject`, { reason });
    return res.data;
  },

  updateProgress: async (id: number, progress_percentage: number, note?: string) => {
    const res = await api.patch<Issue>(`/issues/${id}/progress`, { progress_percentage, note });
    return res.data;
  },

  addNote: async (id: number, progress_percentage: number, note: string) => {
    const res = await api.post<Issue>(`/issues/${id}/notes`, { progress_percentage, note });
    return res.data;
  },

  setEstimate: async (id: number, estimated_completion_date: string) => {
    const res = await api.patch<Issue>(`/issues/${id}/estimate`, { estimated_completion_date });
    return res.data;
  },

  resolveIssue: async (id: number) => {
    const res = await api.post<Issue>(`/issues/${id}/resolve`);
    return res.data;
  },

  closeIssue: async (id: number) => {
    const res = await api.post<Issue>(`/issues/${id}/close`);
    return res.data;
  },

  submitReport: async (data: {
    submission_id?: string;
    selected_category: string;
    description: string;
    latitude: number;
    longitude: number;
    address?: string;
    image_url?: string;
    gps_accuracy?: number;
    urgency?: string;
    title?: string;
    voice_transcript?: string;
    original_language?: string;
    citizen_duplicate_choice?: string;
  }) => {
    const res = await api.post('/issues/submit-report', data);
    return res.data;
  },

  previewDuplicates: async (data: {
    latitude: number;
    longitude: number;
    category: string;
    description?: string;
  }) => {
    const res = await api.post('/issues/preview-duplicates', data);
    return res.data;
  },

  getIssueReports: async (id: number) => {
    const res = await api.get(`/issues/${id}/reports`);
    return res.data;
  },

  getIssueAIAnalysis: async (id: number) => {
    const res = await api.get(`/issues/${id}/ai-analysis`);
    return res.data;
  },

  getIssueActivityLog: async (id: number) => {
    const res = await api.get(`/issues/${id}/activity-log`);
    return res.data;
  },
};

export const adminService = {
  getDuplicateReviewQueue: async () => {
    const res = await api.get('/admin/duplicate-review');
    return res.data;
  },

  confirmDuplicate: async (reportId: number, notes?: string) => {
    const res = await api.post(`/admin/duplicate-review/${reportId}/confirm`, { notes });
    return res.data;
  },

  rejectDuplicate: async (reportId: number, reason?: string) => {
    const res = await api.post(`/admin/duplicate-review/${reportId}/reject`, { reason });
    return res.data;
  },

  moveReport: async (reportId: number, targetIssueId: number, notes?: string) => {
    const res = await api.post(`/admin/duplicate-review/${reportId}/move`, { target_issue_id: targetIssueId, notes });
    return res.data;
  },

  invalidateReport: async (reportId: number, reason: string) => {
    const res = await api.post(`/admin/duplicate-review/${reportId}/invalidate`, { reason });
    return res.data;
  },

  getSeverityReviewQueue: async () => {
    const res = await api.get('/admin/severity-review');
    return res.data;
  },

  approveSeverity: async (issueId: number, notes?: string) => {
    const res = await api.post(`/admin/severity-review/${issueId}/approve`, null, { params: { notes } });
    return res.data;
  },

  overrideSeverity: async (issueId: number, data: { severity_score: number; severity_level: string; priority_score?: number; reason: string }) => {
    const res = await api.post(`/admin/severity-review/${issueId}/override`, data);
    return res.data;
  },

  reconcileCounts: async () => {
    const res = await api.post('/admin/reconcile');
    return res.data;
  },

  getIntelligenceAnalytics: async () => {
    const res = await api.get('/admin/intelligence/analytics');
    return res.data;
  },

  getDedupConfig: async () => {
    const res = await api.get('/admin/config/dedup');
    return res.data;
  },

  updateDedupConfig: async (data: any) => {
    const res = await api.put('/admin/config/dedup', data);
    return res.data;
  },

  getSeverityConfig: async () => {
    const res = await api.get('/admin/config/severity');
    return res.data;
  },

  updateSeverityConfig: async (data: any) => {
    const res = await api.put('/admin/config/severity', data);
    return res.data;
  },

  getPriorityConfig: async () => {
    const res = await api.get('/admin/config/priority');
    return res.data;
  },

  updatePriorityConfig: async (data: any) => {
    const res = await api.put('/admin/config/priority', data);
    return res.data;
  },
};

export const departmentService = {
  listDepartments: async () => {
    const res = await api.get<Department[]>('/departments');
    return res.data;
  },
};

export const analyticsService = {
  getDashboardStats: async () => {
    const res = await api.get<AnalyticsDashboardData>('/analytics/dashboard');
    return res.data;
  },
  getPublicSummary: async () => {
    const res = await api.get<PublicAccountabilitySummary>('/analytics/public-summary');
    return res.data;
  },
  getPredictiveHotspots: async () => {
    const res = await api.get<PredictiveHotspot[]>('/analytics/predictive-hotspots');
    return res.data;
  },
};

export const citizenService = {
  stats: async () => (await api.get('/issues/stats/citizen')).data,
  reports: async (params?: Record<string, string | number | undefined>) => (await api.get<Issue[]>('/issues/my-reports', { params })).data,
  details: async (id: number) => (await api.get<Issue>(`/issues/${id}`)).data,
  timeline: async (id: number) => (await api.get(`/issues/${id}/timeline`)).data,
  support: async (id: number) => (await api.post<Issue>(`/issues/${id}/support`)).data,
  verify: async (id: number, confirmed: boolean, feedback?: string, reopen_reason?: string) =>
    (await api.post<Issue>(`/issues/${id}/verify-resolution`, { confirmed_resolved: confirmed, feedback, reopen_reason })).data,
};

// ─── Smart Camera AI Service ─────────────────────────────────────────────────
export const smartCameraService = {
  /** Upload image for Gemini Vision analysis. Returns temp_image_filename + analysis. */
  analyzeImage: async (file: File) => {
    const form = new FormData();
    form.append('file', file);
    const res = await api.post('/smart-camera/analyze', form, {
      headers: { 'Content-Type': 'multipart/form-data' },
      timeout: 45000,
    });
    return res.data as {
      success: boolean;
      temp_image_filename: string;
      image_url: string;
      ai_engine: string;
      gemini_available: boolean;
      analysis: {
        is_civic_issue: boolean;
        issue_category: string;
        issue_title: string;
        description: string;
        severity: string;
        confidence: number;
        confidence_percent: number;
        suggested_department: string;
        visual_evidence: string;
        not_civic_reason: string;
      };
    };
  },

  /** Find nearby existing issues for duplicate detection. */
  findNearbyIssues: async (lat: number, lng: number, category?: string, radius?: number) => {
    const res = await api.get('/smart-camera/nearby-issues', {
      params: { latitude: lat, longitude: lng, category, radius_meters: radius ?? 100 },
    });
    return res.data as {
      count: number;
      radius_meters: number;
      nearby_issues: Array<{
        id: number; display_id: string; title: string; issue_type: string;
        status: string; latitude: number; longitude: number; address: string;
        distance_meters: number; distance_text: string; report_count: number;
        image_url: string | null; created_at: string; category_match: boolean;
        similarity_score: number;
      }>;
    };
  },

  /** Submit a new report from Smart Camera. */
  submitReport: async (payload: {
    title: string; description: string; category: string; severity: string;
    latitude: number; longitude: number; address: string;
    temp_image_filename: string; ai_confidence: number; ai_engine: string;
  }) => {
    const form = new FormData();
    Object.entries(payload).forEach(([k, v]) => form.append(k, String(v)));
    const res = await api.post('/smart-camera/submit', form, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    return res.data;
  },

  /** Add supporting evidence to existing issue (duplicate confirmed). */
  supportIssue: async (issueId: number, temp_image_filename: string, note?: string) => {
    const form = new FormData();
    form.append('temp_image_filename', temp_image_filename);
    if (note) form.append('note', note);
    const res = await api.post(`/smart-camera/support-issue/${issueId}`, form, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    return res.data;
  },
};

// ─── Smart Follow-up Notifications & Feedback Service ─────────────────────────
export const notificationService = {
  getNotifications: async () => {
    const res = await api.get('/notifications');
    return res.data as {
      unread_count: number;
      notifications: Array<{
        id: number;
        issue_id: number | null;
        title: string;
        message: string;
        type: string;
        is_read: boolean;
        follow_up_status: string | null;
        follow_up_note: string | null;
        created_at: string;
      }>;
    };
  },
  markRead: async (id: number) => {
    return (await api.patch(`/notifications/${id}/read`)).data;
  },
  respondFollowUp: async (payload: { notification_id: number; response: string; note?: string }) => {
    return (await api.post('/notifications/follow-up-response', payload)).data as {
      success: boolean;
      message: string;
      status: string;
    };
  },
  verifyResolution: async (payload: { issue_id: number; status: 'YES' | 'NO' | 'PARTIALLY_RESOLVED'; feedback_notes?: string }) => {
    return (await api.post('/notifications/verify-resolution', payload)).data as {
      success: boolean;
      message: string;
      current_status: string;
    };
  },
};

export const officerService = {
  assigned: async () => (await api.get<Issue[]>('/issues/department/assigned')).data,
  accept: async (id: number) => (await api.post<Issue>(`/issues/${id}/accept`)).data,
  reject: async (id: number, reason: string) => (await api.post<Issue>(`/issues/${id}/reject`, { reason })).data,
  assign: async (id: number, officer_id: number) => (await api.post<Issue>(`/issues/${id}/assign`, { officer_id })).data,
  status: async (id: number, status: string, notes?: string) => (await api.patch<Issue>(`/issues/${id}/status`, { status, notes })).data,
  progress: async (id: number, progress_percentage: number, note?: string) => (await api.patch<Issue>(`/issues/${id}/progress`, { progress_percentage, note })).data,
  note: async (id: number, progress_percentage: number, note: string) => (await api.post<Issue>(`/issues/${id}/notes`, { progress_percentage, note })).data,
  estimate: async (id: number, estimated_completion_date: string) => (await api.patch<Issue>(`/issues/${id}/estimate`, { estimated_completion_date })).data,
  submitResolution: async (id: number, resolution_image_url: string, notes: string) =>
    (await api.post<Issue>(`/issues/${id}/submit-resolution`, { resolution_image_url, notes })).data,
  resolve: async (id: number) => (await api.post<Issue>(`/issues/${id}/resolve`)).data,
  close: async (id: number) => (await api.post<Issue>(`/issues/${id}/close`)).data,
};
