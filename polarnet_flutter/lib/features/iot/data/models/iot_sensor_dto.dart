import 'package:polarnet_flutter/features/iot/domain/models/iot_sensor.dart';

class IoTReadingDto {
  final String id;
  final double value;
  final String unit;
  final DateTime timestamp;
  final String status;

  IoTReadingDto({
    required this.id,
    required this.value,
    required this.unit,
    required this.timestamp,
    required this.status,
  });

  factory IoTReadingDto.fromJson(Map<String, dynamic> json) {
    return IoTReadingDto(
      id: json['id'].toString(),
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      status: json['status'] ?? 'normal',
    );
  }

  IoTReading toDomain() {
    return IoTReading(
      id: id,
      value: value,
      unit: unit,
      timestamp: timestamp,
      status: _parseStatus(status),
    );
  }

  IoTStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'warning':
        return IoTStatus.warning;
      case 'critical':
        return IoTStatus.critical;
      default:
        return IoTStatus.normal;
    }
  }
}

class IoTSensorDto {
  final String id;
  final String code;
  final String type;
  final int equipmentId;
  final List<IoTReadingDto> readings;

  IoTSensorDto({
    required this.id,
    required this.code,
    required this.type,
    required this.equipmentId,
    required this.readings,
  });

  factory IoTSensorDto.fromJson(Map<String, dynamic> json) {
    List<IoTReadingDto> readingsList = [];
    if (json['iot_readings'] != null) {
      readingsList = (json['iot_readings'] as List)
          .map((e) => IoTReadingDto.fromJson(e))
          .toList();
    }

    return IoTSensorDto(
      id: json['id'].toString(),
      code: json['code'] ?? '',
      type: json['type'] ?? 'other',
      equipmentId: json['equipment_id'] ?? 0,
      readings: readingsList,
    );
  }

  IoTSensor toDomain() {
    return IoTSensor(
      id: id,
      code: code,
      type: _parseType(type),
      equipmentId: equipmentId,
      readings: readings.map((e) => e.toDomain()).toList(),
    );
  }

  IoTSensorType _parseType(String type) {
    switch (type.toLowerCase()) {
      case 'temperature':
        return IoTSensorType.temperature;
      case 'humidity':
        return IoTSensorType.humidity;
      case 'door_status':
      case 'doorstatus':
        return IoTSensorType.doorStatus;
      default:
        return IoTSensorType.other;
    }
  }
}
