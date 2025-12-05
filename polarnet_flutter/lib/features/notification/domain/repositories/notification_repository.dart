import 'package:polarnet_flutter/features/notification/domain/models/notification.dart';

abstract class NotificationRepository {
  /// Get all notifications for a user
  Future<List<AppNotification>> getNotifications(String userId, String role);

  /// Mark a notification as read
  Future<bool> markAsRead(String notificationId);

  /// Mark all notifications as read
  Future<bool> markAllAsRead(String userId, String role);

  /// Get unread notifications count
  Future<int> getUnreadCount(String userId, String role);
}
