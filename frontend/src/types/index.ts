export enum UserRole {
  CITIZEN = 'CITIZEN',
  ADMIN = 'ADMIN',
  OFFICER = 'OFFICER',
}

export enum IssueType {
  POTHOLE = 'Pothole',
  ROAD_DAMAGE = 'Damaged Road',
  GARBAGE = 'Garbage Accumulation',
  OVERFLOWING_DUSTBIN = 'Overflowing Dustbin',
  WATER_LEAKAGE = 'Water Leakage',
  DRAINAGE_BLOCKAGE = 'Drainage Blockage',
  WATERLOGGING = 'Waterlogging',
  STREETLIGHT = 'Damaged Streetlight',
  ELECTRICAL_WIRE = 'Exposed Electrical Wire',
  MANHOLE = 'Open Manhole',
  INFRASTRUCTURE_DAMAGE = 'Broken Public Infrastructure',
  OTHER = 'Other Civic Problem',
}

export enum IssueStatus {
  SUBMITTED = 'SUBMITTED',
  REPORTED = 'REPORTED',
  AI_ANALYZED = 'AI_ANALYZED',
  UNDER_REVIEW = 'UNDER_REVIEW',
  ASSIGNED = 'ASSIGNED',
  ACCEPTED = 'ACCEPTED',
  IN_PROGRESS = 'IN_PROGRESS',
  AWAITING_INSPECTION = 'AWAITING_INSPECTION',
  RESOLUTION_SUBMITTED = 'RESOLUTION_SUBMITTED',
  CITIZEN_VERIFICATION = 'CITIZEN_VERIFICATION',
  RESOLVED = 'RESOLVED',
  REOPENED = 'REOPENED',
  REJECTED = 'REJECTED',
  CLOSED = 'CLOSED',
}

export enum SeverityLevel {
  LOW = 'LOW',
  MODERATE = 'MODERATE',
  MEDIUM = 'MEDIUM',
  HIGH = 'HIGH',
  CRITICAL = 'CRITICAL',
}

export interface User {
  id: number;
  full_name: string;
  email: string;
  role: UserRole;
  department_id?: number | null;
  created_at: string;
}

export interface Department {
  id: number;
  name: string;
  code: string;
  description?: string;
  contact_email?: string;
  created_at: string;
}

export interface BoundingBox {
  class: string;
  confidence: number;
  x: number;
  y: number;
  width: number;
  height: number;
  box_normalized?: number[];
}

export interface AIAnalysisResult {
  issue_type: string;
  confidence: number;
  severity: SeverityLevel;
  priority_score: number;
  priority_explanation?: string;
  recommended_department: string;
  recommended_department_code: string;
  sla_hours?: number;
  bounding_boxes: BoundingBox[];
  defect_area_ratio: number;
  annotated_image_url?: string;
  original_image_url: string;
}

export interface NLPAnalysisResult {
  problem_category: string;
  nlp_confidence: number;
  detected_language: string;
  is_urgent: boolean;
  urgency_keywords: string[];
  matched_keywords: string[];
  extracted_location_references: string[];
  suggested_title: string;
  structured_problem: string;
  recommended_department: string;
  recommended_department_code: string;
}

export interface DuplicateCandidate {
  id: number;
  title: string;
  issue_type: string;
  status: string;
  distance_meters: number;
  created_at?: string;
  address?: string;
  support_count: number;
  match_confidence: number;
  image_url?: string;
  priority_score: number;
}

export interface IssueImage {
  id: number;
  original_image_path: string;
  image_url?: string;
  annotated_image_path?: string;
  bounding_box_json?: string;
  created_at: string;
}

export interface StatusHistory {
  id: number;
  previous_status?: IssueStatus;
  new_status: IssueStatus;
  changed_by?: User;
  notes?: string;
  progress_percentage?: number;
  created_at: string;
}

export interface DuplicateRelation {
  id: number;
  duplicate_issue_id: number;
  distance_meters: number;
  similarity_score: number;
  created_at: string;
}

export interface AIResolutionComparison {
  comparison_verified: boolean;
  repair_confidence: number;
  defect_cleared: boolean;
  similarity_score: number;
  verdict: string;
  ai_assessment_notes: string;
  recommendation: string;
}

