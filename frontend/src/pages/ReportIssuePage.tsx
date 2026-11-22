import React, { useState, useEffect, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { issueService } from '../services/api';
import { AIAnalysisResult, DuplicateCandidate, NLPAnalysisResult } from '../types';
import {
  Upload, MapPin, Cpu, AlertCircle, ArrowRight, CheckCircle2,
  Image as ImageIcon, Mic, MicOff, Volume2, Sparkles, Building2,
  Users, ShieldAlert, Eye, Info
} from 'lucide-react';

export const ReportIssuePage: React.FC = () => {
  const navigate = useNavigate();

  // Mode: 'photo' or 'voice'
  const [activeTab, setActiveTab] = useState<'photo' | 'voice'>('photo');

  // Input states
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  const [imagePreview, setImagePreview] = useState<string | null>(null);
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string>('Pothole');
  const [latitude, setLatitude] = useState<number>(28.6139);
  const [longitude, setLongitude] = useState<number>(77.2090);
  const [address, setAddress] = useState('Connaught Place Ring Road, Sector 4, New Delhi');

  // Voice Recording & NLP states
  const [isRecording, setIsRecording] = useState(false);
  const [voiceLanguage, setVoiceLanguage] = useState<'hi-IN' | 'en-IN' | 'pa-IN'>('hi-IN');
  const [voiceTranscript, setVoiceTranscript] = useState('');
  const [nlpResult, setNlpResult] = useState<NLPAnalysisResult | null>(null);
  const recognitionRef = useRef<any>(null);

  // AI Inspection & Duplicate Detection states
  const [analyzing, setAnalyzing] = useState(false);
  const [aiResult, setAiResult] = useState<AIAnalysisResult | null>(null);
  const [duplicates, setDuplicates] = useState<DuplicateCandidate[]>([]);
  const [duplicatePreview, setDuplicatePreview] = useState<any>(null);
  const [citizenChoice, setCitizenChoice] = useState<'same_problem' | 'different_problem' | null>(null);
  const [submissionSuccessData, setSubmissionSuccessData] = useState<any>(null);
  const [checkingDuplicates, setCheckingDuplicates] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [supportingId, setSupportingId] = useState<number | null>(null);
  const [error, setError] = useState('');
  const [successMsg, setSuccessMsg] = useState('');

  // 1. File Upload Handler
  const handleFileChange = (file: File | null) => {
    if (!file) return;
    if (!file.type || !file.type.includes('image')) {
      setError('Please select a valid image file (JPG, PNG, WEBP)');
      return;
    }
    setSelectedFile(file);
    setImagePreview(URL.createObjectURL(file));
    setError('');
  };

  // 2. Fetch GPS Location
  const handleFetchLocation = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (pos) => {
          const lat = Number(pos.coords.latitude.toFixed(4));
          const lng = Number(pos.coords.longitude.toFixed(4));
          setLatitude(lat);
          setLongitude(lng);
          setAddress(`GPS Location (${lat}, ${lng})`);
          triggerDuplicateCheck(lat, lng, selectedCategory);
        },
        () => {
          setError('Could not retrieve current location. Using default location coordinates.');
        }
      );
    }
  };

  // 3. Trigger 50m Spatial Duplicate Check & Preview
  const triggerDuplicateCheck = async (lat: number, lng: number, cat: string) => {
    setCheckingDuplicates(true);
    try {
      // Call Duplicate Preview endpoint for citizen experience (Part 13)
      const previewRes = await issueService.previewDuplicates({
        latitude: lat,
        longitude: lng,
        category: cat,
        description
      });
      setDuplicatePreview(previewRes);

      const res = await issueService.checkDuplicates({
        latitude: lat,
        longitude: lng,
        issue_type: cat,
        title,
        description,
        radius_meters: 50.0
      });
      setDuplicates(res.candidates || []);
    } catch {
      // Non-blocking
    } finally {
      setCheckingDuplicates(false);
    }
  };

  // 4. Voice Recording with Web Speech API
  const startVoiceRecording = () => {
    const SpeechRecognition = (window as any).SpeechRecognition || (window as any).webkitSpeechRecognition;
    if (!SpeechRecognition) {
      setError('Speech recognition is not supported on this browser. Please type your description.');
      return;
    }

    try {
      const recognition = new SpeechRecognition();
      recognition.lang = voiceLanguage;
      recognition.continuous = false;
      recognition.interimResults = false;

      recognition.onstart = () => {
        setIsRecording(true);
        setError('');
      };

      recognition.onresult = async (event: any) => {
        const transcriptText = event.results[0][0].transcript;
        setVoiceTranscript(transcriptText);
        setDescription(prev => prev ? `${prev} ${transcriptText}` : transcriptText);
        setIsRecording(false);

        // Run NLP parsing
        try {
          const nlp = await issueService.parseNlp(transcriptText, voiceLanguage.split('-')[0]);
          setNlpResult(nlp);
          setSelectedCategory(nlp.problem_category);
          if (!title) {
            setTitle(nlp.suggested_title);
          }
          triggerDuplicateCheck(latitude, longitude, nlp.problem_category);
        } catch {
          // ignore NLP failure
        }
      };

      recognition.onerror = (e: any) => {
        setIsRecording(false);
        setError(`Voice input error (${e.error}). Please type your description.`);
      };

      recognition.onend = () => {
        setIsRecording(false);
      };

      recognitionRef.current = recognition;
      recognition.start();
    } catch (err: any) {
      setIsRecording(false);
      setError('Could not start voice recognition.');
    }
  };

  const stopVoiceRecording = () => {
    if (recognitionRef.current) {
      recognitionRef.current.stop();
      setIsRecording(false);
    }
  };

  // 5. Run Computer Vision Defect Engine
  const handleRunAIAnalysis = async () => {
    if (!selectedFile) {
      setError('Please upload an infrastructure issue image first.');
      return;
    }
    setError('');
    setAnalyzing(true);

    try {
      const result = await issueService.analyzeImage(selectedFile);
      setAiResult(result);
      setSelectedCategory(result.issue_type);
      if (!title) {
        setTitle(`Reported ${result.issue_type} near ${address.split(',')[0]}`);
      }
      triggerDuplicateCheck(latitude, longitude, result.issue_type);
    } catch (err: any) {
      setError(err.response?.data?.detail || 'Failed to analyze image with AI model.');
    } finally {
      setAnalyzing(false);
    }
  };

  // 6. Citizen Supports Existing Duplicate Instead of Filing Clutter
  const handleSupportDuplicate = async (dupId: number) => {
    setSupportingId(dupId);
    try {
      await issueService.supportIssue(dupId);
      setSuccessMsg('You have successfully endorsed this existing nearby report! Priority has been boosted.');
      setTimeout(() => navigate(`/issue/${dupId}`), 1500);
    } catch (err: any) {
      setError(err.response?.data?.detail || 'Could not support existing report.');
    } finally {
      setSupportingId(null);
    }
  };

  // 7. Text-to-Speech Playback
  const speakText = (text: string) => {
    if ('speechSynthesis' in window) {
      const utterance = new SpeechSynthesisUtterance(text);
      utterance.lang = voiceLanguage;
      window.speechSynthesis.speak(utterance);
    }
  };

  // 8. Submit Report to NagarSetu via AI Pipeline
  const handleSubmitReport = async () => {
    if (!aiResult && !selectedFile) {
      setError('Please provide an image of the civic issue or run AI analysis.');
      return;
    }
    setSubmitting(true);
    setError('');

    try {
      const pipelineRes = await issueService.submitReport({
        submission_id: crypto.randomUUID ? crypto.randomUUID() : `sub-${Date.now()}-${Math.random().toString(36).substring(2, 9)}`,
        selected_category: selectedCategory,
        description,
        latitude,
        longitude,
        address,
        image_url: aiResult?.original_image_url || '/uploads/original/sample_infra.jpg',
        title: title || `${selectedCategory} Defect Report`,
        voice_transcript: voiceTranscript,
        original_language: voiceLanguage.split('-')[0],
        citizen_duplicate_choice: citizenChoice || undefined
      });

      setSubmissionSuccessData(pipelineRes);
    } catch (err: any) {
      setError(err.response?.data?.detail || 'Failed to submit issue report.');
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="min-h-screen bg-sky-50 text-slate-900 py-10 px-4 sm:px-6 lg:px-8">
      <div className="max-w-5xl mx-auto space-y-8">
        {/* Header */}
        <div>
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-teal-50 border border-teal-200 text-teal-600 text-xs font-semibold mb-3">
            <Sparkles className="w-3.5 h-3.5 text-teal-500" /> NAGARSETU CITIZEN REPORTING PORTAL
          </div>
          <h1 className="text-3xl sm:text-4xl font-extrabold text-slate-900 tracking-tight">
            Report Public Infrastructure Problem
          </h1>
          <p className="text-sm text-slate-500 mt-1">
            Capture photos or describe the issue via voice in Hindi, Punjabi, or English. AI validates the defect and enforces municipal repair accountability.
          </p>
        </div>

        {/* Notifications */}
        {error && (
          <div className="p-4 rounded-xl bg-red-50/40 border border-red-200 text-red-600 text-sm flex items-center gap-3">
            <AlertCircle className="w-5 h-5 flex-shrink-0 text-red-500" />
            <span>{error}</span>
          </div>
        )}
        {successMsg && (
          <div className="p-4 rounded-xl bg-emerald-50/40 border border-emerald-200 text-emerald-300 text-sm flex items-center gap-3">
            <CheckCircle2 className="w-5 h-5 flex-shrink-0 text-emerald-400" />
            <span>{successMsg}</span>
          </div>
        )}

        {/* 50-METER DUPLICATE WARNING & INTELLIGENT CITIZEN PREVIEW BANNER (Part 13) */}
        {duplicatePreview?.has_possible_duplicates && duplicatePreview.top_candidate && (
          <div className="p-6 rounded-2xl bg-gradient-to-r from-amber-950/60 to-orange-950/40 border border-amber-600/70 space-y-4 shadow-xl">
            <div className="flex items-start justify-between gap-4">
              <div className="flex items-start gap-3">
                <ShieldAlert className="w-6 h-6 text-amber-400 mt-0.5 flex-shrink-0" />
                <div>
                  <h3 className="text-base font-bold text-amber-200">
                    {duplicatePreview.message || `Looks like this problem has already been reported by ${duplicatePreview.top_candidate.total_reports} people.`}
                  </h3>
                  <p className="text-xs text-amber-300/80 mt-1">
                    Existing Issue: <strong className="text-slate-900">{duplicatePreview.top_candidate.display_id || `NG-${duplicatePreview.top_candidate.issue_id}`}</strong> — {duplicatePreview.top_candidate.title} ({duplicatePreview.top_candidate.distance_meters.toFixed(0)}m away).
                    Submitting your report adds ground photographic proof and dynamically boosts its municipal priority!
                  </p>
                </div>
              </div>
              <span className="text-xs bg-amber-900/80 text-amber-200 px-3 py-1 rounded-full border border-amber-700 font-semibold flex-shrink-0">
                {duplicatePreview.top_candidate.total_reports} Existing Reports
              </span>
            </div>

            <div className="p-3.5 rounded-xl bg-white border border-slate-200 flex flex-wrap items-center justify-between gap-3">
              <span className="text-xs text-slate-600 font-medium">
                Are you reporting the exact same physical issue?
              </span>
              <div className="flex items-center gap-2.5">
                <button
                  type="button"
                  onClick={() => setCitizenChoice('same_problem')}
                  className={`px-4 py-2 rounded-xl text-xs font-bold transition-all flex items-center gap-1.5 ${
                    citizenChoice === 'same_problem'
                      ? 'bg-amber-500 text-slate-950 ring-2 ring-amber-300 shadow-lg'
                      : 'bg-amber-50/70 hover:bg-amber-900 text-amber-100 border border-amber-700'
                  }`}
                >
                  <CheckCircle2 className="w-4 h-4" /> Yes, this is the same problem
                </button>
                <button
                  type="button"
                  onClick={() => setCitizenChoice('different_problem')}
                  className={`px-4 py-2 rounded-xl text-xs font-bold transition-all flex items-center gap-1.5 ${
                    citizenChoice === 'different_problem'
                      ? 'bg-slate-700 text-slate-900 ring-2 ring-slate-400'
                      : 'bg-slate-50 hover:bg-slate-100 text-slate-600 border border-slate-700'
                  }`}
                >
                  No, this is a different problem
                </button>
              </div>
            </div>
          </div>
        )}

        {/* INPUT WORKBENCH */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
          {/* LEFT COLUMN: Input Mode */}
          <div className="lg:col-span-7 space-y-6">
            {/* Mode Selector Tabs */}
            <div className="flex rounded-xl bg-slate-50 p-1 border border-slate-200">
              <button
                type="button"
                onClick={() => setActiveTab('photo')}
                className={`flex-1 py-2.5 rounded-lg text-sm font-semibold flex items-center justify-center gap-2 transition-all ${
                  activeTab === 'photo'
                    ? 'bg-cyan-500/20 text-teal-600 border border-cyan-500/40 shadow-sm'
                    : 'text-slate-500 hover:text-slate-900'
                }`}
              >
                <ImageIcon className="w-4 h-4" /> Upload Defect Photo
              </button>
              <button
                type="button"
                onClick={() => setActiveTab('voice')}
                className={`flex-1 py-2.5 rounded-lg text-sm font-semibold flex items-center justify-center gap-2 transition-all ${
                  activeTab === 'voice'
                    ? 'bg-teal-500/20 text-teal-300 border border-teal-500/40 shadow-sm'
                    : 'text-slate-500 hover:text-slate-900'
                }`}
              >
                <Mic className="w-4 h-4" /> Multilingual Voice Reporting
              </button>
            </div>

            {/* TAB A: Photo Upload & AI Vision */}
            {activeTab === 'photo' && (
              <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-5">
                <label className="block text-sm font-semibold text-slate-700">
                  Ground Infrastructure Defect Photograph
                </label>

                <div className="border-2 border-dashed border-slate-700 hover:border-cyan-500/60 rounded-xl p-6 text-center cursor-pointer transition-all bg-sky-50/40">
                  <input
                    type="file"
                    accept="image/*"
                    onChange={(e) => handleFileChange(e.target.files?.[0] || null)}
                    className="hidden"
                    id="image-file-input"
                  />
                  <label htmlFor="image-file-input" className="cursor-pointer space-y-2 block">
                    <Upload className="w-8 h-8 text-teal-500 mx-auto" />
                    <div className="text-sm font-medium text-slate-600">
                      {selectedFile ? selectedFile.name : 'Click to select photo (Pothole, Waste, Manhole, Waterlogging)'}
                    </div>
                    <div className="text-xs text-slate-500">Supports JPG, PNG, WEBP (Max 15MB)</div>
                  </label>
                </div>

                {imagePreview && (
                  <div className="space-y-4">
                    <div className="relative rounded-xl overflow-hidden border border-slate-700 bg-sky-50 max-h-72 flex items-center justify-center">
                      <img src={imagePreview} alt="Defect Preview" className="object-contain w-full h-full max-h-72" />
                      {aiResult && (
                        <div className="absolute top-3 left-3 bg-sky-50/90 border border-cyan-500 text-teal-600 text-xs px-3 py-1 rounded-full font-bold flex items-center gap-1.5 shadow-lg">
                          <Eye className="w-3.5 h-3.5" /> Defect Identified: {aiResult.issue_type} ({intToPct(aiResult.confidence)}%)
                        </div>
                      )}
                    </div>

                    <button
                      type="button"
                      onClick={handleRunAIAnalysis}
                      disabled={analyzing}
                      className="w-full py-3 rounded-xl bg-gradient-to-r from-cyan-600 to-teal-500 hover:from-cyan-500 hover:to-teal-400 text-slate-950 font-bold text-sm flex items-center justify-center gap-2 transition-all shadow-md shadow-cyan-950"
                    >
                      <Cpu className="w-4 h-4" />
                      {analyzing ? 'Inspecting Defect Geometry...' : 'Run NagarSetu AI Vision Analysis'}
                    </button>
                  </div>
                )}
              </div>
            )}

            {/* TAB B: Multilingual Voice First */}
            {activeTab === 'voice' && (
              <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-5">
                <div className="flex items-center justify-between">
                  <label className="text-sm font-semibold text-slate-700 flex items-center gap-2">
                    <Mic className="w-4 h-4 text-teal-400" />
                    Speak Your Complaint Naturally
                  </label>
                  <select
                    value={voiceLanguage}
                    onChange={(e: any) => setVoiceLanguage(e.target.value)}
                    className="bg-sky-50 border border-slate-700 text-xs text-slate-600 rounded-lg px-2.5 py-1"
                  >
                    <option value="hi-IN">हिन्दी (Hindi)</option>
                    <option value="en-IN">English (India)</option>
                    <option value="pa-IN">ਪੰਜਾਬੀ (Punjabi)</option>
                  </select>
                </div>

                <div className="p-6 rounded-xl bg-sky-50 border border-slate-200 text-center space-y-4">
                  <div className="flex justify-center">
                    <button
                      type="button"
                      onClick={isRecording ? stopVoiceRecording : startVoiceRecording}
                      className={`w-16 h-16 rounded-full flex items-center justify-center transition-all ${
                        isRecording
                          ? 'bg-rose-500 text-white animate-pulse shadow-lg shadow-rose-500/40 ring-4 ring-rose-500/20'
                          : 'bg-teal-500 hover:bg-teal-400 text-slate-950 shadow-lg shadow-teal-500/30'
                      }`}
                    >
                      {isRecording ? <MicOff className="w-7 h-7" /> : <Mic className="w-7 h-7" />}
                    </button>
                  </div>
                  <div className="text-sm font-semibold text-slate-600">
                    {isRecording ? 'Listening... Speak now' : 'Tap microphone to speak in Hindi or English'}
                  </div>
                  <div className="text-xs text-slate-500 italic">
                    Example: "Mere ghar ke paas sadak par bahut bada gaddha hai aur andhera hai"
                  </div>
                </div>

                {voiceTranscript && (
                  <div className="p-4 rounded-xl bg-sky-50 border border-teal-200/60 space-y-2">
                    <div className="flex items-center justify-between text-xs text-teal-400 font-semibold">
                      <span>Transcribed Voice Speech</span>
                      <button
                        type="button"
                        onClick={() => speakText(voiceTranscript)}
                        className="flex items-center gap-1 hover:text-slate-900"
                        title="Listen to TTS"
                      >
                        <Volume2 className="w-3.5 h-3.5" /> Listen
                      </button>
                    </div>
                    <p className="text-sm text-slate-700">"{voiceTranscript}"</p>
                    {nlpResult && (
                      <div className="text-xs text-slate-500 pt-1 border-t border-slate-200 flex flex-wrap gap-2">
                        <span className="text-teal-600">Category: <strong>{nlpResult.problem_category}</strong></span>
                        {nlpResult.is_urgent && <span className="text-red-500 font-bold">⚠️ Urgent Issue</span>}
                        <span>Routing: {nlpResult.recommended_department}</span>
                      </div>
                    )}
                  </div>
                )}
              </div>
            )}

            {/* Location & Coordinates Input */}
            <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-4">
              <div className="flex items-center justify-between">
                <label className="text-sm font-semibold text-slate-700 flex items-center gap-2">
                  <MapPin className="w-4 h-4 text-teal-500" /> Ground Location & Address
                </label>
                <button
                  type="button"
                  onClick={handleFetchLocation}
                  className="px-3 py-1 rounded-lg bg-teal-50 border border-teal-200 text-teal-600 hover:text-slate-900 text-xs font-semibold flex items-center gap-1.5 transition-colors"
                >
                  <MapPin className="w-3.5 h-3.5" /> Detect My GPS
                </button>
              </div>

              <input
                type="text"
                value={address}
                onChange={(e) => setAddress(e.target.value)}
                placeholder="Enter landmark, road name, or sector"
                className="w-full bg-sky-50 border border-slate-200 rounded-xl px-4 py-2.5 text-sm text-slate-700 focus:outline-none focus:border-cyan-500"
              />

              <div className="grid grid-cols-2 gap-3 text-xs text-slate-500">
                <div className="p-2.5 rounded-lg bg-sky-50 border border-slate-200">
                  Latitude: <strong className="text-slate-700 font-mono">{latitude}</strong>
                </div>
                <div className="p-2.5 rounded-lg bg-sky-50 border border-slate-200">
                  Longitude: <strong className="text-slate-700 font-mono">{longitude}</strong>
                </div>
              </div>
            </div>

            {/* Description Textarea */}
            <div className="p-6 rounded-2xl bg-white border border-slate-200 space-y-3">
              <label className="text-sm font-semibold text-slate-700">
                Detailed Ground Description (Text or Spoken)
              </label>
              <textarea
                rows={3}
                value={description}
                onChange={(e) => setDescription(e.target.value)}
                placeholder="Describe the severity, hazard to vehicles/pedestrians, or exact spot..."
                className="w-full bg-sky-50 border border-slate-200 rounded-xl px-4 py-2.5 text-sm text-slate-700 focus:outline-none focus:border-cyan-500"
              />
            </div>
          </div>

          {/* RIGHT COLUMN: AI Analysis & Final Review */}
          <div className="lg:col-span-5 space-y-6">
            {/* AI Results Card */}
            <div className="p-6 rounded-2xl bg-gradient-to-br from-slate-900/90 to-slate-950 border border-slate-200 space-y-5">
              <div className="flex items-center justify-between border-b border-slate-200 pb-3">
                <div className="flex items-center gap-2 text-teal-500 font-bold text-sm">
                  <Cpu className="w-4 h-4" />
                  <span>AI Triage & Classification</span>
                </div>
                <span className="text-xs text-slate-500 font-mono">v2.0 Engine</span>
              </div>

              {aiResult ? (
                <div className="space-y-4">
                  {/* Category Pill */}
                  <div className="flex items-center justify-between">
                    <span className="text-xs text-slate-500">Detected Category</span>
                    <span className="text-sm font-bold text-slate-900 bg-teal-50 px-3 py-1 rounded-lg border border-teal-200">
                      {aiResult.issue_type}
                    </span>
                  </div>

                  {/* Priority Gauge */}
                  <div className="p-4 rounded-xl bg-sky-50 border border-slate-200 space-y-2">
                    <div className="flex justify-between items-center text-xs">
                      <span className="text-slate-500 font-medium">Explainable Priority Score</span>
                      <span className="font-extrabold text-amber-400 font-mono text-sm">
                        {aiResult.priority_score}/100 ({aiResult.severity})
                      </span>
                    </div>
                    <div className="w-full bg-slate-100 h-2.5 rounded-full overflow-hidden">
                      <div
                        className="bg-gradient-to-r from-emerald-500 via-amber-500 to-rose-500 h-full rounded-full transition-all duration-700"
                        style={{ width: `${aiResult.priority_score}%` }}
                      />
                    </div>
                    {aiResult.priority_explanation && (
                      <div className="text-[11px] text-slate-500 whitespace-pre-line pt-2 border-t border-slate-200 leading-relaxed">
                        {aiResult.priority_explanation}
                      </div>
                    )}
                  </div>

                  {/* Routing & SLA */}
                  <div className="p-4 rounded-xl bg-sky-50 border border-slate-200 space-y-2">
                    <div className="text-xs text-slate-500 flex items-center gap-1.5">
                      <Building2 className="w-3.5 h-3.5 text-teal-400" />
                      <span>Target Department & SLA</span>
                    </div>
                    <div className="text-sm font-semibold text-slate-700">
                      {aiResult.recommended_department}
                    </div>
                    <div className="text-xs text-emerald-400 font-mono">
                      Target SLA Commitment: {aiResult.sla_hours || 48} hours
                    </div>
                  </div>

                  {/* Annotated Defect Preview */}
                  {aiResult.annotated_image_url && (
                    <div className="space-y-1.5">
                      <div className="text-xs text-slate-500 flex items-center gap-1">
                        <Eye className="w-3.5 h-3.5 text-teal-500" />
                        <span>Computer Vision Bounding Box Overlay</span>
                      </div>
                      <div className="rounded-xl overflow-hidden border border-slate-200 bg-sky-50 max-h-48">
                        <img
                          src={aiResult.annotated_image_url}
                          alt="AI Bounding Box"
                          className="w-full h-full object-contain max-h-48"
                        />
                      </div>
                    </div>
                  )}
                </div>
              ) : (
                <div className="py-12 text-center text-slate-500 space-y-2">
                  <Cpu className="w-10 h-10 text-slate-700 mx-auto" />
                  <p className="text-xs">Upload a defect photo or speak to trigger AI triage.</p>
                </div>
              )}
            </div>

            {/* Editable Title */}
            <div className="p-5 rounded-2xl bg-white border border-slate-200 space-y-2">
              <label className="text-xs font-semibold text-slate-500 uppercase tracking-wider">
                Complaint Title
              </label>
              <input
                type="text"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                placeholder="Brief summary of defect"
                className="w-full bg-sky-50 border border-slate-200 rounded-xl px-4 py-2.5 text-sm text-slate-700 focus:outline-none focus:border-cyan-500"
              />
            </div>

            {/* Submit Button */}
            <button
              type="button"
              onClick={handleSubmitReport}
              disabled={submitting}
              className="w-full py-4 rounded-xl bg-gradient-to-r from-cyan-500 via-teal-400 to-emerald-500 hover:from-cyan-400 hover:to-emerald-400 text-slate-950 font-extrabold text-base flex items-center justify-center gap-2.5 transition-all shadow-xl shadow-cyan-950 disabled:opacity-50"
            >
              <CheckCircle2 className="w-5 h-5" />
              {submitting ? 'Submitting to NagarSetu...' : 'Submit Complaint to Authorities'}
            </button>
            <p className="text-[11px] text-center text-slate-500">
              By submitting, your complaint enters the NagarSetu audit trail and requires official repair proof.
            </p>
          </div>
        </div>

        {/* POST-SUBMISSION INTELLIGENCE CONFIRMATION MODAL (Part 10 & 13) */}
        {submissionSuccessData && (
          <div className="fixed inset-0 z-50 bg-sky-50/85 backdrop-blur-md flex items-center justify-center p-4">
            <div className="bg-slate-50 border border-slate-700 max-w-lg w-full rounded-3xl p-6 sm:p-8 space-y-6 shadow-2xl animate-in fade-in zoom-in-95">
              <div className="flex items-center gap-3 border-b border-slate-200 pb-4">
                <div className="w-12 h-12 rounded-2xl bg-emerald-500/10 border border-emerald-500/30 flex items-center justify-center text-emerald-400 flex-shrink-0">
                  <CheckCircle2 className="w-6 h-6" />
                </div>
                <div>
                  <div className="text-xs font-semibold text-emerald-400 uppercase tracking-wider">
                    {submissionSuccessData.duplicate_decision === 'HIGH' ? 'Consolidated with Existing Issue' : 'New Civic Issue Registered'}
                  </div>
                  <h2 className="text-xl font-extrabold text-slate-900">Report Successfully Logged</h2>
                </div>
              </div>

              {/* Message Box */}
              <div className="p-4 rounded-2xl bg-sky-50/80 border border-slate-200 text-sm text-slate-600 leading-relaxed">
                {submissionSuccessData.message}
              </div>

              {/* Key Indicators */}
              <div className="grid grid-cols-2 gap-3 text-xs">
                <div className="p-3.5 rounded-xl bg-slate-100/50 border border-slate-700/60 space-y-1">
                  <div className="text-slate-500 font-medium">Report Tracking ID</div>
                  <div className="font-mono text-teal-600 font-bold text-sm truncate">
                    {submissionSuccessData.report_tracking_id}
                  </div>
                </div>

                <div className="p-3.5 rounded-xl bg-slate-100/50 border border-slate-700/60 space-y-1">
                  <div className="text-slate-500 font-medium">Civic Issue ID</div>
                  <div className="font-mono text-purple-300 font-bold text-sm">
                    {submissionSuccessData.parent_issue?.display_id || `NG-${submissionSuccessData.parent_issue?.id || 'NEW'}`}
                  </div>
                </div>

                {submissionSuccessData.parent_issue && (
                  <>
                    <div className="p-3.5 rounded-xl bg-slate-100/50 border border-slate-700/60 space-y-1">
                      <div className="text-slate-500 font-medium">Total Citizen Reports</div>
                      <div className="text-amber-300 font-extrabold text-base">
                        {submissionSuccessData.parent_issue.total_reports} ({submissionSuccessData.parent_issue.unique_citizens} unique citizens)
                      </div>
                    </div>

                    <div className="p-3.5 rounded-xl bg-slate-100/50 border border-slate-700/60 space-y-1">
                      <div className="text-slate-500 font-medium">Dynamic Priority</div>
                      <div className="text-red-500 font-extrabold text-base">
                        {submissionSuccessData.parent_issue.priority_level} ({submissionSuccessData.parent_issue.priority_score.toFixed(1)}/100)
                      </div>
                    </div>
                  </>
                )}
              </div>

              {/* Action Buttons */}
              <div className="flex items-center gap-3 pt-2">
                <button
                  type="button"
                  onClick={() => {
                    const targetId = submissionSuccessData.parent_issue?.id;
                    if (targetId) {
                      navigate(`/issue/${targetId}`);
                    } else {
                      navigate('/my-reports');
                    }
                  }}
                  className="flex-1 py-3.5 rounded-xl bg-cyan-500 hover:bg-cyan-400 text-slate-950 font-bold text-sm flex items-center justify-center gap-2 transition-colors shadow-lg"
                >
                  <span>View Issue & Timeline</span>
                  <ArrowRight className="w-4 h-4" />
                </button>
                <button
                  type="button"
                  onClick={() => navigate('/dashboard')}
                  className="px-5 py-3.5 rounded-xl bg-slate-100 hover:bg-slate-700 text-slate-600 text-sm font-semibold transition-colors"
                >
                  My Dashboard
                </button>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

function intToPct(val: number): number {
  return Math.round(val <= 1.0 ? val * 100 : val);
}
