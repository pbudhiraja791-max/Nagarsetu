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

abstract class ReportCountHistory
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ReportCountHistory._({
    this.id,
    required this.issueId,
    required this.reportId,
    required this.previousCount,
    required this.newCount,
    required this.actionType,
    required this.createdAt,
  });

  factory ReportCountHistory({
    int? id,
    required int issueId,
    required int reportId,
    required int previousCount,
    required int newCount,
    required String actionType,
    required DateTime createdAt,
  }) = _ReportCountHistoryImpl;

  factory ReportCountHistory.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReportCountHistory(
      id: jsonSerialization['id'] as int?,
      issueId: jsonSerialization['issueId'] as int,
      reportId: jsonSerialization['reportId'] as int,
      previousCount: jsonSerialization['previousCount'] as int,
      newCount: jsonSerialization['newCount'] as int,
      actionType: jsonSerialization['actionType'] as String,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = ReportCountHistoryTable();

  static const db = ReportCountHistoryRepository._();

  @override
  int? id;

  int issueId;

  int reportId;

  int previousCount;

  int newCount;

  String actionType;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ReportCountHistory]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ReportCountHistory copyWith({
    int? id,
    int? issueId,
    int? reportId,
    int? previousCount,
    int? newCount,
    String? actionType,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReportCountHistory',
      if (id != null) 'id': id,
      'issueId': issueId,
      'reportId': reportId,
      'previousCount': previousCount,
      'newCount': newCount,
      'actionType': actionType,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReportCountHistory',
      if (id != null) 'id': id,
      'issueId': issueId,
      'reportId': reportId,
      'previousCount': previousCount,
      'newCount': newCount,
      'actionType': actionType,
      'createdAt': createdAt.toJson(),
    };
  }

  static ReportCountHistoryInclude include() {
    return ReportCountHistoryInclude._();
  }

  static ReportCountHistoryIncludeList includeList({
    _is.WhereExpressionBuilder<ReportCountHistoryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReportCountHistoryTable>? orderBy,
    _is.OrderByListBuilder<ReportCountHistoryTable>? orderByList,
    ReportCountHistoryInclude? include,
  }) {
    return ReportCountHistoryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReportCountHistory.t),
      orderByList: orderByList?.call(ReportCountHistory.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReportCountHistoryImpl extends ReportCountHistory {
  _ReportCountHistoryImpl({
    int? id,
    required int issueId,
    required int reportId,
    required int previousCount,
    required int newCount,
    required String actionType,
    required DateTime createdAt,
  }) : super._(
         id: id,
         issueId: issueId,
         reportId: reportId,
         previousCount: previousCount,
         newCount: newCount,
         actionType: actionType,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ReportCountHistory]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ReportCountHistory copyWith({
    Object? id = _Undefined,
    int? issueId,
    int? reportId,
    int? previousCount,
    int? newCount,
    String? actionType,
    DateTime? createdAt,
  }) {
    return ReportCountHistory(
      id: id is int? ? id : this.id,
      issueId: issueId ?? this.issueId,
      reportId: reportId ?? this.reportId,
      previousCount: previousCount ?? this.previousCount,
      newCount: newCount ?? this.newCount,
      actionType: actionType ?? this.actionType,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ReportCountHistoryUpdateTable
    extends _is.UpdateTable<ReportCountHistoryTable> {
  ReportCountHistoryUpdateTable(super.table);

  _is.ColumnValue<int, int> issueId(int value) => _is.ColumnValue(
    table.issueId,
    value,
  );

  _is.ColumnValue<int, int> reportId(int value) => _is.ColumnValue(
    table.reportId,
    value,
  );

  _is.ColumnValue<int, int> previousCount(int value) => _is.ColumnValue(
    table.previousCount,
    value,
  );

  _is.ColumnValue<int, int> newCount(int value) => _is.ColumnValue(
    table.newCount,
    value,
  );

  _is.ColumnValue<String, String> actionType(String value) => _is.ColumnValue(
    table.actionType,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class ReportCountHistoryTable extends _is.Table<int?> {
  ReportCountHistoryTable({super.tableRelation})
    : super(tableName: 'report_count_history') {
    updateTable = ReportCountHistoryUpdateTable(this);
    issueId = _is.ColumnInt(
      'issueId',
      this,
    );
    reportId = _is.ColumnInt(
      'reportId',
      this,
    );
    previousCount = _is.ColumnInt(
      'previousCount',
      this,
    );
    newCount = _is.ColumnInt(
      'newCount',
      this,
    );
    actionType = _is.ColumnString(
      'actionType',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final ReportCountHistoryUpdateTable updateTable;

  late final _is.ColumnInt issueId;

  late final _is.ColumnInt reportId;

  late final _is.ColumnInt previousCount;

  late final _is.ColumnInt newCount;

  late final _is.ColumnString actionType;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    issueId,
    reportId,
    previousCount,
    newCount,
    actionType,
    createdAt,
  ];
}

class ReportCountHistoryInclude extends _is.IncludeObject {
  ReportCountHistoryInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ReportCountHistory.t;
}

class ReportCountHistoryIncludeList extends _is.IncludeList {
  ReportCountHistoryIncludeList._({
    _is.WhereExpressionBuilder<ReportCountHistoryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReportCountHistory.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ReportCountHistory.t;
}

class ReportCountHistoryRepository {
  const ReportCountHistoryRepository._();

  /// Returns a list of [ReportCountHistory]s matching the given query parameters.
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
  Future<List<ReportCountHistory>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReportCountHistoryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReportCountHistoryTable>? orderBy,
    _is.OrderByListBuilder<ReportCountHistoryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ReportCountHistory>(
      where: where?.call(ReportCountHistory.t),
      orderBy: orderBy?.call(ReportCountHistory.t),
      orderByList: orderByList?.call(ReportCountHistory.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [ReportCountHistory]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `ReportCountHistory.t`.
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
  _ida.Stream<List<ReportCountHistory>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReportCountHistoryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReportCountHistoryTable>? orderBy,
    _is.OrderByListBuilder<ReportCountHistoryTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<ReportCountHistory>(
      where: where?.call(ReportCountHistory.t),
      orderBy: orderBy?.call(ReportCountHistory.t),
      orderByList: orderByList?.call(ReportCountHistory.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [ReportCountHistory] matching the given query parameters.
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
  Future<ReportCountHistory?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReportCountHistoryTable>? where,
    int? offset,
    _is.OrderByBuilder<ReportCountHistoryTable>? orderBy,
    _is.OrderByListBuilder<ReportCountHistoryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ReportCountHistory>(
      where: where?.call(ReportCountHistory.t),
      orderBy: orderBy?.call(ReportCountHistory.t),
      orderByList: orderByList?.call(ReportCountHistory.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ReportCountHistory] by its [id] or null if no such row exists.
  Future<ReportCountHistory?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ReportCountHistory>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ReportCountHistory]s in the list and returns the inserted rows.
  ///
  /// The returned [ReportCountHistory]s will have their `id` fields set.
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
  Future<List<ReportCountHistory>> insert(
    _is.DatabaseSession session,
    List<ReportCountHistory> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ReportCountHistory>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ReportCountHistory] and returns the inserted row.
  ///
  /// The returned [ReportCountHistory] will have its `id` field set.
  Future<ReportCountHistory> insertRow(
    _is.DatabaseSession session,
    ReportCountHistory row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ReportCountHistory>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ReportCountHistory]s in the list and returns the resulting rows.
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
  /// The returned [ReportCountHistory]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReportCountHistory>> upsert(
    _is.DatabaseSession session,
    List<ReportCountHistory> rows, {
    required _is.ColumnSelections<ReportCountHistoryTable> conflictColumns,
    _is.ColumnSelections<ReportCountHistoryTable>? updateColumns,
    _is.WhereExpressionBuilder<ReportCountHistoryTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ReportCountHistory>(
      rows,
      conflictColumns: conflictColumns(ReportCountHistory.t),
      updateColumns: updateColumns?.call(ReportCountHistory.t),
      updateWhere: updateWhere?.call(ReportCountHistory.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ReportCountHistory] and returns the resulting row.
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
  /// The returned [ReportCountHistory] will have its `id` field set.
  Future<ReportCountHistory?> upsertRow(
    _is.DatabaseSession session,
    ReportCountHistory row, {
    required _is.ColumnSelections<ReportCountHistoryTable> conflictColumns,
    _is.ColumnSelections<ReportCountHistoryTable>? updateColumns,
    _is.WhereExpressionBuilder<ReportCountHistoryTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ReportCountHistory>(
      row,
      conflictColumns: conflictColumns(ReportCountHistory.t),
      updateColumns: updateColumns?.call(ReportCountHistory.t),
      updateWhere: updateWhere?.call(ReportCountHistory.t),
      transaction: transaction,
    );
  }

  /// Updates all [ReportCountHistory]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReportCountHistory>> update(
    _is.DatabaseSession session,
    List<ReportCountHistory> rows, {
    _is.ColumnSelections<ReportCountHistoryTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ReportCountHistory>(
      rows,
      columns: columns?.call(ReportCountHistory.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ReportCountHistory]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ReportCountHistory> updateRow(
    _is.DatabaseSession session,
    ReportCountHistory row, {
    _is.ColumnSelections<ReportCountHistoryTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ReportCountHistory>(
      row,
      columns: columns?.call(ReportCountHistory.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReportCountHistory] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ReportCountHistory?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ReportCountHistoryUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ReportCountHistory>(
      id,
      columnValues: columnValues(ReportCountHistory.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ReportCountHistory]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ReportCountHistory>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ReportCountHistoryUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ReportCountHistoryTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ReportCountHistoryTable>? orderBy,
    _is.OrderByListBuilder<ReportCountHistoryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ReportCountHistory>(
      columnValues: columnValues(ReportCountHistory.t.updateTable),
      where: where(ReportCountHistory.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReportCountHistory.t),
      orderByList: orderByList?.call(ReportCountHistory.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ReportCountHistory]s in the list and returns the deleted rows.
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
  Future<List<ReportCountHistory>> delete(
    _is.DatabaseSession session,
    List<ReportCountHistory> rows, {
    _is.OrderByBuilder<ReportCountHistoryTable>? orderBy,
    _is.OrderByListBuilder<ReportCountHistoryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ReportCountHistory>(
      rows,
      orderBy: orderBy?.call(ReportCountHistory.t),
      orderByList: orderByList?.call(ReportCountHistory.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ReportCountHistory].
  Future<ReportCountHistory> deleteRow(
    _is.DatabaseSession session,
    ReportCountHistory row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ReportCountHistory>(
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
  Future<List<ReportCountHistory>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReportCountHistoryTable> where,
    _is.OrderByBuilder<ReportCountHistoryTable>? orderBy,
    _is.OrderByListBuilder<ReportCountHistoryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ReportCountHistory>(
      where: where(ReportCountHistory.t),
      orderBy: orderBy?.call(ReportCountHistory.t),
      orderByList: orderByList?.call(ReportCountHistory.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ReportCountHistoryTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ReportCountHistory>(
      where: where?.call(ReportCountHistory.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ReportCountHistory] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ReportCountHistoryTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ReportCountHistory>(
      where: where(ReportCountHistory.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
