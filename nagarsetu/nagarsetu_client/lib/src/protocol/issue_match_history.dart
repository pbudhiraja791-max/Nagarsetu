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

abstract class IssueMatchHistory
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  IssueMatchHistory._({
    this.id,
    required this.reportId,
    this.matchedIssueId,
    required this.geographicSimilarity,
    required this.imageSimilarity,
    required this.descriptionSimilarity,
    required this.categorySimilarity,
    required this.temporalSimilarity,
    required this.combinedSimilarityScore,
    required this.matchingDecision,
    this.decisionReason,
    this.reviewedBy,
    required this.createdAt,
  });

  factory IssueMatchHistory({
    int? id,
    required int reportId,
    int? matchedIssueId,
    required double geographicSimilarity,
    required double imageSimilarity,
    required double descriptionSimilarity,
    required double categorySimilarity,
    required double temporalSimilarity,
    required double combinedSimilarityScore,
    required String matchingDecision,
    String? decisionReason,
    int? reviewedBy,
    required DateTime createdAt,
  }) = _IssueMatchHistoryImpl;

  factory IssueMatchHistory.fromJson(Map<String, dynamic> jsonSerialization) {
    return IssueMatchHistory(
      id: jsonSerialization['id'] as int?,
      reportId: jsonSerialization['reportId'] as int,
      matchedIssueId: jsonSerialization['matchedIssueId'] as int?,
      geographicSimilarity: (jsonSerialization['geographicSimilarity'] as num)
          .toDouble(),
      imageSimilarity: (jsonSerialization['imageSimilarity'] as num).toDouble(),
      descriptionSimilarity: (jsonSerialization['descriptionSimilarity'] as num)
          .toDouble(),
      categorySimilarity: (jsonSerialization['categorySimilarity'] as num)
          .toDouble(),
      temporalSimilarity: (jsonSerialization['temporalSimilarity'] as num)
          .toDouble(),
      combinedSimilarityScore:
          (jsonSerialization['combinedSimilarityScore'] as num).toDouble(),
      matchingDecision: jsonSerialization['matchingDecision'] as String,
      decisionReason: jsonSerialization['decisionReason'] as String?,
      reviewedBy: jsonSerialization['reviewedBy'] as int?,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int reportId;

  int? matchedIssueId;

  double geographicSimilarity;

  double imageSimilarity;

  double descriptionSimilarity;

  double categorySimilarity;

  double temporalSimilarity;

  double combinedSimilarityScore;

  String matchingDecision;

  String? decisionReason;

  int? reviewedBy;

  DateTime createdAt;

  /// Returns a shallow copy of this [IssueMatchHistory]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  IssueMatchHistory copyWith({
    int? id,
    int? reportId,
    int? matchedIssueId,
    double? geographicSimilarity,
    double? imageSimilarity,
    double? descriptionSimilarity,
    double? categorySimilarity,
    double? temporalSimilarity,
    double? combinedSimilarityScore,
    String? matchingDecision,
    String? decisionReason,
    int? reviewedBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IssueMatchHistory',
      if (id != null) 'id': id,
      'reportId': reportId,
      if (matchedIssueId != null) 'matchedIssueId': matchedIssueId,
      'geographicSimilarity': geographicSimilarity,
      'imageSimilarity': imageSimilarity,
      'descriptionSimilarity': descriptionSimilarity,
      'categorySimilarity': categorySimilarity,
      'temporalSimilarity': temporalSimilarity,
      'combinedSimilarityScore': combinedSimilarityScore,
      'matchingDecision': matchingDecision,
      if (decisionReason != null) 'decisionReason': decisionReason,
      if (reviewedBy != null) 'reviewedBy': reviewedBy,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IssueMatchHistory',
      if (id != null) 'id': id,
      'reportId': reportId,
      if (matchedIssueId != null) 'matchedIssueId': matchedIssueId,
      'geographicSimilarity': geographicSimilarity,
      'imageSimilarity': imageSimilarity,
      'descriptionSimilarity': descriptionSimilarity,
      'categorySimilarity': categorySimilarity,
      'temporalSimilarity': temporalSimilarity,
      'combinedSimilarityScore': combinedSimilarityScore,
      'matchingDecision': matchingDecision,
      if (decisionReason != null) 'decisionReason': decisionReason,
      if (reviewedBy != null) 'reviewedBy': reviewedBy,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IssueMatchHistoryImpl extends IssueMatchHistory {
  _IssueMatchHistoryImpl({
    int? id,
    required int reportId,
    int? matchedIssueId,
    required double geographicSimilarity,
    required double imageSimilarity,
    required double descriptionSimilarity,
    required double categorySimilarity,
    required double temporalSimilarity,
    required double combinedSimilarityScore,
    required String matchingDecision,
    String? decisionReason,
    int? reviewedBy,
    required DateTime createdAt,
  }) : super._(
         id: id,
         reportId: reportId,
         matchedIssueId: matchedIssueId,
         geographicSimilarity: geographicSimilarity,
         imageSimilarity: imageSimilarity,
         descriptionSimilarity: descriptionSimilarity,
         categorySimilarity: categorySimilarity,
         temporalSimilarity: temporalSimilarity,
         combinedSimilarityScore: combinedSimilarityScore,
         matchingDecision: matchingDecision,
         decisionReason: decisionReason,
         reviewedBy: reviewedBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [IssueMatchHistory]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  IssueMatchHistory copyWith({
    Object? id = _Undefined,
    int? reportId,
    Object? matchedIssueId = _Undefined,
    double? geographicSimilarity,
    double? imageSimilarity,
    double? descriptionSimilarity,
    double? categorySimilarity,
    double? temporalSimilarity,
    double? combinedSimilarityScore,
    String? matchingDecision,
    Object? decisionReason = _Undefined,
    Object? reviewedBy = _Undefined,
    DateTime? createdAt,
  }) {
    return IssueMatchHistory(
      id: id is int? ? id : this.id,
      reportId: reportId ?? this.reportId,
      matchedIssueId: matchedIssueId is int?
          ? matchedIssueId
          : this.matchedIssueId,
      geographicSimilarity: geographicSimilarity ?? this.geographicSimilarity,
      imageSimilarity: imageSimilarity ?? this.imageSimilarity,
      descriptionSimilarity:
          descriptionSimilarity ?? this.descriptionSimilarity,
      categorySimilarity: categorySimilarity ?? this.categorySimilarity,
      temporalSimilarity: temporalSimilarity ?? this.temporalSimilarity,
      combinedSimilarityScore:
          combinedSimilarityScore ?? this.combinedSimilarityScore,
      matchingDecision: matchingDecision ?? this.matchingDecision,
      decisionReason: decisionReason is String?
          ? decisionReason
          : this.decisionReason,
      reviewedBy: reviewedBy is int? ? reviewedBy : this.reviewedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
