import 'dart:convert';
import 'dart:math';
import '../generated/protocol.dart';

class PriorityCalculationService {
  /// Calculates dynamic 0-100 priority score with explainable factor breakdown
  static PriorityCalculationResult calculatePriority({
    required int totalReports,
    required int uniqueCitizens,
    required double severityScore, // 0 - 100
    required String category,
    required DateTime firstReportedAt,
    required int reopenedCount,
  }) {
    // 1. Report Frequency / Citizen Weight (30%)
    // Smooth logarithmic curve: 1 citizen = 25 pts, 5 = 65 pts, 15+ = 100 pts
    final freqScore = min(100.0, 25.0 + (log(max(1, uniqueCitizens)) * 28.0));

    // 2. Physical Severity (25%)
    final clampedSeverity = severityScore.clamp(0.0, 100.0);

    // 3. Public Safety Hazard (15%)
    double safetyScore = 40.0;
    final catLower = category.toLowerCase();
    if (catLower.contains('wire') || catLower.contains('spark') || catLower.contains('shock') || catLower.contains('manhole')) {
      safetyScore = 95.0; // Acute life-safety risk
    } else if (catLower.contains('waterlogging') || catLower.contains('drainage') || catLower.contains('pothole')) {
      safetyScore = 65.0;
    } else if (catLower.contains('garbage')) {
      safetyScore = 55.0;
    } else if (catLower.contains('streetlight')) {
      safetyScore = 45.0;
    }

    // 4. Population Impact (10%)
    double populationScore = 50.0;
    if (uniqueCitizens >= 10 || totalReports >= 15) {
      populationScore = 90.0;
    } else if (uniqueCitizens >= 5) {
      populationScore = 70.0;
    }

    // 5. Time Unresolved / Aging Factor (10%)
    final hoursUnresolved = DateTime.now().toUtc().difference(firstReportedAt).inHours;
    // 0 hrs = 20 pts, 24 hrs = 45 pts, 72 hrs = 75 pts, 7+ days = 100 pts
    final durationScore = min(100.0, 20.0 + (hoursUnresolved / 168.0 * 80.0));

    // 6. Reopened Factor (10%)
    // Each rejected/reopened cycle adds significant escalation
    final reopenedScore = min(100.0, reopenedCount * 45.0);

    // Weighted Combined Score
    final finalScore = (freqScore * 0.30) +
        (clampedSeverity * 0.25) +
        (safetyScore * 0.15) +
        (populationScore * 0.10) +
        (durationScore * 0.10) +
        (reopenedScore * 0.10);

    final roundedScore = double.parse(finalScore.toStringAsFixed(1));

    // Determine Priority Level
    String level;
    if (roundedScore >= 75.0 || safetyScore >= 90.0 && roundedScore >= 60.0) {
      level = 'Critical';
    } else if (roundedScore >= 50.0) {
      level = 'High';
    } else if (roundedScore >= 25.0) {
      level = 'Medium';
    } else {
      level = 'Low';
    }

    final breakdown = {
      'report_frequency': {
        'score': freqScore.round(),
        'weight': 0.30,
        'points': (freqScore * 0.30).toStringAsFixed(1),
        'unique_citizens': uniqueCitizens,
      },
      'severity': {
        'score': clampedSeverity.round(),
        'weight': 0.25,
        'points': (clampedSeverity * 0.25).toStringAsFixed(1),
      },
      'public_safety': {
        'score': safetyScore.round(),
        'weight': 0.15,
        'points': (safetyScore * 0.15).toStringAsFixed(1),
      },
      'population_impact': {
        'score': populationScore.round(),
        'weight': 0.10,
        'points': (populationScore * 0.10).toStringAsFixed(1),
      },
      'time_unresolved': {
        'score': durationScore.round(),
        'weight': 0.10,
        'points': (durationScore * 0.10).toStringAsFixed(1),
        'hours': hoursUnresolved,
      },
      'reopened_factor': {
        'score': reopenedScore.round(),
        'weight': 0.10,
        'points': (reopenedScore * 0.10).toStringAsFixed(1),
        'count': reopenedCount,
      },
    };

    final explanation =
        'Priority $roundedScore/100 ($level): (Freq 30%: ${(freqScore * 0.3).toStringAsFixed(1)}pts, '
        'Sev 25%: ${(clampedSeverity * 0.25).toStringAsFixed(1)}pts, '
        'Safety 15%: ${(safetyScore * 0.15).toStringAsFixed(1)}pts, '
        'Aging 10%: ${(durationScore * 0.10).toStringAsFixed(1)}pts).';

    return PriorityCalculationResult(
      score: roundedScore,
      level: level,
      explanation: explanation,
      breakdownJson: jsonEncode(breakdown),
    );
  }
}
