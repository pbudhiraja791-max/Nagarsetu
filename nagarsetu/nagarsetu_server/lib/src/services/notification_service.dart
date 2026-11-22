import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class NotificationService {
  /// Sends an in-app notification to a specific user
  static Future<Notification> sendNotification({
    required Session session,
    required int userId,
    required String title,
    required String message,
    required String notificationType,
    int? relatedIssueId,
  }) async {
    final notification = Notification(
      userId: userId,
      title: title,
      message: message,
      notificationType: notificationType,
      relatedIssueId: relatedIssueId,
      isRead: false,
      createdAt: DateTime.now().toUtc(),
    );

    return await Notification.db.insertRow(session, notification);
  }

  /// Retrieves user notifications with pagination
  static Future<List<Notification>> getUserNotifications({
    required Session session,
    required int userId,
    int limit = 30,
    int offset = 0,
  }) async {
    return await Notification.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.createdAt.desc(),
      limit: limit,
      offset: offset,
    );
  }

  /// Marks a specific notification as read
  static Future<bool> markAsRead(Session session, int notificationId, int userId) async {
    final notif = await Notification.db.findById(session, notificationId);
    if (notif != null && notif.userId == userId) {
      notif.isRead = true;
      await Notification.db.updateRow(session, notif);
      return true;
    }
    return false;
  }

  /// Marks all notifications for a user as read
  static Future<int> markAllAsRead(Session session, int userId) async {
    final unread = await Notification.db.find(
      session,
      where: (t) => t.userId.equals(userId) & t.isRead.equals(false),
    );

    for (final notif in unread) {
      notif.isRead = true;
      await Notification.db.updateRow(session, notif);
    }

    return unread.length;
  }
}
