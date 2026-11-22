import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/auth_service.dart';
import '../middleware/rbac_middleware.dart';

class AuthEndpoint extends Endpoint {
  /// Registers a new citizen, officer, or admin account
  Future<User> register(
    Session session, {
    required String name,
    required String email,
    required String password,
    String role = 'Citizen',
    String? phone,
  }) async {
    return await AuthService.registerUser(
      session: session,
      name: name,
      email: email,
      password: password,
      role: role,
      phone: phone,
    );
  }

  /// Authenticates user and returns profile
  Future<User> login(
    Session session, {
    required String email,
    required String password,
  }) async {
    return await AuthService.authenticateUser(
      session: session,
      email: email,
      password: password,
    );
  }

  /// Returns current authenticated user profile
  Future<User?> getProfile(Session session) async {
    return await RbacMiddleware.getCurrentUser(session);
  }

  /// Updates password for authenticated user
  Future<bool> changePassword(
    Session session, {
    required String oldPassword,
    required String newPassword,
  }) async {
    final user = await RbacMiddleware.requireUser(session);
    return await AuthService.changePassword(
      session: session,
      userId: user.id!,
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }
}
