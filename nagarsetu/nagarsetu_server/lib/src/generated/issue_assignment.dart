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

abstract class IssueAssignment
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  IssueAssignment._({
    this.id,
    required this.issueId,
    required this.departmentId,
    this.officerId,
    required this.assignedBy,
    required this.assignedAt,
    this.deadline,
    required this.assignmentStatus,
    this.remarks,
  });

  factory IssueAssignment({
    int? id,
    required int issueId,
    required int departmentId,
    int? officerId,
    required int assignedBy,
    required DateTime assignedAt,
    DateTime? deadline,
    required String assignmentStatus,
    String? remarks,
  }) = _IssueAssignmentImpl;

  factory IssueAssignment.fromJson(Map<String, dynamic> jsonSerialization) {
    return IssueAssignment(
      id: jsonSerialization['id'] as int?,
      issueId: jsonSerialization['issueId'] as int,
      departmentId: jsonSerialization['departmentId'] as int,
      officerId: jsonSerialization['officerId'] as int?,
      assignedBy: jsonSerialization['assignedBy'] as int,
      assignedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['assignedAt'],
      ),
      deadline: jsonSerialization['deadline'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['deadline']),
      assignmentStatus: jsonSerialization['assignmentStatus'] as String,
      remarks: jsonSerialization['remarks'] as String?,
    );
  }

  static final t = IssueAssignmentTable();

  static const db = IssueAssignmentRepository._();

  @override
  int? id;

  int issueId;

  int departmentId;

  int? officerId;

  int assignedBy;

  DateTime assignedAt;

  DateTime? deadline;

  String assignmentStatus;

  String? remarks;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [IssueAssignment]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  IssueAssignment copyWith({
    int? id,
    int? issueId,
    int? departmentId,
    int? officerId,
    int? assignedBy,
    DateTime? assignedAt,
    DateTime? deadline = const _is.$UndefinedDateTime(),
    String? assignmentStatus,
    String? remarks,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IssueAssignment',
      if (id != null) 'id': id,
      'issueId': issueId,
      'departmentId': departmentId,
      if (officerId != null) 'officerId': officerId,
      'assignedBy': assignedBy,
      'assignedAt': assignedAt.toJson(),
      if (deadline != null) 'deadline': deadline?.toJson(),
      'assignmentStatus': assignmentStatus,
      if (remarks != null) 'remarks': remarks,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IssueAssignment',
      if (id != null) 'id': id,
      'issueId': issueId,
      'departmentId': departmentId,
      if (officerId != null) 'officerId': officerId,
      'assignedBy': assignedBy,
      'assignedAt': assignedAt.toJson(),
      if (deadline != null) 'deadline': deadline?.toJson(),
      'assignmentStatus': assignmentStatus,
      if (remarks != null) 'remarks': remarks,
    };
  }

  static IssueAssignmentInclude include() {
    return IssueAssignmentInclude._();
  }

  static IssueAssignmentIncludeList includeList({
    _is.WhereExpressionBuilder<IssueAssignmentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IssueAssignmentTable>? orderBy,
    _is.OrderByListBuilder<IssueAssignmentTable>? orderByList,
    IssueAssignmentInclude? include,
  }) {
    return IssueAssignmentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IssueAssignment.t),
      orderByList: orderByList?.call(IssueAssignment.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IssueAssignmentImpl extends IssueAssignment {
  _IssueAssignmentImpl({
    int? id,
    required int issueId,
    required int departmentId,
    int? officerId,
    required int assignedBy,
    required DateTime assignedAt,
    DateTime? deadline,
    required String assignmentStatus,
    String? remarks,
  }) : super._(
         id: id,
         issueId: issueId,
         departmentId: departmentId,
         officerId: officerId,
         assignedBy: assignedBy,
         assignedAt: assignedAt,
         deadline: deadline,
         assignmentStatus: assignmentStatus,
         remarks: remarks,
       );

  /// Returns a shallow copy of this [IssueAssignment]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  IssueAssignment copyWith({
    Object? id = _Undefined,
    int? issueId,
    int? departmentId,
    Object? officerId = _Undefined,
    int? assignedBy,
    DateTime? assignedAt,
    DateTime? deadline = const _is.$UndefinedDateTime(),
    String? assignmentStatus,
    Object? remarks = _Undefined,
  }) {
    return IssueAssignment(
      id: id is int? ? id : this.id,
      issueId: issueId ?? this.issueId,
      departmentId: departmentId ?? this.departmentId,
      officerId: officerId is int? ? officerId : this.officerId,
      assignedBy: assignedBy ?? this.assignedBy,
      assignedAt: assignedAt ?? this.assignedAt,
      deadline: deadline is _is.UndefinedSentinel ? this.deadline : deadline,
      assignmentStatus: assignmentStatus ?? this.assignmentStatus,
      remarks: remarks is String? ? remarks : this.remarks,
    );
  }
}

