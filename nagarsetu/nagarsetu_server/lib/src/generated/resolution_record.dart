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

abstract class ResolutionRecord
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ResolutionRecord._({
    this.id,
    required this.issueId,
    required this.officerId,
    required this.resolutionDescription,
    this.beforeImageReference,
    this.afterImageReference,
    this.latitude,
    this.longitude,
    required this.submittedAt,
    required this.verificationStatus,
    this.verifiedBy,
    this.verifiedAt,
    this.rejectionReason,
  });

  factory ResolutionRecord({
    int? id,
    required int issueId,
    required int officerId,
    required String resolutionDescription,
    String? beforeImageReference,
    String? afterImageReference,
    double? latitude,
    double? longitude,
    required DateTime submittedAt,
    required String verificationStatus,
    int? verifiedBy,
    DateTime? verifiedAt,
    String? rejectionReason,
  }) = _ResolutionRecordImpl;

  factory ResolutionRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return ResolutionRecord(
      id: jsonSerialization['id'] as int?,
      issueId: jsonSerialization['issueId'] as int,
      officerId: jsonSerialization['officerId'] as int,
      resolutionDescription:
          jsonSerialization['resolutionDescription'] as String,
      beforeImageReference:
          jsonSerialization['beforeImageReference'] as String?,
      afterImageReference: jsonSerialization['afterImageReference'] as String?,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      submittedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['submittedAt'],
      ),
      verificationStatus: jsonSerialization['verificationStatus'] as String,
      verifiedBy: jsonSerialization['verifiedBy'] as int?,
      verifiedAt: jsonSerialization['verifiedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['verifiedAt']),
      rejectionReason: jsonSerialization['rejectionReason'] as String?,
    );
  }

  static final t = ResolutionRecordTable();

  static const db = ResolutionRecordRepository._();

  @override
  int? id;

  int issueId;

  int officerId;

  String resolutionDescription;

  String? beforeImageReference;

  String? afterImageReference;

  double? latitude;

  double? longitude;

  DateTime submittedAt;

  String verificationStatus;

  int? verifiedBy;

  DateTime? verifiedAt;

  String? rejectionReason;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ResolutionRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ResolutionRecord copyWith({
    int? id,
    int? issueId,
    int? officerId,
    String? resolutionDescription,
    String? beforeImageReference,
    String? afterImageReference,
    double? latitude,
    double? longitude,
    DateTime? submittedAt,
    String? verificationStatus,
    int? verifiedBy,
    DateTime? verifiedAt = const _is.$UndefinedDateTime(),
    String? rejectionReason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ResolutionRecord',
      if (id != null) 'id': id,
      'issueId': issueId,
      'officerId': officerId,
      'resolutionDescription': resolutionDescription,
      if (beforeImageReference != null)
        'beforeImageReference': beforeImageReference,
      if (afterImageReference != null)
        'afterImageReference': afterImageReference,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'submittedAt': submittedAt.toJson(),
      'verificationStatus': verificationStatus,
      if (verifiedBy != null) 'verifiedBy': verifiedBy,
      if (verifiedAt != null) 'verifiedAt': verifiedAt?.toJson(),
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ResolutionRecord',
      if (id != null) 'id': id,
      'issueId': issueId,
      'officerId': officerId,
      'resolutionDescription': resolutionDescription,
      if (beforeImageReference != null)
        'beforeImageReference': beforeImageReference,
      if (afterImageReference != null)
        'afterImageReference': afterImageReference,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'submittedAt': submittedAt.toJson(),
      'verificationStatus': verificationStatus,
      if (verifiedBy != null) 'verifiedBy': verifiedBy,
      if (verifiedAt != null) 'verifiedAt': verifiedAt?.toJson(),
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
    };
  }

  static ResolutionRecordInclude include() {
    return ResolutionRecordInclude._();
  }

  static ResolutionRecordIncludeList includeList({
    _is.WhereExpressionBuilder<ResolutionRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ResolutionRecordTable>? orderBy,
    _is.OrderByListBuilder<ResolutionRecordTable>? orderByList,
    ResolutionRecordInclude? include,
  }) {
    return ResolutionRecordIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ResolutionRecord.t),
      orderByList: orderByList?.call(ResolutionRecord.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ResolutionRecordImpl extends ResolutionRecord {
  _ResolutionRecordImpl({
    int? id,
    required int issueId,
    required int officerId,
    required String resolutionDescription,
    String? beforeImageReference,
    String? afterImageReference,
    double? latitude,
    double? longitude,
    required DateTime submittedAt,
    required String verificationStatus,
    int? verifiedBy,
    DateTime? verifiedAt,
    String? rejectionReason,
  }) : super._(
         id: id,
         issueId: issueId,
         officerId: officerId,
         resolutionDescription: resolutionDescription,
         beforeImageReference: beforeImageReference,
         afterImageReference: afterImageReference,
         latitude: latitude,
         longitude: longitude,
         submittedAt: submittedAt,
         verificationStatus: verificationStatus,
         verifiedBy: verifiedBy,
         verifiedAt: verifiedAt,
         rejectionReason: rejectionReason,
       );

  /// Returns a shallow copy of this [ResolutionRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ResolutionRecord copyWith({
    Object? id = _Undefined,
    int? issueId,
    int? officerId,
    String? resolutionDescription,
    Object? beforeImageReference = _Undefined,
    Object? afterImageReference = _Undefined,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    DateTime? submittedAt,
    String? verificationStatus,
    Object? verifiedBy = _Undefined,
    DateTime? verifiedAt = const _is.$UndefinedDateTime(),
    Object? rejectionReason = _Undefined,
  }) {
    return ResolutionRecord(
      id: id is int? ? id : this.id,
      issueId: issueId ?? this.issueId,
      officerId: officerId ?? this.officerId,
      resolutionDescription:
          resolutionDescription ?? this.resolutionDescription,
      beforeImageReference: beforeImageReference is String?
          ? beforeImageReference
          : this.beforeImageReference,
      afterImageReference: afterImageReference is String?
          ? afterImageReference
          : this.afterImageReference,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      submittedAt: submittedAt ?? this.submittedAt,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      verifiedBy: verifiedBy is int? ? verifiedBy : this.verifiedBy,
      verifiedAt: verifiedAt is _is.UndefinedSentinel
          ? this.verifiedAt
          : verifiedAt,
      rejectionReason: rejectionReason is String?
          ? rejectionReason
          : this.rejectionReason,
    );
  }
}

