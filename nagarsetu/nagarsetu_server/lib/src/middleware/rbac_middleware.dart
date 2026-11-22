import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class RbacMiddleware {
  static const String roleCitizen = 'Citizen';
  static const String roleOfficer = 'Officer';
  static const String roleAdmin = 'Admin';

  /// Retrieves the current authenticated User from database based on session
  static Future<User?> getCurrentUser(Session session) async {
    final authInfo = session.authenticated;
    if (authInfo == null) {
      return null;
    }

    final userId = int.tryParse(authInfo.userIdentifier);
    if (userId == null) {
      return null;
    }
    // Check if user exists in our users table
    final user = await User.db.findById(session, userId);
    return user;
  }

  /// Requires an authenticated user, throws an exception otherwise
  static Future<User> requireUser(Session session) async {
    final user = await getCurrentUser(session);
    if (user == null) {
      throw ServerpodClientException(
        'Authentication required. Please sign in to access this resource.',
        401,
      );
    }
    if (!user.isActive) {
      throw ServerpodClientException(
        'Account deactivated. Please contact municipal support.',
        403,
      );
    }
    return user;
  }

  /// Requires the user to have one of the permitted roles
  static Future<User> requireRole(Session session, List<String> permittedRoles) async {
    final user = await requireUser(session);
    final normalizedUserRole = user.role.toUpperCase();
    final normalizedPermitted = permittedRoles.map((r) => r.toUpperCase()).toList();

    if (!normalizedPermitted.contains(normalizedUserRole)) {
      throw ServerpodClientException(
        'Access denied. Required role: ${permittedRoles.join(" or ")}',
        403,
      );
    }
    return user;
  }

  static Future<User> requireCitizen(Session session) =>
      requireRole(session, [roleCitizen, 'CITIZEN']);

  static Future<User> requireOfficer(Session session) =>
      requireRole(session, [roleOfficer, 'OFFICER']);

  static Future<User> requireAdmin(Session session) =>
      requireRole(session, [roleAdmin, 'ADMIN']);
}

class ServerpodClientException implements Exception {
  final String message;
  final int statusCode;

  ServerpodClientException(this.message, [this.statusCode = 400]);

  @override
  String toString() => message;
}