class IssueAssignmentUpdateTable extends _is.UpdateTable<IssueAssignmentTable> {
  IssueAssignmentUpdateTable(super.table);

  _is.ColumnValue<int, int> issueId(int value) => _is.ColumnValue(
    table.issueId,
    value,
  );

  _is.ColumnValue<int, int> departmentId(int value) => _is.ColumnValue(
    table.departmentId,
    value,
  );

  _is.ColumnValue<int, int> officerId(int? value) => _is.ColumnValue(
    table.officerId,
    value,
  );

  _is.ColumnValue<int, int> assignedBy(int value) => _is.ColumnValue(
    table.assignedBy,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> assignedAt(DateTime value) =>
      _is.ColumnValue(
        table.assignedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> deadline(DateTime? value) =>
      _is.ColumnValue(
        table.deadline,
        value,
      );

  _is.ColumnValue<String, String> assignmentStatus(String value) =>
      _is.ColumnValue(
        table.assignmentStatus,
        value,
      );

  _is.ColumnValue<String, String> remarks(String? value) => _is.ColumnValue(
    table.remarks,
    value,
  );
}

class IssueAssignmentTable extends _is.Table<int?> {
  IssueAssignmentTable({super.tableRelation})
    : super(tableName: 'issue_assignments') {
    updateTable = IssueAssignmentUpdateTable(this);
    issueId = _is.ColumnInt(
      'issueId',
      this,
    );
    departmentId = _is.ColumnInt(
      'departmentId',
      this,
    );
    officerId = _is.ColumnInt(
      'officerId',
      this,
    );
    assignedBy = _is.ColumnInt(
      'assignedBy',
      this,
    );
    assignedAt = _is.ColumnDateTime(
      'assignedAt',
      this,
    );
    deadline = _is.ColumnDateTime(
      'deadline',
      this,
    );
    assignmentStatus = _is.ColumnString(
      'assignmentStatus',
      this,
    );
    remarks = _is.ColumnString(
      'remarks',
      this,
    );
  }

  late final IssueAssignmentUpdateTable updateTable;

  late final _is.ColumnInt issueId;

  late final _is.ColumnInt departmentId;

  late final _is.ColumnInt officerId;

  late final _is.ColumnInt assignedBy;

  late final _is.ColumnDateTime assignedAt;

  late final _is.ColumnDateTime deadline;

  late final _is.ColumnString assignmentStatus;

  late final _is.ColumnString remarks;

  @override
  List<_is.Column> get columns => [
    id,
    issueId,
    departmentId,
    officerId,
    assignedBy,
    assignedAt,
    deadline,
    assignmentStatus,
    remarks,
  ];
}

class IssueAssignmentInclude extends _is.IncludeObject {
  IssueAssignmentInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => IssueAssignment.t;
}

class IssueAssignmentIncludeList extends _is.IncludeList {
  IssueAssignmentIncludeList._({
    _is.WhereExpressionBuilder<IssueAssignmentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(IssueAssignment.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => IssueAssignment.t;
}

class IssueAssignmentRepository {
  const IssueAssignmentRepository._();

  /// Returns a list of [IssueAssignment]s matching the given query parameters.
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
  Future<List<IssueAssignment>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IssueAssignmentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IssueAssignmentTable>? orderBy,
    _is.OrderByListBuilder<IssueAssignmentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<IssueAssignment>(
      where: where?.call(IssueAssignment.t),
      orderBy: orderBy?.call(IssueAssignment.t),
      orderByList: orderByList?.call(IssueAssignment.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [IssueAssignment]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `IssueAssignment.t`.
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
  _ida.Stream<List<IssueAssignment>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IssueAssignmentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IssueAssignmentTable>? orderBy,
    _is.OrderByListBuilder<IssueAssignmentTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<IssueAssignment>(
      where: where?.call(IssueAssignment.t),
      orderBy: orderBy?.call(IssueAssignment.t),
      orderByList: orderByList?.call(IssueAssignment.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [IssueAssignment] matching the given query parameters.
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
  Future<IssueAssignment?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IssueAssignmentTable>? where,
    int? offset,
    _is.OrderByBuilder<IssueAssignmentTable>? orderBy,
    _is.OrderByListBuilder<IssueAssignmentTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<IssueAssignment>(
      where: where?.call(IssueAssignment.t),
      orderBy: orderBy?.call(IssueAssignment.t),
      orderByList: orderByList?.call(IssueAssignment.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [IssueAssignment] by its [id] or null if no such row exists.
  Future<IssueAssignment?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<IssueAssignment>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [IssueAssignment]s in the list and returns the inserted rows.
  ///
  /// The returned [IssueAssignment]s will have their `id` fields set.
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
  Future<List<IssueAssignment>> insert(
    _is.DatabaseSession session,
    List<IssueAssignment> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<IssueAssignment>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [IssueAssignment] and returns the inserted row.
  ///
  /// The returned [IssueAssignment] will have its `id` field set.
  Future<IssueAssignment> insertRow(
    _is.DatabaseSession session,
    IssueAssignment row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<IssueAssignment>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [IssueAssignment]s in the list and returns the resulting rows.
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
  /// The returned [IssueAssignment]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IssueAssignment>> upsert(
    _is.DatabaseSession session,
    List<IssueAssignment> rows, {
    required _is.ColumnSelections<IssueAssignmentTable> conflictColumns,
    _is.ColumnSelections<IssueAssignmentTable>? updateColumns,
    _is.WhereExpressionBuilder<IssueAssignmentTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<IssueAssignment>(
      rows,
      conflictColumns: conflictColumns(IssueAssignment.t),
      updateColumns: updateColumns?.call(IssueAssignment.t),
      updateWhere: updateWhere?.call(IssueAssignment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [IssueAssignment] and returns the resulting row.
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
  /// The returned [IssueAssignment] will have its `id` field set.
  Future<IssueAssignment?> upsertRow(
    _is.DatabaseSession session,
    IssueAssignment row, {
    required _is.ColumnSelections<IssueAssignmentTable> conflictColumns,
    _is.ColumnSelections<IssueAssignmentTable>? updateColumns,
    _is.WhereExpressionBuilder<IssueAssignmentTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<IssueAssignment>(
      row,
      conflictColumns: conflictColumns(IssueAssignment.t),
      updateColumns: updateColumns?.call(IssueAssignment.t),
      updateWhere: updateWhere?.call(IssueAssignment.t),
      transaction: transaction,
    );
  }

  /// Updates all [IssueAssignment]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IssueAssignment>> update(
    _is.DatabaseSession session,
    List<IssueAssignment> rows, {
    _is.ColumnSelections<IssueAssignmentTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<IssueAssignment>(
      rows,
      columns: columns?.call(IssueAssignment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [IssueAssignment]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<IssueAssignment> updateRow(
    _is.DatabaseSession session,
    IssueAssignment row, {
    _is.ColumnSelections<IssueAssignmentTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<IssueAssignment>(
      row,
      columns: columns?.call(IssueAssignment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [IssueAssignment] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<IssueAssignment?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<IssueAssignmentUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<IssueAssignment>(
      id,
      columnValues: columnValues(IssueAssignment.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [IssueAssignment]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IssueAssignment>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<IssueAssignmentUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<IssueAssignmentTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IssueAssignmentTable>? orderBy,
    _is.OrderByListBuilder<IssueAssignmentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<IssueAssignment>(
      columnValues: columnValues(IssueAssignment.t.updateTable),
      where: where(IssueAssignment.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IssueAssignment.t),
      orderByList: orderByList?.call(IssueAssignment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [IssueAssignment]s in the list and returns the deleted rows.
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
  Future<List<IssueAssignment>> delete(
    _is.DatabaseSession session,
    List<IssueAssignment> rows, {
    _is.OrderByBuilder<IssueAssignmentTable>? orderBy,
    _is.OrderByListBuilder<IssueAssignmentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<IssueAssignment>(
      rows,
      orderBy: orderBy?.call(IssueAssignment.t),
      orderByList: orderByList?.call(IssueAssignment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [IssueAssignment].
  Future<IssueAssignment> deleteRow(
    _is.DatabaseSession session,
    IssueAssignment row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<IssueAssignment>(
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
  Future<List<IssueAssignment>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<IssueAssignmentTable> where,
    _is.OrderByBuilder<IssueAssignmentTable>? orderBy,
    _is.OrderByListBuilder<IssueAssignmentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<IssueAssignment>(
      where: where(IssueAssignment.t),
      orderBy: orderBy?.call(IssueAssignment.t),
      orderByList: orderByList?.call(IssueAssignment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IssueAssignmentTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<IssueAssignment>(
      where: where?.call(IssueAssignment.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [IssueAssignment] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<IssueAssignmentTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<IssueAssignment>(
      where: where(IssueAssignment.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