class ResolutionRecordUpdateTable
    extends _is.UpdateTable<ResolutionRecordTable> {
  ResolutionRecordUpdateTable(super.table);

  _is.ColumnValue<int, int> issueId(int value) => _is.ColumnValue(
    table.issueId,
    value,
  );

  _is.ColumnValue<int, int> officerId(int value) => _is.ColumnValue(
    table.officerId,
    value,
  );

  _is.ColumnValue<String, String> resolutionDescription(String value) =>
      _is.ColumnValue(
        table.resolutionDescription,
        value,
      );

  _is.ColumnValue<String, String> beforeImageReference(String? value) =>
      _is.ColumnValue(
        table.beforeImageReference,
        value,
      );

  _is.ColumnValue<String, String> afterImageReference(String? value) =>
      _is.ColumnValue(
        table.afterImageReference,
        value,
      );

  _is.ColumnValue<double, double> latitude(double? value) => _is.ColumnValue(
    table.latitude,
    value,
  );

  _is.ColumnValue<double, double> longitude(double? value) => _is.ColumnValue(
    table.longitude,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> submittedAt(DateTime value) =>
      _is.ColumnValue(
        table.submittedAt,
        value,
      );

  _is.ColumnValue<String, String> verificationStatus(String value) =>
      _is.ColumnValue(
        table.verificationStatus,
        value,
      );

  _is.ColumnValue<int, int> verifiedBy(int? value) => _is.ColumnValue(
    table.verifiedBy,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> verifiedAt(DateTime? value) =>
      _is.ColumnValue(
        table.verifiedAt,
        value,
      );

  _is.ColumnValue<String, String> rejectionReason(String? value) =>
      _is.ColumnValue(
        table.rejectionReason,
        value,
      );
}

class ResolutionRecordTable extends _is.Table<int?> {
  ResolutionRecordTable({super.tableRelation})
    : super(tableName: 'resolution_records') {
    updateTable = ResolutionRecordUpdateTable(this);
    issueId = _is.ColumnInt(
      'issueId',
      this,
    );
    officerId = _is.ColumnInt(
      'officerId',
      this,
    );
    resolutionDescription = _is.ColumnString(
      'resolutionDescription',
      this,
    );
    beforeImageReference = _is.ColumnString(
      'beforeImageReference',
      this,
    );
    afterImageReference = _is.ColumnString(
      'afterImageReference',
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
    submittedAt = _is.ColumnDateTime(
      'submittedAt',
      this,
    );
    verificationStatus = _is.ColumnString(
      'verificationStatus',
      this,
    );
    verifiedBy = _is.ColumnInt(
      'verifiedBy',
      this,
    );
    verifiedAt = _is.ColumnDateTime(
      'verifiedAt',
      this,
    );
    rejectionReason = _is.ColumnString(
      'rejectionReason',
      this,
    );
  }

  late final ResolutionRecordUpdateTable updateTable;

  late final _is.ColumnInt issueId;

  late final _is.ColumnInt officerId;

  late final _is.ColumnString resolutionDescription;

  late final _is.ColumnString beforeImageReference;

  late final _is.ColumnString afterImageReference;

  late final _is.ColumnDouble latitude;

  late final _is.ColumnDouble longitude;

  late final _is.ColumnDateTime submittedAt;

  late final _is.ColumnString verificationStatus;

  late final _is.ColumnInt verifiedBy;

  late final _is.ColumnDateTime verifiedAt;

  late final _is.ColumnString rejectionReason;

  @override
  List<_is.Column> get columns => [
    id,
    issueId,
    officerId,
    resolutionDescription,
    beforeImageReference,
    afterImageReference,
    latitude,
    longitude,
    submittedAt,
    verificationStatus,
    verifiedBy,
    verifiedAt,
    rejectionReason,
  ];
}

class ResolutionRecordInclude extends _is.IncludeObject {
  ResolutionRecordInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ResolutionRecord.t;
}

class ResolutionRecordIncludeList extends _is.IncludeList {
  ResolutionRecordIncludeList._({
    _is.WhereExpressionBuilder<ResolutionRecordTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ResolutionRecord.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ResolutionRecord.t;
}

class ResolutionRecordRepository {
  const ResolutionRecordRepository._();

  /// Returns a list of [ResolutionRecord]s matching the given query parameters.
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
  Future<List<ResolutionRecord>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ResolutionRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ResolutionRecordTable>? orderBy,
    _is.OrderByListBuilder<ResolutionRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ResolutionRecord>(
      where: where?.call(ResolutionRecord.t),
      orderBy: orderBy?.call(ResolutionRecord.t),
      orderByList: orderByList?.call(ResolutionRecord.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [ResolutionRecord]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `ResolutionRecord.t`.
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
  _ida.Stream<List<ResolutionRecord>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ResolutionRecordTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ResolutionRecordTable>? orderBy,
    _is.OrderByListBuilder<ResolutionRecordTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<ResolutionRecord>(
      where: where?.call(ResolutionRecord.t),
      orderBy: orderBy?.call(ResolutionRecord.t),
      orderByList: orderByList?.call(ResolutionRecord.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [ResolutionRecord] matching the given query parameters.
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
  Future<ResolutionRecord?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ResolutionRecordTable>? where,
    int? offset,
    _is.OrderByBuilder<ResolutionRecordTable>? orderBy,
    _is.OrderByListBuilder<ResolutionRecordTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ResolutionRecord>(
      where: where?.call(ResolutionRecord.t),
      orderBy: orderBy?.call(ResolutionRecord.t),
      orderByList: orderByList?.call(ResolutionRecord.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ResolutionRecord] by its [id] or null if no such row exists.
  Future<ResolutionRecord?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ResolutionRecord>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ResolutionRecord]s in the list and returns the inserted rows.
  ///
  /// The returned [ResolutionRecord]s will have their `id` fields set.
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
  Future<List<ResolutionRecord>> insert(
    _is.DatabaseSession session,
    List<ResolutionRecord> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ResolutionRecord>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ResolutionRecord] and returns the inserted row.
  ///
  /// The returned [ResolutionRecord] will have its `id` field set.
  Future<ResolutionRecord> insertRow(
    _is.DatabaseSession session,
    ResolutionRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ResolutionRecord>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ResolutionRecord]s in the list and returns the resulting rows.
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
  /// The returned [ResolutionRecord]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ResolutionRecord>> upsert(
    _is.DatabaseSession session,
    List<ResolutionRecord> rows, {
    required _is.ColumnSelections<ResolutionRecordTable> conflictColumns,
    _is.ColumnSelections<ResolutionRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<ResolutionRecordTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ResolutionRecord>(
      rows,
      conflictColumns: conflictColumns(ResolutionRecord.t),
      updateColumns: updateColumns?.call(ResolutionRecord.t),
      updateWhere: updateWhere?.call(ResolutionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ResolutionRecord] and returns the resulting row.
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
  /// The returned [ResolutionRecord] will have its `id` field set.
  Future<ResolutionRecord?> upsertRow(
    _is.DatabaseSession session,
    ResolutionRecord row, {
    required _is.ColumnSelections<ResolutionRecordTable> conflictColumns,
    _is.ColumnSelections<ResolutionRecordTable>? updateColumns,
    _is.WhereExpressionBuilder<ResolutionRecordTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ResolutionRecord>(
      row,
      conflictColumns: conflictColumns(ResolutionRecord.t),
      updateColumns: updateColumns?.call(ResolutionRecord.t),
      updateWhere: updateWhere?.call(ResolutionRecord.t),
      transaction: transaction,
    );
  }

  /// Updates all [ResolutionRecord]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ResolutionRecord>> update(
    _is.DatabaseSession session,
    List<ResolutionRecord> rows, {
    _is.ColumnSelections<ResolutionRecordTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ResolutionRecord>(
      rows,
      columns: columns?.call(ResolutionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ResolutionRecord]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ResolutionRecord> updateRow(
    _is.DatabaseSession session,
    ResolutionRecord row, {
    _is.ColumnSelections<ResolutionRecordTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ResolutionRecord>(
      row,
      columns: columns?.call(ResolutionRecord.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ResolutionRecord] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ResolutionRecord?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ResolutionRecordUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ResolutionRecord>(
      id,
      columnValues: columnValues(ResolutionRecord.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ResolutionRecord]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ResolutionRecord>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ResolutionRecordUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ResolutionRecordTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ResolutionRecordTable>? orderBy,
    _is.OrderByListBuilder<ResolutionRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ResolutionRecord>(
      columnValues: columnValues(ResolutionRecord.t.updateTable),
      where: where(ResolutionRecord.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ResolutionRecord.t),
      orderByList: orderByList?.call(ResolutionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ResolutionRecord]s in the list and returns the deleted rows.
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
  Future<List<ResolutionRecord>> delete(
    _is.DatabaseSession session,
    List<ResolutionRecord> rows, {
    _is.OrderByBuilder<ResolutionRecordTable>? orderBy,
    _is.OrderByListBuilder<ResolutionRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ResolutionRecord>(
      rows,
      orderBy: orderBy?.call(ResolutionRecord.t),
      orderByList: orderByList?.call(ResolutionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ResolutionRecord].
  Future<ResolutionRecord> deleteRow(
    _is.DatabaseSession session,
    ResolutionRecord row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ResolutionRecord>(
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
  Future<List<ResolutionRecord>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ResolutionRecordTable> where,
    _is.OrderByBuilder<ResolutionRecordTable>? orderBy,
    _is.OrderByListBuilder<ResolutionRecordTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ResolutionRecord>(
      where: where(ResolutionRecord.t),
      orderBy: orderBy?.call(ResolutionRecord.t),
      orderByList: orderByList?.call(ResolutionRecord.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ResolutionRecordTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ResolutionRecord>(
      where: where?.call(ResolutionRecord.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ResolutionRecord] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ResolutionRecordTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ResolutionRecord>(
      where: where(ResolutionRecord.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
