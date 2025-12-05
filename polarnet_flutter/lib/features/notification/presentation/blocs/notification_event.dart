import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

/// Load all notifications for a user
class LoadNotifications extends NotificationEvent {
  final String userId;
  final String role;

  const LoadNotifications({required this.userId, required this.role});

  @override
  List<Object?> get props => [userId, role];
}

/// Refresh notifications
class RefreshNotifications extends NotificationEvent {
  final String userId;
  final String role;

  const RefreshNotifications({required this.userId, required this.role});

  @override
  List<Object?> get props => [userId, role];
}

/// Mark a single notification as read
class MarkNotificationAsRead extends NotificationEvent {
  final String notificationId;

  const MarkNotificationAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

/// Mark all notifications as read
class MarkAllNotificationsAsRead extends NotificationEvent {
  final String userId;
  final String role;

  const MarkAllNotificationsAsRead({required this.userId, required this.role});

  @override
  List<Object?> get props => [userId, role];
}

/// Load unread count only
class LoadUnreadCount extends NotificationEvent {
  final String userId;
  final String role;

  const LoadUnreadCount({required this.userId, required this.role});

  @override
  List<Object?> get props => [userId, role];
}