export interface Issue {
  id: number;
  display_id?: string;
  title: string;
  summary?: string;
  description?: string;
  issue_type: IssueType;
  latitude: number;
  longitude: number;
  address?: string;
  area?: string;
  ai_confidence: number;
  severity: SeverityLevel;
  severity_score?: number;
  severity_level?: string;
  priority_score: number;
  priority_level?: string;
  priority_breakdown?: string;
  priority_explanation?: string;
  priority_override_reason?: string | null;
  status: IssueStatus;
  reporter_id: number;
  reporter?: User;
  department_id?: number;
  department?: Department;
  assigned_department?: string;
  assigned_officer_name?: string;
  total_reports?: number;
  unique_citizens?: number;
  first_reported_at?: string;
  last_reported_at?: string;
  deadline?: string | null;
  images: IssueImage[];
  status_history: StatusHistory[];
  assigned_officer_id?: number | null;
  assigned_officer?: User | null;
  assigned_at?: string | null;
  progress_percentage: number;
  latest_update?: string | null;
  
  // SLA
  sla_hours?: number;
  sla_deadline?: string | null;
  is_escalated?: boolean;

  // Resolution & Citizen Verification
  resolution_image_path?: string | null;
  resolution_notes?: string | null;
  resolution_ai_comparison?: string | null;
  resolution_submitted_at?: string | null;
  citizen_feedback?: string | null;
  citizen_verified_at?: string | null;
  estimated_completion_date?: string | null;
  resolved_at?: string | null;
  closed_at?: string | null;

  // Voice & Community
  support_count: number;
  original_language?: string;
  voice_audio_path?: string | null;
  voice_transcript?: string | null;

  created_at: string;
  updated_at: string;
}

export interface CitizenReport {
  id: number;
  report_tracking_id: string;
  submission_id?: string;
  reporter_name: string;
  reporter_phone?: string;
  description?: string;
  category: string;
  latitude: number;
  longitude: number;
  gps_accuracy?: number;
  address?: string;
  status?: string;
  counted: boolean;
  link_method: string;
  repeat_reporter: boolean;
  created_at: string;
  images: string[];
  media?: any[];
}

export interface SeverityAssessmentHistoryItem {
  id: number;
  score: number;
  level: string;
  confidence: number;
  explanation: string;
  is_escalation?: boolean;
  is_deescalation?: boolean;
  created_at: string;
}

export interface IssueAIAnalysis {
  issue_id: number;
  display_id?: string;
  priority_score?: number;
  priority_level?: string;
  priority_breakdown?: any;
  severity_assessment?: any;
  duplicate_matches?: any[];
  current_severity?: {
    score: number;
    level: string;
    confidence: number;
    explanation?: string;
    risk_factors: string[];
    history: SeverityAssessmentHistoryItem[];
  };
  current_priority?: {
    score: number;
    level: string;
    breakdown: any;
    explanation?: string;
  };
  duplicate_detection_matches?: {
    id: number;
    report_id: number;
    geo_similarity: number;
    visual_similarity: number;
    text_similarity: number;
    context_similarity: number;
    final_score: number;
    decision: string;
    ai_reasoning?: string;
    created_at: string;
  }[];
}

export interface IssueActivityLogItem {
  id: number;
  action?: string;
  action_type?: string;
  actor_name?: string;
  actor_role?: string;
  actor_type?: string;
  actor_id?: number;
  description?: string;
  notes?: string;
  before_state?: any;
  after_state?: any;
  created_at: string;
}

export interface PendingDuplicateReport {
  report_id: number;
  report_tracking_id: string;
  submission_id?: string;
  created_at: string;
  reporter_name: string;
  category: string;
  description?: string;
  address?: string;
  latitude: number;
  longitude: number;
  image_url?: string;
  report?: any;
  match?: any;
  candidate_issue?: any;
  suggested_issue?: {
    id: number;
    display_id?: string;
    title: string;
    description?: string;
    category?: string;
    address?: string;
    total_reports: number;
    unique_citizens: number;
    severity_level: string;
    priority_score: number;
    status?: string;
    image_url?: string;
  };
  match_metrics?: {
    final_score: number;
    geo_similarity: number;
    visual_similarity: number;
    text_similarity: number;
    context_similarity: number;
    ai_confidence: number;
    ai_reasoning: string;
    model_name: string;
  };
}

export interface PendingSeverityIssue {
  issue_id: number;
  display_id?: string;
  title: string;
  category: string;
  address?: string;
  current_severity: string;
  current_severity_score: number;
  current_severity_level?: string;
  priority_score: number;
  total_reports: number;
  unique_citizens: number;
  ai_confidence: number;
  risk_factors: string[];
  ai_explanation?: string;
  ai_reasoning?: string;
  review_reason?: string;
  model_name?: string;
  image_url?: string;
  reports_count: number;
}

