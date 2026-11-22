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
import 'package:http/http.dart' as _i85jenna;
import 'package:nagarsetu_client/src/protocol/audit_log.dart' as _izug5nan;
import 'package:nagarsetu_client/src/protocol/citizen_report.dart' as _i5pm6t6a;
import 'package:nagarsetu_client/src/protocol/civic_issue.dart' as _it3kcvzu;
import 'package:nagarsetu_client/src/protocol/dashboard_analytics.dart'
    as _i6hov5z7;
import 'package:nagarsetu_client/src/protocol/greetings/greeting.dart'
    as _isxj22x1;
import 'package:nagarsetu_client/src/protocol/issue_timeline_item.dart'
    as _igl4iy3c;
import 'package:nagarsetu_client/src/protocol/place.dart' as _idf5iruj;
import 'package:nagarsetu_client/src/protocol/resolution_record.dart'
    as _ila8ky1i;
import 'package:nagarsetu_client/src/protocol/story.dart' as _iel4wtun;
import 'package:nagarsetu_client/src/protocol/submit_report_response.dart'
    as _iwmy6tt1;
import 'package:nagarsetu_client/src/protocol/user.dart' as _i9djkgpe;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// By extending [EmailOtpIdpBaseEndpoint], the email identity provider
/// endpoints, including the passwordless sign-in with one-time passwords, are
/// made available on the server and enable the corresponding sign-in widget on
/// the client.
///
/// Extend [EmailIdpBaseEndpoint] instead for the password based sign-in only.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailOtpIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Starts a passwordless login by sending a one-time password to [email].
  ///
  /// The code is sent whether or not an account is registered for the email.
  /// If none is, verifying the code lets the user create a new account.
  ///
  /// Always returns a login request ID, which must be passed to
  /// [verifyOtpLoginCode] together with the one-time password.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the email is
  ///   not valid.
  /// - [EmailAccountRequestExceptionReason.tooManyAttempts] if too many
  ///   one-time passwords have been requested for the email.
  @override
  _ida.Future<_isc.UuidValue> startOtpLogin({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startOtpLogin',
        {'email': email},
      );

  /// Verifies a one-time password and returns a token to complete the login.
  ///
  /// If [EmailAccountOtpVerificationResult.accountExists] is `true`, pass the
  /// token to [finishOtpLogin] to sign in. Otherwise, have the user accept the
  /// terms (and optionally set a password if
  /// [EmailAccountOtpVerificationResult.allowPassword] is `true`) and pass it
  /// to [finishOtpRegistration] to create the account.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the login request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts to verify the code.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists for
  ///   the given [otpLoginRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<_iaic.EmailAccountOtpVerificationResult> verifyOtpLoginCode({
    required _isc.UuidValue otpLoginRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<_iaic.EmailAccountOtpVerificationResult>(
    'emailIdp',
    'verifyOtpLoginCode',
    {
      'otpLoginRequestId': otpLoginRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a passwordless login for an existing account and returns a new
  /// session.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the login request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [otpLoginToken] is
  ///   invalid or no account exists for the email.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> finishOtpLogin({
    required String otpLoginToken,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishOtpLogin',
    {'otpLoginToken': otpLoginToken},
  );

  /// Completes a passwordless login for an email without an account, by
  /// creating a new auth user with a profile and attaching the verified email
  /// to it.
  ///
  /// Must only be called after the user accepted the terms. The [password] is
  /// optional, and may only be set if
  /// [EmailAccountOtpVerificationResult.allowPassword] was `true`.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the login request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if a password is
  ///   given but not allowed, or it does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [otpLoginToken] is
  ///   invalid or an account already exists for the email.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishOtpRegistration({
    required String otpLoginToken,
    String? password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishOtpRegistration',
    {
      'otpLoginToken': otpLoginToken,
      'password': password,
    },
  );

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// {@category Endpoint}
class EndpointAdmin extends _isc.EndpointRef {
  EndpointAdmin(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

  /// Fetches pending duplicate reports requiring human administrator review
  _ida.Future<List<_i5pm6t6a.CitizenReport>> getPendingDuplicateReviews({
    required int limit,
  }) => caller.callServerEndpoint<List<_i5pm6t6a.CitizenReport>>(
    'admin',
    'getPendingDuplicateReviews',
    {'limit': limit},
  );

  /// Admin manually confirms duplicate suggestion, merging report into existing issue
  _ida.Future<_it3kcvzu.CivicIssue> confirmDuplicate({
    required int reportId,
    String? remarks,
  }) => caller.callServerEndpoint<_it3kcvzu.CivicIssue>(
    'admin',
    'confirmDuplicate',
    {
      'reportId': reportId,
      'remarks': remarks,
    },
  );

  /// Admin rejects duplicate candidate and forms a distinct new CivicIssue
  _ida.Future<_it3kcvzu.CivicIssue> rejectDuplicate({
    required int reportId,
    String? remarks,
  }) => caller.callServerEndpoint<_it3kcvzu.CivicIssue>(
    'admin',
    'rejectDuplicate',
    {
      'reportId': reportId,
      'remarks': remarks,
    },
  );

  /// Assigns a civic issue to a municipal department and officer
  _ida.Future<_it3kcvzu.CivicIssue> assignIssue({
    required int issueId,
    required int departmentId,
    required int officerId,
    DateTime? deadline,
    String? remarks,
  }) => caller.callServerEndpoint<_it3kcvzu.CivicIssue>(
    'admin',
    'assignIssue',
    {
      'issueId': issueId,
      'departmentId': departmentId,
      'officerId': officerId,
      'deadline': deadline,
      'remarks': remarks,
    },
  );

  /// Manually overrides priority score and level for an issue
  _ida.Future<_it3kcvzu.CivicIssue> updateIssuePriority({
    required int issueId,
    required double manualScore,
    required String manualLevel,
    required String reason,
  }) => caller.callServerEndpoint<_it3kcvzu.CivicIssue>(
    'admin',
    'updateIssuePriority',
    {
      'issueId': issueId,
      'manualScore': manualScore,
      'manualLevel': manualLevel,
      'reason': reason,
    },
  );

  /// Reconciles database-wide report counter invariants
  _ida.Future<String> reconcileDatabase() => caller.callServerEndpoint<String>(
    'admin',
    'reconcileDatabase',
    {},
  );

  /// Fetches system audit logs for administrative oversight
  _ida.Future<List<_izug5nan.AuditLog>> getAuditLogs({
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_izug5nan.AuditLog>>(
    'admin',
    'getAuditLogs',
    {
      'limit': limit,
      'offset': offset,
    },
  );
}

/// {@category Endpoint}
class EndpointAnalytics extends _isc.EndpointRef {
  EndpointAnalytics(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'analytics';

  /// Fetches system-wide civic performance indicators, category distribution, and resolution metrics
  _ida.Future<_i6hov5z7.DashboardAnalytics> getDashboardAnalytics() =>
      caller.callServerEndpoint<_i6hov5z7.DashboardAnalytics>(
        'analytics',
        'getDashboardAnalytics',
        {},
      );
}

/// {@category Endpoint}
class EndpointAuth extends _isc.EndpointRef {
  EndpointAuth(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'auth';

  /// Registers a new citizen, officer, or admin account
  _ida.Future<_i9djkgpe.User> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? phone,
  }) => caller.callServerEndpoint<_i9djkgpe.User>(
    'auth',
    'register',
    {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'phone': phone,
    },
  );

  /// Authenticates user and returns profile
  _ida.Future<_i9djkgpe.User> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i9djkgpe.User>(
    'auth',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Returns current authenticated user profile
  _ida.Future<_i9djkgpe.User?> getProfile() =>
      caller.callServerEndpoint<_i9djkgpe.User?>(
        'auth',
        'getProfile',
        {},
      );

  /// Updates password for authenticated user
  _ida.Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) => caller.callServerEndpoint<bool>(
    'auth',
    'changePassword',
    {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    },
  );
}

/// {@category Endpoint}
class EndpointIssue extends _isc.EndpointRef {
  EndpointIssue(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'issue';

  /// Retrieves paginated civic issues with optional filtering by status, category, or priority level
  _ida.Future<List<_it3kcvzu.CivicIssue>> getAllIssues({
    required int page,
    required int limit,
    String? status,
    String? category,
    String? priorityLevel,
  }) => caller.callServerEndpoint<List<_it3kcvzu.CivicIssue>>(
    'issue',
    'getAllIssues',
    {
      'page': page,
      'limit': limit,
      'status': status,
      'category': category,
      'priorityLevel': priorityLevel,
    },
  );

  /// Retrieves a specific civic issue by its ID
  _ida.Future<_it3kcvzu.CivicIssue?> getIssueById(int id) =>
      caller.callServerEndpoint<_it3kcvzu.CivicIssue?>(
        'issue',
        'getIssueById',
        {'id': id},
      );

  /// Spatial search: returns issues within radiusMeters of coordinates, sorted by proximity
  _ida.Future<List<_it3kcvzu.CivicIssue>> getNearbyIssues({
    required double latitude,
    required double longitude,
    required double radiusMeters,
    String? category,
  }) => caller.callServerEndpoint<List<_it3kcvzu.CivicIssue>>(
    'issue',
    'getNearbyIssues',
    {
      'latitude': latitude,
      'longitude': longitude,
      'radiusMeters': radiusMeters,
      'category': category,
    },
  );

  /// Public civic feed for citizens
  _ida.Future<List<_it3kcvzu.CivicIssue>> getPublicIssues({
    required int page,
    required int limit,
  }) => caller.callServerEndpoint<List<_it3kcvzu.CivicIssue>>(
    'issue',
    'getPublicIssues',
    {
      'page': page,
      'limit': limit,
    },
  );

  /// Retrieves complete audit and event timeline for a civic issue
  _ida.Future<List<_igl4iy3c.IssueTimelineItem>> getIssueTimeline(
    int issueId,
  ) => caller.callServerEndpoint<List<_igl4iy3c.IssueTimelineItem>>(
    'issue',
    'getIssueTimeline',
    {'issueId': issueId},
  );
}

/// {@category Endpoint}
class EndpointOfficer extends _isc.EndpointRef {
  EndpointOfficer(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'officer';

  /// Fetches issues assigned to the authenticated municipal officer
  _ida.Future<List<_it3kcvzu.CivicIssue>> getAssignedIssues() =>
      caller.callServerEndpoint<List<_it3kcvzu.CivicIssue>>(
        'officer',
        'getAssignedIssues',
        {},
      );

  /// Officer acknowledges receipt and transitions issue to IN_PROGRESS
  _ida.Future<_it3kcvzu.CivicIssue> acceptAssignment({required int issueId}) =>
      caller.callServerEndpoint<_it3kcvzu.CivicIssue>(
        'officer',
        'acceptAssignment',
        {'issueId': issueId},
      );

  /// Submits completion evidence with mandatory after-repair photo
  _ida.Future<_ila8ky1i.ResolutionRecord> submitResolution({
    required int issueId,
    required String description,
    required String afterImageReference,
    String? beforeImageReference,
    double? latitude,
    double? longitude,
  }) => caller.callServerEndpoint<_ila8ky1i.ResolutionRecord>(
    'officer',
    'submitResolution',
    {
      'issueId': issueId,
      'description': description,
      'afterImageReference': afterImageReference,
      'beforeImageReference': beforeImageReference,
      'latitude': latitude,
      'longitude': longitude,
    },
  );
}

/// {@category Endpoint}
class EndpointPlaces extends _isc.EndpointRef {
  EndpointPlaces(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'places';

  /// Creates a new municipal landmark or place
  _ida.Future<_idf5iruj.Place> createPlace({
    required String name,
    String? description,
    String? address,
    String? category,
    required double latitude,
    required double longitude,
  }) => caller.callServerEndpoint<_idf5iruj.Place>(
    'places',
    'createPlace',
    {
      'name': name,
      'description': description,
      'address': address,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
    },
  );

  /// Lists all municipal places
  _ida.Future<List<_idf5iruj.Place>> getPlaces({
    required int page,
    required int limit,
  }) => caller.callServerEndpoint<List<_idf5iruj.Place>>(
    'places',
    'getPlaces',
    {
      'page': page,
      'limit': limit,
    },
  );

  /// Retrieves details of a specific place
  _ida.Future<_idf5iruj.Place?> getPlaceById(int id) =>
      caller.callServerEndpoint<_idf5iruj.Place?>(
        'places',
        'getPlaceById',
        {'id': id},
      );

  /// Publishes a community story or civic news item for a place
  _ida.Future<_iel4wtun.Story> createStory({
    required int placeId,
    required String title,
    required String description,
    String? imageReference,
    String? audioReference,
    int? relatedIssueId,
    required String visibility,
  }) => caller.callServerEndpoint<_iel4wtun.Story>(
    'places',
    'createStory',
    {
      'placeId': placeId,
      'title': title,
      'description': description,
      'imageReference': imageReference,
      'audioReference': audioReference,
      'relatedIssueId': relatedIssueId,
      'visibility': visibility,
    },
  );

  /// Retrieves community stories associated with a place
  _ida.Future<List<_iel4wtun.Story>> getStoriesByPlace({
    required int placeId,
    required int limit,
  }) => caller.callServerEndpoint<List<_iel4wtun.Story>>(
    'places',
    'getStoriesByPlace',
    {
      'placeId': placeId,
      'limit': limit,
    },
  );
}

/// {@category Endpoint}
class EndpointReport extends _isc.EndpointRef {
  EndpointReport(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'report';

  /// Submits a citizen report with AI duplicate detection, atomic counters, and idempotency protection
  _ida.Future<_iwmy6tt1.SubmitReportResponse> submitReport({
    required String description,
    required String category,
    required double latitude,
    required double longitude,
    String? address,
    String? imageReference,
    String? audioReference,
    String? idempotencyKey,
  }) => caller.callServerEndpoint<_iwmy6tt1.SubmitReportResponse>(
    'report',
    'submitReport',
    {
      'description': description,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'imageReference': imageReference,
      'audioReference': audioReference,
      'idempotencyKey': idempotencyKey,
    },
  );

  /// Retrieves details for a specific citizen report
  _ida.Future<_i5pm6t6a.CitizenReport?> getReportById(int reportId) =>
      caller.callServerEndpoint<_i5pm6t6a.CitizenReport?>(
        'report',
        'getReportById',
        {'reportId': reportId},
      );

  /// Retrieves reports submitted by the current authenticated citizen
  _ida.Future<List<_i5pm6t6a.CitizenReport>> getMyReports() =>
      caller.callServerEndpoint<List<_i5pm6t6a.CitizenReport>>(
        'report',
        'getMyReports',
        {},
      );

  /// Retrieves all citizen reports consolidated under a civic issue
  _ida.Future<List<_i5pm6t6a.CitizenReport>> getReportsByIssue(int issueId) =>
      caller.callServerEndpoint<List<_i5pm6t6a.CitizenReport>>(
        'report',
        'getReportsByIssue',
        {'issueId': issueId},
      );
}

/// {@category Endpoint}
class EndpointStorage extends _isc.EndpointRef {
  EndpointStorage(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'storage';

  /// Uploads an image encoded in Base64 and returns the stored resource reference URL
  _ida.Future<String> uploadImageBase64({
    required String base64Data,
    required String fileName,
  }) => caller.callServerEndpoint<String>(
    'storage',
    'uploadImageBase64',
    {
      'base64Data': base64Data,
      'fileName': fileName,
    },
  );

  /// Uploads an audio clip encoded in Base64 and returns the stored resource reference URL
  _ida.Future<String> uploadAudioBase64({
    required String base64Data,
    required String fileName,
  }) => caller.callServerEndpoint<String>(
    'storage',
    'uploadAudioBase64',
    {
      'base64Data': base64Data,
      'fileName': fileName,
    },
  );
}

/// {@category Endpoint}
class EndpointVerification extends _isc.EndpointRef {
  EndpointVerification(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'verification';

  /// Admin reviews resolution evidence submitted by officer
  _ida.Future<_it3kcvzu.CivicIssue> adminVerifyResolution({
    required int issueId,
    required bool approved,
    String? rejectionReason,
  }) => caller.callServerEndpoint<_it3kcvzu.CivicIssue>(
    'verification',
    'adminVerifyResolution',
    {
      'issueId': issueId,
      'approved': approved,
      'rejectionReason': rejectionReason,
    },
  );

  /// Citizen reviews remediation on ground (confirms fixed or reopens)
  _ida.Future<_it3kcvzu.CivicIssue> citizenVerifyResolution({
    required int issueId,
    required bool confirmedFixed,
    String? remarks,
    String? imageReference,
  }) => caller.callServerEndpoint<_it3kcvzu.CivicIssue>(
    'verification',
    'citizenVerifyResolution',
    {
      'issueId': issueId,
      'confirmedFixed': confirmedFixed,
      'remarks': remarks,
      'imageReference': imageReference,
    },
  );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _isc.EndpointRef {
  EndpointGreeting(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _ida.Future<_isxj22x1.Greeting> hello(String name) =>
      caller.callServerEndpoint<_isxj22x1.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    admin = EndpointAdmin(this);
    analytics = EndpointAnalytics(this);
    auth = EndpointAuth(this);
    issue = EndpointIssue(this);
    officer = EndpointOfficer(this);
    places = EndpointPlaces(this);
    report = EndpointReport(this);
    storage = EndpointStorage(this);
    verification = EndpointVerification(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointAdmin admin;

  late final EndpointAnalytics analytics;

  late final EndpointAuth auth;

  late final EndpointIssue issue;

  late final EndpointOfficer officer;

  late final EndpointPlaces places;

  late final EndpointReport report;

  late final EndpointStorage storage;

  late final EndpointVerification verification;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'admin': admin,
    'analytics': analytics,
    'auth': auth,
    'issue': issue,
    'officer': officer,
    'places': places,
    'report': report,
    'storage': storage,
    'verification': verification,
    'greeting': greeting,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
