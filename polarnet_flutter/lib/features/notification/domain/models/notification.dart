import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppNotification extends Equatable {
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

  const AppNotification({
    required this.id,
    required this.userId,
    required this.role,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Returns an icon based on notification type
  IconData get typeIcon {
    switch (type.toLowerCase()) {
      case 'alert':
        return Icons.warning_amber;
      case 'request':
        return Icons.assignment;
      case 'equipment':
        return Icons.inventory_2;
      case 'payment':
        return Icons.payment;
      case 'message':
        return Icons.message;
      case 'system':
        return Icons.settings;
      case 'rental':
        return Icons.handshake;
      default:
        return Icons.notifications;
    }
  }

  /// Returns a color based on notification type
  Color get typeColor {
    switch (type.toLowerCase()) {
      case 'alert':
        return Colors.orange;
      case 'request':
        return Colors.blue;
      case 'equipment':
        return Colors.teal;
      case 'payment':
        return Colors.green;
      case 'message':
        return Colors.purple;
      case 'system':
        return Colors.grey;
      case 'rental':
        return Colors.indigo;
      default:
        return Colors.blueGrey;
    }
  }

  /// Returns a human-readable type name
  String get typeName {
    switch (type.toLowerCase()) {
      case 'alert':
        return 'Alerta';
      case 'request':
        return 'Solicitud';
      case 'equipment':
        return 'Equipo';
      case 'payment':
        return 'Pago';
      case 'message':
        return 'Mensaje';
      case 'system':
        return 'Sistema';
      case 'rental':
        return 'Alquiler';
      default:
        return 'Notificación';
    }
  }

  AppNotification copyWith({
    String? id,
    String? userId,
    String? role,
    String? type,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    role,
    type,
    title,
    message,
    timestamp,
    isRead,
    createdAt,
    updatedAt,
  ];
}
