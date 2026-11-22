import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../utils/geo_utils.dart';
import '../integrations/python_ai_service_client.dart';

class DuplicateDetectionService {
  final PythonAiServiceClient _aiClient;

  // Configurable confidence thresholds
  final double highConfidenceThreshold;
  final double mediumConfidenceThreshold;

  DuplicateDetectionService({
    PythonAiServiceClient? aiClient,
    this.highConfidenceThreshold = 85.0,
    this.mediumConfidenceThreshold = 60.0,
  }) : _aiClient = aiClient ?? PythonAiServiceClient();

  /// Evaluates duplicate candidates for a new citizen report
  Future<DuplicateCheckResult> evaluateDuplicate({
    required Session session,
    required String category,
    required String description,
    required double latitude,
    required double longitude,
    String? imageReference,
  }) async {
    // 1. Get category search radius in meters
    final maxRadius = GeoUtils.getRadiusForCategory(category);

    // 2. Query open / active civic issues matching the same category
    final candidateIssues = await CivicIssue.db.find(
      session,
      where: (t) => t.category.equals(category),
      orderBy: (t) => t.createdAt.desc(),
      limit: 25,
    );

    CivicIssue? bestCandidate;
    double highestScore = 0.0;
    double bestGeoSim = 0.0;
    double bestVisualSim = 0.0;
    double bestDescSim = 0.0;
    double bestCatSim = 1.0;
    double bestTempSim = 0.8;
    String bestReasoning = 'No nearby existing issues found.';

    for (final issue in candidateIssues) {
      final distance = GeoUtils.haversineDistanceMeters(
        latitude,
        longitude,
        issue.latitude,
        issue.longitude,
      );

      // Strict boundary check: beyond radius -> cannot be duplicate
      if (distance > maxRadius) continue;

      // Location similarity (35%)
      final geoSim = GeoUtils.proximitySimilarity(distance, maxRadius);

      // Consult AI microservice / fallback
      final aiResult = await _aiClient.evaluateDuplicateWithAi(
        newCategory: category,
        newDescription: description,
        existingCategory: issue.category,
        existingTitle: issue.title,
        existingSummary: issue.descriptionSummary ?? issue.title,
        distanceMeters: distance,
        newImageUrl: imageReference,
      );

      final visualSim = (aiResult['visual_match'] as num?)?.toDouble() ?? 0.5;
      final descSim = (aiResult['text_match'] as num?)?.toDouble() ?? 0.5;
      final catSim = 1.0; // Same category verified above

      // Temporal similarity (5%): issues reported recently receive higher correlation
      final ageHours = DateTime.now().difference(issue.lastReportedAt).inHours;
      final tempSim = ageHours <= 24 ? 1.0 : ageHours <= 168 ? 0.7 : 0.4;

      // Weighted scoring: Location 35%, Image 25%, Description 20%, Category 15%, Temporal 5%
      final combinedScore = ((geoSim * 0.35) +
              (visualSim * 0.25) +
              (descSim * 0.20) +
              (catSim * 0.15) +
              (tempSim * 0.05)) *
          100.0;

      if (combinedScore > highestScore) {
        highestScore = combinedScore;
        bestCandidate = issue;
        bestGeoSim = geoSim;
        bestVisualSim = visualSim;
        bestDescSim = descSim;
        bestCatSim = catSim;
        bestTempSim = tempSim;
        bestReasoning = aiResult['reasoning'] as String? ??
            'Proximity (${distance.toStringAsFixed(1)}m) and category match candidate issue #${issue.id}.';
      }
    }

    String decision;
    bool isDuplicate = false;

    if (highestScore >= highConfidenceThreshold && bestCandidate != null) {
      decision = 'HIGH_CONFIDENCE';
      isDuplicate = true;
    } else if (highestScore >= mediumConfidenceThreshold && bestCandidate != null) {
      decision = 'MEDIUM_CONFIDENCE';
      isDuplicate = false; // Hold for admin review
    } else {
      decision = 'LOW_CONFIDENCE';
      isDuplicate = false;
    }

    return DuplicateCheckResult(
      isDuplicate: isDuplicate,
      decision: decision,
      confidence: highestScore,
      candidateIssueId: bestCandidate?.id,
      geoSimilarity: bestGeoSim,
      imageSimilarity: bestVisualSim,
      descriptionSimilarity: bestDescSim,
      categorySimilarity: bestCatSim,
      temporalSimilarity: bestTempSim,
      combinedScore: highestScore,
      reasoning: bestReasoning,
    );
  }
}
