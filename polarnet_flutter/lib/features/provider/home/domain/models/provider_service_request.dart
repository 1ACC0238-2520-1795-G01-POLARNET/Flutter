import 'package:polarnet_flutter/features/auth/domain/models/user.dart';
import 'package:polarnet_flutter/shared/domain/models/equipment.dart';

class ProviderServiceRequest {
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
  final Equipment? equipment;
  final User? client;

  ProviderServiceRequest({
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
    this.client,
  });

  ProviderServiceRequest copyWith({
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
    User? client,
  }) {
    return ProviderServiceRequest(
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
      client: client ?? this.client,
    );
  }
}
