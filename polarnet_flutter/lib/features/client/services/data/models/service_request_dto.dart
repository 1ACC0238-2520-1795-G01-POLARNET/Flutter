import 'package:polarnet_flutter/features/client/services/domain/models/service_request.dart';

class ServiceRequestDto {
  final int id;
  final int clientId;
  final int equipmentId;
  final String requestType;
  final String? description;
  final String? startDate;
  final String? endDate;
  final String status;
  final double totalPrice;
  final String? notes;
  final String? createdAt;

  ServiceRequestDto({
    required this.id,
    required this.clientId,
    required this.equipmentId,
    required this.requestType,
    this.description,
    this.startDate,
    this.endDate,
    required this.status,
    required this.totalPrice,
    this.notes,
    this.createdAt,
  });

  factory ServiceRequestDto.fromJson(Map<String, dynamic> json) {
    return ServiceRequestDto(
      id: json['id'] as int,
      clientId: json['client_id'] as int,
      equipmentId: json['equipment_id'] as int,
      requestType: json['request_type'] as String,
      description: json['description'] as String?,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      status: json['status'] as String,
      totalPrice: (json['total_price'] as num).toDouble(),
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'equipment_id': equipmentId,
      'request_type': requestType,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
      'total_price': totalPrice,
      'notes': notes,
      'created_at': createdAt,
    };
  }

  ServiceRequest toDomain() {
    return ServiceRequest(
      id: id,
      clientId: clientId,
      equipmentId: equipmentId,
      requestType: requestType,
      description: description,
      startDate: startDate,
      endDate: endDate,
      status: status,
      totalPrice: totalPrice,
      notes: notes,
      createdAt: createdAt,
      equipment: null,
    );
  }
}
