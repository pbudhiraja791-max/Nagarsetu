import 'dart:convert';
import 'package:http/http.dart' as http;

class PythonAiServiceClient {
  final String baseUrl;
  final Duration timeout;

  PythonAiServiceClient({
    this.baseUrl = 'http://127.0.0.1:8000/api/v1',
    this.timeout = const Duration(seconds: 5),
  });

  /// Evaluates duplicate similarity between a new report and candidate issue
  Future<Map<String, dynamic>> evaluateDuplicateWithAi({
    required String newCategory,
    required String newDescription,
    required String existingCategory,
    required String existingTitle,
    required String existingSummary,
    double distanceMeters = 0.0,
    String? newImageUrl,
    String? existingImageUrl,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/ai/evaluate-duplicate'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'new_category': newCategory,
              'new_description': newDescription,
              'existing_category': existingCategory,
              'existing_title': existingTitle,
              'existing_summary': existingSummary,
              'distance_meters': distanceMeters,
              'new_image_url': newImageUrl,
              'existing_image_url': existingImageUrl,
            }),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      // Fallback deterministic logic if Python microservice is not reachable
    }

    return _deterministicFallbackDuplicate(
      newCategory: newCategory,
      newDescription: newDescription,
      existingCategory: existingCategory,
      existingTitle: existingTitle,
      existingSummary: existingSummary,
      distanceMeters: distanceMeters,
    );
  }

  /// Evaluates physical severity and dimensions
  Future<Map<String, dynamic>> evaluateSeverityWithAi({
    required String category,
    required String description,
    String? imageUrl,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/ai/evaluate-severity'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'category': category,
              'description': description,
              'image_url': imageUrl,
            }),
          )
          .timeout(timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      // Fallback deterministic severity calculation
    }

    return _deterministicFallbackSeverity(category, description);
  }

  Map<String, dynamic> _deterministicFallbackDuplicate({
    required String newCategory,
    required String newDescription,
    required String existingCategory,
    required String existingTitle,
    required String existingSummary,
    required double distanceMeters,
  }) {
    // Hard category gate
    final isCategoryMatch = newCategory.trim().toLowerCase() == existingCategory.trim().toLowerCase();
    if (!isCategoryMatch) {
      return {
        'same_problem': false,
        'confidence': 0.1,
        'text_match': 0.1,
        'visual_match': 0.1,
        'reasoning': 'Different categories at location ($newCategory vs $existingCategory); hard category gate separated issues.',
        'model_name': 'nagarsetu_deterministic_fallback'
      };
    }

    // Semantic text word intersection
    final newWords = newDescription.toLowerCase().split(RegExp(r'\s+')).where((w) => w.length > 2).toSet();
    final existingWords = ('$existingTitle $existingSummary').toLowerCase().split(RegExp(r'\s+')).where((w) => w.length > 2).toSet();
    final intersection = newWords.intersection(existingWords).length;
    final union = newWords.union(existingWords).length;
    final textSim = union > 0 ? (intersection / union) : 0.4;

    final geoSim = distanceMeters <= 30.0 ? 0.9 : distanceMeters <= 75.0 ? 0.7 : 0.3;
    final isSame = textSim >= 0.25 && geoSim >= 0.7;

    return {
      'same_problem': isSame,
      'confidence': isSame ? 0.85 : 0.45,
      'text_match': textSim,
      'visual_match': 0.65,
      'reasoning': isSame
          ? 'Proximity (${distanceMeters.toStringAsFixed(1)}m) and descriptive keywords match active issue.'
          : 'Geographical or semantic distance suggests distinct physical incident.',
      'model_name': 'nagarsetu_deterministic_fallback'
    };
  }

  Map<String, dynamic> _deterministicFallbackSeverity(String category, String description) {
    final lower = '$category $description'.toLowerCase();
    double baseScore = 45.0;
    String level = 'MEDIUM';

    if (lower.contains('wire') || lower.contains('spark') || lower.contains('shock') || lower.contains('manhole') || lower.contains('collapse')) {
      baseScore = 85.0;
      level = 'CRITICAL';
    } else if (lower.contains('garbage') || lower.contains('dump') || lower.contains('overflow') || lower.contains('deep')) {
      baseScore = 65.0;
      level = 'HIGH';
    } else if (lower.contains('dim') || lower.contains('minor') || lower.contains('small')) {
      baseScore = 25.0;
      level = 'LOW';
    }

    return {
      'severity_score': baseScore,
      'severity_level': level,
      'confidence': 0.80,
      'hazard_factors': ['Pedestrian obstruction', 'Municipal safety guideline'],
      'reasoning': 'Evaluated via deterministic municipal hazard matrix.',
      'model_name': 'nagarsetu_deterministic_matrix'
    };
  }
}
