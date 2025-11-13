import 'package:polarnet_flutter/features/client/home/data/remote/models/equipment_dto.dart';

class ClientEquipmentDto {
  final int id;
  final int clientId;
  final int equipmentId;
  final String ownershipType;
  final String startDate;
  final String? endDate;
  final String status;
  final String? notes;
  final EquipmentDto? equipment;

  ClientEquipmentDto({
    required this.id,
    required this.clientId,
    required this.equipmentId,
    required this.ownershipType,
    required this.startDate,
    this.endDate,
    required this.status,
    this.notes,
    this.equipment,
  });

  factory ClientEquipmentDto.fromJson(Map<String, dynamic> json) {
    return ClientEquipmentDto(
      id: json['id'] as int,
      clientId: json['client_id'] as int,
      equipmentId: json['equipment_id'] as int,
      ownershipType: json['ownership_type'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String?,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      equipment: json['equipment'] != null
          ? EquipmentDto.fromJson(json['equipment'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'equipment_id': equipmentId,
      'ownership_type': ownershipType,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
      'notes': notes,
    };
  }
}
