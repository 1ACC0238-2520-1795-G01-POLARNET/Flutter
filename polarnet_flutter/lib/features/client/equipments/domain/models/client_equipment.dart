import 'package:polarnet_flutter/shared/domain/models/equipment.dart';

class ClientEquipment {
  final int id;
  final int clientId;
  final int equipmentId;
  final String ownershipType; // "rented" o "owned"
  final String startDate;
  final String? endDate;
  final String status; // "active", "returned", "pending"
  final String? notes;
  final Equipment? equipment; // Relación anidada

  ClientEquipment({
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

  // Helper para verificar si está activo
  bool get isActive => status == 'active';

  // Helper para verificar si es rentado
  bool get isRented => ownershipType == 'rented';

  // Helper para verificar si es propio
  bool get isOwned => ownershipType == 'owned';
}
