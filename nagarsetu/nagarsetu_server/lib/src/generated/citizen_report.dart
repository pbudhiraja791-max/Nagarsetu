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
import 'dart:async' as _ida;
import 'package:serverpod/serverpod.dart' as _is;

abstract class CitizenReport
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  CitizenReport._({
    this.id,
    required this.citizenId,
    this.issueId,
    required this.description,
    required this.category,
    required this.latitude,
    required this.longitude,
    this.address,
    this.imageReference,
    this.audioReference,
    this.aiDetectedCategory,
    this.aiConfidence,
    this.duplicateDetectionScore,
    required this.duplicateDetectionStatus,
    required this.submissionStatus,
    this.idempotencyKey,
    required this.counted,
    this.linkMethod,
    required this.repeatReporter,
    required this.createdAt,
  });

  factory CitizenReport({
    int? id,
    required int citizenId,
    int? issueId,
    required String description,
    required String category,
    required double latitude,
    required double longitude,
    String? address,
    String? imageReference,
    String? audioReference,
    String? aiDetectedCategory,
    double? aiConfidence,
    double? duplicateDetectionScore,
    required String duplicateDetectionStatus,
    required String submissionStatus,
    String? idempotencyKey,
    required bool counted,
    String? linkMethod,
    required bool repeatReporter,
    required DateTime createdAt,
  }) = _CitizenReportImpl;

  factory CitizenReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return CitizenReport(
      id: jsonSerialization['id'] as int?,
      citizenId: jsonSerialization['citizenId'] as int,
      issueId: jsonSerialization['issueId'] as int?,
      description: jsonSerialization['description'] as String,
      category: jsonSerialization['category'] as String,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      address: jsonSerialization['address'] as String?,
      imageReference: jsonSerialization['imageReference'] as String?,
      audioReference: jsonSerialization['audioReference'] as String?,
      aiDetectedCategory: jsonSerialization['aiDetectedCategory'] as String?,
      aiConfidence: (jsonSerialization['aiConfidence'] as num?)?.toDouble(),
      duplicateDetectionScore:
          (jsonSerialization['duplicateDetectionScore'] as num?)?.toDouble(),
      duplicateDetectionStatus:
          jsonSerialization['duplicateDetectionStatus'] as String,
      submissionStatus: jsonSerialization['submissionStatus'] as String,
      idempotencyKey: jsonSerialization['idempotencyKey'] as String?,
      counted: _is.BoolJsonExtension.fromJson(jsonSerialization['counted']),
      linkMethod: jsonSerialization['linkMethod'] as String?,
      repeatReporter: _is.BoolJsonExtension.fromJson(
        jsonSerialization['repeatReporter'],
      ),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = CitizenReportTable();

  static const db = CitizenReportRepository._();

  @override
  int? id;

  int citizenId;

  int? issueId;

  String description;

  String category;

  double latitude;

  double longitude;

  String? address;

  String? imageReference;

  String? audioReference;

  String? aiDetectedCategory;

  double? aiConfidence;

  double? duplicateDetectionScore;

  String duplicateDetectionStatus;

  String submissionStatus;

  String? idempotencyKey;

  bool counted;

  String? linkMethod;

  bool repeatReporter;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CitizenReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CitizenReport copyWith({
    int? id,
    int? citizenId,
    int? issueId,
    String? description,
    String? category,
    double? latitude,
    double? longitude,
    String? address,
    String? imageReference,
    String? audioReference,
    String? aiDetectedCategory,
    double? aiConfidence,
    double? duplicateDetectionScore,
    String? duplicateDetectionStatus,
    String? submissionStatus,
    String? idempotencyKey,
    bool? counted,
    String? linkMethod,
    bool? repeatReporter,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CitizenReport',
      if (id != null) 'id': id,
      'citizenId': citizenId,
      if (issueId != null) 'issueId': issueId,
      'description': description,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      if (address != null) 'address': address,
      if (imageReference != null) 'imageReference': imageReference,
      if (audioReference != null) 'audioReference': audioReference,
      if (aiDetectedCategory != null) 'aiDetectedCategory': aiDetectedCategory,
      if (aiConfidence != null) 'aiConfidence': aiConfidence,
      if (duplicateDetectionScore != null)
        'duplicateDetectionScore': duplicateDetectionScore,
      'duplicateDetectionStatus': duplicateDetectionStatus,
      'submissionStatus': submissionStatus,
      if (idempotencyKey != null) 'idempotencyKey': idempotencyKey,
      'counted': counted,
      if (linkMethod != null) 'linkMethod': linkMethod,
      'repeatReporter': repeatReporter,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CitizenReport',
      if (id != null) 'id': id,
      'citizenId': citizenId,
      if (issueId != null) 'issueId': issueId,
      'description': description,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      if (address != null) 'address': address,
      if (imageReference != null) 'imageReference': imageReference,
      if (audioReference != null) 'audioReference': audioReference,
      if (aiDetectedCategory != null) 'aiDetectedCategory': aiDetectedCategory,
      if (aiConfidence != null) 'aiConfidence': aiConfidence,
      if (duplicateDetectionScore != null)
        'duplicateDetectionScore': duplicateDetectionScore,
      'duplicateDetectionStatus': duplicateDetectionStatus,
      'submissionStatus': submissionStatus,
      if (idempotencyKey != null) 'idempotencyKey': idempotencyKey,
      'counted': counted,
      if (linkMethod != null) 'linkMethod': linkMethod,
      'repeatReporter': repeatReporter,
      'createdAt': createdAt.toJson(),
    };
  }

  static CitizenReportInclude include() {
    return CitizenReportInclude._();
  }

  static CitizenReportIncludeList includeList({
    _is.WhereExpressionBuilder<CitizenReportTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CitizenReportTable>? orderBy,
    _is.OrderByListBuilder<CitizenReportTable>? orderByList,
    CitizenReportInclude? include,
  }) {
    return CitizenReportIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CitizenReport.t),
      orderByList: orderByList?.call(CitizenReport.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CitizenReportImpl extends CitizenReport {
  _CitizenReportImpl({
    int? id,
    required int citizenId,
    int? issueId,
    required String description,
    required String category,
    required double latitude,
    required double longitude,
    String? address,
    String? imageReference,
    String? audioReference,
    String? aiDetectedCategory,
    double? aiConfidence,
    double? duplicateDetectionScore,
    required String duplicateDetectionStatus,
    required String submissionStatus,
    String? idempotencyKey,
    required bool counted,
    String? linkMethod,
    required bool repeatReporter,
    required DateTime createdAt,
  }) : super._(
         id: id,
         citizenId: citizenId,
         issueId: issueId,
         description: description,
         category: category,
         latitude: latitude,
         longitude: longitude,
         address: address,
         imageReference: imageReference,
         audioReference: audioReference,
         aiDetectedCategory: aiDetectedCategory,
         aiConfidence: aiConfidence,
         duplicateDetectionScore: duplicateDetectionScore,
         duplicateDetectionStatus: duplicateDetectionStatus,
         submissionStatus: submissionStatus,
         idempotencyKey: idempotencyKey,
         counted: counted,
         linkMethod: linkMethod,
         repeatReporter: repeatReporter,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CitizenReport]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CitizenReport copyWith({
    Object? id = _Undefined,
    int? citizenId,
    Object? issueId = _Undefined,
    String? description,
    String? category,
    double? latitude,
    double? longitude,
    Object? address = _Undefined,
    Object? imageReference = _Undefined,
    Object? audioReference = _Undefined,
    Object? aiDetectedCategory = _Undefined,
    Object? aiConfidence = _Undefined,
    Object? duplicateDetectionScore = _Undefined,
    String? duplicateDetectionStatus,
    String? submissionStatus,
    Object? idempotencyKey = _Undefined,
    bool? counted,
    Object? linkMethod = _Undefined,
    bool? repeatReporter,
    DateTime? createdAt,
  }) {
    return CitizenReport(
      id: id is int? ? id : this.id,
      citizenId: citizenId ?? this.citizenId,
      issueId: issueId is int? ? issueId : this.issueId,
      description: description ?? this.description,
      category: category ?? this.category,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address is String? ? address : this.address,
      imageReference: imageReference is String?
          ? imageReference
          : this.imageReference,
      audioReference: audioReference is String?
          ? audioReference
          : this.audioReference,
      aiDetectedCategory: aiDetectedCategory is String?
          ? aiDetectedCategory
          : this.aiDetectedCategory,
      aiConfidence: aiConfidence is double? ? aiConfidence : this.aiConfidence,
      duplicateDetectionScore: duplicateDetectionScore is double?
          ? duplicateDetectionScore
          : this.duplicateDetectionScore,
      duplicateDetectionStatus:
          duplicateDetectionStatus ?? this.duplicateDetectionStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      idempotencyKey: idempotencyKey is String?
          ? idempotencyKey
          : this.idempotencyKey,
      counted: counted ?? this.counted,
      linkMethod: linkMethod is String? ? linkMethod : this.linkMethod,
      repeatReporter: repeatReporter ?? this.repeatReporter,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CitizenReportUpdateTable extends _is.UpdateTable<CitizenReportTable> {
  CitizenReportUpdateTable(super.table);

  _is.ColumnValue<int, int> citizenId(int value) => _is.ColumnValue(
    table.citizenId,
    value,
  );

  _is.ColumnValue<int, int> issueId(int? value) => _is.ColumnValue(
    table.issueId,
    value,
  );

  _is.ColumnValue<String, String> description(String value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<String, String> category(String value) => _is.ColumnValue(
    table.category,
    value,
  );

  _is.ColumnValue<double, double> latitude(double value) => _is.ColumnValue(
    table.latitude,
    value,
  );

  _is.ColumnValue<double, double> longitude(double value) => _is.ColumnValue(
    table.longitude,
    value,
  );

  _is.ColumnValue<String, String> address(String? value) => _is.ColumnValue(
    table.address,
    value,
  );

  _is.ColumnValue<String, String> imageReference(String? value) =>
      _is.ColumnValue(
        table.imageReference,
        value,
      );

  _is.ColumnValue<String, String> audioReference(String? value) =>
      _is.ColumnValue(
        table.audioReference,
        value,
      );

  _is.ColumnValue<String, String> aiDetectedCategory(String? value) =>
      _is.ColumnValue(
        table.aiDetectedCategory,
        value,
      );

  _is.ColumnValue<double, double> aiConfidence(double? value) =>
      _is.ColumnValue(
        table.aiConfidence,
        value,
      );

  _is.ColumnValue<double, double> duplicateDetectionScore(double? value) =>
      _is.ColumnValue(
        table.duplicateDetectionScore,
        value,
      );

  _is.ColumnValue<String, String> duplicateDetectionStatus(String value) =>
      _is.ColumnValue(
        table.duplicateDetectionStatus,
        value,
      );

  _is.ColumnValue<String, String> submissionStatus(String value) =>
      _is.ColumnValue(
        table.submissionStatus,
        value,
      );

  _is.ColumnValue<String, String> idempotencyKey(String? value) =>
      _is.ColumnValue(
        table.idempotencyKey,
        value,
      );

  _is.ColumnValue<bool, bool> counted(bool value) => _is.ColumnValue(
    table.counted,
    value,
  );

  _is.ColumnValue<String, String> linkMethod(String? value) => _is.ColumnValue(
    table.linkMethod,
    value,
  );

  _is.ColumnValue<bool, bool> repeatReporter(bool value) => _is.ColumnValue(
    table.repeatReporter,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class CitizenReportTable extends _is.Table<int?> {
  CitizenReportTable({super.tableRelation})
    : super(tableName: 'citizen_reports') {
    updateTable = CitizenReportUpdateTable(this);
    citizenId = _is.ColumnInt(
      'citizenId',
      this,
    );
    issueId = _is.ColumnInt(
      'issueId',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    category = _is.ColumnString(
      'category',
      this,
    );
    latitude = _is.ColumnDouble(
      'latitude',
      this,
    );
    longitude = _is.ColumnDouble(
      'longitude',
      this,
    );
    address = _is.ColumnString(
      'address',
      this,
    );
    imageReference = _is.ColumnString(
      'imageReference',
      this,
    );
    audioReference = _is.ColumnString(
      'audioReference',
      this,
    );
    aiDetectedCategory = _is.ColumnString(
      'aiDetectedCategory',
      this,
    );
    aiConfidence = _is.ColumnDouble(
      'aiConfidence',
      this,
    );
    duplicateDetectionScore = _is.ColumnDouble(
      'duplicateDetectionScore',
      this,
    );
    duplicateDetectionStatus = _is.ColumnString(
      'duplicateDetectionStatus',
      this,
    );
    submissionStatus = _is.ColumnString(
      'submissionStatus',
      this,
    );
    idempotencyKey = _is.ColumnString(
      'idempotencyKey',
      this,
    );
    counted = _is.ColumnBool(
      'counted',
      this,
    );
    linkMethod = _is.ColumnString(
      'linkMethod',
      this,
    );
    repeatReporter = _is.ColumnBool(
      'repeatReporter',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final CitizenReportUpdateTable updateTable;

  late final _is.ColumnInt citizenId;

  late final _is.ColumnInt issueId;

  late final _is.ColumnString description;

  late final _is.ColumnString category;

  late final _is.ColumnDouble latitude;

  late final _is.ColumnDouble longitude;

  late final _is.ColumnString address;

  late final _is.ColumnString imageReference;

  late final _is.ColumnString audioReference;

  late final _is.ColumnString aiDetectedCategory;

  late final _is.ColumnDouble aiConfidence;

  late final _is.ColumnDouble duplicateDetectionScore;

  late final _is.ColumnString duplicateDetectionStatus;

  late final _is.ColumnString submissionStatus;

  late final _is.ColumnString idempotencyKey;

  late final _is.ColumnBool counted;

  late final _is.ColumnString linkMethod;

  late final _is.ColumnBool repeatReporter;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    citizenId,
    issueId,
    description,
    category,
    latitude,
    longitude,
    address,
    imageReference,
    audioReference,
    aiDetectedCategory,
    aiConfidence,
    duplicateDetectionScore,
    duplicateDetectionStatus,
    submissionStatus,
    idempotencyKey,
    counted,
    linkMethod,
    repeatReporter,
    createdAt,
  ];
}

class CitizenReportInclude extends _is.IncludeObject {
  CitizenReportInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => CitizenReport.t;
}

class CitizenReportIncludeList extends _is.IncludeList {
  CitizenReportIncludeList._({
    _is.WhereExpressionBuilder<CitizenReportTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CitizenReport.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CitizenReport.t;
}

class CitizenReportRepository {
  const CitizenReportRepository._();

  /// Returns a list of [CitizenReport]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<CitizenReport>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CitizenReportTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CitizenReportTable>? orderBy,
    _is.OrderByListBuilder<CitizenReportTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CitizenReport>(
      where: where?.call(CitizenReport.t),
      orderBy: orderBy?.call(CitizenReport.t),
      orderByList: orderByList?.call(CitizenReport.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [CitizenReport]s matching the given query parameters every time the
  /// source tables are modified.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// Use [throttle] to specify the minimum interval between queries. It can
  /// also be set to `null`, in which case the stream will only be throttled
  /// when its subscription is paused.
  ///
  /// Source tables are collected from the queried table, [where], [orderBy],
  /// [orderByList], and the [include] graph. [alsoTriggerOnTables] is added
  /// to that set. Pass [Table] instances such as `CitizenReport.t`.
  ///
  /// Raw [Expression] SQL is not inspected. Tables referenced only in raw
  /// SQL must be passed via [alsoTriggerOnTables].
  ///
  /// The stream always reads committed state and never joins an ambient
  /// [Transaction]. Emissions for a write fire after that write commits.
  ///
  /// Currently only supported on SQLite. Calling this method on PostgreSQL
  /// throws an [UnsupportedError].
  ///
  /// ```dart
  /// var subscription = Persons.db.watch(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// ).listen((persons) {
  ///   // Handle the latest matching rows.
  /// });
  /// ```
  _ida.Stream<List<CitizenReport>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CitizenReportTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CitizenReportTable>? orderBy,
    _is.OrderByListBuilder<CitizenReportTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<CitizenReport>(
      where: where?.call(CitizenReport.t),
      orderBy: orderBy?.call(CitizenReport.t),
      orderByList: orderByList?.call(CitizenReport.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [CitizenReport] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<CitizenReport?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CitizenReportTable>? where,
    int? offset,
    _is.OrderByBuilder<CitizenReportTable>? orderBy,
    _is.OrderByListBuilder<CitizenReportTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CitizenReport>(
      where: where?.call(CitizenReport.t),
      orderBy: orderBy?.call(CitizenReport.t),
      orderByList: orderByList?.call(CitizenReport.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CitizenReport] by its [id] or null if no such row exists.
  Future<CitizenReport?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CitizenReport>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CitizenReport]s in the list and returns the inserted rows.
  ///
  /// The returned [CitizenReport]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CitizenReport>> insert(
    _is.DatabaseSession session,
    List<CitizenReport> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CitizenReport>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CitizenReport] and returns the inserted row.
  ///
  /// The returned [CitizenReport] will have its `id` field set.
  Future<CitizenReport> insertRow(
    _is.DatabaseSession session,
    CitizenReport row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CitizenReport>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CitizenReport]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [CitizenReport]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CitizenReport>> upsert(
    _is.DatabaseSession session,
    List<CitizenReport> rows, {
    required _is.ColumnSelections<CitizenReportTable> conflictColumns,
    _is.ColumnSelections<CitizenReportTable>? updateColumns,
    _is.WhereExpressionBuilder<CitizenReportTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CitizenReport>(
      rows,
      conflictColumns: conflictColumns(CitizenReport.t),
      updateColumns: updateColumns?.call(CitizenReport.t),
      updateWhere: updateWhere?.call(CitizenReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CitizenReport] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [CitizenReport] will have its `id` field set.
  Future<CitizenReport?> upsertRow(
    _is.DatabaseSession session,
    CitizenReport row, {
    required _is.ColumnSelections<CitizenReportTable> conflictColumns,
    _is.ColumnSelections<CitizenReportTable>? updateColumns,
    _is.WhereExpressionBuilder<CitizenReportTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CitizenReport>(
      row,
      conflictColumns: conflictColumns(CitizenReport.t),
      updateColumns: updateColumns?.call(CitizenReport.t),
      updateWhere: updateWhere?.call(CitizenReport.t),
      transaction: transaction,
    );
  }

  /// Updates all [CitizenReport]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CitizenReport>> update(
    _is.DatabaseSession session,
    List<CitizenReport> rows, {
    _is.ColumnSelections<CitizenReportTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CitizenReport>(
      rows,
      columns: columns?.call(CitizenReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CitizenReport]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CitizenReport> updateRow(
    _is.DatabaseSession session,
    CitizenReport row, {
    _is.ColumnSelections<CitizenReportTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CitizenReport>(
      row,
      columns: columns?.call(CitizenReport.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CitizenReport] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CitizenReport?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CitizenReportUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CitizenReport>(
      id,
      columnValues: columnValues(CitizenReport.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CitizenReport]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CitizenReport>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CitizenReportUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CitizenReportTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CitizenReportTable>? orderBy,
    _is.OrderByListBuilder<CitizenReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CitizenReport>(
      columnValues: columnValues(CitizenReport.t.updateTable),
      where: where(CitizenReport.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CitizenReport.t),
      orderByList: orderByList?.call(CitizenReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CitizenReport]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CitizenReport>> delete(
    _is.DatabaseSession session,
    List<CitizenReport> rows, {
    _is.OrderByBuilder<CitizenReportTable>? orderBy,
    _is.OrderByListBuilder<CitizenReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CitizenReport>(
      rows,
      orderBy: orderBy?.call(CitizenReport.t),
      orderByList: orderByList?.call(CitizenReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CitizenReport].
  Future<CitizenReport> deleteRow(
    _is.DatabaseSession session,
    CitizenReport row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CitizenReport>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CitizenReport>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CitizenReportTable> where,
    _is.OrderByBuilder<CitizenReportTable>? orderBy,
    _is.OrderByListBuilder<CitizenReportTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CitizenReport>(
      where: where(CitizenReport.t),
      orderBy: orderBy?.call(CitizenReport.t),
      orderByList: orderByList?.call(CitizenReport.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CitizenReportTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CitizenReport>(
      where: where?.call(CitizenReport.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CitizenReport] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CitizenReportTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CitizenReport>(
      where: where(CitizenReport.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
