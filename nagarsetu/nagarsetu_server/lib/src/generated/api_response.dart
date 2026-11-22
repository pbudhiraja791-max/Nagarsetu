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

abstract class ApiResponse
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ApiResponse._({
    required this.success,
    required this.message,
    this.errorCode,
    this.data,
  });

  factory ApiResponse({
    required bool success,
    required String message,
    String? errorCode,
    String? data,
  }) = _ApiResponseImpl;

  factory ApiResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return ApiResponse(
      success: _is.BoolJsonExtension.fromJson(jsonSerialization['success']),
      message: jsonSerialization['message'] as String,
      errorCode: jsonSerialization['errorCode'] as String?,
      data: jsonSerialization['data'] as String?,
    );
  }

  bool success;

  String message;

  String? errorCode;

  String? data;

  /// Returns a shallow copy of this [ApiResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ApiResponse copyWith({
    bool? success,
    String? message,
    String? errorCode,
    String? data,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ApiResponse',
      'success': success,
      'message': message,
      if (errorCode != null) 'errorCode': errorCode,
      if (data != null) 'data': data,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ApiResponse',
      'success': success,
      'message': message,
      if (errorCode != null) 'errorCode': errorCode,
      if (data != null) 'data': data,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ApiResponseImpl extends ApiResponse {
  _ApiResponseImpl({
    required bool success,
    required String message,
    String? errorCode,
    String? data,
  }) : super._(
         success: success,
         message: message,
         errorCode: errorCode,
         data: data,
       );

  /// Returns a shallow copy of this [ApiResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ApiResponse copyWith({
    bool? success,
    String? message,
    Object? errorCode = _Undefined,
    Object? data = _Undefined,
  }) {
    return ApiResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      errorCode: errorCode is String? ? errorCode : this.errorCode,
      data: data is String? ? data : this.data,
    );
  }
}
