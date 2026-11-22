import React, { useState, useRef, useCallback, useEffect } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { smartCameraService } from '../services/api';
import { useAuth } from '../context/AuthContext';
import {
  Camera, Upload, Cpu, MapPin, CheckCircle2, XCircle, AlertTriangle,
  ArrowLeft, ArrowRight, RefreshCw, Zap, Eye, Building2, RotateCcw,
  Plus, Sparkles, ShieldAlert, Navigation, ChevronRight, Info,
} from 'lucide-react';

// ─── Types ───────────────────────────────────────────────────────────────────
type Step = 'capture' | 'preview' | 'analyzing' | 'ai_result' | 'location' | 'duplicate' | 'confirm' | 'success';

interface AIAnalysis {
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
}

interface NearbyIssue {
  id: number; display_id: string; title: string; issue_type: string;
  status: string; distance_meters: number; distance_text: string;
  report_count: number; image_url: string | null; similarity_score: number;
  category_match: boolean;
}

// ─── Helpers ─────────────────────────────────────────────────────────────────
const SEVERITY_COLORS: Record<string, string> = {
  Low:      'bg-emerald-50 text-emerald-700 border-emerald-200',
  Medium:   'bg-amber-50  text-amber-700  border-amber-200',
  High:     'bg-orange-50 text-orange-700 border-orange-200',
  Critical: 'bg-red-50    text-red-700    border-red-200',
};

const SEVERITY_DOTS: Record<string, string> = {
  Low: 'bg-emerald-400', Medium: 'bg-amber-400', High: 'bg-orange-400', Critical: 'bg-red-500 animate-pulse',
};

const CATEGORY_ICONS: Record<string, string> = {
  'Pothole': '🕳️', 'Road Damage': '🚧', 'Garbage Accumulation': '🗑️',
  'Overflowing Dustbin': '♻️', 'Water Leakage': '💧', 'Drainage Blockage': '🌊',
  'Waterlogging': '🌧️', 'Electrical Wire Hazard': '⚡',
  'Open Manhole': '⚠️', 'Infrastructure Damage': '🏗️', 'Other': '📌',
};

const STEPS: Record<Step, number> = {
  capture: 1, preview: 2, analyzing: 3, ai_result: 4,
  location: 5, duplicate: 6, confirm: 7, success: 8,
};

