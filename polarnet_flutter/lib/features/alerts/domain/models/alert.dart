import 'package:flutter/material.dart';

enum AlertSeverity { low, medium, high, critical }

enum AlertType { temperature, humidity, doorStatus, voltage, other }

class Alert {
  final String id;
  final String type;
  final double value;
  final double? minAllowed;
  final double? maxAllowed;
  final DateTime timestamp;
  final String severity;
  final String message;
  final bool isAcknowledged;
  final String? clientId;
  final String? providerId;

  Alert({
    required this.id,
    required this.type,
    required this.value,
    this.minAllowed,
    this.maxAllowed,
    required this.timestamp,
    required this.severity,
    required this.message,
    this.isAcknowledged = false,
    this.clientId,
    this.providerId,
  });

  AlertSeverity get severityEnum {
    switch (severity.toLowerCase()) {
      case 'low':
        return AlertSeverity.low;
      case 'medium':
        return AlertSeverity.medium;
      case 'high':
        return AlertSeverity.high;
      case 'critical':
        return AlertSeverity.critical;
      default:
        return AlertSeverity.low;
    }
  }

  AlertType get typeEnum {
    switch (type.toLowerCase()) {
      case 'temperature':
        return AlertType.temperature;
      case 'humidity':
        return AlertType.humidity;
      case 'doorstatus':
      case 'door_status':
        return AlertType.doorStatus;
      case 'voltage':
        return AlertType.voltage;
      default:
        return AlertType.other;
    }
  }

  Color get severityColor {
    switch (severityEnum) {
      case AlertSeverity.low:
        return Colors.blue;
      case AlertSeverity.medium:
        return Colors.orange;
      case AlertSeverity.high:
        return Colors.deepOrange;
      case AlertSeverity.critical:
        return Colors.red;
    }
  }

  IconData get typeIcon {
    switch (typeEnum) {
      case AlertType.temperature:
        return Icons.thermostat;
      case AlertType.humidity:
        return Icons.water_drop;
      case AlertType.doorStatus:
        return Icons.door_front_door;
      case AlertType.voltage:
        return Icons.electrical_services;
      case AlertType.other:
        return Icons.warning;
    }
  }

  String get typeName {
    switch (typeEnum) {
      case AlertType.temperature:
        return 'Temperatura';
      case AlertType.humidity:
        return 'Humedad';
      case AlertType.doorStatus:
        return 'Estado Puerta';
      case AlertType.voltage:
        return 'Voltaje';
      case AlertType.other:
        return 'Otro';
    }
  }

  Alert copyWith({
    String? id,
    String? type,
    double? value,
    double? minAllowed,
    double? maxAllowed,
    DateTime? timestamp,
    String? severity,
    String? message,
    bool? isAcknowledged,
    String? clientId,
    String? providerId,
  }) {
    return Alert(
      id: id ?? this.id,
      type: type ?? this.type,
      value: value ?? this.value,
      minAllowed: minAllowed ?? this.minAllowed,
      maxAllowed: maxAllowed ?? this.maxAllowed,
      timestamp: timestamp ?? this.timestamp,
      severity: severity ?? this.severity,
      message: message ?? this.message,
      isAcknowledged: isAcknowledged ?? this.isAcknowledged,
      clientId: clientId ?? this.clientId,
      providerId: providerId ?? this.providerId,
    );
  }
}
