import 'package:flutter/material.dart';

enum IoTSensorType { temperature, humidity, doorStatus, other }

enum IoTStatus { normal, warning, critical }

class IoTReading {
  final String id;
  final double value;
  final String unit;
  final DateTime timestamp;
  final IoTStatus status;

  IoTReading({
    required this.id,
    required this.value,
    required this.unit,
    required this.timestamp,
    required this.status,
  });

  Color get statusColor {
    switch (status) {
      case IoTStatus.normal:
        return Colors.green;
      case IoTStatus.warning:
        return Colors.orange;
      case IoTStatus.critical:
        return Colors.red;
    }
  }
}

class IoTSensor {
  final String id;
  final String code;
  final IoTSensorType type;
  final int equipmentId;
  final List<IoTReading> readings;

  IoTSensor({
    required this.id,
    required this.code,
    required this.type,
    required this.equipmentId,
    this.readings = const [],
  });

  IoTReading? get latestReading => readings.isNotEmpty ? readings.first : null;

  String get name {
    switch (type) {
      case IoTSensorType.temperature:
        return 'Temperatura';
      case IoTSensorType.humidity:
        return 'Humedad';
      case IoTSensorType.doorStatus:
        return 'Estado Puerta';
      case IoTSensorType.other:
        // Detectar por código
        if (code.toUpperCase().contains('VOLT')) {
          return 'Voltaje';
        } else if (code.toUpperCase().contains('CURR')) {
          return 'Corriente';
        }
        return 'Sensor';
    }
  }
}
