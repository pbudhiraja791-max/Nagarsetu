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

abstract class SubmitReportResponse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SubmitReportResponse._({
    required this.reportId,
    this.issueId,
    this.issueCode,
    required this.totalReports,
    required this.uniqueCitizens,
    required this.duplicateDetected,
    required this.status,
    required this.trackingId,
  });

  factory SubmitReportResponse({
    required int reportId,
    int? issueId,
    String? issueCode,
    required int totalReports,
    required int uniqueCitizens,
    required bool duplicateDetected,
    required String status,
    required String trackingId,
  }) = _SubmitReportResponseImpl;

  factory SubmitReportResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SubmitReportResponse(
      reportId: jsonSerialization['reportId'] as int,
      issueId: jsonSerialization['issueId'] as int?,
      issueCode: jsonSerialization['issueCode'] as String?,
      totalReports: jsonSerialization['totalReports'] as int,
      uniqueCitizens: jsonSerialization['uniqueCitizens'] as int,
      duplicateDetected: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['duplicateDetected'],
      ),
      status: jsonSerialization['status'] as String,
      trackingId: jsonSerialization['trackingId'] as String,
    );
  }

  int reportId;

  int? issueId;

  String? issueCode;

  int totalReports;

  int uniqueCitizens;

  bool duplicateDetected;

  String status;

  String trackingId;

  /// Returns a shallow copy of this [SubmitReportResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SubmitReportResponse copyWith({
    int? reportId,
    int? issueId,
    String? issueCode,
    int? totalReports,
    int? uniqueCitizens,
    bool? duplicateDetected,
    String? status,
    String? trackingId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SubmitReportResponse',
      'reportId': reportId,
      if (issueId != null) 'issueId': issueId,
      if (issueCode != null) 'issueCode': issueCode,
      'totalReports': totalReports,
      'uniqueCitizens': uniqueCitizens,
      'duplicateDetected': duplicateDetected,
      'status': status,
      'trackingId': trackingId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SubmitReportResponse',
      'reportId': reportId,
      if (issueId != null) 'issueId': issueId,
      if (issueCode != null) 'issueCode': issueCode,
      'totalReports': totalReports,
      'uniqueCitizens': uniqueCitizens,
      'duplicateDetected': duplicateDetected,
      'status': status,
      'trackingId': trackingId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SubmitReportResponseImpl extends SubmitReportResponse {
  _SubmitReportResponseImpl({
    required int reportId,
    int? issueId,
    String? issueCode,
    required int totalReports,
    required int uniqueCitizens,
    required bool duplicateDetected,
    required String status,
    required String trackingId,
  }) : super._(
         reportId: reportId,
         issueId: issueId,
         issueCode: issueCode,
         totalReports: totalReports,
         uniqueCitizens: uniqueCitizens,
         duplicateDetected: duplicateDetected,
         status: status,
         trackingId: trackingId,
       );

  /// Returns a shallow copy of this [SubmitReportResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SubmitReportResponse copyWith({
    int? reportId,
    Object? issueId = _Undefined,
    Object? issueCode = _Undefined,
    int? totalReports,
    int? uniqueCitizens,
    bool? duplicateDetected,
    String? status,
    String? trackingId,
  }) {
    return SubmitReportResponse(
      reportId: reportId ?? this.reportId,
      issueId: issueId is int? ? issueId : this.issueId,
      issueCode: issueCode is String? ? issueCode : this.issueCode,
      totalReports: totalReports ?? this.totalReports,
      uniqueCitizens: uniqueCitizens ?? this.uniqueCitizens,
      duplicateDetected: duplicateDetected ?? this.duplicateDetected,
      status: status ?? this.status,
      trackingId: trackingId ?? this.trackingId,
    );
  }
}
