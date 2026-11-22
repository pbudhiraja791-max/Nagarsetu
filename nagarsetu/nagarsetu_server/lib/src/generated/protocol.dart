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
import 'package:nagarsetu_server/src/generated/audit_log.dart' as _ix0rezvy;
import 'package:nagarsetu_server/src/generated/citizen_report.dart'
    as _i7pac1a4;
import 'package:nagarsetu_server/src/generated/civic_issue.dart' as _itl2lvhp;
import 'package:nagarsetu_server/src/generated/issue_timeline_item.dart'
    as _iuzl316s;
import 'package:nagarsetu_server/src/generated/place.dart' as _iaj5r3oi;
import 'package:nagarsetu_server/src/generated/story.dart' as _ik4h1j5x;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
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

class Protocol extends _is.DatabaseSerializationManager
    implements _is.DatabaseProtocolDeserializationProvider {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  @override
  _is.ProtocolDeserialization get deserializationMetadata =>
      _is.ProtocolDeserialization.cached(
        this,
        types: const [
          _is.getType<_ivocdqwh.ApiResponse>,
          _is.getType<_itixckla.AuditLog>,
          _is.getType<_io13seno.CitizenReport>,
          _is.getType<_i8rthojw.CitizenVerification>,
          _is.getType<_iajwbfgj.CivicIssue>,
          _is.getType<_ichko28z.DashboardAnalytics>,
          _is.getType<_i30690kx.Department>,
          _is.getType<_ieh0bqys.DuplicateCheckResult>,
          _is.getType<_izw8z7ou.Greeting>,
          _is.getType<_i306qart.IssueAssignment>,
          _is.getType<_imehol3d.IssueMatchHistory>,
          _is.getType<_i1vdg1b2.IssueTimelineItem>,
          _is.getType<_irt10kca.Notification>,
          _is.getType<_i8p143l9.Officer>,
          _is.getType<_isaqapjx.Place>,
          _is.getType<_i76gkble.PriorityCalculationResult>,
          _is.getType<_is5fg8iw.ReportCountHistory>,
          _is.getType<_inzhlssr.ResolutionRecord>,
          _is.getType<_ixuwv6na.Story>,
          _is.getType<_ioo0pzq9.SubmitReportResponse>,
          _is.getType<_iv73i78m.User>,
          _is.getType<_ivocdqwh.ApiResponse?>,
          _is.getType<_itixckla.AuditLog?>,
          _is.getType<_io13seno.CitizenReport?>,
          _is.getType<_i8rthojw.CitizenVerification?>,
          _is.getType<_iajwbfgj.CivicIssue?>,
          _is.getType<_ichko28z.DashboardAnalytics?>,
          _is.getType<_i30690kx.Department?>,
          _is.getType<_ieh0bqys.DuplicateCheckResult?>,
          _is.getType<_izw8z7ou.Greeting?>,
          _is.getType<_i306qart.IssueAssignment?>,
          _is.getType<_imehol3d.IssueMatchHistory?>,
          _is.getType<_i1vdg1b2.IssueTimelineItem?>,
          _is.getType<_irt10kca.Notification?>,
          _is.getType<_i8p143l9.Officer?>,
          _is.getType<_isaqapjx.Place?>,
          _is.getType<_i76gkble.PriorityCalculationResult?>,
          _is.getType<_is5fg8iw.ReportCountHistory?>,
          _is.getType<_inzhlssr.ResolutionRecord?>,
          _is.getType<_ixuwv6na.Story?>,
          _is.getType<_ioo0pzq9.SubmitReportResponse?>,
          _is.getType<_iv73i78m.User?>,
          _is.getType<List<_i7pac1a4.CitizenReport>>,
          _is.getType<List<_ix0rezvy.AuditLog>>,
          _is.getType<List<_itl2lvhp.CivicIssue>>,
          _is.getType<List<_iuzl316s.IssueTimelineItem>>,
          _is.getType<List<_iaj5r3oi.Place>>,
          _is.getType<List<_ik4h1j5x.Story>>,
        ],
        modules: const [
          _iais.Protocol.new,
          _iacs.Protocol.new,
          _isp.Protocol.new,
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

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    ..._ownTableDefinitions,
    ..._iais.Protocol().getOwnTableDefinitions(),
    ..._iacs.Protocol().getOwnTableDefinitions(),
    ..._isp.Protocol.targetTableDefinitions,
  ];

  static List<_isp.TableDefinition> get _ownTableDefinitions => [
    _isp.TableDefinition(
      name: 'audit_logs',
      dartName: 'AuditLog',
      schema: 'public',
      module: 'nagarsetu',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'actorId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'actorRole',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'action',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'entityType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'entityId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'oldValues',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'newValues',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'audit_entity_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'entityType',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'entityId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'audit_actor_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'actorId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'citizen_reports',
      dartName: 'CitizenReport',
      schema: 'public',
      module: 'nagarsetu',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'citizenId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'issueId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'category',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'latitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'longitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'address',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'imageReference',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'audioReference',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'aiDetectedCategory',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'aiConfidence',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'duplicateDetectionScore',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'duplicateDetectionStatus',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'submissionStatus',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'idempotencyKey',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'counted',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'linkMethod',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'repeatReporter',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'citizen_report_issue_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'issueId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'citizen_report_citizen_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'citizenId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'citizen_report_idem_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'idempotencyKey',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'citizen_verifications',
      dartName: 'CitizenVerification',
      schema: 'public',
      module: 'nagarsetu',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'issueId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'citizenId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'verificationStatus',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'remarks',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'imageReference',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'citizen_verif_issue_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'issueId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'citizen_verif_citizen_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'citizenId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'civic_issues',
      dartName: 'CivicIssue',
      schema: 'public',
      module: 'nagarsetu',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'issueCode',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'category',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'descriptionSummary',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'locationName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'address',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'latitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'longitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'priorityScore',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'priorityLevel',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'priorityExplanation',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'totalReports',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'uniqueCitizens',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'assignedDepartmentId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'assignedOfficerId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'firstReportedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'lastReportedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'resolvedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'reopenedCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'civic_issue_code_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'issueCode',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'civic_issue_coords_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'latitude',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'longitude',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'civic_issue_status_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'status',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'civic_issue_cat_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'category',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'departments',
      dartName: 'Department',
      schema: 'public',
      module: 'nagarsetu',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'contactEmail',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'contactPhone',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'isActive',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'department_name_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'name',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'issue_assignments',
      dartName: 'IssueAssignment',
      schema: 'public',
      module: 'nagarsetu',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'issueId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'departmentId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'officerId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'assignedBy',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'assignedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'deadline',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'assignmentStatus',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'remarks',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'issue_assign_issue_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'issueId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'issue_assign_officer_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'officerId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'issue_match_history',
      dartName: 'IssueMatchHistory',
      schema: 'public',
      module: 'nagarsetu',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'reportId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'matchedIssueId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'geographicSimilarity',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'imageSimilarity',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'descriptionSimilarity',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'categorySimilarity',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'temporalSimilarity',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'combinedSimilarityScore',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'matchingDecision',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'decisionReason',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'reviewedBy',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'match_history_report_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'reportId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'match_history_issue_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'matchedIssueId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'notifications',
      dartName: 'Notification',
      schema: 'public',
      module: 'nagarsetu',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'message',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'notificationType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'relatedIssueId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'isRead',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'notification_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'officers',
      dartName: 'Officer',
      schema: 'public',
      module: 'nagarsetu',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'departmentId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'employeeCode',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'designation',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'assignedArea',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'isActive',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'officer_emp_code_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'employeeCode',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'officer_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'places',
      dartName: 'Place',
      schema: 'public',
      module: 'nagarsetu',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'address',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'category',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'latitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'longitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'place_coords_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'latitude',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'longitude',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'report_count_history',
      dartName: 'ReportCountHistory',
      schema: 'public',
      module: 'nagarsetu',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'issueId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'reportId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'previousCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'newCount',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'actionType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'count_hist_issue_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'issueId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'resolution_records',
      dartName: 'ResolutionRecord',
      schema: 'public',
      module: 'nagarsetu',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'issueId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'officerId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'resolutionDescription',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'beforeImageReference',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'afterImageReference',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'latitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'longitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'submittedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'verificationStatus',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'verifiedBy',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'verifiedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'rejectionReason',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'resolution_issue_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'issueId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'resolution_officer_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'officerId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'stories',
      dartName: 'Story',
      schema: 'public',
      module: 'nagarsetu',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'placeId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'authorId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'imageReference',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'audioReference',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'relatedIssueId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'visibility',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'story_place_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'placeId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'story_author_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authorId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'users',
      dartName: 'User',
      schema: 'public',
      module: 'nagarsetu',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'phone',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'passwordHash',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'profileImage',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'isActive',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'user_email_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'email',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
  ];

  static String? getClassNameFromObjectJson(dynamic data) =>
      _is.ProtocolDeserialization.readClassName(data);

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    final rawDataClassName = _is.ProtocolDeserialization.readClassName(data);
    final dataClassName = rawDataClassName;
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
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
    if (t == _is.getType<_ivocdqwh.ApiResponse?>()) {
      return (data != null ? _ivocdqwh.ApiResponse.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_itixckla.AuditLog?>()) {
      return (data != null ? _itixckla.AuditLog.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_io13seno.CitizenReport?>()) {
      return (data != null ? _io13seno.CitizenReport.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i8rthojw.CitizenVerification?>()) {
      return (data != null
              ? _i8rthojw.CitizenVerification.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iajwbfgj.CivicIssue?>()) {
      return (data != null ? _iajwbfgj.CivicIssue.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ichko28z.DashboardAnalytics?>()) {
      return (data != null ? _ichko28z.DashboardAnalytics.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i30690kx.Department?>()) {
      return (data != null ? _i30690kx.Department.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ieh0bqys.DuplicateCheckResult?>()) {
      return (data != null
              ? _ieh0bqys.DuplicateCheckResult.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i306qart.IssueAssignment?>()) {
      return (data != null ? _i306qart.IssueAssignment.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_imehol3d.IssueMatchHistory?>()) {
      return (data != null ? _imehol3d.IssueMatchHistory.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i1vdg1b2.IssueTimelineItem?>()) {
      return (data != null ? _i1vdg1b2.IssueTimelineItem.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_irt10kca.Notification?>()) {
      return (data != null ? _irt10kca.Notification.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i8p143l9.Officer?>()) {
      return (data != null ? _i8p143l9.Officer.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_isaqapjx.Place?>()) {
      return (data != null ? _isaqapjx.Place.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i76gkble.PriorityCalculationResult?>()) {
      return (data != null
              ? _i76gkble.PriorityCalculationResult.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_is5fg8iw.ReportCountHistory?>()) {
      return (data != null ? _is5fg8iw.ReportCountHistory.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_inzhlssr.ResolutionRecord?>()) {
      return (data != null ? _inzhlssr.ResolutionRecord.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ixuwv6na.Story?>()) {
      return (data != null ? _ixuwv6na.Story.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ioo0pzq9.SubmitReportResponse?>()) {
      return (data != null
              ? _ioo0pzq9.SubmitReportResponse.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iv73i78m.User?>()) {
      return (data != null ? _iv73i78m.User.fromJson(data) : null) as T;
    }
    if (t == List<_i7pac1a4.CitizenReport>) {
      return (data as List)
              .map((e) => deserialize<_i7pac1a4.CitizenReport>(e))
              .toList()
          as T;
    }
    if (t == List<_ix0rezvy.AuditLog>) {
      return (data as List)
              .map((e) => deserialize<_ix0rezvy.AuditLog>(e))
              .toList()
          as T;
    }
    if (t == List<_itl2lvhp.CivicIssue>) {
      return (data as List)
              .map((e) => deserialize<_itl2lvhp.CivicIssue>(e))
              .toList()
          as T;
    }
    if (t == List<_iuzl316s.IssueTimelineItem>) {
      return (data as List)
              .map((e) => deserialize<_iuzl316s.IssueTimelineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_iaj5r3oi.Place>) {
      return (data as List).map((e) => deserialize<_iaj5r3oi.Place>(e)).toList()
          as T;
    }
    if (t == List<_ik4h1j5x.Story>) {
      return (data as List).map((e) => deserialize<_ik4h1j5x.Story>(e)).toList()
          as T;
    }
    final modules = deserializationMetadata.modulesForDeserialization(
      t,
      className: rawDataClassName,
    );
    for (final module in modules) {
      try {
        return module.deserialize<T>(data, t);
      } on _is.DeserializationTypeNotFoundException catch (_) {}
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
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
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
      return _iais.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(19),
      });
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      return _iacs.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(20),
      });
    }
    if (dataClassName.startsWith('serverpod.')) {
      return _isp.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(10),
      });
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('nagarsetu', this);
    _iacs.Protocol().registerHostProtocol('nagarsetu', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _itixckla.AuditLog:
        return _itixckla.AuditLog.t;
      case _io13seno.CitizenReport:
        return _io13seno.CitizenReport.t;
      case _i8rthojw.CitizenVerification:
        return _i8rthojw.CitizenVerification.t;
      case _iajwbfgj.CivicIssue:
        return _iajwbfgj.CivicIssue.t;
      case _i30690kx.Department:
        return _i30690kx.Department.t;
      case _i306qart.IssueAssignment:
        return _i306qart.IssueAssignment.t;
      case _imehol3d.IssueMatchHistory:
        return _imehol3d.IssueMatchHistory.t;
      case _irt10kca.Notification:
        return _irt10kca.Notification.t;
      case _i8p143l9.Officer:
        return _i8p143l9.Officer.t;
      case _isaqapjx.Place:
        return _isaqapjx.Place.t;
      case _is5fg8iw.ReportCountHistory:
        return _is5fg8iw.ReportCountHistory.t;
      case _inzhlssr.ResolutionRecord:
        return _inzhlssr.ResolutionRecord.t;
      case _ixuwv6na.Story:
        return _ixuwv6na.Story.t;
      case _iv73i78m.User:
        return _iv73i78m.User.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  List<_isp.TableDefinition> getOwnTableDefinitions() => _ownTableDefinitions;

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
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
