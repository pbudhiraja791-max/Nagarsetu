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
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../endpoints/admin_endpoint.dart' as _i5t1w2d2;
import '../endpoints/analytics_endpoint.dart' as _ibbhv9ku;
import '../endpoints/auth_endpoint.dart' as _iyggisn2;
import '../endpoints/issue_endpoint.dart' as _isyn1z06;
import '../endpoints/officer_endpoint.dart' as _il6jp61o;
import '../endpoints/places_endpoint.dart' as _id40adi8;
import '../endpoints/report_endpoint.dart' as _i90z2r7i;
import '../endpoints/storage_endpoint.dart' as _ithym10a;
import '../endpoints/verification_endpoint.dart' as _ie4zs15l;
import '../greetings/greeting_endpoint.dart' as _il624ik7;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    initializeOwnEndpoints(server);
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeOwnEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeOwnEndpoints(server);
  }

  @override
  void initializeOwnEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'admin': _i5t1w2d2.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          null,
        ),
      'analytics': _ibbhv9ku.AnalyticsEndpoint()
        ..initialize(
          server,
          'analytics',
          null,
        ),
      'auth': _iyggisn2.AuthEndpoint()
        ..initialize(
          server,
          'auth',
          null,
        ),
      'issue': _isyn1z06.IssueEndpoint()
        ..initialize(
          server,
          'issue',
          null,
        ),
      'officer': _il6jp61o.OfficerEndpoint()
        ..initialize(
          server,
          'officer',
          null,
        ),
      'places': _id40adi8.PlacesEndpoint()
        ..initialize(
          server,
          'places',
          null,
        ),
      'report': _i90z2r7i.ReportEndpoint()
        ..initialize(
          server,
          'report',
          null,
        ),
      'storage': _ithym10a.StorageEndpoint()
        ..initialize(
          server,
          'storage',
          null,
        ),
      'verification': _ie4zs15l.VerificationEndpoint()
        ..initialize(
          server,
          'verification',
          null,
        ),
      'greeting': _il624ik7.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'startOtpLogin': _is.MethodConnector(
          name: 'startOtpLogin',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startOtpLogin(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyOtpLoginCode': _is.MethodConnector(
          name: 'verifyOtpLoginCode',
          params: {
            'otpLoginRequestId': _is.ParameterDescription(
              name: 'otpLoginRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyOtpLoginCode(
                    session,
                    otpLoginRequestId: params['otpLoginRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishOtpLogin': _is.MethodConnector(
          name: 'finishOtpLogin',
          params: {
            'otpLoginToken': _is.ParameterDescription(
              name: 'otpLoginToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishOtpLogin(
                    session,
                    otpLoginToken: params['otpLoginToken'],
                  ),
        ),
        'finishOtpRegistration': _is.MethodConnector(
          name: 'finishOtpRegistration',
          params: {
            'otpLoginToken': _is.ParameterDescription(
              name: 'otpLoginToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishOtpRegistration(
                    session,
                    otpLoginToken: params['otpLoginToken'],
                    password: params['password'],
                  ),
        ),
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['admin'] = _is.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'getPendingDuplicateReviews': _is.MethodConnector(
          name: 'getPendingDuplicateReviews',
          params: {
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i5t1w2d2.AdminEndpoint)
                  .getPendingDuplicateReviews(
                    session,
                    limit: params['limit'],
                  ),
        ),
        'confirmDuplicate': _is.MethodConnector(
          name: 'confirmDuplicate',
          params: {
            'reportId': _is.ParameterDescription(
              name: 'reportId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'remarks': _is.ParameterDescription(
              name: 'remarks',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i5t1w2d2.AdminEndpoint)
                  .confirmDuplicate(
                    session,
                    reportId: params['reportId'],
                    remarks: params['remarks'],
                  ),
        ),
        'rejectDuplicate': _is.MethodConnector(
          name: 'rejectDuplicate',
          params: {
            'reportId': _is.ParameterDescription(
              name: 'reportId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'remarks': _is.ParameterDescription(
              name: 'remarks',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i5t1w2d2.AdminEndpoint)
                  .rejectDuplicate(
                    session,
                    reportId: params['reportId'],
                    remarks: params['remarks'],
                  ),
        ),
        'assignIssue': _is.MethodConnector(
          name: 'assignIssue',
          params: {
            'issueId': _is.ParameterDescription(
              name: 'issueId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'departmentId': _is.ParameterDescription(
              name: 'departmentId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'officerId': _is.ParameterDescription(
              name: 'officerId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'deadline': _is.ParameterDescription(
              name: 'deadline',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'remarks': _is.ParameterDescription(
              name: 'remarks',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i5t1w2d2.AdminEndpoint).assignIssue(
                    session,
                    issueId: params['issueId'],
                    departmentId: params['departmentId'],
                    officerId: params['officerId'],
                    deadline: params['deadline'],
                    remarks: params['remarks'],
                  ),
        ),
        'updateIssuePriority': _is.MethodConnector(
          name: 'updateIssuePriority',
          params: {
            'issueId': _is.ParameterDescription(
              name: 'issueId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'manualScore': _is.ParameterDescription(
              name: 'manualScore',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'manualLevel': _is.ParameterDescription(
              name: 'manualLevel',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i5t1w2d2.AdminEndpoint)
                  .updateIssuePriority(
                    session,
                    issueId: params['issueId'],
                    manualScore: params['manualScore'],
                    manualLevel: params['manualLevel'],
                    reason: params['reason'],
                  ),
        ),
        'reconcileDatabase': _is.MethodConnector(
          name: 'reconcileDatabase',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i5t1w2d2.AdminEndpoint)
                  .reconcileDatabase(session),
        ),
        'getAuditLogs': _is.MethodConnector(
          name: 'getAuditLogs',
          params: {
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i5t1w2d2.AdminEndpoint).getAuditLogs(
                    session,
                    limit: params['limit'],
                    offset: params['offset'],
                  ),
        ),
      },
    );
    connectors['analytics'] = _is.EndpointConnector(
      name: 'analytics',
      endpoint: endpoints['analytics']!,
      methodConnectors: {
        'getDashboardAnalytics': _is.MethodConnector(
          name: 'getDashboardAnalytics',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['analytics'] as _ibbhv9ku.AnalyticsEndpoint)
                  .getDashboardAnalytics(session),
        ),
      },
    );
    connectors['auth'] = _is.EndpointConnector(
      name: 'auth',
      endpoint: endpoints['auth']!,
      methodConnectors: {
        'register': _is.MethodConnector(
          name: 'register',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'role': _is.ParameterDescription(
              name: 'role',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'phone': _is.ParameterDescription(
              name: 'phone',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _iyggisn2.AuthEndpoint).register(
                session,
                name: params['name'],
                email: params['email'],
                password: params['password'],
                role: params['role'],
                phone: params['phone'],
              ),
        ),
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _iyggisn2.AuthEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'getProfile': _is.MethodConnector(
          name: 'getProfile',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _iyggisn2.AuthEndpoint)
                  .getProfile(session),
        ),
        'changePassword': _is.MethodConnector(
          name: 'changePassword',
          params: {
            'oldPassword': _is.ParameterDescription(
              name: 'oldPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['auth'] as _iyggisn2.AuthEndpoint).changePassword(
                    session,
                    oldPassword: params['oldPassword'],
                    newPassword: params['newPassword'],
                  ),
        ),
      },
    );
    connectors['issue'] = _is.EndpointConnector(
      name: 'issue',
      endpoint: endpoints['issue']!,
      methodConnectors: {
        'getAllIssues': _is.MethodConnector(
          name: 'getAllIssues',
          params: {
            'page': _is.ParameterDescription(
              name: 'page',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'status': _is.ParameterDescription(
              name: 'status',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'category': _is.ParameterDescription(
              name: 'category',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'priorityLevel': _is.ParameterDescription(
              name: 'priorityLevel',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['issue'] as _isyn1z06.IssueEndpoint).getAllIssues(
                    session,
                    page: params['page'],
                    limit: params['limit'],
                    status: params['status'],
                    category: params['category'],
                    priorityLevel: params['priorityLevel'],
                  ),
        ),
        'getIssueById': _is.MethodConnector(
          name: 'getIssueById',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['issue'] as _isyn1z06.IssueEndpoint).getIssueById(
                    session,
                    params['id'],
                  ),
        ),
        'getNearbyIssues': _is.MethodConnector(
          name: 'getNearbyIssues',
          params: {
            'latitude': _is.ParameterDescription(
              name: 'latitude',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'longitude': _is.ParameterDescription(
              name: 'longitude',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'radiusMeters': _is.ParameterDescription(
              name: 'radiusMeters',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'category': _is.ParameterDescription(
              name: 'category',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['issue'] as _isyn1z06.IssueEndpoint)
                  .getNearbyIssues(
                    session,
                    latitude: params['latitude'],
                    longitude: params['longitude'],
                    radiusMeters: params['radiusMeters'],
                    category: params['category'],
                  ),
        ),
        'getPublicIssues': _is.MethodConnector(
          name: 'getPublicIssues',
          params: {
            'page': _is.ParameterDescription(
              name: 'page',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['issue'] as _isyn1z06.IssueEndpoint)
                  .getPublicIssues(
                    session,
                    page: params['page'],
                    limit: params['limit'],
                  ),
        ),
        'getIssueTimeline': _is.MethodConnector(
          name: 'getIssueTimeline',
          params: {
            'issueId': _is.ParameterDescription(
              name: 'issueId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['issue'] as _isyn1z06.IssueEndpoint)
                  .getIssueTimeline(
                    session,
                    params['issueId'],
                  ),
        ),
      },
    );
    connectors['officer'] = _is.EndpointConnector(
      name: 'officer',
      endpoint: endpoints['officer']!,
      methodConnectors: {
        'getAssignedIssues': _is.MethodConnector(
          name: 'getAssignedIssues',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['officer'] as _il6jp61o.OfficerEndpoint)
                  .getAssignedIssues(session),
        ),
        'acceptAssignment': _is.MethodConnector(
          name: 'acceptAssignment',
          params: {
            'issueId': _is.ParameterDescription(
              name: 'issueId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['officer'] as _il6jp61o.OfficerEndpoint)
                  .acceptAssignment(
                    session,
                    issueId: params['issueId'],
                  ),
        ),
        'submitResolution': _is.MethodConnector(
          name: 'submitResolution',
          params: {
            'issueId': _is.ParameterDescription(
              name: 'issueId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'description': _is.ParameterDescription(
              name: 'description',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'afterImageReference': _is.ParameterDescription(
              name: 'afterImageReference',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'beforeImageReference': _is.ParameterDescription(
              name: 'beforeImageReference',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'latitude': _is.ParameterDescription(
              name: 'latitude',
              type: _is.getType<double?>(),
              nullable: true,
            ),
            'longitude': _is.ParameterDescription(
              name: 'longitude',
              type: _is.getType<double?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['officer'] as _il6jp61o.OfficerEndpoint)
                  .submitResolution(
                    session,
                    issueId: params['issueId'],
                    description: params['description'],
                    afterImageReference: params['afterImageReference'],
                    beforeImageReference: params['beforeImageReference'],
                    latitude: params['latitude'],
                    longitude: params['longitude'],
                  ),
        ),
      },
    );
    connectors['places'] = _is.EndpointConnector(
      name: 'places',
      endpoint: endpoints['places']!,
      methodConnectors: {
        'createPlace': _is.MethodConnector(
          name: 'createPlace',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'description': _is.ParameterDescription(
              name: 'description',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'address': _is.ParameterDescription(
              name: 'address',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'category': _is.ParameterDescription(
              name: 'category',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'latitude': _is.ParameterDescription(
              name: 'latitude',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'longitude': _is.ParameterDescription(
              name: 'longitude',
              type: _is.getType<double>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['places'] as _id40adi8.PlacesEndpoint).createPlace(
                    session,
                    name: params['name'],
                    description: params['description'],
                    address: params['address'],
                    category: params['category'],
                    latitude: params['latitude'],
                    longitude: params['longitude'],
                  ),
        ),
        'getPlaces': _is.MethodConnector(
          name: 'getPlaces',
          params: {
            'page': _is.ParameterDescription(
              name: 'page',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['places'] as _id40adi8.PlacesEndpoint).getPlaces(
                    session,
                    page: params['page'],
                    limit: params['limit'],
                  ),
        ),
        'getPlaceById': _is.MethodConnector(
          name: 'getPlaceById',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['places'] as _id40adi8.PlacesEndpoint)
                  .getPlaceById(
                    session,
                    params['id'],
                  ),
        ),
        'createStory': _is.MethodConnector(
          name: 'createStory',
          params: {
            'placeId': _is.ParameterDescription(
              name: 'placeId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'description': _is.ParameterDescription(
              name: 'description',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'imageReference': _is.ParameterDescription(
              name: 'imageReference',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'audioReference': _is.ParameterDescription(
              name: 'audioReference',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'relatedIssueId': _is.ParameterDescription(
              name: 'relatedIssueId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'visibility': _is.ParameterDescription(
              name: 'visibility',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['places'] as _id40adi8.PlacesEndpoint).createStory(
                    session,
                    placeId: params['placeId'],
                    title: params['title'],
                    description: params['description'],
                    imageReference: params['imageReference'],
                    audioReference: params['audioReference'],
                    relatedIssueId: params['relatedIssueId'],
                    visibility: params['visibility'],
                  ),
        ),
        'getStoriesByPlace': _is.MethodConnector(
          name: 'getStoriesByPlace',
          params: {
            'placeId': _is.ParameterDescription(
              name: 'placeId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['places'] as _id40adi8.PlacesEndpoint)
                  .getStoriesByPlace(
                    session,
                    placeId: params['placeId'],
                    limit: params['limit'],
                  ),
        ),
      },
    );
    connectors['report'] = _is.EndpointConnector(
      name: 'report',
      endpoint: endpoints['report']!,
      methodConnectors: {
        'submitReport': _is.MethodConnector(
          name: 'submitReport',
          params: {
            'description': _is.ParameterDescription(
              name: 'description',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'category': _is.ParameterDescription(
              name: 'category',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'latitude': _is.ParameterDescription(
              name: 'latitude',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'longitude': _is.ParameterDescription(
              name: 'longitude',
              type: _is.getType<double>(),
              nullable: false,
            ),
            'address': _is.ParameterDescription(
              name: 'address',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'imageReference': _is.ParameterDescription(
              name: 'imageReference',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'audioReference': _is.ParameterDescription(
              name: 'audioReference',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'idempotencyKey': _is.ParameterDescription(
              name: 'idempotencyKey',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['report'] as _i90z2r7i.ReportEndpoint)
                  .submitReport(
                    session,
                    description: params['description'],
                    category: params['category'],
                    latitude: params['latitude'],
                    longitude: params['longitude'],
                    address: params['address'],
                    imageReference: params['imageReference'],
                    audioReference: params['audioReference'],
                    idempotencyKey: params['idempotencyKey'],
                  ),
        ),
        'getReportById': _is.MethodConnector(
          name: 'getReportById',
          params: {
            'reportId': _is.ParameterDescription(
              name: 'reportId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['report'] as _i90z2r7i.ReportEndpoint)
                  .getReportById(
                    session,
                    params['reportId'],
                  ),
        ),
        'getMyReports': _is.MethodConnector(
          name: 'getMyReports',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['report'] as _i90z2r7i.ReportEndpoint)
                  .getMyReports(session),
        ),
        'getReportsByIssue': _is.MethodConnector(
          name: 'getReportsByIssue',
          params: {
            'issueId': _is.ParameterDescription(
              name: 'issueId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['report'] as _i90z2r7i.ReportEndpoint)
                  .getReportsByIssue(
                    session,
                    params['issueId'],
                  ),
        ),
      },
    );
    connectors['storage'] = _is.EndpointConnector(
      name: 'storage',
      endpoint: endpoints['storage']!,
      methodConnectors: {
        'uploadImageBase64': _is.MethodConnector(
          name: 'uploadImageBase64',
          params: {
            'base64Data': _is.ParameterDescription(
              name: 'base64Data',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'fileName': _is.ParameterDescription(
              name: 'fileName',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['storage'] as _ithym10a.StorageEndpoint)
                  .uploadImageBase64(
                    session,
                    base64Data: params['base64Data'],
                    fileName: params['fileName'],
                  ),
        ),
        'uploadAudioBase64': _is.MethodConnector(
          name: 'uploadAudioBase64',
          params: {
            'base64Data': _is.ParameterDescription(
              name: 'base64Data',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'fileName': _is.ParameterDescription(
              name: 'fileName',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['storage'] as _ithym10a.StorageEndpoint)
                  .uploadAudioBase64(
                    session,
                    base64Data: params['base64Data'],
                    fileName: params['fileName'],
                  ),
        ),
      },
    );
    connectors['verification'] = _is.EndpointConnector(
      name: 'verification',
      endpoint: endpoints['verification']!,
      methodConnectors: {
        'adminVerifyResolution': _is.MethodConnector(
          name: 'adminVerifyResolution',
          params: {
            'issueId': _is.ParameterDescription(
              name: 'issueId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'approved': _is.ParameterDescription(
              name: 'approved',
              type: _is.getType<bool>(),
              nullable: false,
            ),
            'rejectionReason': _is.ParameterDescription(
              name: 'rejectionReason',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['verification'] as _ie4zs15l.VerificationEndpoint)
                      .adminVerifyResolution(
                        session,
                        issueId: params['issueId'],
                        approved: params['approved'],
                        rejectionReason: params['rejectionReason'],
                      ),
        ),
        'citizenVerifyResolution': _is.MethodConnector(
          name: 'citizenVerifyResolution',
          params: {
            'issueId': _is.ParameterDescription(
              name: 'issueId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'confirmedFixed': _is.ParameterDescription(
              name: 'confirmedFixed',
              type: _is.getType<bool>(),
              nullable: false,
            ),
            'remarks': _is.ParameterDescription(
              name: 'remarks',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'imageReference': _is.ParameterDescription(
              name: 'imageReference',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['verification'] as _ie4zs15l.VerificationEndpoint)
                      .citizenVerifyResolution(
                        session,
                        issueId: params['issueId'],
                        confirmedFixed: params['confirmedFixed'],
                        remarks: params['remarks'],
                        imageReference: params['imageReference'],
                      ),
        ),
      },
    );
    connectors['greeting'] = _is.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _is.MethodConnector(
          name: 'hello',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['greeting'] as _il624ik7.GreetingEndpoint).hello(
                    session,
                    params['name'],
                  ),
        ),
      },
    );
  }
}
