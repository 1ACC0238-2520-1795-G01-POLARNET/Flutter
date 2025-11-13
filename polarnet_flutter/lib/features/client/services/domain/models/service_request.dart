import 'package:polarnet_flutter/shared/domain/models/equipment.dart';

class ServiceRequest {
  final int id;
  final int clientId;
  final int equipmentId;
  final String requestType; // "rental", "maintenance", "installation"
  final String? description;
  final String? startDate;
  final String? endDate;
  final String status; // "pending", "in_progress", "completed", "cancelled"
  final double totalPrice;
  final String? notes;
  final String? createdAt;
  final Equipment? equipment;

  ServiceRequest({
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
    this.equipment,
  });

  ServiceRequest copyWith({
    int? id,
    int? clientId,
    int? equipmentId,
    String? requestType,
    String? description,
    String? startDate,
    String? endDate,
    String? status,
    double? totalPrice,
    String? notes,
    String? createdAt,
    Equipment? equipment,
  }) {
    return ServiceRequest(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      equipmentId: equipmentId ?? this.equipmentId,
      requestType: requestType ?? this.requestType,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      equipment: equipment ?? this.equipment,
    );
  }
}
