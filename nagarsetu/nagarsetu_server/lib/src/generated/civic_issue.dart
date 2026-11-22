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

abstract class CivicIssue
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  CivicIssue._({
    this.id,
    required this.issueCode,
    required this.title,
    required this.category,
    this.descriptionSummary,
    this.locationName,
    this.address,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.priorityScore,
    required this.priorityLevel,
    this.priorityExplanation,
    required this.totalReports,
    required this.uniqueCitizens,
    this.assignedDepartmentId,
    this.assignedOfficerId,
    required this.firstReportedAt,
    required this.lastReportedAt,
    this.resolvedAt,
    required this.reopenedCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CivicIssue({
    int? id,
    required String issueCode,
    required String title,
    required String category,
    String? descriptionSummary,
    String? locationName,
    String? address,
    required double latitude,
    required double longitude,
    required String status,
    required double priorityScore,
    required String priorityLevel,
    String? priorityExplanation,
    required int totalReports,
    required int uniqueCitizens,
    int? assignedDepartmentId,
    int? assignedOfficerId,
    required DateTime firstReportedAt,
    required DateTime lastReportedAt,
    DateTime? resolvedAt,
    required int reopenedCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CivicIssueImpl;

  factory CivicIssue.fromJson(Map<String, dynamic> jsonSerialization) {
    return CivicIssue(
      id: jsonSerialization['id'] as int?,
      issueCode: jsonSerialization['issueCode'] as String,
      title: jsonSerialization['title'] as String,
      category: jsonSerialization['category'] as String,
      descriptionSummary: jsonSerialization['descriptionSummary'] as String?,
      locationName: jsonSerialization['locationName'] as String?,
      address: jsonSerialization['address'] as String?,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      status: jsonSerialization['status'] as String,
      priorityScore: (jsonSerialization['priorityScore'] as num).toDouble(),
      priorityLevel: jsonSerialization['priorityLevel'] as String,
      priorityExplanation: jsonSerialization['priorityExplanation'] as String?,
      totalReports: jsonSerialization['totalReports'] as int,
      uniqueCitizens: jsonSerialization['uniqueCitizens'] as int,
      assignedDepartmentId: jsonSerialization['assignedDepartmentId'] as int?,
      assignedOfficerId: jsonSerialization['assignedOfficerId'] as int?,
      firstReportedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['firstReportedAt'],
      ),
      lastReportedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastReportedAt'],
      ),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['resolvedAt']),
      reopenedCount: jsonSerialization['reopenedCount'] as int,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = CivicIssueTable();

  static const db = CivicIssueRepository._();

  @override
  int? id;

  String issueCode;

  String title;

  String category;

  String? descriptionSummary;

  String? locationName;

  String? address;

  double latitude;

  double longitude;

  String status;

  double priorityScore;

  String priorityLevel;

  String? priorityExplanation;

  int totalReports;

  int uniqueCitizens;

  int? assignedDepartmentId;

  int? assignedOfficerId;

  DateTime firstReportedAt;

  DateTime lastReportedAt;

  DateTime? resolvedAt;

  int reopenedCount;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CivicIssue]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CivicIssue copyWith({
    int? id,
    String? issueCode,
    String? title,
    String? category,
    String? descriptionSummary,
    String? locationName,
    String? address,
    double? latitude,
    double? longitude,
    String? status,
    double? priorityScore,
    String? priorityLevel,
    String? priorityExplanation,
    int? totalReports,
    int? uniqueCitizens,
    int? assignedDepartmentId,
    int? assignedOfficerId,
    DateTime? firstReportedAt,
    DateTime? lastReportedAt,
    DateTime? resolvedAt = const _is.$UndefinedDateTime(),
    int? reopenedCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CivicIssue',
      if (id != null) 'id': id,
      'issueCode': issueCode,
      'title': title,
      'category': category,
      if (descriptionSummary != null) 'descriptionSummary': descriptionSummary,
      if (locationName != null) 'locationName': locationName,
      if (address != null) 'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'priorityScore': priorityScore,
      'priorityLevel': priorityLevel,
      if (priorityExplanation != null)
        'priorityExplanation': priorityExplanation,
      'totalReports': totalReports,
      'uniqueCitizens': uniqueCitizens,
      if (assignedDepartmentId != null)
        'assignedDepartmentId': assignedDepartmentId,
      if (assignedOfficerId != null) 'assignedOfficerId': assignedOfficerId,
      'firstReportedAt': firstReportedAt.toJson(),
      'lastReportedAt': lastReportedAt.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      'reopenedCount': reopenedCount,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CivicIssue',
      if (id != null) 'id': id,
      'issueCode': issueCode,
      'title': title,
      'category': category,
      if (descriptionSummary != null) 'descriptionSummary': descriptionSummary,
      if (locationName != null) 'locationName': locationName,
      if (address != null) 'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'priorityScore': priorityScore,
      'priorityLevel': priorityLevel,
      if (priorityExplanation != null)
        'priorityExplanation': priorityExplanation,
      'totalReports': totalReports,
      'uniqueCitizens': uniqueCitizens,
      if (assignedDepartmentId != null)
        'assignedDepartmentId': assignedDepartmentId,
      if (assignedOfficerId != null) 'assignedOfficerId': assignedOfficerId,
      'firstReportedAt': firstReportedAt.toJson(),
      'lastReportedAt': lastReportedAt.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      'reopenedCount': reopenedCount,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static CivicIssueInclude include() {
    return CivicIssueInclude._();
  }

  static CivicIssueIncludeList includeList({
    _is.WhereExpressionBuilder<CivicIssueTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CivicIssueTable>? orderBy,
    _is.OrderByListBuilder<CivicIssueTable>? orderByList,
    CivicIssueInclude? include,
  }) {
    return CivicIssueIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CivicIssue.t),
      orderByList: orderByList?.call(CivicIssue.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CivicIssueImpl extends CivicIssue {
  _CivicIssueImpl({
    int? id,
    required String issueCode,
    required String title,
    required String category,
    String? descriptionSummary,
    String? locationName,
    String? address,
    required double latitude,
    required double longitude,
    required String status,
    required double priorityScore,
    required String priorityLevel,
    String? priorityExplanation,
    required int totalReports,
    required int uniqueCitizens,
    int? assignedDepartmentId,
    int? assignedOfficerId,
    required DateTime firstReportedAt,
    required DateTime lastReportedAt,
    DateTime? resolvedAt,
    required int reopenedCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         issueCode: issueCode,
         title: title,
         category: category,
         descriptionSummary: descriptionSummary,
         locationName: locationName,
         address: address,
         latitude: latitude,
         longitude: longitude,
         status: status,
         priorityScore: priorityScore,
         priorityLevel: priorityLevel,
         priorityExplanation: priorityExplanation,
         totalReports: totalReports,
         uniqueCitizens: uniqueCitizens,
         assignedDepartmentId: assignedDepartmentId,
         assignedOfficerId: assignedOfficerId,
         firstReportedAt: firstReportedAt,
         lastReportedAt: lastReportedAt,
         resolvedAt: resolvedAt,
         reopenedCount: reopenedCount,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CivicIssue]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CivicIssue copyWith({
    Object? id = _Undefined,
    String? issueCode,
    String? title,
    String? category,
    Object? descriptionSummary = _Undefined,
    Object? locationName = _Undefined,
    Object? address = _Undefined,
    double? latitude,
    double? longitude,
    String? status,
    double? priorityScore,
    String? priorityLevel,
    Object? priorityExplanation = _Undefined,
    int? totalReports,
    int? uniqueCitizens,
    Object? assignedDepartmentId = _Undefined,
    Object? assignedOfficerId = _Undefined,
    DateTime? firstReportedAt,
    DateTime? lastReportedAt,
    DateTime? resolvedAt = const _is.$UndefinedDateTime(),
    int? reopenedCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CivicIssue(
      id: id is int? ? id : this.id,
      issueCode: issueCode ?? this.issueCode,
      title: title ?? this.title,
      category: category ?? this.category,
      descriptionSummary: descriptionSummary is String?
          ? descriptionSummary
          : this.descriptionSummary,
      locationName: locationName is String? ? locationName : this.locationName,
      address: address is String? ? address : this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      priorityScore: priorityScore ?? this.priorityScore,
      priorityLevel: priorityLevel ?? this.priorityLevel,
      priorityExplanation: priorityExplanation is String?
          ? priorityExplanation
          : this.priorityExplanation,
      totalReports: totalReports ?? this.totalReports,
      uniqueCitizens: uniqueCitizens ?? this.uniqueCitizens,
      assignedDepartmentId: assignedDepartmentId is int?
          ? assignedDepartmentId
          : this.assignedDepartmentId,
      assignedOfficerId: assignedOfficerId is int?
          ? assignedOfficerId
          : this.assignedOfficerId,
      firstReportedAt: firstReportedAt ?? this.firstReportedAt,
      lastReportedAt: lastReportedAt ?? this.lastReportedAt,
      resolvedAt: resolvedAt is _is.UndefinedSentinel
          ? this.resolvedAt
          : resolvedAt,
      reopenedCount: reopenedCount ?? this.reopenedCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CivicIssueUpdateTable extends _is.UpdateTable<CivicIssueTable> {
  CivicIssueUpdateTable(super.table);

  _is.ColumnValue<String, String> issueCode(String value) => _is.ColumnValue(
    table.issueCode,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> category(String value) => _is.ColumnValue(
    table.category,
    value,
  );

  _is.ColumnValue<String, String> descriptionSummary(String? value) =>
      _is.ColumnValue(
        table.descriptionSummary,
        value,
      );

  _is.ColumnValue<String, String> locationName(String? value) =>
      _is.ColumnValue(
        table.locationName,
        value,
      );

  _is.ColumnValue<String, String> address(String? value) => _is.ColumnValue(
    table.address,
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

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<double, double> priorityScore(double value) =>
      _is.ColumnValue(
        table.priorityScore,
        value,
      );

  _is.ColumnValue<String, String> priorityLevel(String value) =>
      _is.ColumnValue(
        table.priorityLevel,
        value,
      );

  _is.ColumnValue<String, String> priorityExplanation(String? value) =>
      _is.ColumnValue(
        table.priorityExplanation,
        value,
      );

  _is.ColumnValue<int, int> totalReports(int value) => _is.ColumnValue(
    table.totalReports,
    value,
  );

  _is.ColumnValue<int, int> uniqueCitizens(int value) => _is.ColumnValue(
    table.uniqueCitizens,
    value,
  );

  _is.ColumnValue<int, int> assignedDepartmentId(int? value) => _is.ColumnValue(
    table.assignedDepartmentId,
    value,
  );

  _is.ColumnValue<int, int> assignedOfficerId(int? value) => _is.ColumnValue(
    table.assignedOfficerId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> firstReportedAt(DateTime value) =>
      _is.ColumnValue(
        table.firstReportedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastReportedAt(DateTime value) =>
      _is.ColumnValue(
        table.lastReportedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> resolvedAt(DateTime? value) =>
      _is.ColumnValue(
        table.resolvedAt,
        value,
      );

  _is.ColumnValue<int, int> reopenedCount(int value) => _is.ColumnValue(
    table.reopenedCount,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class CivicIssueTable extends _is.Table<int?> {
  CivicIssueTable({super.tableRelation}) : super(tableName: 'civic_issues') {
    updateTable = CivicIssueUpdateTable(this);
    issueCode = _is.ColumnString(
      'issueCode',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    category = _is.ColumnString(
      'category',
      this,
    );
    descriptionSummary = _is.ColumnString(
      'descriptionSummary',
      this,
    );
    locationName = _is.ColumnString(
      'locationName',
      this,
    );
    address = _is.ColumnString(
      'address',
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
    status = _is.ColumnString(
      'status',
      this,
    );
    priorityScore = _is.ColumnDouble(
      'priorityScore',
      this,
    );
    priorityLevel = _is.ColumnString(
      'priorityLevel',
      this,
    );
    priorityExplanation = _is.ColumnString(
      'priorityExplanation',
      this,
    );
    totalReports = _is.ColumnInt(
      'totalReports',
      this,
    );
    uniqueCitizens = _is.ColumnInt(
      'uniqueCitizens',
      this,
    );
    assignedDepartmentId = _is.ColumnInt(
      'assignedDepartmentId',
      this,
    );
    assignedOfficerId = _is.ColumnInt(
      'assignedOfficerId',
      this,
    );
    firstReportedAt = _is.ColumnDateTime(
      'firstReportedAt',
      this,
    );
    lastReportedAt = _is.ColumnDateTime(
      'lastReportedAt',
      this,
    );
    resolvedAt = _is.ColumnDateTime(
      'resolvedAt',
      this,
    );
    reopenedCount = _is.ColumnInt(
      'reopenedCount',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final CivicIssueUpdateTable updateTable;

  late final _is.ColumnString issueCode;

  late final _is.ColumnString title;

  late final _is.ColumnString category;

  late final _is.ColumnString descriptionSummary;

  late final _is.ColumnString locationName;

  late final _is.ColumnString address;

  late final _is.ColumnDouble latitude;

  late final _is.ColumnDouble longitude;

  late final _is.ColumnString status;

  late final _is.ColumnDouble priorityScore;

  late final _is.ColumnString priorityLevel;

  late final _is.ColumnString priorityExplanation;

  late final _is.ColumnInt totalReports;

  late final _is.ColumnInt uniqueCitizens;

  late final _is.ColumnInt assignedDepartmentId;

  late final _is.ColumnInt assignedOfficerId;

  late final _is.ColumnDateTime firstReportedAt;

  late final _is.ColumnDateTime lastReportedAt;

  late final _is.ColumnDateTime resolvedAt;

  late final _is.ColumnInt reopenedCount;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    issueCode,
    title,
    category,
    descriptionSummary,
    locationName,
    address,
    latitude,
    longitude,
    status,
    priorityScore,
    priorityLevel,
    priorityExplanation,
    totalReports,
    uniqueCitizens,
    assignedDepartmentId,
    assignedOfficerId,
    firstReportedAt,
    lastReportedAt,
    resolvedAt,
    reopenedCount,
    createdAt,
    updatedAt,
  ];
}

class CivicIssueInclude extends _is.IncludeObject {
  CivicIssueInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => CivicIssue.t;
}

class CivicIssueIncludeList extends _is.IncludeList {
  CivicIssueIncludeList._({
    _is.WhereExpressionBuilder<CivicIssueTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CivicIssue.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CivicIssue.t;
}

class CivicIssueRepository {
  const CivicIssueRepository._();

  /// Returns a list of [CivicIssue]s matching the given query parameters.
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
  Future<List<CivicIssue>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CivicIssueTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CivicIssueTable>? orderBy,
    _is.OrderByListBuilder<CivicIssueTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CivicIssue>(
      where: where?.call(CivicIssue.t),
      orderBy: orderBy?.call(CivicIssue.t),
      orderByList: orderByList?.call(CivicIssue.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [CivicIssue]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `CivicIssue.t`.
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
  _ida.Stream<List<CivicIssue>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CivicIssueTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CivicIssueTable>? orderBy,
    _is.OrderByListBuilder<CivicIssueTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<CivicIssue>(
      where: where?.call(CivicIssue.t),
      orderBy: orderBy?.call(CivicIssue.t),
      orderByList: orderByList?.call(CivicIssue.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [CivicIssue] matching the given query parameters.
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
  Future<CivicIssue?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CivicIssueTable>? where,
    int? offset,
    _is.OrderByBuilder<CivicIssueTable>? orderBy,
    _is.OrderByListBuilder<CivicIssueTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CivicIssue>(
      where: where?.call(CivicIssue.t),
      orderBy: orderBy?.call(CivicIssue.t),
      orderByList: orderByList?.call(CivicIssue.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CivicIssue] by its [id] or null if no such row exists.
  Future<CivicIssue?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CivicIssue>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CivicIssue]s in the list and returns the inserted rows.
  ///
  /// The returned [CivicIssue]s will have their `id` fields set.
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
  Future<List<CivicIssue>> insert(
    _is.DatabaseSession session,
    List<CivicIssue> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CivicIssue>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CivicIssue] and returns the inserted row.
  ///
  /// The returned [CivicIssue] will have its `id` field set.
  Future<CivicIssue> insertRow(
    _is.DatabaseSession session,
    CivicIssue row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CivicIssue>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CivicIssue]s in the list and returns the resulting rows.
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
  /// The returned [CivicIssue]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CivicIssue>> upsert(
    _is.DatabaseSession session,
    List<CivicIssue> rows, {
    required _is.ColumnSelections<CivicIssueTable> conflictColumns,
    _is.ColumnSelections<CivicIssueTable>? updateColumns,
    _is.WhereExpressionBuilder<CivicIssueTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CivicIssue>(
      rows,
      conflictColumns: conflictColumns(CivicIssue.t),
      updateColumns: updateColumns?.call(CivicIssue.t),
      updateWhere: updateWhere?.call(CivicIssue.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CivicIssue] and returns the resulting row.
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
  /// The returned [CivicIssue] will have its `id` field set.
  Future<CivicIssue?> upsertRow(
    _is.DatabaseSession session,
    CivicIssue row, {
    required _is.ColumnSelections<CivicIssueTable> conflictColumns,
    _is.ColumnSelections<CivicIssueTable>? updateColumns,
    _is.WhereExpressionBuilder<CivicIssueTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CivicIssue>(
      row,
      conflictColumns: conflictColumns(CivicIssue.t),
      updateColumns: updateColumns?.call(CivicIssue.t),
      updateWhere: updateWhere?.call(CivicIssue.t),
      transaction: transaction,
    );
  }

  /// Updates all [CivicIssue]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CivicIssue>> update(
    _is.DatabaseSession session,
    List<CivicIssue> rows, {
    _is.ColumnSelections<CivicIssueTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CivicIssue>(
      rows,
      columns: columns?.call(CivicIssue.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CivicIssue]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CivicIssue> updateRow(
    _is.DatabaseSession session,
    CivicIssue row, {
    _is.ColumnSelections<CivicIssueTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CivicIssue>(
      row,
      columns: columns?.call(CivicIssue.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CivicIssue] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CivicIssue?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CivicIssueUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CivicIssue>(
      id,
      columnValues: columnValues(CivicIssue.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CivicIssue]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CivicIssue>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CivicIssueUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CivicIssueTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CivicIssueTable>? orderBy,
    _is.OrderByListBuilder<CivicIssueTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CivicIssue>(
      columnValues: columnValues(CivicIssue.t.updateTable),
      where: where(CivicIssue.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CivicIssue.t),
      orderByList: orderByList?.call(CivicIssue.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CivicIssue]s in the list and returns the deleted rows.
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
  Future<List<CivicIssue>> delete(
    _is.DatabaseSession session,
    List<CivicIssue> rows, {
    _is.OrderByBuilder<CivicIssueTable>? orderBy,
    _is.OrderByListBuilder<CivicIssueTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CivicIssue>(
      rows,
      orderBy: orderBy?.call(CivicIssue.t),
      orderByList: orderByList?.call(CivicIssue.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CivicIssue].
  Future<CivicIssue> deleteRow(
    _is.DatabaseSession session,
    CivicIssue row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CivicIssue>(
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
  Future<List<CivicIssue>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CivicIssueTable> where,
    _is.OrderByBuilder<CivicIssueTable>? orderBy,
    _is.OrderByListBuilder<CivicIssueTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CivicIssue>(
      where: where(CivicIssue.t),
      orderBy: orderBy?.call(CivicIssue.t),
      orderByList: orderByList?.call(CivicIssue.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CivicIssueTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CivicIssue>(
      where: where?.call(CivicIssue.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CivicIssue] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CivicIssueTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CivicIssue>(
      where: where(CivicIssue.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
