import 'package:polarnet_flutter/features/alerts/domain/models/alert.dart';

class AlertDto {
  final String id;
  final String type;
  final double value;
  final double? minAllowed;
  final double? maxAllowed;
  final String timestamp;
  final String severity;
  final String message;
  final bool isAcknowledged;
  final int? equipmentId;
  final String? clientId;
  final String? providerId;

  AlertDto({
    required this.id,
    required this.type,
    required this.value,
    this.minAllowed,
    this.maxAllowed,
    required this.timestamp,
    required this.severity,
    required this.message,
    this.isAcknowledged = false,
    this.equipmentId,
    this.clientId,
    this.providerId,
  });

  factory AlertDto.fromJson(Map<String, dynamic> json) {
    return AlertDto(
      id: json['id'].toString(),
      type: json['type'] as String,
      value: (json['value'] as num).toDouble(),
      minAllowed: json['min_allowed'] != null
          ? (json['min_allowed'] as num).toDouble()
          : null,
      maxAllowed: json['max_allowed'] != null
          ? (json['max_allowed'] as num).toDouble()
          : null,
      timestamp: json['timestamp'] as String,
      severity: json['severity'] as String,
      message: json['message'] as String,
      isAcknowledged: json['is_acknowledged'] as bool? ?? false,
      equipmentId: json['equipment_id'] as int?,
      clientId: json['client_id'] as String?,
      providerId: json['provider_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'value': value,
      'min_allowed': minAllowed,
      'max_allowed': maxAllowed,
      'timestamp': timestamp,
      'severity': severity,
      'message': message,
      'is_acknowledged': isAcknowledged,
      'client_id': clientId,
      'provider_id': providerId,
    };
  }

  Alert toDomain() {
    return Alert(
      id: id,
      type: type,
      value: value,
      minAllowed: minAllowed,
      maxAllowed: maxAllowed,
      timestamp: DateTime.parse(timestamp),
      severity: severity,
      message: message,
      isAcknowledged: isAcknowledged,
      clientId: clientId,
      providerId: providerId,
    );
  }
}
