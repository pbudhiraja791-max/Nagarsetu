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

abstract class IssueMatchHistory
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  IssueMatchHistory._({
    this.id,
    required this.reportId,
    this.matchedIssueId,
    required this.geographicSimilarity,
    required this.imageSimilarity,
    required this.descriptionSimilarity,
    required this.categorySimilarity,
    required this.temporalSimilarity,
    required this.combinedSimilarityScore,
    required this.matchingDecision,
    this.decisionReason,
    this.reviewedBy,
    required this.createdAt,
  });

  factory IssueMatchHistory({
    int? id,
    required int reportId,
    int? matchedIssueId,
    required double geographicSimilarity,
    required double imageSimilarity,
    required double descriptionSimilarity,
    required double categorySimilarity,
    required double temporalSimilarity,
    required double combinedSimilarityScore,
    required String matchingDecision,
    String? decisionReason,
    int? reviewedBy,
    required DateTime createdAt,
  }) = _IssueMatchHistoryImpl;

  factory IssueMatchHistory.fromJson(Map<String, dynamic> jsonSerialization) {
    return IssueMatchHistory(
      id: jsonSerialization['id'] as int?,
      reportId: jsonSerialization['reportId'] as int,
      matchedIssueId: jsonSerialization['matchedIssueId'] as int?,
      geographicSimilarity: (jsonSerialization['geographicSimilarity'] as num)
          .toDouble(),
      imageSimilarity: (jsonSerialization['imageSimilarity'] as num).toDouble(),
      descriptionSimilarity: (jsonSerialization['descriptionSimilarity'] as num)
          .toDouble(),
      categorySimilarity: (jsonSerialization['categorySimilarity'] as num)
          .toDouble(),
      temporalSimilarity: (jsonSerialization['temporalSimilarity'] as num)
          .toDouble(),
      combinedSimilarityScore:
          (jsonSerialization['combinedSimilarityScore'] as num).toDouble(),
      matchingDecision: jsonSerialization['matchingDecision'] as String,
      decisionReason: jsonSerialization['decisionReason'] as String?,
      reviewedBy: jsonSerialization['reviewedBy'] as int?,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = IssueMatchHistoryTable();

  static const db = IssueMatchHistoryRepository._();

  @override
  int? id;

  int reportId;

  int? matchedIssueId;

  double geographicSimilarity;

  double imageSimilarity;

  double descriptionSimilarity;

  double categorySimilarity;

  double temporalSimilarity;

  double combinedSimilarityScore;

  String matchingDecision;

  String? decisionReason;

  int? reviewedBy;

  DateTime createdAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [IssueMatchHistory]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  IssueMatchHistory copyWith({
    int? id,
    int? reportId,
    int? matchedIssueId,
    double? geographicSimilarity,
    double? imageSimilarity,
    double? descriptionSimilarity,
    double? categorySimilarity,
    double? temporalSimilarity,
    double? combinedSimilarityScore,
    String? matchingDecision,
    String? decisionReason,
    int? reviewedBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IssueMatchHistory',
      if (id != null) 'id': id,
      'reportId': reportId,
      if (matchedIssueId != null) 'matchedIssueId': matchedIssueId,
      'geographicSimilarity': geographicSimilarity,
      'imageSimilarity': imageSimilarity,
      'descriptionSimilarity': descriptionSimilarity,
      'categorySimilarity': categorySimilarity,
      'temporalSimilarity': temporalSimilarity,
      'combinedSimilarityScore': combinedSimilarityScore,
      'matchingDecision': matchingDecision,
      if (decisionReason != null) 'decisionReason': decisionReason,
      if (reviewedBy != null) 'reviewedBy': reviewedBy,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IssueMatchHistory',
      if (id != null) 'id': id,
      'reportId': reportId,
      if (matchedIssueId != null) 'matchedIssueId': matchedIssueId,
      'geographicSimilarity': geographicSimilarity,
      'imageSimilarity': imageSimilarity,
      'descriptionSimilarity': descriptionSimilarity,
      'categorySimilarity': categorySimilarity,
      'temporalSimilarity': temporalSimilarity,
      'combinedSimilarityScore': combinedSimilarityScore,
      'matchingDecision': matchingDecision,
      if (decisionReason != null) 'decisionReason': decisionReason,
      if (reviewedBy != null) 'reviewedBy': reviewedBy,
      'createdAt': createdAt.toJson(),
    };
  }

  static IssueMatchHistoryInclude include() {
    return IssueMatchHistoryInclude._();
  }

  static IssueMatchHistoryIncludeList includeList({
    _is.WhereExpressionBuilder<IssueMatchHistoryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IssueMatchHistoryTable>? orderBy,
    _is.OrderByListBuilder<IssueMatchHistoryTable>? orderByList,
    IssueMatchHistoryInclude? include,
  }) {
    return IssueMatchHistoryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IssueMatchHistory.t),
      orderByList: orderByList?.call(IssueMatchHistory.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IssueMatchHistoryImpl extends IssueMatchHistory {
  _IssueMatchHistoryImpl({
    int? id,
    required int reportId,
    int? matchedIssueId,
    required double geographicSimilarity,
    required double imageSimilarity,
    required double descriptionSimilarity,
    required double categorySimilarity,
    required double temporalSimilarity,
    required double combinedSimilarityScore,
    required String matchingDecision,
    String? decisionReason,
    int? reviewedBy,
    required DateTime createdAt,
  }) : super._(
         id: id,
         reportId: reportId,
         matchedIssueId: matchedIssueId,
         geographicSimilarity: geographicSimilarity,
         imageSimilarity: imageSimilarity,
         descriptionSimilarity: descriptionSimilarity,
         categorySimilarity: categorySimilarity,
         temporalSimilarity: temporalSimilarity,
         combinedSimilarityScore: combinedSimilarityScore,
         matchingDecision: matchingDecision,
         decisionReason: decisionReason,
         reviewedBy: reviewedBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [IssueMatchHistory]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  IssueMatchHistory copyWith({
    Object? id = _Undefined,
    int? reportId,
    Object? matchedIssueId = _Undefined,
    double? geographicSimilarity,
    double? imageSimilarity,
    double? descriptionSimilarity,
    double? categorySimilarity,
    double? temporalSimilarity,
    double? combinedSimilarityScore,
    String? matchingDecision,
    Object? decisionReason = _Undefined,
    Object? reviewedBy = _Undefined,
    DateTime? createdAt,
  }) {
    return IssueMatchHistory(
      id: id is int? ? id : this.id,
      reportId: reportId ?? this.reportId,
      matchedIssueId: matchedIssueId is int?
          ? matchedIssueId
          : this.matchedIssueId,
      geographicSimilarity: geographicSimilarity ?? this.geographicSimilarity,
      imageSimilarity: imageSimilarity ?? this.imageSimilarity,
      descriptionSimilarity:
          descriptionSimilarity ?? this.descriptionSimilarity,
      categorySimilarity: categorySimilarity ?? this.categorySimilarity,
      temporalSimilarity: temporalSimilarity ?? this.temporalSimilarity,
      combinedSimilarityScore:
          combinedSimilarityScore ?? this.combinedSimilarityScore,
      matchingDecision: matchingDecision ?? this.matchingDecision,
      decisionReason: decisionReason is String?
          ? decisionReason
          : this.decisionReason,
      reviewedBy: reviewedBy is int? ? reviewedBy : this.reviewedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class IssueMatchHistoryUpdateTable
    extends _is.UpdateTable<IssueMatchHistoryTable> {
  IssueMatchHistoryUpdateTable(super.table);

  _is.ColumnValue<int, int> reportId(int value) => _is.ColumnValue(
    table.reportId,
    value,
  );

  _is.ColumnValue<int, int> matchedIssueId(int? value) => _is.ColumnValue(
    table.matchedIssueId,
    value,
  );

  _is.ColumnValue<double, double> geographicSimilarity(double value) =>
      _is.ColumnValue(
        table.geographicSimilarity,
        value,
      );

  _is.ColumnValue<double, double> imageSimilarity(double value) =>
      _is.ColumnValue(
        table.imageSimilarity,
        value,
      );

  _is.ColumnValue<double, double> descriptionSimilarity(double value) =>
      _is.ColumnValue(
        table.descriptionSimilarity,
        value,
      );

  _is.ColumnValue<double, double> categorySimilarity(double value) =>
      _is.ColumnValue(
        table.categorySimilarity,
        value,
      );

  _is.ColumnValue<double, double> temporalSimilarity(double value) =>
      _is.ColumnValue(
        table.temporalSimilarity,
        value,
      );

  _is.ColumnValue<double, double> combinedSimilarityScore(double value) =>
      _is.ColumnValue(
        table.combinedSimilarityScore,
        value,
      );

  _is.ColumnValue<String, String> matchingDecision(String value) =>
      _is.ColumnValue(
        table.matchingDecision,
        value,
      );

  _is.ColumnValue<String, String> decisionReason(String? value) =>
      _is.ColumnValue(
        table.decisionReason,
        value,
      );

  _is.ColumnValue<int, int> reviewedBy(int? value) => _is.ColumnValue(
    table.reviewedBy,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class IssueMatchHistoryTable extends _is.Table<int?> {
  IssueMatchHistoryTable({super.tableRelation})
    : super(tableName: 'issue_match_history') {
    updateTable = IssueMatchHistoryUpdateTable(this);
    reportId = _is.ColumnInt(
      'reportId',
      this,
    );
    matchedIssueId = _is.ColumnInt(
      'matchedIssueId',
      this,
    );
    geographicSimilarity = _is.ColumnDouble(
      'geographicSimilarity',
      this,
    );
    imageSimilarity = _is.ColumnDouble(
      'imageSimilarity',
      this,
    );
    descriptionSimilarity = _is.ColumnDouble(
      'descriptionSimilarity',
      this,
    );
    categorySimilarity = _is.ColumnDouble(
      'categorySimilarity',
      this,
    );
    temporalSimilarity = _is.ColumnDouble(
      'temporalSimilarity',
      this,
    );
    combinedSimilarityScore = _is.ColumnDouble(
      'combinedSimilarityScore',
      this,
    );
    matchingDecision = _is.ColumnString(
      'matchingDecision',
      this,
    );
    decisionReason = _is.ColumnString(
      'decisionReason',
      this,
    );
    reviewedBy = _is.ColumnInt(
      'reviewedBy',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final IssueMatchHistoryUpdateTable updateTable;

  late final _is.ColumnInt reportId;

  late final _is.ColumnInt matchedIssueId;

  late final _is.ColumnDouble geographicSimilarity;

  late final _is.ColumnDouble imageSimilarity;

  late final _is.ColumnDouble descriptionSimilarity;

  late final _is.ColumnDouble categorySimilarity;

  late final _is.ColumnDouble temporalSimilarity;

  late final _is.ColumnDouble combinedSimilarityScore;

  late final _is.ColumnString matchingDecision;

  late final _is.ColumnString decisionReason;

  late final _is.ColumnInt reviewedBy;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    reportId,
    matchedIssueId,
    geographicSimilarity,
    imageSimilarity,
    descriptionSimilarity,
    categorySimilarity,
    temporalSimilarity,
    combinedSimilarityScore,
    matchingDecision,
    decisionReason,
    reviewedBy,
    createdAt,
  ];
}

class IssueMatchHistoryInclude extends _is.IncludeObject {
  IssueMatchHistoryInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => IssueMatchHistory.t;
}

class IssueMatchHistoryIncludeList extends _is.IncludeList {
  IssueMatchHistoryIncludeList._({
    _is.WhereExpressionBuilder<IssueMatchHistoryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(IssueMatchHistory.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => IssueMatchHistory.t;
}

class IssueMatchHistoryRepository {
  const IssueMatchHistoryRepository._();

  /// Returns a list of [IssueMatchHistory]s matching the given query parameters.
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
  Future<List<IssueMatchHistory>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IssueMatchHistoryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IssueMatchHistoryTable>? orderBy,
    _is.OrderByListBuilder<IssueMatchHistoryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<IssueMatchHistory>(
      where: where?.call(IssueMatchHistory.t),
      orderBy: orderBy?.call(IssueMatchHistory.t),
      orderByList: orderByList?.call(IssueMatchHistory.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [IssueMatchHistory]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `IssueMatchHistory.t`.
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
  _ida.Stream<List<IssueMatchHistory>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IssueMatchHistoryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IssueMatchHistoryTable>? orderBy,
    _is.OrderByListBuilder<IssueMatchHistoryTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<IssueMatchHistory>(
      where: where?.call(IssueMatchHistory.t),
      orderBy: orderBy?.call(IssueMatchHistory.t),
      orderByList: orderByList?.call(IssueMatchHistory.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [IssueMatchHistory] matching the given query parameters.
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
  Future<IssueMatchHistory?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IssueMatchHistoryTable>? where,
    int? offset,
    _is.OrderByBuilder<IssueMatchHistoryTable>? orderBy,
    _is.OrderByListBuilder<IssueMatchHistoryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<IssueMatchHistory>(
      where: where?.call(IssueMatchHistory.t),
      orderBy: orderBy?.call(IssueMatchHistory.t),
      orderByList: orderByList?.call(IssueMatchHistory.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [IssueMatchHistory] by its [id] or null if no such row exists.
  Future<IssueMatchHistory?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<IssueMatchHistory>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [IssueMatchHistory]s in the list and returns the inserted rows.
  ///
  /// The returned [IssueMatchHistory]s will have their `id` fields set.
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
  Future<List<IssueMatchHistory>> insert(
    _is.DatabaseSession session,
    List<IssueMatchHistory> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<IssueMatchHistory>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [IssueMatchHistory] and returns the inserted row.
  ///
  /// The returned [IssueMatchHistory] will have its `id` field set.
  Future<IssueMatchHistory> insertRow(
    _is.DatabaseSession session,
    IssueMatchHistory row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<IssueMatchHistory>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [IssueMatchHistory]s in the list and returns the resulting rows.
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
  /// The returned [IssueMatchHistory]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IssueMatchHistory>> upsert(
    _is.DatabaseSession session,
    List<IssueMatchHistory> rows, {
    required _is.ColumnSelections<IssueMatchHistoryTable> conflictColumns,
    _is.ColumnSelections<IssueMatchHistoryTable>? updateColumns,
    _is.WhereExpressionBuilder<IssueMatchHistoryTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<IssueMatchHistory>(
      rows,
      conflictColumns: conflictColumns(IssueMatchHistory.t),
      updateColumns: updateColumns?.call(IssueMatchHistory.t),
      updateWhere: updateWhere?.call(IssueMatchHistory.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [IssueMatchHistory] and returns the resulting row.
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
  /// The returned [IssueMatchHistory] will have its `id` field set.
  Future<IssueMatchHistory?> upsertRow(
    _is.DatabaseSession session,
    IssueMatchHistory row, {
    required _is.ColumnSelections<IssueMatchHistoryTable> conflictColumns,
    _is.ColumnSelections<IssueMatchHistoryTable>? updateColumns,
    _is.WhereExpressionBuilder<IssueMatchHistoryTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<IssueMatchHistory>(
      row,
      conflictColumns: conflictColumns(IssueMatchHistory.t),
      updateColumns: updateColumns?.call(IssueMatchHistory.t),
      updateWhere: updateWhere?.call(IssueMatchHistory.t),
      transaction: transaction,
    );
  }

  /// Updates all [IssueMatchHistory]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IssueMatchHistory>> update(
    _is.DatabaseSession session,
    List<IssueMatchHistory> rows, {
    _is.ColumnSelections<IssueMatchHistoryTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<IssueMatchHistory>(
      rows,
      columns: columns?.call(IssueMatchHistory.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [IssueMatchHistory]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<IssueMatchHistory> updateRow(
    _is.DatabaseSession session,
    IssueMatchHistory row, {
    _is.ColumnSelections<IssueMatchHistoryTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<IssueMatchHistory>(
      row,
      columns: columns?.call(IssueMatchHistory.t),
      transaction: transaction,
    );
  }

  /// Updates a single [IssueMatchHistory] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<IssueMatchHistory?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<IssueMatchHistoryUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<IssueMatchHistory>(
      id,
      columnValues: columnValues(IssueMatchHistory.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [IssueMatchHistory]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IssueMatchHistory>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<IssueMatchHistoryUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<IssueMatchHistoryTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IssueMatchHistoryTable>? orderBy,
    _is.OrderByListBuilder<IssueMatchHistoryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<IssueMatchHistory>(
      columnValues: columnValues(IssueMatchHistory.t.updateTable),
      where: where(IssueMatchHistory.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IssueMatchHistory.t),
      orderByList: orderByList?.call(IssueMatchHistory.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [IssueMatchHistory]s in the list and returns the deleted rows.
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
  Future<List<IssueMatchHistory>> delete(
    _is.DatabaseSession session,
    List<IssueMatchHistory> rows, {
    _is.OrderByBuilder<IssueMatchHistoryTable>? orderBy,
    _is.OrderByListBuilder<IssueMatchHistoryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<IssueMatchHistory>(
      rows,
      orderBy: orderBy?.call(IssueMatchHistory.t),
      orderByList: orderByList?.call(IssueMatchHistory.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [IssueMatchHistory].
  Future<IssueMatchHistory> deleteRow(
    _is.DatabaseSession session,
    IssueMatchHistory row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<IssueMatchHistory>(
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
  Future<List<IssueMatchHistory>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<IssueMatchHistoryTable> where,
    _is.OrderByBuilder<IssueMatchHistoryTable>? orderBy,
    _is.OrderByListBuilder<IssueMatchHistoryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<IssueMatchHistory>(
      where: where(IssueMatchHistory.t),
      orderBy: orderBy?.call(IssueMatchHistory.t),
      orderByList: orderByList?.call(IssueMatchHistory.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IssueMatchHistoryTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<IssueMatchHistory>(
      where: where?.call(IssueMatchHistory.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [IssueMatchHistory] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<IssueMatchHistoryTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<IssueMatchHistory>(
      where: where(IssueMatchHistory.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
