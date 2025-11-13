import 'package:polarnet_flutter/features/auth/data/models/user_dto.dart';
import 'package:polarnet_flutter/features/provider/home/domain/models/provider_service_request.dart';
import 'package:polarnet_flutter/features/client/home/data/remote/models/equipment_dto.dart';
import 'package:polarnet_flutter/shared/domain/models/equipment.dart';

class ProviderServiceRequestDto {
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
  final EquipmentDto? equipment;
  final UserDto? client;

  ProviderServiceRequestDto({
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

  factory ProviderServiceRequestDto.fromJson(Map<String, dynamic> json) {
    return ProviderServiceRequestDto(
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
      equipment: json['equipment'] != null
          ? EquipmentDto.fromJson(json['equipment'] as Map<String, dynamic>)
          : null,
      client: json['client'] != null
          ? UserDto.fromJson(json['client'] as Map<String, dynamic>)
          : null,
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

  ProviderServiceRequest toDomain() {
    return ProviderServiceRequest(
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
      equipment: equipment != null
          ? Equipment(
              id: equipment!.id,
              providerId: equipment!.providerId,
              name: equipment!.name,
              brand: equipment!.brand,
              model: equipment!.model,
              category: equipment!.category,
              description: equipment!.description,
              thumbnail: equipment!.thumbnail,
              specifications: equipment!.specifications,
              available: equipment!.available,
              location: equipment!.location,
              pricePerMonth: equipment!.pricePerMonth,
              purchasePrice: equipment!.purchasePrice,
              createdAt: equipment!.createdAt,
              updatedAt: equipment!.updatedAt,
            )
          : null,
      client: client?.toDomain(),
    );
  }
}
