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
import 'package:serverpod/serverpod.dart' as _is;

abstract class PriorityCalculationResult
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PriorityCalculationResult._({
    required this.score,
    required this.level,
    required this.explanation,
    required this.breakdownJson,
  });

  factory PriorityCalculationResult({
    required double score,
    required String level,
    required String explanation,
    required String breakdownJson,
  }) = _PriorityCalculationResultImpl;

  factory PriorityCalculationResult.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PriorityCalculationResult(
      score: (jsonSerialization['score'] as num).toDouble(),
      level: jsonSerialization['level'] as String,
      explanation: jsonSerialization['explanation'] as String,
      breakdownJson: jsonSerialization['breakdownJson'] as String,
    );
  }

  double score;

  String level;

  String explanation;

  String breakdownJson;

  /// Returns a shallow copy of this [PriorityCalculationResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PriorityCalculationResult copyWith({
    double? score,
    String? level,
    String? explanation,
    String? breakdownJson,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PriorityCalculationResult',
      'score': score,
      'level': level,
      'explanation': explanation,
      'breakdownJson': breakdownJson,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PriorityCalculationResult',
      'score': score,
      'level': level,
      'explanation': explanation,
      'breakdownJson': breakdownJson,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _PriorityCalculationResultImpl extends PriorityCalculationResult {
  _PriorityCalculationResultImpl({
    required double score,
    required String level,
    required String explanation,
    required String breakdownJson,
  }) : super._(
         score: score,
         level: level,
         explanation: explanation,
         breakdownJson: breakdownJson,
       );

  /// Returns a shallow copy of this [PriorityCalculationResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PriorityCalculationResult copyWith({
    double? score,
    String? level,
    String? explanation,
    String? breakdownJson,
  }) {
    return PriorityCalculationResult(
      score: score ?? this.score,
      level: level ?? this.level,
      explanation: explanation ?? this.explanation,
      breakdownJson: breakdownJson ?? this.breakdownJson,
    );
  }
}