// ─── Component ───────────────────────────────────────────────────────────────
export const SmartCameraPage: React.FC = () => {
  const navigate = useNavigate();
  const { user } = useAuth();
  const videoRef = useRef<HTMLVideoElement>(null);
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const streamRef = useRef<MediaStream | null>(null);

  // Step state
  const [step, setStep] = useState<Step>('capture');

  // Camera state
  const [cameraActive, setCameraActive] = useState(false);
  const [cameraError, setCameraError] = useState('');
  const [facingMode, setFacingMode] = useState<'environment' | 'user'>('environment');
  const [flashOn, setFlashOn] = useState(false);
  const [cameraSupported] = useState(() => !!(navigator.mediaDevices?.getUserMedia));

  // Image state
  const [capturedFile, setCapturedFile] = useState<File | null>(null);
  const [imagePreviewUrl, setImagePreviewUrl] = useState<string | null>(null);
  const [tempImageFilename, setTempImageFilename] = useState('');
  const [qualityWarning, setQualityWarning] = useState<string | null>(null);

  // AI state
  const [aiAnalysis, setAiAnalysis] = useState<AIAnalysis | null>(null);
  const [aiError, setAiError] = useState('');
  const [aiEngine, setAiEngine] = useState('');

  // Editable fields
  const [editTitle, setEditTitle] = useState('');
  const [editDesc, setEditDesc] = useState('');
  const [editCategory, setEditCategory] = useState('');
  const [editSeverity, setEditSeverity] = useState('Medium');

  // Location state
  const [latitude, setLatitude] = useState<number | null>(null);
  const [longitude, setLongitude] = useState<number | null>(null);
  const [address, setAddress] = useState('');
  const [locationLoading, setLocationLoading] = useState(false);
  const [locationError, setLocationError] = useState('');

  // Duplicate state
  const [nearbyIssues, setNearbyIssues] = useState<NearbyIssue[]>([]);
  const [duplicateLoading, setDuplicateLoading] = useState(false);
  const [selectedDuplicate, setSelectedDuplicate] = useState<NearbyIssue | null>(null);

  // Submit state
  const [submitting, setSubmitting] = useState(false);
  const [submitError, setSubmitError] = useState('');
  const [successData, setSuccessData] = useState<any>(null);

  // ── Camera lifecycle ──────────────────────────────────────────────────────
  const startCamera = useCallback(async () => {
    setCameraError('');
    try {
      if (streamRef.current) {
        streamRef.current.getTracks().forEach(t => t.stop());
      }
      const stream = await navigator.mediaDevices.getUserMedia({
        video: { facingMode, width: { ideal: 1920 }, height: { ideal: 1080 } },
        audio: false,
      });
      streamRef.current = stream;
      if (videoRef.current) {
        videoRef.current.srcObject = stream;
        await videoRef.current.play();
      }
      setCameraActive(true);
    } catch (err: any) {
      const msg = err.name === 'NotAllowedError'
        ? 'Camera permission denied. Please allow camera access in your browser settings.'
        : err.name === 'NotFoundError'
        ? 'No camera found on this device.'
        : 'Could not start camera. Try uploading a photo instead.';
      setCameraError(msg);
      setCameraActive(false);
    }
  }, [facingMode]);

  const stopCamera = useCallback(() => {
    if (streamRef.current) {
      streamRef.current.getTracks().forEach(t => t.stop());
      streamRef.current = null;
    }
    setCameraActive(false);
  }, []);

  useEffect(() => {
    if (step === 'capture' && cameraSupported) startCamera();
    return () => { if (step !== 'capture') stopCamera(); };
  }, [step, facingMode]);

  useEffect(() => {
    return () => stopCamera();
  }, []);

  // ── Capture photo from live camera ───────────────────────────────────────
  const capturePhoto = useCallback(() => {
    if (!videoRef.current || !canvasRef.current) return;
    const video = videoRef.current;
    const canvas = canvasRef.current;
    canvas.width = video.videoWidth || 1920;
    canvas.height = video.videoHeight || 1080;
    const ctx = canvas.getContext('2d')!;
    ctx.drawImage(video, 0, 0, canvas.width, canvas.height);

    // Validate image quality (brightness / contrast check)
    let warn: string | null = null;
    try {
      const imgData = ctx.getImageData(0, 0, canvas.width, canvas.height);
      const data = imgData.data;
      let sumLuma = 0;
      const step = Math.max(1, Math.floor(data.length / (320 * 240 * 4)));
      let sampled = 0;
      for (let i = 0; i < data.length; i += 4 * step) {
        sumLuma += 0.299 * data[i] + 0.587 * data[i + 1] + 0.114 * data[i + 2];
        sampled++;
      }
      const avgBrightness = sumLuma / sampled;
      if (avgBrightness < 35) {
        warn = "The photo is too dark. The civic issue might not be visible.";
      } else if (avgBrightness > 245) {
        warn = "The photo is overexposed or washed out.";
      }
    } catch {
      // ignore security restrictions if any
    }
    setQualityWarning(warn);

    canvas.toBlob((blob) => {
      if (!blob) return;
      const file = new File([blob], `capture_${Date.now()}.jpg`, { type: 'image/jpeg' });
      setCapturedFile(file);
      setImagePreviewUrl(URL.createObjectURL(blob));
      stopCamera();
      setStep('preview');
    }, 'image/jpeg', 0.95);
  }, [stopCamera]);

  // ── Rotate captured image 90 degrees ─────────────────────────────────────
  const rotateImage = () => {
    if (!imagePreviewUrl) return;
    const img = new Image();
    img.onload = () => {
      const canvas = document.createElement('canvas');
      canvas.width = img.height;
      canvas.height = img.width;
      const ctx = canvas.getContext('2d')!;
      ctx.translate(canvas.width / 2, canvas.height / 2);
      ctx.rotate((90 * Math.PI) / 180);
      ctx.drawImage(img, -img.width / 2, -img.height / 2);
      canvas.toBlob((blob) => {
        if (blob) {
          const file = new File([blob], `rotated_${Date.now()}.jpg`, { type: 'image/jpeg' });
          setCapturedFile(file);
          setImagePreviewUrl(URL.createObjectURL(blob));
        }
      }, 'image/jpeg', 0.95);
    };
    img.src = imagePreviewUrl;
  };

  // ── Switch camera ─────────────────────────────────────────────────────────
  const switchCamera = useCallback(() => {
    setFacingMode(m => m === 'environment' ? 'user' : 'environment');
  }, []);

  // ── File upload from gallery ──────────────────────────────────────────────
  const handleFileUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    if (!file.type.startsWith('image/')) {
      setCameraError('Please select a valid image file (JPG, PNG, WEBP)');
      return;
    }
    if (file.size > 15 * 1024 * 1024) {
      setCameraError('Image too large. Maximum 15MB.');
      return;
    }
    setQualityWarning(null);
    setCapturedFile(file);
    setImagePreviewUrl(URL.createObjectURL(file));
    stopCamera();
    setStep('preview');
  };

  // ── Run AI Analysis ───────────────────────────────────────────────────────
  const runAIAnalysis = async () => {
    if (!capturedFile) return;
    if (!user) { navigate('/login'); return; }
    setStep('analyzing');
    setAiError('');
    try {
      const result = await smartCameraService.analyzeImage(capturedFile);
      setTempImageFilename(result.temp_image_filename);
      setAiEngine(result.ai_engine);
      setAiAnalysis(result.analysis);
      setEditTitle(result.analysis.issue_title);
      setEditDesc(result.analysis.description);
      setEditCategory(result.analysis.issue_category);
      setEditSeverity(result.analysis.severity);
      setStep('ai_result');
    } catch (err: any) {
      const msg = err.response?.data?.detail || 'AI analysis failed. You can still submit manually.';
      setAiError(msg);
      setStep('ai_result');
    }
  };

  // ── Fetch GPS Location ────────────────────────────────────────────────────
  const fetchLocation = () => {
    setLocationLoading(true);
    setLocationError('');
    if (!navigator.geolocation) {
      setLocationError('Geolocation not supported by your browser.');
      setLocationLoading(false);
      return;
    }
    navigator.geolocation.getCurrentPosition(
      async (pos) => {
        const lat = parseFloat(pos.coords.latitude.toFixed(5));
        const lng = parseFloat(pos.coords.longitude.toFixed(5));
        setLatitude(lat);
        setLongitude(lng);
        setAddress(`GPS Location (${lat}, ${lng})`);
        setLocationLoading(false);

        // Try reverse geocode via Nominatim (free, no key)
        try {
          const geo = await fetch(
            `https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lng}&format=json`
          ).then(r => r.json());
          if (geo?.display_name) {
            const parts = geo.display_name.split(',').slice(0, 4).join(',');
            setAddress(parts);
          }
        } catch { /* use GPS fallback address */ }
      },
      (err) => {
        const msg = err.code === 1
          ? 'Location permission denied. Please enter location manually.'
          : 'Could not get location. Enter manually below.';
        setLocationError(msg);
        setLocationLoading(false);
      },
      { timeout: 10000, enableHighAccuracy: true }
    );
  };

  const goToLocation = () => {
    setStep('location');
    fetchLocation();
  };

  // ── Check for duplicate issues ────────────────────────────────────────────
  const checkDuplicates = async () => {
    if (!latitude || !longitude) { goToSubmitConfirm(); return; }
    setStep('duplicate');
    setDuplicateLoading(true);
    try {
      const result = await smartCameraService.findNearbyIssues(latitude, longitude, editCategory, 100);
      setNearbyIssues(result.nearby_issues);
    } catch { setNearbyIssues([]); }
    setDuplicateLoading(false);
  };

  const goToSubmitConfirm = () => setStep('confirm');

  // ── Final Submit — New Issue ──────────────────────────────────────────────
  const submitNewIssue = async () => {
    if (!tempImageFilename) { setSubmitError('Image upload is missing. Please retake.'); return; }
    setSubmitting(true);
    setSubmitError('');
    try {
      const result = await smartCameraService.submitReport({
        title: editTitle,
        description: editDesc,
        category: editCategory,
        severity: editSeverity,
        latitude: latitude ?? 28.6139,
        longitude: longitude ?? 77.2090,
        address: address || 'Location not available',
        temp_image_filename: tempImageFilename,
        ai_confidence: aiAnalysis?.confidence ?? 0,
        ai_engine: aiEngine,
      });
      setSuccessData(result);
      setStep('success');
    } catch (err: any) {
      setSubmitError(err.response?.data?.detail || 'Submission failed. Please try again.');
    } finally {
      setSubmitting(false);
    }
  };

  // ── Submit as Supporting Evidence ─────────────────────────────────────────
  const submitAsSupport = async () => {
    if (!selectedDuplicate || !tempImageFilename) return;
    setSubmitting(true);
    setSubmitError('');
    try {
      const result = await smartCameraService.supportIssue(
        selectedDuplicate.id,
        tempImageFilename,
        `Supporting photo from Smart Camera. Category: ${editCategory}`
      );
      setSuccessData({ ...result, type: 'support' });
      setStep('success');
    } catch (err: any) {
      setSubmitError(err.response?.data?.detail || 'Failed to add support. Please try again.');
    } finally {
      setSubmitting(false);
    }
  };

  const retake = () => {
    setCapturedFile(null);
    setImagePreviewUrl(null);
    setAiAnalysis(null);
    setAiError('');
    setTempImageFilename('');
    setNearbyIssues([]);
    setSelectedDuplicate(null);
    setSubmitError('');
    setStep('capture');
  };

  // ─────────────────────────────────────────────────────────────────────────
  // RENDER
  // ─────────────────────────────────────────────────────────────────────────
  const currentStepNum = STEPS[step] ?? 1;

  return (
    <div className="min-h-full bg-[#f3f6fb] p-4 md:p-6 max-w-2xl mx-auto">

      {/* Header */}
      <div className="flex items-center gap-3 mb-5">
        <button onClick={() => navigate(-1)} className="w-9 h-9 rounded-xl bg-white border border-slate-200 flex items-center justify-center hover:bg-slate-50 transition-colors shadow-sm">
          <ArrowLeft className="w-4 h-4 text-slate-600" />
        </button>
        <div>
          <h1 className="text-lg font-black text-slate-900 flex items-center gap-2">
            <Camera className="w-5 h-5 text-[#1a2b6b]" /> Smart Civic Camera
          </h1>
          <p className="text-xs text-slate-500">AI-powered issue detection & reporting</p>
        </div>
        {step !== 'success' && (
          <div className="ml-auto flex items-center gap-1">
            {Object.values(STEPS).slice(0, 7).map((n) => (
              <div key={n} className={`h-1.5 rounded-full transition-all ${n <= currentStepNum ? 'bg-[#1a2b6b] w-5' : 'bg-slate-200 w-3'}`} />
            ))}
          </div>
        )}
      </div>

      {/* ── STEP 1: CAPTURE ─────────────────────────────────────────────── */}
      {step === 'capture' && (
        <div className="space-y-4">
          {/* Camera viewfinder */}
          <div className="relative bg-slate-900 rounded-2xl overflow-hidden aspect-[4/3] shadow-xl">
            {cameraActive && (
              <video
                ref={videoRef}
                autoPlay
                playsInline
                muted
                className="w-full h-full object-cover"
              />
            )}

            {!cameraActive && !cameraError && (
              <div className="absolute inset-0 flex flex-col items-center justify-center text-slate-400 gap-3">
                <RefreshCw className="w-8 h-8 animate-spin text-slate-500" />
                <span className="text-sm">Starting camera…</span>
              </div>
            )}

            {cameraError && (
              <div className="absolute inset-0 flex flex-col items-center justify-center text-center px-6 gap-4">
                <div className="w-16 h-16 rounded-full bg-red-500/20 flex items-center justify-center">
                  <XCircle className="w-8 h-8 text-red-400" />
                </div>
                <p className="text-slate-300 text-sm">{cameraError}</p>
              </div>
            )}

            {/* Overlay controls — top bar */}
            {cameraActive && (
              <div className="absolute top-0 left-0 right-0 flex items-center justify-between p-3">
                <button
                  onClick={() => setFlashOn(f => !f)}
                  className={`w-10 h-10 rounded-full flex items-center justify-center transition-all ${flashOn ? 'bg-yellow-400 text-slate-900' : 'bg-black/40 text-white'}`}
                >
                  <Zap className="w-5 h-5" />
                </button>
                <div className="bg-black/50 text-white text-xs px-3 py-1.5 rounded-full font-medium">
                  Point at a civic issue
                </div>
                <button
                  onClick={switchCamera}
                  className="w-10 h-10 rounded-full bg-black/40 text-white flex items-center justify-center hover:bg-black/60 transition-all"
                >
                  <RotateCcw className="w-5 h-5" />
                </button>
              </div>
            )}

            {/* Corner guides */}
            {cameraActive && (
              <>
                <div className="absolute top-14 left-6 w-6 h-6 border-t-2 border-l-2 border-white/60 rounded-tl-sm" />
                <div className="absolute top-14 right-6 w-6 h-6 border-t-2 border-r-2 border-white/60 rounded-tr-sm" />
                <div className="absolute bottom-20 left-6 w-6 h-6 border-b-2 border-l-2 border-white/60 rounded-bl-sm" />
                <div className="absolute bottom-20 right-6 w-6 h-6 border-b-2 border-r-2 border-white/60 rounded-br-sm" />
              </>
            )}

            {/* Capture button */}
            {cameraActive && (
              <div className="absolute bottom-5 left-0 right-0 flex justify-center">
                <button
                  onClick={capturePhoto}
                  className="w-16 h-16 rounded-full bg-white border-4 border-white/80 shadow-2xl hover:scale-105 active:scale-95 transition-all flex items-center justify-center"
                >
                  <div className="w-12 h-12 rounded-full bg-[#1a2b6b]" />
                </button>
              </div>
            )}
          </div>

          {/* Hidden canvas for capture */}
          <canvas ref={canvasRef} className="hidden" />

          {/* Gallery / Upload fallback */}
          <div className="flex gap-3">
            <button
              onClick={() => fileInputRef.current?.click()}
              className="flex-1 flex items-center justify-center gap-2 py-3.5 rounded-xl bg-white border border-slate-200 text-slate-700 font-semibold text-sm hover:bg-slate-50 transition-all shadow-sm"
            >
              <Upload className="w-4 h-4" /> Upload from Gallery
            </button>
            {cameraError && (
              <button
                onClick={startCamera}
                className="px-4 py-3.5 rounded-xl bg-[#1a2b6b] text-white font-semibold text-sm hover:bg-blue-800 transition-all shadow-sm"
              >
                Retry
              </button>
            )}
          </div>

          <input
            ref={fileInputRef}
            type="file"
            accept="image/*"
            capture="environment"
            onChange={handleFileUpload}
            className="hidden"
          />

          {!user && (
            <div className="flex items-center gap-2 p-3 bg-amber-50 border border-amber-200 rounded-xl text-sm text-amber-700">
              <AlertTriangle className="w-4 h-4 shrink-0" />
              <span>You need to <Link to="/login" className="font-bold underline">log in</Link> to submit reports.</span>
            </div>
          )}
        </div>
      )}

      {/* ── STEP 2: PREVIEW ─────────────────────────────────────────────── */}
      {step === 'preview' && imagePreviewUrl && (
        <div className="space-y-4">
          <div className="relative rounded-2xl overflow-hidden shadow-xl bg-slate-900">
            <img src={imagePreviewUrl} alt="Captured" className="w-full object-contain max-h-80" />
            <div className="absolute top-3 right-3 flex items-center gap-2">
              <button
                type="button"
                onClick={rotateImage}
                title="Rotate 90°"
                className="w-9 h-9 rounded-full bg-black/60 text-white flex items-center justify-center hover:bg-black/80 transition-all shadow-md"
              >
                <RotateCcw className="w-4 h-4" />
              </button>
              <button
                type="button"
                onClick={retake}
                title="Cancel"
                className="w-9 h-9 rounded-full bg-black/60 text-white flex items-center justify-center hover:bg-black/80 transition-all shadow-md"
              >
                <XCircle className="w-5 h-5" />
              </button>
            </div>
            <div className="absolute bottom-3 left-3 bg-black/60 text-white text-xs px-3 py-1.5 rounded-full">
              {capturedFile?.name || 'Captured photo'}
            </div>
          </div>

          {/* Image Quality Warning if blur or lighting issue */}
          {qualityWarning && (
            <div className="bg-amber-50 border border-amber-300 rounded-2xl p-4 flex items-start gap-3 shadow-sm">
              <AlertTriangle className="w-5 h-5 text-amber-600 shrink-0 mt-0.5" />
              <div className="flex-1">
                <p className="text-sm font-bold text-amber-900">Image Quality Warning</p>
                <p className="text-xs text-amber-800 mt-0.5">
                  The image is not clear enough to identify the issue accurately. Please capture another photograph.
                </p>
                <p className="text-xs text-amber-600 italic mt-1">{qualityWarning}</p>
                <div className="flex gap-2 mt-3">
                  <button
                    type="button"
                    onClick={retake}
                    className="px-3.5 py-1.5 bg-amber-600 text-white rounded-xl text-xs font-bold hover:bg-amber-700 shadow-sm transition-all"
                  >
                    Retake Photo
                  </button>
                  <button
                    type="button"
                    onClick={() => setQualityWarning(null)}
                    className="px-3 py-1.5 bg-white border border-amber-300 text-amber-800 rounded-xl text-xs font-semibold hover:bg-amber-100 transition-all"
                  >
                    Continue Anyway
                  </button>
                </div>
              </div>
            </div>
          )}

          <div className="bg-blue-50 border border-blue-200 rounded-xl p-4 flex items-start gap-3">
            <Sparkles className="w-5 h-5 text-blue-600 shrink-0 mt-0.5" />
            <div>
              <p className="text-sm font-semibold text-blue-800">Ready for AI Analysis</p>
              <p className="text-xs text-blue-600 mt-0.5">Gemini Vision will identify the civic issue, suggest a title, description and severity automatically.</p>
            </div>
          </div>

          <div className="grid grid-cols-2 gap-3">
            <button onClick={retake} className="py-3.5 rounded-xl border border-slate-300 bg-white text-slate-700 font-semibold text-sm hover:bg-slate-50 flex items-center justify-center gap-2 transition-all">
              <RotateCcw className="w-4 h-4" /> Retake
            </button>
            <button onClick={runAIAnalysis} className="py-3.5 rounded-xl bg-[#1a2b6b] hover:bg-blue-800 text-white font-bold text-sm flex items-center justify-center gap-2 transition-all shadow-md">
              <Cpu className="w-4 h-4" /> Analyze with AI
            </button>
          </div>
        </div>
      )}

      {/* ── STEP 3: ANALYZING ───────────────────────────────────────────── */}
      {step === 'analyzing' && (
        <div className="flex flex-col items-center justify-center py-20 gap-6">
          <div className="relative">
            <div className="w-24 h-24 rounded-full bg-blue-50 border-4 border-[#1a2b6b]/20 flex items-center justify-center">
              <Cpu className="w-10 h-10 text-[#1a2b6b]" />
            </div>
            <div className="absolute inset-0 rounded-full border-4 border-[#1a2b6b] border-t-transparent animate-spin" />
          </div>
          <div className="text-center space-y-1">
            <p className="text-lg font-black text-slate-900">Gemini AI Analyzing…</p>
            <p className="text-sm text-slate-500">Detecting civic issue, severity &amp; department</p>
          </div>
          <div className="w-full max-w-xs space-y-2">
            {['Uploading image…', 'Running Vision AI…', 'Classifying issue…', 'Calculating severity…'].map((t, i) => (
              <div key={t} className="flex items-center gap-2 text-sm text-slate-500">
                <div className="w-4 h-4 rounded-full bg-blue-100 flex items-center justify-center">
                  <div className="w-2 h-2 rounded-full bg-[#1a2b6b] animate-pulse" style={{ animationDelay: `${i * 0.3}s` }} />
                </div>
                {t}
              </div>
            ))}
          </div>
        </div>
      )}

      {/* ── STEP 4: AI RESULT ───────────────────────────────────────────── */}
      {step === 'ai_result' && (
        <div className="space-y-4">
          {/* Image thumbnail */}
          {imagePreviewUrl && (
            <div className="relative rounded-xl overflow-hidden h-36 bg-slate-900">
              <img src={imagePreviewUrl} alt="Analyzed" className="w-full h-full object-cover" />
              <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent" />
              <div className="absolute bottom-3 left-3 text-white text-xs font-semibold flex items-center gap-1.5">
                <Eye className="w-3.5 h-3.5" /> {aiEngine || 'AI Analyzed'}
              </div>
            </div>
          )}

          {aiError && !aiAnalysis && (
            <div className="p-4 bg-red-50 border border-red-200 rounded-xl flex items-start gap-3">
              <AlertTriangle className="w-5 h-5 text-red-500 shrink-0 mt-0.5" />
              <div>
                <p className="text-sm font-semibold text-red-700">AI Unavailable</p>
                <p className="text-xs text-red-600">{aiError} You can still fill in details manually.</p>
              </div>
            </div>
          )}

          {aiAnalysis && !aiAnalysis.is_civic_issue && (
            <div className="p-4 bg-amber-50 border border-amber-200 rounded-xl flex items-start gap-3">
              <Info className="w-5 h-5 text-amber-600 shrink-0 mt-0.5" />
              <div>
                <p className="text-sm font-semibold text-amber-800">Not a Civic Issue Detected</p>
                <p className="text-xs text-amber-700">{aiAnalysis.not_civic_reason || 'The image does not appear to show a civic infrastructure problem.'}</p>
                <p className="text-xs text-amber-600 mt-1">You can still submit manually if you believe otherwise.</p>
              </div>
            </div>
          )}

          {aiAnalysis && aiAnalysis.is_civic_issue && (
            <div className="bg-white rounded-2xl border border-slate-200 shadow-sm p-4 space-y-3">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <span className="text-2xl">{CATEGORY_ICONS[aiAnalysis.issue_category] || '📌'}</span>
                  <div>
                    <p className="text-xs font-semibold text-slate-500 uppercase tracking-wide">Detected Issue</p>
                    <p className="text-sm font-black text-slate-900">{aiAnalysis.issue_category}</p>
                  </div>
                </div>
                <div className="text-right">
                  <p className="text-xs text-slate-500">Confidence</p>
                  <p className="text-lg font-black text-[#1a2b6b]">{aiAnalysis.confidence_percent}%</p>
                </div>
              </div>

              {/* Confidence bar */}
              <div className="h-1.5 bg-slate-100 rounded-full overflow-hidden">
                <div className="h-full bg-[#1a2b6b] rounded-full transition-all" style={{ width: `${aiAnalysis.confidence_percent}%` }} />
              </div>

              <div className={`inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-bold border ${SEVERITY_COLORS[aiAnalysis.severity]}`}>
                <span className={`w-1.5 h-1.5 rounded-full ${SEVERITY_DOTS[aiAnalysis.severity]}`} />
                {aiAnalysis.severity} Severity
              </div>

              {aiAnalysis.visual_evidence && (
                <p className="text-xs text-slate-500 italic">👁️ {aiAnalysis.visual_evidence}</p>
              )}

              <div className="flex items-center gap-1.5 text-xs text-slate-600">
                <Building2 className="w-3.5 h-3.5 text-blue-500" />
                Suggested: <span className="font-semibold">{aiAnalysis.suggested_department}</span>
              </div>
            </div>
          )}

          {/* Editable fields */}
          <div className="bg-white rounded-2xl border border-slate-200 shadow-sm p-4 space-y-3">
            <p className="text-sm font-bold text-slate-700 flex items-center gap-1.5">
              <Sparkles className="w-4 h-4 text-[#1a2b6b]" /> Review &amp; Edit Details
            </p>

            <div className="space-y-2">
              <label className="text-xs font-semibold text-slate-600">Title</label>
              <input
                value={editTitle}
                onChange={e => setEditTitle(e.target.value)}
                placeholder="Short description of the issue"
                className="w-full px-3 py-2.5 text-sm rounded-xl border border-slate-200 bg-slate-50 text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-400"
              />
            </div>

            <div className="space-y-2">
              <label className="text-xs font-semibold text-slate-600">Description</label>
              <textarea
                value={editDesc}
                onChange={e => setEditDesc(e.target.value)}
                rows={3}
                placeholder="Describe the problem in detail…"
                className="w-full px-3 py-2.5 text-sm rounded-xl border border-slate-200 bg-slate-50 text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-400 resize-none"
              />
            </div>

            <div className="grid grid-cols-2 gap-3">
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-600">Category</label>
                <select
                  value={editCategory}
                  onChange={e => setEditCategory(e.target.value)}
                  className="w-full px-3 py-2.5 text-xs rounded-xl border border-slate-200 bg-slate-50 text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-400"
                >
                  {['Pothole','Road Damage','Garbage Accumulation','Overflowing Dustbin','Water Leakage','Drainage Blockage','Waterlogging','Electrical Wire Hazard','Open Manhole','Infrastructure Damage','Other'].map(c => (
                    <option key={c} value={c}>{c}</option>
                  ))}
                </select>
              </div>
              <div className="space-y-1.5">
                <label className="text-xs font-semibold text-slate-600">Severity</label>
                <select
                  value={editSeverity}
                  onChange={e => setEditSeverity(e.target.value)}
                  className="w-full px-3 py-2.5 text-xs rounded-xl border border-slate-200 bg-slate-50 text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-400"
                >
                  {['Low','Medium','High','Critical'].map(s => (
                    <option key={s} value={s}>{s}</option>
                  ))}
                </select>
              </div>
            </div>
          </div>

          <button
            onClick={goToLocation}
            disabled={!editTitle.trim()}
            className="w-full py-3.5 rounded-xl bg-[#1a2b6b] hover:bg-blue-800 disabled:opacity-50 text-white font-bold text-sm flex items-center justify-center gap-2 transition-all shadow-md"
          >
            Next: Add Location <ArrowRight className="w-4 h-4" />
          </button>
        </div>
      )}

      {/* ── STEP 5: LOCATION ────────────────────────────────────────────── */}
      {step === 'location' && (
        <div className="space-y-4">
          <div className="bg-white rounded-2xl border border-slate-200 shadow-sm p-5 space-y-4">
            <div className="flex items-center gap-2 mb-1">
              <MapPin className="w-5 h-5 text-[#1a2b6b]" />
              <h2 className="font-black text-slate-900">Confirm Location</h2>
            </div>

            {locationLoading && (
              <div className="flex items-center gap-3 p-3 bg-blue-50 rounded-xl text-blue-700 text-sm">
                <Navigation className="w-4 h-4 animate-pulse" />
                Getting your GPS location…
              </div>
            )}

            {locationError && (
              <div className="p-3 bg-red-50 border border-red-200 rounded-xl text-red-700 text-sm flex items-center gap-2">
                <AlertTriangle className="w-4 h-4 shrink-0" />
                {locationError}
              </div>
            )}

            {latitude && longitude && (
              <div className="p-3 bg-emerald-50 border border-emerald-200 rounded-xl flex items-center gap-3">
                <CheckCircle2 className="w-5 h-5 text-emerald-500 shrink-0" />
                <div className="text-sm">
                  <p className="font-semibold text-emerald-800">Location Detected</p>
                  <p className="text-emerald-600 text-xs font-mono">{latitude}, {longitude}</p>
                </div>
              </div>
            )}

            <div className="space-y-2">
              <label className="text-xs font-semibold text-slate-600">Address / Landmark</label>
              <input
                value={address}
                onChange={e => setAddress(e.target.value)}
                placeholder="Enter address or nearby landmark…"
                className="w-full px-3 py-2.5 text-sm rounded-xl border border-slate-200 bg-slate-50 text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-400"
              />
            </div>

            {(!latitude || !longitude) && (
              <div className="grid grid-cols-2 gap-3">
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-600">Latitude</label>
                  <input
                    type="number" step="0.00001"
                    value={latitude ?? ''}
                    onChange={e => setLatitude(parseFloat(e.target.value))}
                    placeholder="e.g. 28.6139"
                    className="w-full px-3 py-2.5 text-sm rounded-xl border border-slate-200 bg-slate-50 text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-400"
                  />
                </div>
                <div className="space-y-1.5">
                  <label className="text-xs font-semibold text-slate-600">Longitude</label>
                  <input
                    type="number" step="0.00001"
                    value={longitude ?? ''}
                    onChange={e => setLongitude(parseFloat(e.target.value))}
                    placeholder="e.g. 77.2090"
                    className="w-full px-3 py-2.5 text-sm rounded-xl border border-slate-200 bg-slate-50 text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-400"
                  />
                </div>
              </div>
            )}

            <div className="flex gap-3">
              <button
                onClick={fetchLocation}
                disabled={locationLoading}
                className="flex-1 flex items-center justify-center gap-2 py-3 rounded-xl border border-slate-300 bg-white text-slate-700 font-semibold text-sm hover:bg-slate-50 transition-all"
              >
                <Navigation className="w-4 h-4" />
                {latitude ? 'Re-detect' : 'Detect GPS'}
              </button>
              <button
                onClick={checkDuplicates}
                className="flex-1 py-3 rounded-xl bg-[#1a2b6b] hover:bg-blue-800 text-white font-bold text-sm flex items-center justify-center gap-2 transition-all shadow-md"
              >
                Continue <ArrowRight className="w-4 h-4" />
              </button>
            </div>
          </div>
        </div>
      )}

      {/* ── STEP 6: DUPLICATE CHECK ─────────────────────────────────────── */}
      {step === 'duplicate' && (
        <div className="space-y-4">
          <div className="bg-white rounded-2xl border border-slate-200 shadow-sm p-5">
            <div className="flex items-center gap-2 mb-3">
              <ShieldAlert className="w-5 h-5 text-[#1a2b6b]" />
              <h2 className="font-black text-slate-900">Duplicate Check</h2>
            </div>

            {duplicateLoading && (
              <div className="flex flex-col items-center py-8 gap-3">
                <RefreshCw className="w-8 h-8 text-[#1a2b6b] animate-spin" />
                <p className="text-sm text-slate-500">Scanning for existing issues nearby…</p>
              </div>
            )}

            {!duplicateLoading && nearbyIssues.length === 0 && (
              <div className="text-center py-6 space-y-2">
                <div className="w-14 h-14 rounded-full bg-emerald-50 flex items-center justify-center mx-auto">
                  <CheckCircle2 className="w-7 h-7 text-emerald-500" />
                </div>
                <p className="text-sm font-bold text-slate-800">No duplicates found!</p>
                <p className="text-xs text-slate-500">This appears to be a new issue. Proceeding to submit.</p>
              </div>
            )}

            {!duplicateLoading && nearbyIssues.length > 0 && (
              <div className="space-y-3">
                <p className="text-sm text-slate-600">
                  Found <span className="font-bold text-orange-600">{nearbyIssues.length}</span> similar issue{nearbyIssues.length > 1 ? 's' : ''} nearby. Is yours the same?
                </p>

                {nearbyIssues.map(issue => (
                  <button
                    key={issue.id}
                    onClick={() => setSelectedDuplicate(issue.id === selectedDuplicate?.id ? null : issue)}
                    className={`w-full text-left p-3 rounded-xl border-2 transition-all ${
                      selectedDuplicate?.id === issue.id
                        ? 'border-[#1a2b6b] bg-blue-50'
                        : 'border-slate-200 bg-slate-50 hover:border-slate-300'
                    }`}
                  >
                    <div className="flex items-start gap-3">
                      {issue.image_url && (
                        <img src={issue.image_url} alt="" className="w-14 h-14 rounded-lg object-cover shrink-0 bg-slate-200" />
                      )}
                      {!issue.image_url && (
                        <div className="w-14 h-14 rounded-lg bg-slate-200 flex items-center justify-center shrink-0">
                          <span className="text-2xl">{CATEGORY_ICONS[issue.issue_type] || '📌'}</span>
                        </div>
                      )}
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center gap-2 mb-0.5">
                          <span className="text-xs font-mono text-teal-600 font-bold">{issue.display_id}</span>
                          <span className="text-[10px] bg-slate-100 text-slate-500 px-1.5 py-0.5 rounded">{issue.distance_text}</span>
                          {issue.category_match && <span className="text-[10px] bg-blue-100 text-blue-600 px-1.5 py-0.5 rounded">Same category</span>}
                        </div>
                        <p className="text-sm font-semibold text-slate-900 truncate">{issue.title}</p>
                        <p className="text-xs text-slate-500 mt-0.5">{issue.report_count} reports · {issue.status.replace('_', ' ')}</p>
                      </div>
                      <div className="text-right shrink-0">
                        <div className="text-xs font-bold text-[#1a2b6b]">{Math.round(issue.similarity_score * 100)}%</div>
                        <div className="text-[10px] text-slate-400">match</div>
                      </div>
                    </div>
                  </button>
                ))}
              </div>
            )}
          </div>

          {!duplicateLoading && (
            <div className="grid grid-cols-2 gap-3">
              {selectedDuplicate ? (
                <>
                  <button
                    onClick={() => { setSelectedDuplicate(null); goToSubmitConfirm(); }}
                    className="py-3.5 rounded-xl border border-slate-300 bg-white text-slate-700 font-semibold text-sm hover:bg-slate-50 transition-all"
                  >
                    Different Issue
                  </button>
                  <button
                    onClick={submitAsSupport}
                    disabled={submitting}
                    className="py-3.5 rounded-xl bg-emerald-500 hover:bg-emerald-600 disabled:opacity-50 text-white font-bold text-sm flex items-center justify-center gap-2 transition-all shadow-md"
                  >
                    {submitting ? <RefreshCw className="w-4 h-4 animate-spin" /> : <Plus className="w-4 h-4" />}
                    Same Issue! +1
                  </button>
                </>
              ) : (
                <>
                  <button onClick={() => setStep('location')} className="py-3.5 rounded-xl border border-slate-300 bg-white text-slate-700 font-semibold text-sm hover:bg-slate-50 transition-all">
                    ← Back
                  </button>
                  <button onClick={goToSubmitConfirm} className="py-3.5 rounded-xl bg-[#1a2b6b] hover:bg-blue-800 text-white font-bold text-sm flex items-center justify-center gap-2 transition-all shadow-md">
                    New Issue <ArrowRight className="w-4 h-4" />
                  </button>
                </>
              )}
            </div>
          )}

          {submitError && (
            <p className="text-xs text-red-600 text-center">{submitError}</p>
          )}
        </div>
      )}

      {/* ── STEP 7: CONFIRM & SUBMIT ─────────────────────────────────────── */}
      {step === 'confirm' && (
        <div className="space-y-4">
          <div className="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
            {imagePreviewUrl && (
              <img src={imagePreviewUrl} alt="Report" className="w-full h-40 object-cover" />
            )}
            <div className="p-4 space-y-3">
              <div className="flex items-start justify-between gap-3">
                <div>
                  <p className="text-xs text-slate-500 uppercase tracking-wide font-semibold">{editCategory}</p>
                  <h2 className="text-base font-black text-slate-900 mt-0.5">{editTitle}</h2>
                </div>
                <span className={`shrink-0 text-xs font-bold px-2.5 py-1 rounded-full border ${SEVERITY_COLORS[editSeverity]}`}>
                  {editSeverity}
                </span>
              </div>

              <p className="text-sm text-slate-600 leading-relaxed">{editDesc}</p>

              {(latitude && longitude) && (
                <div className="flex items-center gap-1.5 text-xs text-slate-500">
                  <MapPin className="w-3.5 h-3.5 text-blue-500" />
                  {address || `${latitude}, ${longitude}`}
                </div>
              )}

              {aiAnalysis && (
                <div className="flex items-center gap-1.5 text-xs text-slate-400">
                  <Cpu className="w-3.5 h-3.5" />
                  AI confidence: {aiAnalysis.confidence_percent}% · {aiEngine}
                </div>
              )}
            </div>
          </div>

          {submitError && (
            <div className="p-3 bg-red-50 border border-red-200 rounded-xl text-red-700 text-sm flex items-center gap-2">
              <AlertTriangle className="w-4 h-4 shrink-0" />
              {submitError}
            </div>
          )}

          <div className="grid grid-cols-2 gap-3">
            <button onClick={() => setStep('ai_result')} className="py-3.5 rounded-xl border border-slate-300 bg-white text-slate-700 font-semibold text-sm hover:bg-slate-50 transition-all">
              ← Edit
            </button>
            <button
              onClick={submitNewIssue}
              disabled={submitting}
              className="py-3.5 rounded-xl bg-[#1a2b6b] hover:bg-blue-800 disabled:opacity-50 text-white font-bold text-sm flex items-center justify-center gap-2 transition-all shadow-md"
            >
              {submitting
                ? <><RefreshCw className="w-4 h-4 animate-spin" /> Submitting…</>
                : <><CheckCircle2 className="w-4 h-4" /> Submit Report</>
              }
            </button>
          </div>
        </div>
      )}

      {/* ── STEP 8: SUCCESS ──────────────────────────────────────────────── */}
      {step === 'success' && successData && (
        <div className="flex flex-col items-center text-center py-10 gap-6">
          <div className="relative">
            <div className="w-24 h-24 rounded-full bg-emerald-50 border-4 border-emerald-200 flex items-center justify-center">
              <CheckCircle2 className="w-12 h-12 text-emerald-500" />
            </div>
          </div>

          <div className="space-y-2">
            <h2 className="text-2xl font-black text-slate-900">
              {successData.type === 'support' ? 'Support Added!' : 'Report Submitted!'}
            </h2>
            <p className="text-slate-500 text-sm max-w-xs">
              {successData.type === 'support'
                ? `Your photo has been added to issue ${successData.display_id}. It now has ${successData.new_report_count} reports — helping prioritize this fix!`
                : `Your report ${successData.issue?.display_id} has been submitted and routed to ${successData.issue?.department || 'the right department'}.`
              }
            </p>
          </div>

          {successData.issue?.display_id && (
            <div className="bg-slate-50 rounded-xl px-5 py-3 border border-slate-200">
              <p className="text-xs text-slate-500">Report ID</p>
              <p className="text-xl font-black text-[#1a2b6b] font-mono">{successData.issue.display_id}</p>
            </div>
          )}

          <div className="flex flex-col gap-3 w-full max-w-xs">
            <Link
              to="/map"
              className="py-3.5 rounded-xl bg-[#1a2b6b] hover:bg-blue-800 text-white font-bold text-sm flex items-center justify-center gap-2 transition-all shadow-md"
            >
              <MapPin className="w-4 h-4" /> View on Map
            </Link>
            <button
              onClick={retake}
              className="py-3.5 rounded-xl border border-slate-300 bg-white text-slate-700 font-semibold text-sm hover:bg-slate-50 flex items-center justify-center gap-2 transition-all"
            >
              <Camera className="w-4 h-4" /> Report Another Issue
            </button>
            <Link to="/" className="text-sm text-slate-400 hover:text-slate-600 transition-colors">
              ← Back to Home
            </Link>
          </div>
        </div>
      )}
    </div>
  );
};
