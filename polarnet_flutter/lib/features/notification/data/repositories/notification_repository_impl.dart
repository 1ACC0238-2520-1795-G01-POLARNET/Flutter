import 'package:polarnet_flutter/features/notification/data/models/notification_dto.dart';
import 'package:polarnet_flutter/features/notification/data/remote/notification_service.dart';
import 'package:polarnet_flutter/features/notification/domain/models/notification.dart';
import 'package:polarnet_flutter/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationService _service;

  /// Set to false to use Supabase data
  static const bool _useFakeData = false;

  NotificationRepositoryImpl(this._service);

  @override
  Future<List<AppNotification>> getNotifications(
    String userId,
    String role,
  ) async {
    if (_useFakeData) {
      return _generateFakeNotifications();
    }

    try {
      final dtos = await _service.getNotifications(userId, role);
      return dtos.map((dto) => dto.toDomain()).toList();
    } catch (e) {
      throw Exception('Error getting notifications: $e');
    }
  }

  @override
  Future<bool> markAsRead(String notificationId) async {
    if (_useFakeData) {
      await Future.delayed(const Duration(milliseconds: 300));
      return true;
    }

    try {
      return await _service.markAsRead(notificationId);
    } catch (e) {
      throw Exception('Error marking as read: $e');
    }
  }

  @override
  Future<bool> markAllAsRead(String userId, String role) async {
    if (_useFakeData) {
      await Future.delayed(const Duration(milliseconds: 300));
      return true;
    }

    try {
      return await _service.markAllAsRead(userId, role);
    } catch (e) {
      throw Exception('Error marking all as read: $e');
    }
  }

  @override
  Future<int> getUnreadCount(String userId, String role) async {
    if (_useFakeData) {
      final notifications = await _generateFakeNotifications();
      return notifications.where((n) => !n.isRead).length;
    }

    try {
      return await _service.getUnreadCount(userId, role);
    } catch (e) {
      throw Exception('Error getting unread count: $e');
    }
  }

  List<AppNotification> _generateFakeNotifications() {
    final now = DateTime.now();
    return [
      AppNotification(
        id: '1',
        userId: 'user_1',
        role: 'provider',
        type: 'request',
        title: 'Nueva solicitud de alquiler',
        message:
            'El cliente Juan Pérez ha solicitado alquilar la Cámara Frigorífica Industrial por 3 meses.',
        timestamp: now.subtract(const Duration(minutes: 15)),
        isRead: false,
      ),
      AppNotification(
        id: '2',
        userId: 'user_1',
        role: 'provider',
        type: 'alert',
        title: 'Alerta de temperatura',
        message:
            'La temperatura del equipo #123 ha superado el límite máximo permitido.',
        timestamp: now.subtract(const Duration(hours: 1)),
        isRead: false,
      ),
      AppNotification(
        id: '3',
        userId: 'user_1',
        role: 'provider',
        type: 'payment',
        title: 'Pago recibido',
        message:
            'Se ha recibido el pago de S/ 1,500.00 por el alquiler del mes de diciembre.',
        timestamp: now.subtract(const Duration(hours: 3)),
        isRead: false,
      ),
      AppNotification(
        id: '4',
        userId: 'user_1',
        role: 'provider',
        type: 'equipment',
        title: 'Equipo devuelto',
        message:
            'El Congelador Industrial ha sido devuelto por el cliente María García.',
        timestamp: now.subtract(const Duration(hours: 6)),
        isRead: true,
      ),
      AppNotification(
        id: '5',
        userId: 'user_1',
        role: 'provider',
        type: 'rental',
        title: 'Contrato próximo a vencer',
        message:
            'El contrato de alquiler de Vitrina Refrigerada vence en 5 días.',
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      AppNotification(
        id: '6',
        userId: 'user_1',
        role: 'provider',
        type: 'message',
        title: 'Nuevo mensaje',
        message: 'Carlos Ruiz te ha enviado un mensaje sobre su pedido.',
        timestamp: now.subtract(const Duration(days: 1, hours: 5)),
        isRead: true,
      ),
      AppNotification(
        id: '7',
        userId: 'user_1',
        role: 'provider',
        type: 'system',
        title: 'Actualización del sistema',
        message:
            'Se han implementado nuevas funcionalidades en la plataforma. Revisa las novedades.',
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
      AppNotification(
        id: '8',
        userId: 'user_1',
        role: 'provider',
        type: 'alert',
        title: 'Mantenimiento programado',
        message:
            'Recordatorio: El equipo Cámara Frigorífica #456 tiene mantenimiento programado para mañana.',
        timestamp: now.subtract(const Duration(days: 3)),
        isRead: true,
      ),
    ];
  }
}
