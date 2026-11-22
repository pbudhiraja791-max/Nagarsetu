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

abstract class Officer
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Officer._({
    this.id,
    required this.userId,
    required this.departmentId,
    required this.employeeCode,
    this.designation,
    this.assignedArea,
    required this.isActive,
    required this.createdAt,
  });

  factory Officer({
    int? id,
    required int userId,
    required int departmentId,
    required String employeeCode,
    String? designation,
    String? assignedArea,
    required bool isActive,
    required DateTime createdAt,
  }) = _OfficerImpl;

  factory Officer.fromJson(Map<String, dynamic> jsonSerialization) {
    return Officer(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      departmentId: jsonSerialization['departmentId'] as int,
      employeeCode: jsonSerialization['employeeCode'] as String,
      designation: jsonSerialization['designation'] as String?,
      assignedArea: jsonSerialization['assignedArea'] as String?,
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = OfficerTable();

  static const db = OfficerRepository._();

  @override
  int? id;

  int userId;

  int departmentId;

  String employeeCode;

  String? designation;

  String? assignedArea;

  bool isActive;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Officer]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Officer copyWith({
    int? id,
    int? userId,
    int? departmentId,
    String? employeeCode,
    String? designation,
    String? assignedArea,
    bool? isActive,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Officer',
      if (id != null) 'id': id,
      'userId': userId,
      'departmentId': departmentId,
      'employeeCode': employeeCode,
      if (designation != null) 'designation': designation,
      if (assignedArea != null) 'assignedArea': assignedArea,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Officer',
      if (id != null) 'id': id,
      'userId': userId,
      'departmentId': departmentId,
      'employeeCode': employeeCode,
      if (designation != null) 'designation': designation,
      if (assignedArea != null) 'assignedArea': assignedArea,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
    };
  }

  static OfficerInclude include() {
    return OfficerInclude._();
  }

  static OfficerIncludeList includeList({
    _is.WhereExpressionBuilder<OfficerTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OfficerTable>? orderBy,
    _is.OrderByListBuilder<OfficerTable>? orderByList,
    OfficerInclude? include,
  }) {
    return OfficerIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Officer.t),
      orderByList: orderByList?.call(Officer.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OfficerImpl extends Officer {
  _OfficerImpl({
    int? id,
    required int userId,
    required int departmentId,
    required String employeeCode,
    String? designation,
    String? assignedArea,
    required bool isActive,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         departmentId: departmentId,
         employeeCode: employeeCode,
         designation: designation,
         assignedArea: assignedArea,
         isActive: isActive,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Officer]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Officer copyWith({
    Object? id = _Undefined,
    int? userId,
    int? departmentId,
    String? employeeCode,
    Object? designation = _Undefined,
    Object? assignedArea = _Undefined,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Officer(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      departmentId: departmentId ?? this.departmentId,
      employeeCode: employeeCode ?? this.employeeCode,
      designation: designation is String? ? designation : this.designation,
      assignedArea: assignedArea is String? ? assignedArea : this.assignedArea,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class OfficerUpdateTable extends _is.UpdateTable<OfficerTable> {
  OfficerUpdateTable(super.table);

  _is.ColumnValue<int, int> userId(int value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<int, int> departmentId(int value) => _is.ColumnValue(
    table.departmentId,
    value,
  );

  _is.ColumnValue<String, String> employeeCode(String value) => _is.ColumnValue(
    table.employeeCode,
    value,
  );

  _is.ColumnValue<String, String> designation(String? value) => _is.ColumnValue(
    table.designation,
    value,
  );

  _is.ColumnValue<String, String> assignedArea(String? value) =>
      _is.ColumnValue(
        table.assignedArea,
        value,
      );

  _is.ColumnValue<bool, bool> isActive(bool value) => _is.ColumnValue(
    table.isActive,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class OfficerTable extends _is.Table<int?> {
  OfficerTable({super.tableRelation}) : super(tableName: 'officers') {
    updateTable = OfficerUpdateTable(this);
    userId = _is.ColumnInt(
      'userId',
      this,
    );
    departmentId = _is.ColumnInt(
      'departmentId',
      this,
    );
    employeeCode = _is.ColumnString(
      'employeeCode',
      this,
    );
    designation = _is.ColumnString(
      'designation',
      this,
    );
    assignedArea = _is.ColumnString(
      'assignedArea',
      this,
    );
    isActive = _is.ColumnBool(
      'isActive',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final OfficerUpdateTable updateTable;

  late final _is.ColumnInt userId;

  late final _is.ColumnInt departmentId;

  late final _is.ColumnString employeeCode;

  late final _is.ColumnString designation;

  late final _is.ColumnString assignedArea;

  late final _is.ColumnBool isActive;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    departmentId,
    employeeCode,
    designation,
    assignedArea,
    isActive,
    createdAt,
  ];
}

class OfficerInclude extends _is.IncludeObject {
  OfficerInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Officer.t;
}

class OfficerIncludeList extends _is.IncludeList {
  OfficerIncludeList._({
    _is.WhereExpressionBuilder<OfficerTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Officer.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Officer.t;
}

class OfficerRepository {
  const OfficerRepository._();

  /// Returns a list of [Officer]s matching the given query parameters.
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
  Future<List<Officer>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OfficerTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OfficerTable>? orderBy,
    _is.OrderByListBuilder<OfficerTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Officer>(
      where: where?.call(Officer.t),
      orderBy: orderBy?.call(Officer.t),
      orderByList: orderByList?.call(Officer.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [Officer]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `Officer.t`.
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
  _ida.Stream<List<Officer>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OfficerTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OfficerTable>? orderBy,
    _is.OrderByListBuilder<OfficerTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<Officer>(
      where: where?.call(Officer.t),
      orderBy: orderBy?.call(Officer.t),
      orderByList: orderByList?.call(Officer.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [Officer] matching the given query parameters.
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
  Future<Officer?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OfficerTable>? where,
    int? offset,
    _is.OrderByBuilder<OfficerTable>? orderBy,
    _is.OrderByListBuilder<OfficerTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Officer>(
      where: where?.call(Officer.t),
      orderBy: orderBy?.call(Officer.t),
      orderByList: orderByList?.call(Officer.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Officer] by its [id] or null if no such row exists.
  Future<Officer?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Officer>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Officer]s in the list and returns the inserted rows.
  ///
  /// The returned [Officer]s will have their `id` fields set.
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
  Future<List<Officer>> insert(
    _is.DatabaseSession session,
    List<Officer> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Officer>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Officer] and returns the inserted row.
  ///
  /// The returned [Officer] will have its `id` field set.
  Future<Officer> insertRow(
    _is.DatabaseSession session,
    Officer row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Officer>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Officer]s in the list and returns the resulting rows.
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
  /// The returned [Officer]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Officer>> upsert(
    _is.DatabaseSession session,
    List<Officer> rows, {
    required _is.ColumnSelections<OfficerTable> conflictColumns,
    _is.ColumnSelections<OfficerTable>? updateColumns,
    _is.WhereExpressionBuilder<OfficerTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Officer>(
      rows,
      conflictColumns: conflictColumns(Officer.t),
      updateColumns: updateColumns?.call(Officer.t),
      updateWhere: updateWhere?.call(Officer.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Officer] and returns the resulting row.
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
  /// The returned [Officer] will have its `id` field set.
  Future<Officer?> upsertRow(
    _is.DatabaseSession session,
    Officer row, {
    required _is.ColumnSelections<OfficerTable> conflictColumns,
    _is.ColumnSelections<OfficerTable>? updateColumns,
    _is.WhereExpressionBuilder<OfficerTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Officer>(
      row,
      conflictColumns: conflictColumns(Officer.t),
      updateColumns: updateColumns?.call(Officer.t),
      updateWhere: updateWhere?.call(Officer.t),
      transaction: transaction,
    );
  }

  /// Updates all [Officer]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Officer>> update(
    _is.DatabaseSession session,
    List<Officer> rows, {
    _is.ColumnSelections<OfficerTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Officer>(
      rows,
      columns: columns?.call(Officer.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Officer]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Officer> updateRow(
    _is.DatabaseSession session,
    Officer row, {
    _is.ColumnSelections<OfficerTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Officer>(
      row,
      columns: columns?.call(Officer.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Officer] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Officer?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<OfficerUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Officer>(
      id,
      columnValues: columnValues(Officer.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Officer]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Officer>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<OfficerUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<OfficerTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OfficerTable>? orderBy,
    _is.OrderByListBuilder<OfficerTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Officer>(
      columnValues: columnValues(Officer.t.updateTable),
      where: where(Officer.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Officer.t),
      orderByList: orderByList?.call(Officer.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Officer]s in the list and returns the deleted rows.
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
  Future<List<Officer>> delete(
    _is.DatabaseSession session,
    List<Officer> rows, {
    _is.OrderByBuilder<OfficerTable>? orderBy,
    _is.OrderByListBuilder<OfficerTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Officer>(
      rows,
      orderBy: orderBy?.call(Officer.t),
      orderByList: orderByList?.call(Officer.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Officer].
  Future<Officer> deleteRow(
    _is.DatabaseSession session,
    Officer row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Officer>(
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
  Future<List<Officer>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<OfficerTable> where,
    _is.OrderByBuilder<OfficerTable>? orderBy,
    _is.OrderByListBuilder<OfficerTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Officer>(
      where: where(Officer.t),
      orderBy: orderBy?.call(Officer.t),
      orderByList: orderByList?.call(Officer.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OfficerTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Officer>(
      where: where?.call(Officer.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Officer] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<OfficerTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Officer>(
      where: where(Officer.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
