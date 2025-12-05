import 'package:polarnet_flutter/features/notification/domain/models/notification.dart';

class NotificationDto {
  final String id;
  final String userId;
  final String role;
  final String type;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NotificationDto({
    required this.id,
    required this.userId,
    required this.role,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isRead,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationDto.fromJson(Map<String, dynamic> json) {
    return NotificationDto(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      role: json['role'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['is_read'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'user_id': userId,
      'role': role,
      'type': type,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
    };
    // Solo incluir created_at y updated_at si tienen valor
    if (createdAt != null) {
      json['created_at'] = createdAt!.toIso8601String();
    }
    if (updatedAt != null) {
      json['updated_at'] = updatedAt!.toIso8601String();
    }
    return json;
  }

  AppNotification toDomain() {
    return AppNotification(
      id: id,
      userId: userId,
      role: role,
      type: type,
      title: title,
      message: message,
      timestamp: timestamp,
      isRead: isRead,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
