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

abstract class CitizenVerification
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  CitizenVerification._({
    this.id,
    required this.issueId,
    required this.citizenId,
    required this.verificationStatus,
    this.remarks,
    this.imageReference,
    required this.createdAt,
  });

  factory CitizenVerification({
    int? id,
    required int issueId,
    required int citizenId,
    required String verificationStatus,
    String? remarks,
    String? imageReference,
    required DateTime createdAt,
  }) = _CitizenVerificationImpl;

  factory CitizenVerification.fromJson(Map<String, dynamic> jsonSerialization) {
    return CitizenVerification(
      id: jsonSerialization['id'] as int?,
      issueId: jsonSerialization['issueId'] as int,
      citizenId: jsonSerialization['citizenId'] as int,
      verificationStatus: jsonSerialization['verificationStatus'] as String,
      remarks: jsonSerialization['remarks'] as String?,
      imageReference: jsonSerialization['imageReference'] as String?,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = CitizenVerificationTable();

  static const db = CitizenVerificationRepository._();

  @override
  int? id;

  int issueId;

  int citizenId;

  String verificationStatus;

  String? remarks;

  String? imageReference;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CitizenVerification]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CitizenVerification copyWith({
    int? id,
    int? issueId,
    int? citizenId,
    String? verificationStatus,
    String? remarks,
    String? imageReference,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CitizenVerification',
      if (id != null) 'id': id,
      'issueId': issueId,
      'citizenId': citizenId,
      'verificationStatus': verificationStatus,
      if (remarks != null) 'remarks': remarks,
      if (imageReference != null) 'imageReference': imageReference,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CitizenVerification',
      if (id != null) 'id': id,
      'issueId': issueId,
      'citizenId': citizenId,
      'verificationStatus': verificationStatus,
      if (remarks != null) 'remarks': remarks,
      if (imageReference != null) 'imageReference': imageReference,
      'createdAt': createdAt.toJson(),
    };
  }

  static CitizenVerificationInclude include() {
    return CitizenVerificationInclude._();
  }

  static CitizenVerificationIncludeList includeList({
    _is.WhereExpressionBuilder<CitizenVerificationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CitizenVerificationTable>? orderBy,
    _is.OrderByListBuilder<CitizenVerificationTable>? orderByList,
    CitizenVerificationInclude? include,
  }) {
    return CitizenVerificationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CitizenVerification.t),
      orderByList: orderByList?.call(CitizenVerification.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CitizenVerificationImpl extends CitizenVerification {
  _CitizenVerificationImpl({
    int? id,
    required int issueId,
    required int citizenId,
    required String verificationStatus,
    String? remarks,
    String? imageReference,
    required DateTime createdAt,
  }) : super._(
         id: id,
         issueId: issueId,
         citizenId: citizenId,
         verificationStatus: verificationStatus,
         remarks: remarks,
         imageReference: imageReference,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CitizenVerification]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CitizenVerification copyWith({
    Object? id = _Undefined,
    int? issueId,
    int? citizenId,
    String? verificationStatus,
    Object? remarks = _Undefined,
    Object? imageReference = _Undefined,
    DateTime? createdAt,
  }) {
    return CitizenVerification(
      id: id is int? ? id : this.id,
      issueId: issueId ?? this.issueId,
      citizenId: citizenId ?? this.citizenId,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      remarks: remarks is String? ? remarks : this.remarks,
      imageReference: imageReference is String?
          ? imageReference
          : this.imageReference,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class CitizenVerificationUpdateTable
    extends _is.UpdateTable<CitizenVerificationTable> {
  CitizenVerificationUpdateTable(super.table);

  _is.ColumnValue<int, int> issueId(int value) => _is.ColumnValue(
    table.issueId,
    value,
  );

  _is.ColumnValue<int, int> citizenId(int value) => _is.ColumnValue(
    table.citizenId,
    value,
  );

  _is.ColumnValue<String, String> verificationStatus(String value) =>
      _is.ColumnValue(
        table.verificationStatus,
        value,
      );

  _is.ColumnValue<String, String> remarks(String? value) => _is.ColumnValue(
    table.remarks,
    value,
  );

  _is.ColumnValue<String, String> imageReference(String? value) =>
      _is.ColumnValue(
        table.imageReference,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class CitizenVerificationTable extends _is.Table<int?> {
  CitizenVerificationTable({super.tableRelation})
    : super(tableName: 'citizen_verifications') {
    updateTable = CitizenVerificationUpdateTable(this);
    issueId = _is.ColumnInt(
      'issueId',
      this,
    );
    citizenId = _is.ColumnInt(
      'citizenId',
      this,
    );
    verificationStatus = _is.ColumnString(
      'verificationStatus',
      this,
    );
    remarks = _is.ColumnString(
      'remarks',
      this,
    );
    imageReference = _is.ColumnString(
      'imageReference',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final CitizenVerificationUpdateTable updateTable;

  late final _is.ColumnInt issueId;

  late final _is.ColumnInt citizenId;

  late final _is.ColumnString verificationStatus;

  late final _is.ColumnString remarks;

  late final _is.ColumnString imageReference;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    issueId,
    citizenId,
    verificationStatus,
    remarks,
    imageReference,
    createdAt,
  ];
}

class CitizenVerificationInclude extends _is.IncludeObject {
  CitizenVerificationInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => CitizenVerification.t;
}

class CitizenVerificationIncludeList extends _is.IncludeList {
  CitizenVerificationIncludeList._({
    _is.WhereExpressionBuilder<CitizenVerificationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CitizenVerification.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CitizenVerification.t;
}

class CitizenVerificationRepository {
  const CitizenVerificationRepository._();

  /// Returns a list of [CitizenVerification]s matching the given query parameters.
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
  Future<List<CitizenVerification>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CitizenVerificationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CitizenVerificationTable>? orderBy,
    _is.OrderByListBuilder<CitizenVerificationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CitizenVerification>(
      where: where?.call(CitizenVerification.t),
      orderBy: orderBy?.call(CitizenVerification.t),
      orderByList: orderByList?.call(CitizenVerification.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [CitizenVerification]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `CitizenVerification.t`.
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
  _ida.Stream<List<CitizenVerification>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CitizenVerificationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CitizenVerificationTable>? orderBy,
    _is.OrderByListBuilder<CitizenVerificationTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<CitizenVerification>(
      where: where?.call(CitizenVerification.t),
      orderBy: orderBy?.call(CitizenVerification.t),
      orderByList: orderByList?.call(CitizenVerification.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [CitizenVerification] matching the given query parameters.
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
  Future<CitizenVerification?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CitizenVerificationTable>? where,
    int? offset,
    _is.OrderByBuilder<CitizenVerificationTable>? orderBy,
    _is.OrderByListBuilder<CitizenVerificationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CitizenVerification>(
      where: where?.call(CitizenVerification.t),
      orderBy: orderBy?.call(CitizenVerification.t),
      orderByList: orderByList?.call(CitizenVerification.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CitizenVerification] by its [id] or null if no such row exists.
  Future<CitizenVerification?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CitizenVerification>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CitizenVerification]s in the list and returns the inserted rows.
  ///
  /// The returned [CitizenVerification]s will have their `id` fields set.
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
  Future<List<CitizenVerification>> insert(
    _is.DatabaseSession session,
    List<CitizenVerification> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CitizenVerification>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CitizenVerification] and returns the inserted row.
  ///
  /// The returned [CitizenVerification] will have its `id` field set.
  Future<CitizenVerification> insertRow(
    _is.DatabaseSession session,
    CitizenVerification row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CitizenVerification>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CitizenVerification]s in the list and returns the resulting rows.
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
  /// The returned [CitizenVerification]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CitizenVerification>> upsert(
    _is.DatabaseSession session,
    List<CitizenVerification> rows, {
    required _is.ColumnSelections<CitizenVerificationTable> conflictColumns,
    _is.ColumnSelections<CitizenVerificationTable>? updateColumns,
    _is.WhereExpressionBuilder<CitizenVerificationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CitizenVerification>(
      rows,
      conflictColumns: conflictColumns(CitizenVerification.t),
      updateColumns: updateColumns?.call(CitizenVerification.t),
      updateWhere: updateWhere?.call(CitizenVerification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CitizenVerification] and returns the resulting row.
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
  /// The returned [CitizenVerification] will have its `id` field set.
  Future<CitizenVerification?> upsertRow(
    _is.DatabaseSession session,
    CitizenVerification row, {
    required _is.ColumnSelections<CitizenVerificationTable> conflictColumns,
    _is.ColumnSelections<CitizenVerificationTable>? updateColumns,
    _is.WhereExpressionBuilder<CitizenVerificationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CitizenVerification>(
      row,
      conflictColumns: conflictColumns(CitizenVerification.t),
      updateColumns: updateColumns?.call(CitizenVerification.t),
      updateWhere: updateWhere?.call(CitizenVerification.t),
      transaction: transaction,
    );
  }

  /// Updates all [CitizenVerification]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CitizenVerification>> update(
    _is.DatabaseSession session,
    List<CitizenVerification> rows, {
    _is.ColumnSelections<CitizenVerificationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CitizenVerification>(
      rows,
      columns: columns?.call(CitizenVerification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CitizenVerification]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CitizenVerification> updateRow(
    _is.DatabaseSession session,
    CitizenVerification row, {
    _is.ColumnSelections<CitizenVerificationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CitizenVerification>(
      row,
      columns: columns?.call(CitizenVerification.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CitizenVerification] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CitizenVerification?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CitizenVerificationUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CitizenVerification>(
      id,
      columnValues: columnValues(CitizenVerification.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CitizenVerification]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CitizenVerification>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CitizenVerificationUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<CitizenVerificationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CitizenVerificationTable>? orderBy,
    _is.OrderByListBuilder<CitizenVerificationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CitizenVerification>(
      columnValues: columnValues(CitizenVerification.t.updateTable),
      where: where(CitizenVerification.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CitizenVerification.t),
      orderByList: orderByList?.call(CitizenVerification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CitizenVerification]s in the list and returns the deleted rows.
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
  Future<List<CitizenVerification>> delete(
    _is.DatabaseSession session,
    List<CitizenVerification> rows, {
    _is.OrderByBuilder<CitizenVerificationTable>? orderBy,
    _is.OrderByListBuilder<CitizenVerificationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CitizenVerification>(
      rows,
      orderBy: orderBy?.call(CitizenVerification.t),
      orderByList: orderByList?.call(CitizenVerification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CitizenVerification].
  Future<CitizenVerification> deleteRow(
    _is.DatabaseSession session,
    CitizenVerification row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CitizenVerification>(
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
  Future<List<CitizenVerification>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CitizenVerificationTable> where,
    _is.OrderByBuilder<CitizenVerificationTable>? orderBy,
    _is.OrderByListBuilder<CitizenVerificationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CitizenVerification>(
      where: where(CitizenVerification.t),
      orderBy: orderBy?.call(CitizenVerification.t),
      orderByList: orderByList?.call(CitizenVerification.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CitizenVerificationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CitizenVerification>(
      where: where?.call(CitizenVerification.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CitizenVerification] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CitizenVerificationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CitizenVerification>(
      where: where(CitizenVerification.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
