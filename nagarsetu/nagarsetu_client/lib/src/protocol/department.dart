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

abstract class Department
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Department._({
    this.id,
    required this.name,
    this.description,
    this.contactEmail,
    this.contactPhone,
    required this.isActive,
    required this.createdAt,
  });

  factory Department({
    int? id,
    required String name,
    String? description,
    String? contactEmail,
    String? contactPhone,
    required bool isActive,
    required DateTime createdAt,
  }) = _DepartmentImpl;

  factory Department.fromJson(Map<String, dynamic> jsonSerialization) {
    return Department(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      contactEmail: jsonSerialization['contactEmail'] as String?,
      contactPhone: jsonSerialization['contactPhone'] as String?,
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String? description;

  String? contactEmail;

  String? contactPhone;

  bool isActive;

  DateTime createdAt;

  /// Returns a shallow copy of this [Department]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Department copyWith({
    int? id,
    String? name,
    String? description,
    String? contactEmail,
    String? contactPhone,
    bool? isActive,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Department',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (contactEmail != null) 'contactEmail': contactEmail,
      if (contactPhone != null) 'contactPhone': contactPhone,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Department',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (contactEmail != null) 'contactEmail': contactEmail,
      if (contactPhone != null) 'contactPhone': contactPhone,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DepartmentImpl extends Department {
  _DepartmentImpl({
    int? id,
    required String name,
    String? description,
    String? contactEmail,
    String? contactPhone,
    required bool isActive,
    required DateTime createdAt,
  }) : super._(
         id: id,
         name: name,
         description: description,
         contactEmail: contactEmail,
         contactPhone: contactPhone,
         isActive: isActive,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Department]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Department copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    Object? contactEmail = _Undefined,
    Object? contactPhone = _Undefined,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Department(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      contactEmail: contactEmail is String? ? contactEmail : this.contactEmail,
      contactPhone: contactPhone is String? ? contactPhone : this.contactPhone,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
