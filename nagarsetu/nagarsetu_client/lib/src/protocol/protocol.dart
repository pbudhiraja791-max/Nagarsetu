/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:nagarsetu_client/src/protocol/audit_log.dart' as _izug5nan;
import 'package:nagarsetu_client/src/protocol/citizen_report.dart' as _i5pm6t6a;
import 'package:nagarsetu_client/src/protocol/civic_issue.dart' as _it3kcvzu;
import 'package:nagarsetu_client/src/protocol/issue_timeline_item.dart'
    as _igl4iy3c;
import 'package:nagarsetu_client/src/protocol/place.dart' as _idf5iruj;
import 'package:nagarsetu_client/src/protocol/story.dart' as _iel4wtun;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'api_response.dart' as _ivocdqwh;
import 'audit_log.dart' as _itixckla;
import 'citizen_report.dart' as _io13seno;
import 'citizen_verification.dart' as _i8rthojw;
import 'civic_issue.dart' as _iajwbfgj;
import 'dashboard_analytics.dart' as _ichko28z;
import 'department.dart' as _i30690kx;
import 'duplicate_check_result.dart' as _ieh0bqys;
import 'greetings/greeting.dart' as _izw8z7ou;
import 'issue_assignment.dart' as _i306qart;
import 'issue_match_history.dart' as _imehol3d;
import 'issue_timeline_item.dart' as _i1vdg1b2;
import 'notification.dart' as _irt10kca;
import 'officer.dart' as _i8p143l9;
import 'place.dart' as _isaqapjx;
import 'priority_calculation_result.dart' as _i76gkble;
import 'report_count_history.dart' as _is5fg8iw;
import 'resolution_record.dart' as _inzhlssr;
import 'story.dart' as _ixuwv6na;
import 'submit_report_response.dart' as _ioo0pzq9;
import 'user.dart' as _iv73i78m;
export 'api_response.dart';
export 'audit_log.dart';
export 'citizen_report.dart';
export 'citizen_verification.dart';
export 'civic_issue.dart';
export 'dashboard_analytics.dart';
export 'department.dart';
export 'duplicate_check_result.dart';
export 'greetings/greeting.dart';
export 'issue_assignment.dart';
export 'issue_match_history.dart';
export 'issue_timeline_item.dart';
export 'notification.dart';
export 'officer.dart';
export 'place.dart';
export 'priority_calculation_result.dart';
export 'report_count_history.dart';
export 'resolution_record.dart';
export 'story.dart';
export 'submit_report_response.dart';
export 'user.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager
    implements _isc.ProtocolDeserializationProvider {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  @override
  _isc.ProtocolDeserialization get deserializationMetadata =>
      _isc.ProtocolDeserialization.cached(
        this,
        types: const [
          _isc.getType<_ivocdqwh.ApiResponse>,
          _isc.getType<_itixckla.AuditLog>,
          _isc.getType<_io13seno.CitizenReport>,
          _isc.getType<_i8rthojw.CitizenVerification>,
          _isc.getType<_iajwbfgj.CivicIssue>,
          _isc.getType<_ichko28z.DashboardAnalytics>,
          _isc.getType<_i30690kx.Department>,
          _isc.getType<_ieh0bqys.DuplicateCheckResult>,
          _isc.getType<_izw8z7ou.Greeting>,
          _isc.getType<_i306qart.IssueAssignment>,
          _isc.getType<_imehol3d.IssueMatchHistory>,
          _isc.getType<_i1vdg1b2.IssueTimelineItem>,
          _isc.getType<_irt10kca.Notification>,
          _isc.getType<_i8p143l9.Officer>,
          _isc.getType<_isaqapjx.Place>,
          _isc.getType<_i76gkble.PriorityCalculationResult>,
          _isc.getType<_is5fg8iw.ReportCountHistory>,
          _isc.getType<_inzhlssr.ResolutionRecord>,
          _isc.getType<_ixuwv6na.Story>,
          _isc.getType<_ioo0pzq9.SubmitReportResponse>,
          _isc.getType<_iv73i78m.User>,
          _isc.getType<_ivocdqwh.ApiResponse?>,
          _isc.getType<_itixckla.AuditLog?>,
          _isc.getType<_io13seno.CitizenReport?>,
          _isc.getType<_i8rthojw.CitizenVerification?>,
          _isc.getType<_iajwbfgj.CivicIssue?>,
          _isc.getType<_ichko28z.DashboardAnalytics?>,
          _isc.getType<_i30690kx.Department?>,
          _isc.getType<_ieh0bqys.DuplicateCheckResult?>,
          _isc.getType<_izw8z7ou.Greeting?>,
          _isc.getType<_i306qart.IssueAssignment?>,
          _isc.getType<_imehol3d.IssueMatchHistory?>,
          _isc.getType<_i1vdg1b2.IssueTimelineItem?>,
          _isc.getType<_irt10kca.Notification?>,
          _isc.getType<_i8p143l9.Officer?>,
          _isc.getType<_isaqapjx.Place?>,
          _isc.getType<_i76gkble.PriorityCalculationResult?>,
          _isc.getType<_is5fg8iw.ReportCountHistory?>,
          _isc.getType<_inzhlssr.ResolutionRecord?>,
          _isc.getType<_ixuwv6na.Story?>,
          _isc.getType<_ioo0pzq9.SubmitReportResponse?>,
          _isc.getType<_iv73i78m.User?>,
          _isc.getType<List<_i5pm6t6a.CitizenReport>>,
          _isc.getType<List<_izug5nan.AuditLog>>,
          _isc.getType<List<_it3kcvzu.CivicIssue>>,
          _isc.getType<List<_igl4iy3c.IssueTimelineItem>>,
          _isc.getType<List<_idf5iruj.Place>>,
          _isc.getType<List<_iel4wtun.Story>>,
        ],
        modules: const [
          _iaic.Protocol.new,
          _iacc.Protocol.new,
        ],
        classNames: const [
          'ApiResponse',
          'AuditLog',
          'CitizenReport',
          'CitizenVerification',
          'CivicIssue',
          'DashboardAnalytics',
          'Department',
          'DuplicateCheckResult',
          'Greeting',
          'IssueAssignment',
          'IssueMatchHistory',
          'IssueTimelineItem',
          'Notification',
          'Officer',
          'Place',
          'PriorityCalculationResult',
          'ReportCountHistory',
          'ResolutionRecord',
          'Story',
          'SubmitReportResponse',
          'User',
        ],
      );

  static String? getClassNameFromObjectJson(dynamic data) =>
      _isc.ProtocolDeserialization.readClassName(data);

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    final rawDataClassName = _isc.ProtocolDeserialization.readClassName(data);
    final dataClassName = rawDataClassName;
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _ivocdqwh.ApiResponse) {
      return _ivocdqwh.ApiResponse.fromJson(data) as T;
    }
    if (t == _itixckla.AuditLog) {
      return _itixckla.AuditLog.fromJson(data) as T;
    }
    if (t == _io13seno.CitizenReport) {
      return _io13seno.CitizenReport.fromJson(data) as T;
    }
    if (t == _i8rthojw.CitizenVerification) {
      return _i8rthojw.CitizenVerification.fromJson(data) as T;
    }
    if (t == _iajwbfgj.CivicIssue) {
      return _iajwbfgj.CivicIssue.fromJson(data) as T;
    }
    if (t == _ichko28z.DashboardAnalytics) {
      return _ichko28z.DashboardAnalytics.fromJson(data) as T;
    }
    if (t == _i30690kx.Department) {
      return _i30690kx.Department.fromJson(data) as T;
    }
    if (t == _ieh0bqys.DuplicateCheckResult) {
      return _ieh0bqys.DuplicateCheckResult.fromJson(data) as T;
    }
    if (t == _izw8z7ou.Greeting) {
      return _izw8z7ou.Greeting.fromJson(data) as T;
    }
    if (t == _i306qart.IssueAssignment) {
      return _i306qart.IssueAssignment.fromJson(data) as T;
    }
    if (t == _imehol3d.IssueMatchHistory) {
      return _imehol3d.IssueMatchHistory.fromJson(data) as T;
    }
    if (t == _i1vdg1b2.IssueTimelineItem) {
      return _i1vdg1b2.IssueTimelineItem.fromJson(data) as T;
    }
    if (t == _irt10kca.Notification) {
      return _irt10kca.Notification.fromJson(data) as T;
    }
    if (t == _i8p143l9.Officer) {
      return _i8p143l9.Officer.fromJson(data) as T;
    }
    if (t == _isaqapjx.Place) {
      return _isaqapjx.Place.fromJson(data) as T;
    }
    if (t == _i76gkble.PriorityCalculationResult) {
      return _i76gkble.PriorityCalculationResult.fromJson(data) as T;
    }
    if (t == _is5fg8iw.ReportCountHistory) {
      return _is5fg8iw.ReportCountHistory.fromJson(data) as T;
    }
    if (t == _inzhlssr.ResolutionRecord) {
      return _inzhlssr.ResolutionRecord.fromJson(data) as T;
    }
    if (t == _ixuwv6na.Story) {
      return _ixuwv6na.Story.fromJson(data) as T;
    }
    if (t == _ioo0pzq9.SubmitReportResponse) {
      return _ioo0pzq9.SubmitReportResponse.fromJson(data) as T;
    }
    if (t == _iv73i78m.User) {
      return _iv73i78m.User.fromJson(data) as T;
    }
    if (t == _isc.getType<_ivocdqwh.ApiResponse?>()) {
      return (data != null ? _ivocdqwh.ApiResponse.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_itixckla.AuditLog?>()) {
      return (data != null ? _itixckla.AuditLog.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_io13seno.CitizenReport?>()) {
      return (data != null ? _io13seno.CitizenReport.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i8rthojw.CitizenVerification?>()) {
      return (data != null
              ? _i8rthojw.CitizenVerification.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iajwbfgj.CivicIssue?>()) {
      return (data != null ? _iajwbfgj.CivicIssue.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ichko28z.DashboardAnalytics?>()) {
      return (data != null ? _ichko28z.DashboardAnalytics.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i30690kx.Department?>()) {
      return (data != null ? _i30690kx.Department.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ieh0bqys.DuplicateCheckResult?>()) {
      return (data != null
              ? _ieh0bqys.DuplicateCheckResult.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i306qart.IssueAssignment?>()) {
      return (data != null ? _i306qart.IssueAssignment.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_imehol3d.IssueMatchHistory?>()) {
      return (data != null ? _imehol3d.IssueMatchHistory.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i1vdg1b2.IssueTimelineItem?>()) {
      return (data != null ? _i1vdg1b2.IssueTimelineItem.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_irt10kca.Notification?>()) {
      return (data != null ? _irt10kca.Notification.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i8p143l9.Officer?>()) {
      return (data != null ? _i8p143l9.Officer.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_isaqapjx.Place?>()) {
      return (data != null ? _isaqapjx.Place.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i76gkble.PriorityCalculationResult?>()) {
      return (data != null
              ? _i76gkble.PriorityCalculationResult.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_is5fg8iw.ReportCountHistory?>()) {
      return (data != null ? _is5fg8iw.ReportCountHistory.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_inzhlssr.ResolutionRecord?>()) {
      return (data != null ? _inzhlssr.ResolutionRecord.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ixuwv6na.Story?>()) {
      return (data != null ? _ixuwv6na.Story.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ioo0pzq9.SubmitReportResponse?>()) {
      return (data != null
              ? _ioo0pzq9.SubmitReportResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iv73i78m.User?>()) {
      return (data != null ? _iv73i78m.User.fromJson(data) : null) as T;
    }
    if (t == List<_i5pm6t6a.CitizenReport>) {
      return (data as List)
              .map((e) => deserialize<_i5pm6t6a.CitizenReport>(e))
              .toList()
          as T;
    }
    if (t == List<_izug5nan.AuditLog>) {
      return (data as List)
              .map((e) => deserialize<_izug5nan.AuditLog>(e))
              .toList()
          as T;
    }
    if (t == List<_it3kcvzu.CivicIssue>) {
      return (data as List)
              .map((e) => deserialize<_it3kcvzu.CivicIssue>(e))
              .toList()
          as T;
    }
    if (t == List<_igl4iy3c.IssueTimelineItem>) {
      return (data as List)
              .map((e) => deserialize<_igl4iy3c.IssueTimelineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_idf5iruj.Place>) {
      return (data as List).map((e) => deserialize<_idf5iruj.Place>(e)).toList()
          as T;
    }
    if (t == List<_iel4wtun.Story>) {
      return (data as List).map((e) => deserialize<_iel4wtun.Story>(e)).toList()
          as T;
    }
    final modules = deserializationMetadata.modulesForDeserialization(
      t,
      className: rawDataClassName,
    );
    for (final module in modules) {
      try {
        return module.deserialize<T>(data, t);
      } on _isc.DeserializationTypeNotFoundException catch (_) {}
    }

    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ivocdqwh.ApiResponse => 'ApiResponse',
      _itixckla.AuditLog => 'AuditLog',
      _io13seno.CitizenReport => 'CitizenReport',
      _i8rthojw.CitizenVerification => 'CitizenVerification',
      _iajwbfgj.CivicIssue => 'CivicIssue',
      _ichko28z.DashboardAnalytics => 'DashboardAnalytics',
      _i30690kx.Department => 'Department',
      _ieh0bqys.DuplicateCheckResult => 'DuplicateCheckResult',
      _izw8z7ou.Greeting => 'Greeting',
      _i306qart.IssueAssignment => 'IssueAssignment',
      _imehol3d.IssueMatchHistory => 'IssueMatchHistory',
      _i1vdg1b2.IssueTimelineItem => 'IssueTimelineItem',
      _irt10kca.Notification => 'Notification',
      _i8p143l9.Officer => 'Officer',
      _isaqapjx.Place => 'Place',
      _i76gkble.PriorityCalculationResult => 'PriorityCalculationResult',
      _is5fg8iw.ReportCountHistory => 'ReportCountHistory',
      _inzhlssr.ResolutionRecord => 'ResolutionRecord',
      _ixuwv6na.Story => 'Story',
      _ioo0pzq9.SubmitReportResponse => 'SubmitReportResponse',
      _iv73i78m.User => 'User',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('nagarsetu.', '');
    }

    switch (data) {
      case _ivocdqwh.ApiResponse():
        return 'ApiResponse';
      case _itixckla.AuditLog():
        return 'AuditLog';
      case _io13seno.CitizenReport():
        return 'CitizenReport';
      case _i8rthojw.CitizenVerification():
        return 'CitizenVerification';
      case _iajwbfgj.CivicIssue():
        return 'CivicIssue';
      case _ichko28z.DashboardAnalytics():
        return 'DashboardAnalytics';
      case _i30690kx.Department():
        return 'Department';
      case _ieh0bqys.DuplicateCheckResult():
        return 'DuplicateCheckResult';
      case _izw8z7ou.Greeting():
        return 'Greeting';
      case _i306qart.IssueAssignment():
        return 'IssueAssignment';
      case _imehol3d.IssueMatchHistory():
        return 'IssueMatchHistory';
      case _i1vdg1b2.IssueTimelineItem():
        return 'IssueTimelineItem';
      case _irt10kca.Notification():
        return 'Notification';
      case _i8p143l9.Officer():
        return 'Officer';
      case _isaqapjx.Place():
        return 'Place';
      case _i76gkble.PriorityCalculationResult():
        return 'PriorityCalculationResult';
      case _is5fg8iw.ReportCountHistory():
        return 'ReportCountHistory';
      case _inzhlssr.ResolutionRecord():
        return 'ResolutionRecord';
      case _ixuwv6na.Story():
        return 'Story';
      case _ioo0pzq9.SubmitReportResponse():
        return 'SubmitReportResponse';
      case _iv73i78m.User():
        return 'User';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'ApiResponse') {
      return deserialize<_ivocdqwh.ApiResponse>(data['data']);
    }
    if (dataClassName == 'AuditLog') {
      return deserialize<_itixckla.AuditLog>(data['data']);
    }
    if (dataClassName == 'CitizenReport') {
      return deserialize<_io13seno.CitizenReport>(data['data']);
    }
    if (dataClassName == 'CitizenVerification') {
      return deserialize<_i8rthojw.CitizenVerification>(data['data']);
    }
    if (dataClassName == 'CivicIssue') {
      return deserialize<_iajwbfgj.CivicIssue>(data['data']);
    }
    if (dataClassName == 'DashboardAnalytics') {
      return deserialize<_ichko28z.DashboardAnalytics>(data['data']);
    }
    if (dataClassName == 'Department') {
      return deserialize<_i30690kx.Department>(data['data']);
    }
    if (dataClassName == 'DuplicateCheckResult') {
      return deserialize<_ieh0bqys.DuplicateCheckResult>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_izw8z7ou.Greeting>(data['data']);
    }
    if (dataClassName == 'IssueAssignment') {
      return deserialize<_i306qart.IssueAssignment>(data['data']);
    }
    if (dataClassName == 'IssueMatchHistory') {
      return deserialize<_imehol3d.IssueMatchHistory>(data['data']);
    }
    if (dataClassName == 'IssueTimelineItem') {
      return deserialize<_i1vdg1b2.IssueTimelineItem>(data['data']);
    }
    if (dataClassName == 'Notification') {
      return deserialize<_irt10kca.Notification>(data['data']);
    }
    if (dataClassName == 'Officer') {
      return deserialize<_i8p143l9.Officer>(data['data']);
    }
    if (dataClassName == 'Place') {
      return deserialize<_isaqapjx.Place>(data['data']);
    }
    if (dataClassName == 'PriorityCalculationResult') {
      return deserialize<_i76gkble.PriorityCalculationResult>(data['data']);
    }
    if (dataClassName == 'ReportCountHistory') {
      return deserialize<_is5fg8iw.ReportCountHistory>(data['data']);
    }
    if (dataClassName == 'ResolutionRecord') {
      return deserialize<_inzhlssr.ResolutionRecord>(data['data']);
    }
    if (dataClassName == 'Story') {
      return deserialize<_ixuwv6na.Story>(data['data']);
    }
    if (dataClassName == 'SubmitReportResponse') {
      return deserialize<_ioo0pzq9.SubmitReportResponse>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_iv73i78m.User>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      return _iaic.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(19),
      });
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      return _iacc.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(20),
      });
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('nagarsetu', this);
    _iacc.Protocol().registerHostProtocol('nagarsetu', this);
  }

  @override
  String getModuleName() => 'nagarsetu';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
