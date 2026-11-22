import 'package:bcrypt/bcrypt.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../validators/input_validator.dart';

class AuthService {
  /// Registers a new user with secure password hashing
  static Future<User> registerUser({
    required Session session,
    required String name,
    required String email,
    required String password,
    String role = 'Citizen',
    String? phone,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    if (!InputValidator.isValidEmail(cleanEmail)) {
      throw ArgumentError('Invalid email address format.');
    }
    if (password.length < 6) {
      throw ArgumentError('Password must be at least 6 characters long.');
    }

    // Check if user with email already exists
    final existing = await User.db.findFirstRow(
      session,
      where: (t) => t.email.equals(cleanEmail),
    );
    if (existing != null) {
      throw StateError('An account with this email address already exists.');
    }

    final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    final newUser = User(
      name: name.trim(),
      email: cleanEmail,
      phone: phone?.trim(),
      passwordHash: hashedPassword,
      role: role,
      isActive: true,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    final createdUser = await User.db.insertRow(session, newUser);

    // Record audit log
    await AuditLog.db.insertRow(
      session,
      AuditLog(
        actorId: createdUser.id,
        actorRole: role,
        action: 'USER_REGISTERED',
        entityType: 'User',
        entityId: createdUser.id,
        newValues: '{"email": "$cleanEmail", "role": "$role"}',
        createdAt: DateTime.now().toUtc(),
      ),
    );

    return createdUser;
  }

  /// Verifies credentials for user login
  static Future<User> authenticateUser({
    required Session session,
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final user = await User.db.findFirstRow(
      session,
      where: (t) => t.email.equals(cleanEmail),
    );

    if (user == null || user.passwordHash == null) {
      throw ArgumentError('Invalid email or password.');
    }

    final isCorrect = BCrypt.checkpw(password, user.passwordHash!);
    if (!isCorrect) {
      throw ArgumentError('Invalid email or password.');
    }

    if (!user.isActive) {
      throw StateError('This account has been deactivated. Please contact administration.');
    }

    return user;
  }

  /// Changes password with verification of old password
  static Future<bool> changePassword({
    required Session session,
    required int userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    if (newPassword.length < 6) {
      throw ArgumentError('New password must be at least 6 characters long.');
    }

    final user = await User.db.findById(session, userId);
    if (user == null || user.passwordHash == null) {
      throw ArgumentError('User not found.');
    }

    if (!BCrypt.checkpw(oldPassword, user.passwordHash!)) {
      throw ArgumentError('Incorrect current password.');
    }

    user.passwordHash = BCrypt.hashpw(newPassword, BCrypt.gensalt());
    user.updatedAt = DateTime.now().toUtc();
    await User.db.updateRow(session, user);

    await AuditLog.db.insertRow(
      session,
      AuditLog(
        actorId: userId,
        actorRole: user.role,
        action: 'PASSWORD_CHANGED',
        entityType: 'User',
        entityId: userId,
        createdAt: DateTime.now().toUtc(),
      ),
    );

    return true;
  }
}