export interface IntelligenceAnalyticsData {
  total_unique_issues: number;
  total_citizen_reports: number;
  duplicate_reports_auto_linked: number;
  duplicate_reports_pending_review: number;
  auto_linked_count?: number;
  pending_review_count?: number;
  new_issues_created: number;
  average_reports_per_issue: number;
  resolved_issues: number;
  severity_distribution: Record<string, number>;
  priority_distribution: Record<string, number>;
  ai_evaluations_count?: number;
  fallback_evaluations_count?: number;
  total_matches_evaluated?: number;
  processing_breakdown?: {
    total_assessments: number;
    external_ai_assessments: number;
    deterministic_heuristic_assessments: number;
  };
}

export interface DedupConfigSettings {
  auto_link_threshold: number;
  manual_review_threshold: number;
  auto_merge_threshold?: number;
  review_threshold?: number;
  pothole_radius_meters?: number;
  garbage_radius_meters?: number;
  drainage_radius_meters?: number;
  streetlight_radius_meters?: number;
  category_radii: Record<string, number>;
  weights: Record<string, number>;
  ai_enabled: boolean;
  reopening_window_hours: number;
  max_candidates: number;
  updated_at?: string;
}

export interface SeverityConfigSettings {
  low_max: number;
  medium_max: number;
  high_max: number;
  critical_max: number;
  confidence_threshold: number;
  auto_update_threshold: number;
  category_weights: Record<string, any>;
  updated_at?: string;
}

export interface PriorityConfigSettings {
  weight_severity: number;
  weight_safety_risk: number;
  weight_affected_population: number;
  weight_duration: number;
  weight_unique_citizens: number;
  weight_escalation_trend: number;
  severity_weight?: number;
  safety_risk_weight?: number;
  affected_population_weight?: number;
  duration_weight?: number;
  unique_citizens_weight?: number;
  escalation_trend_weight?: number;
  normalization_rules?: Record<string, any>;
  updated_at?: string;
}

export interface DuplicatePreviewResponse {
  has_possible_duplicates: boolean;
  candidate_count: number;
  top_candidate?: {
    issue_id: number;
    display_id?: string;
    title: string;
    category: string;
    distance_meters: number;
    address?: string;
    total_reports: number;
    unique_citizens: number;
    status: string;
    similarity_score: number;
    image_url?: string;
  };
  candidates: {
    issue_id: number;
    display_id?: string;
    title: string;
    category: string;
    distance_meters: number;
    address?: string;
    total_reports: number;
    unique_citizens: number;
    status: string;
    similarity_score: number;
    image_url?: string;
  }[];
  message?: string;
}

export interface MapPoint {
  id: number;
  title: string;
  description?: string;
  issue_type: string;
  latitude: number;
  longitude: number;
  address?: string;
  status: string;
  severity: string;
  priority_score: number;
  priority_explanation?: string;
  image_url?: string;
  annotated_image_url?: string;
  resolution_image_url?: string;
  department?: string | null;
  support_count?: number;
  is_overdue?: boolean;
  created_at: string;
}

export interface DepartmentStat {
  department_id: number;
  department_name: string;
  department_code?: string;
  total_assigned: number;
  active_count?: number;
  pending: number;
  in_progress: number;
  resolved: number;
  resolution_rate: number;
  overdue_count?: number;
}

export interface PredictiveHotspot {
  cluster_id: string;
  latitude: number;
  longitude: number;
  address: string;
  total_complaints: number;
  unresolved_complaints: number;
  critical_complaints: number;
  reopened_complaints: number;
  dominant_category: string;
  risk_score: number;
  risk_level: string;
  risk_color: string;
  recurrence_probability: string;
  confidence: number;
  forecast_period: string;
  preventive_action: string;
  methodology_note: string;
}

export interface AnalyticsDashboardData {
  total_issues: number;
  open_issues: number;
  in_progress_issues: number;
  resolved_issues: number;
  critical_issues_count: number;
  reopened_count?: number;
  escalated_count?: number;
  average_resolution_hours?: number;
  issues_by_category: Record<string, number>;
  issues_by_severity: Record<string, number>;
  issues_by_status: Record<string, number>;
  department_performance: DepartmentStat[];
  predictive_hotspots?: PredictiveHotspot[];
}

export interface PublicAccountabilitySummary {
  total_complaints: number;
  resolved_complaints: number;
  in_progress_complaints: number;
  pending_complaints: number;
  reopened_complaints: number;
  citizen_verified_count: number;
  resolution_rate: number;
  avg_resolution_hours: number;
  department_metrics: DepartmentStat[];
  monthly_trends: { month: string; submitted: number; resolved: number }[];
  data_as_of: string;
}
