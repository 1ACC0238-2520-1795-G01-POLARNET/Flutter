import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polarnet_flutter/features/notification/domain/repositories/notification_repository.dart';
import 'package:polarnet_flutter/features/notification/presentation/blocs/notification_event.dart';
import 'package:polarnet_flutter/features/notification/presentation/blocs/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;

  NotificationBloc(this._repository) : super(const NotificationState()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<RefreshNotifications>(_onRefreshNotifications);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<MarkAllNotificationsAsRead>(_onMarkAllNotificationsAsRead);
    on<LoadUnreadCount>(_onLoadUnreadCount);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      emit(
        state.copyWith(status: NotificationStatus.loading, errorMessage: null),
      );

      final notifications = await _repository.getNotifications(
        event.userId,
        event.role,
      );
      final unreadCount = notifications.where((n) => !n.isRead).length;

      emit(
        state.copyWith(
          status: NotificationStatus.loaded,
          notifications: notifications,
          unreadCount: unreadCount,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NotificationStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshNotifications(
    RefreshNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final notifications = await _repository.getNotifications(
        event.userId,
        event.role,
      );
      final unreadCount = notifications.where((n) => !n.isRead).length;

      emit(
        state.copyWith(
          status: NotificationStatus.loaded,
          notifications: notifications,
          unreadCount: unreadCount,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NotificationStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final success = await _repository.markAsRead(event.notificationId);

      if (success) {
        final updatedNotifications = state.notifications.map((n) {
          if (n.id == event.notificationId) {
            return n.copyWith(isRead: true);
          }
          return n;
        }).toList();

        final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

        emit(
          state.copyWith(
            notifications: updatedNotifications,
            unreadCount: unreadCount,
          ),
        );
      }
    } catch (e) {
      // Silently fail for mark as read
    }
  }

  Future<void> _onMarkAllNotificationsAsRead(
    MarkAllNotificationsAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final success = await _repository.markAllAsRead(event.userId, event.role);

      if (success) {
        final updatedNotifications = state.notifications.map((n) {
          return n.copyWith(isRead: true);
        }).toList();

        emit(
          state.copyWith(notifications: updatedNotifications, unreadCount: 0),
        );
      }
    } catch (e) {
      // Silently fail for mark all as read
    }
  }

  Future<void> _onLoadUnreadCount(
    LoadUnreadCount event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final unreadCount = await _repository.getUnreadCount(
        event.userId,
        event.role,
      );

      emit(state.copyWith(unreadCount: unreadCount));
    } catch (e) {
      // Silently fail for unread count
    }
  }
}
