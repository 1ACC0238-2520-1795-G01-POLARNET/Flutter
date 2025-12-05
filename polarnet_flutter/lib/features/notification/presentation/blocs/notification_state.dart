import 'package:equatable/equatable.dart';
import 'package:polarnet_flutter/features/notification/domain/models/notification.dart';

enum NotificationStatus { initial, loading, loaded, error }

class NotificationState extends Equatable {
  final NotificationStatus status;
  final List<AppNotification> notifications;
  final int unreadCount;
  final String? errorMessage;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.unreadCount = 0,
    this.errorMessage,
  });

  /// Get only unread notifications
  List<AppNotification> get unreadNotifications =>
      notifications.where((n) => !n.isRead).toList();

  /// Get only read notifications
  List<AppNotification> get readNotifications =>
      notifications.where((n) => n.isRead).toList();

  /// Check if there are any unread notifications
  bool get hasUnread => unreadCount > 0;

  NotificationState copyWith({
    NotificationStatus? status,
    List<AppNotification>? notifications,
    int? unreadCount,
    String? errorMessage,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, notifications, unreadCount, errorMessage];
}
