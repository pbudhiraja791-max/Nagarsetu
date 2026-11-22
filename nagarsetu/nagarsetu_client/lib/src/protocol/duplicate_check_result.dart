/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class DuplicateCheckResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DuplicateCheckResult._({
    required this.isDuplicate,
    required this.decision,
    required this.confidence,
    this.candidateIssueId,
    required this.geoSimilarity,
    required this.imageSimilarity,
    required this.descriptionSimilarity,
    required this.categorySimilarity,
    required this.temporalSimilarity,
    required this.combinedScore,
    required this.reasoning,
  });

  factory DuplicateCheckResult({
    required bool isDuplicate,
    required String decision,
    required double confidence,
    int? candidateIssueId,
    required double geoSimilarity,
    required double imageSimilarity,
    required double descriptionSimilarity,
    required double categorySimilarity,
    required double temporalSimilarity,
    required double combinedScore,
    required String reasoning,
  }) = _DuplicateCheckResultImpl;

  factory DuplicateCheckResult.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DuplicateCheckResult(
      isDuplicate: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['isDuplicate'],
      ),
      decision: jsonSerialization['decision'] as String,
      confidence: (jsonSerialization['confidence'] as num).toDouble(),
      candidateIssueId: jsonSerialization['candidateIssueId'] as int?,
      geoSimilarity: (jsonSerialization['geoSimilarity'] as num).toDouble(),
      imageSimilarity: (jsonSerialization['imageSimilarity'] as num).toDouble(),
      descriptionSimilarity: (jsonSerialization['descriptionSimilarity'] as num)
          .toDouble(),
      categorySimilarity: (jsonSerialization['categorySimilarity'] as num)
          .toDouble(),
      temporalSimilarity: (jsonSerialization['temporalSimilarity'] as num)
          .toDouble(),
      combinedScore: (jsonSerialization['combinedScore'] as num).toDouble(),
      reasoning: jsonSerialization['reasoning'] as String,
    );
  }

  bool isDuplicate;

  String decision;

  double confidence;

  int? candidateIssueId;

  double geoSimilarity;

  double imageSimilarity;

  double descriptionSimilarity;

  double categorySimilarity;

  double temporalSimilarity;

  double combinedScore;

  String reasoning;

  /// Returns a shallow copy of this [DuplicateCheckResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DuplicateCheckResult copyWith({
    bool? isDuplicate,
    String? decision,
    double? confidence,
    int? candidateIssueId,
    double? geoSimilarity,
    double? imageSimilarity,
    double? descriptionSimilarity,
    double? categorySimilarity,
    double? temporalSimilarity,
    double? combinedScore,
    String? reasoning,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DuplicateCheckResult',
      'isDuplicate': isDuplicate,
      'decision': decision,
      'confidence': confidence,
      if (candidateIssueId != null) 'candidateIssueId': candidateIssueId,
      'geoSimilarity': geoSimilarity,
      'imageSimilarity': imageSimilarity,
      'descriptionSimilarity': descriptionSimilarity,
      'categorySimilarity': categorySimilarity,
      'temporalSimilarity': temporalSimilarity,
      'combinedScore': combinedScore,
      'reasoning': reasoning,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DuplicateCheckResult',
      'isDuplicate': isDuplicate,
      'decision': decision,
      'confidence': confidence,
      if (candidateIssueId != null) 'candidateIssueId': candidateIssueId,
      'geoSimilarity': geoSimilarity,
      'imageSimilarity': imageSimilarity,
      'descriptionSimilarity': descriptionSimilarity,
      'categorySimilarity': categorySimilarity,
      'temporalSimilarity': temporalSimilarity,
      'combinedScore': combinedScore,
      'reasoning': reasoning,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DuplicateCheckResultImpl extends DuplicateCheckResult {
  _DuplicateCheckResultImpl({
    required bool isDuplicate,
    required String decision,
    required double confidence,
    int? candidateIssueId,
    required double geoSimilarity,
    required double imageSimilarity,
    required double descriptionSimilarity,
    required double categorySimilarity,
    required double temporalSimilarity,
    required double combinedScore,
    required String reasoning,
  }) : super._(
         isDuplicate: isDuplicate,
         decision: decision,
         confidence: confidence,
         candidateIssueId: candidateIssueId,
         geoSimilarity: geoSimilarity,
         imageSimilarity: imageSimilarity,
         descriptionSimilarity: descriptionSimilarity,
         categorySimilarity: categorySimilarity,
         temporalSimilarity: temporalSimilarity,
         combinedScore: combinedScore,
         reasoning: reasoning,
       );

  /// Returns a shallow copy of this [DuplicateCheckResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DuplicateCheckResult copyWith({
    bool? isDuplicate,
    String? decision,
    double? confidence,
    Object? candidateIssueId = _Undefined,
    double? geoSimilarity,
    double? imageSimilarity,
    double? descriptionSimilarity,
    double? categorySimilarity,
    double? temporalSimilarity,
    double? combinedScore,
    String? reasoning,
  }) {
    return DuplicateCheckResult(
      isDuplicate: isDuplicate ?? this.isDuplicate,
      decision: decision ?? this.decision,
      confidence: confidence ?? this.confidence,
      candidateIssueId: candidateIssueId is int?
          ? candidateIssueId
          : this.candidateIssueId,
      geoSimilarity: geoSimilarity ?? this.geoSimilarity,
      imageSimilarity: imageSimilarity ?? this.imageSimilarity,
      descriptionSimilarity:
          descriptionSimilarity ?? this.descriptionSimilarity,
      categorySimilarity: categorySimilarity ?? this.categorySimilarity,
      temporalSimilarity: temporalSimilarity ?? this.temporalSimilarity,
      combinedScore: combinedScore ?? this.combinedScore,
      reasoning: reasoning ?? this.reasoning,
    );
  }
}
