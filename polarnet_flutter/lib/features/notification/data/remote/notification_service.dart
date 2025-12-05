import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:polarnet_flutter/core/constants/api_constants.dart';
import 'package:polarnet_flutter/features/notification/data/models/notification_dto.dart';

class NotificationService {
  final String _baseUrl = '${ApiConstants.supabaseUrl}/rest/v1';
  final String _apiKey = ApiConstants.supabaseAnonKey;

  Map<String, String> get _headers => {
    'apikey': _apiKey,
    'Authorization': 'Bearer $_apiKey',
    'Content-Type': 'application/json',
  };

  /// Get all notifications for a user with specific role
  Future<List<NotificationDto>> getNotifications(
    String userId,
    String role,
  ) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/notifications?user_id=eq.$userId&role=eq.$role&order=timestamp.desc',
      );

      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        return data
            .map(
              (json) => NotificationDto.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }

  /// Mark a notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      final url = Uri.parse('$_baseUrl/notifications?id=eq.$notificationId');

      final response = await http.patch(
        url,
        headers: _headers,
        body: jsonEncode({
          'is_read': true,
          'updated_at': DateTime.now().toIso8601String(),
        }),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception('Error marking notification as read: $e');
    }
  }

  /// Mark all notifications as read for a user
  Future<bool> markAllAsRead(String userId, String role) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/notifications?user_id=eq.$userId&role=eq.$role&is_read=eq.false',
      );

      final response = await http.patch(
        url,
        headers: _headers,
        body: jsonEncode({
          'is_read': true,
          'updated_at': DateTime.now().toIso8601String(),
        }),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception('Error marking all notifications as read: $e');
    }
  }

  /// Get unread notifications count
  Future<int> getUnreadCount(String userId, String role) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/notifications?user_id=eq.$userId&role=eq.$role&is_read=eq.false&select=id',
      );

      final response = await http.get(
        url,
        headers: {..._headers, 'Prefer': 'count=exact'},
      );

      if (response.statusCode == 200) {
        final contentRange = response.headers['content-range'];
        if (contentRange != null) {
          final parts = contentRange.split('/');
          if (parts.length == 2) {
            return int.tryParse(parts[1]) ?? 0;
          }
        }
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        return data.length;
      }

      return 0;
    } catch (e) {
      throw Exception('Error fetching unread count: $e');
    }
  }

  /// Create a new notification
  Future<bool> createNotification(NotificationDto notification) async {
    try {
      final url = Uri.parse('$_baseUrl/notifications');
      final jsonBody = notification.toJson();

      // ignore: avoid_print
      print('📤 Creando notificación:');
      // ignore: avoid_print
      print('   user_id: ${notification.userId}');
      // ignore: avoid_print
      print('   role: ${notification.role}');
      // ignore: avoid_print
      print('   title: ${notification.title}');
      // ignore: avoid_print
      print('   JSON: $jsonBody');

      final response = await http.post(
        url,
        headers: {..._headers, 'Prefer': 'return=minimal'},
        body: jsonEncode(jsonBody),
      );

      // ignore: avoid_print
      print('📡 Response status: ${response.statusCode}');
      // ignore: avoid_print
      print('📦 Response body: ${response.body}');

      final success = response.statusCode == 201 || response.statusCode == 200;
      if (success) {
        // ignore: avoid_print
        print('✅ Notificación creada exitosamente');
      } else {
        // ignore: avoid_print
        print(
          '❌ Error al crear notificación: ${response.statusCode} - ${response.body}',
        );
      }

      return success;
    } catch (e) {
      // ignore: avoid_print
      print('❌ Error creating notification: $e');
      return false;
    }
  }
}
