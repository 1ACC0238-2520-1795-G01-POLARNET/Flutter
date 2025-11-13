import 'dart:developer' as developer;
import 'package:polarnet_flutter/features/client/equipments/data/remote/models/client_equipment_dto.dart';
import 'package:polarnet_flutter/features/client/equipments/data/remote/services/client_equipment_service.dart';
import 'package:polarnet_flutter/features/client/equipments/domain/models/client_equipment.dart';
import 'package:polarnet_flutter/features/client/equipments/domain/repositories/client_equipment_repository.dart';
import 'package:polarnet_flutter/shared/domain/models/equipment.dart';

class ClientEquipmentRepositoryImpl implements ClientEquipmentRepository {
  final ClientEquipmentService service;

  ClientEquipmentRepositoryImpl(this.service);

  @override
  Future<List<ClientEquipment>> getClientEquipments(int clientId) async {
    try {
      developer.log(
        '📡 [CLIENT_EQUIPMENT_REPO] Obteniendo equipos del cliente: $clientId',
        name: 'PolarNet',
      );

      final dtos = await service.getClientEquipmentsByClientId(clientId);

      developer.log(
        '✅ [CLIENT_EQUIPMENT_REPO] Equipos obtenidos: ${dtos.length}',
        name: 'PolarNet',
      );

      return dtos.map((dto) => _mapDtoToDomain(dto)).toList();
    } catch (e, stack) {
      developer.log(
        '❌ [CLIENT_EQUIPMENT_REPO] Error obteniendo equipos: $e',
        name: 'PolarNet',
        error: e,
        stackTrace: stack,
      );
      return [];
    }
  }

  @override
  Future<ClientEquipment?> getClientEquipmentById(int id) async {
    try {
      developer.log(
        '📡 [CLIENT_EQUIPMENT_REPO] Obteniendo client_equipment con ID: $id',
        name: 'PolarNet',
      );

      final dto = await service.getClientEquipmentById(id);
      if (dto == null) {
        developer.log(
          '⚠️ [CLIENT_EQUIPMENT_REPO] No se encontró client_equipment con ID: $id',
          name: 'PolarNet',
        );
        return null;
      }

      developer.log(
        '✅ [CLIENT_EQUIPMENT_REPO] Client_equipment encontrado: ${dto.id}',
        name: 'PolarNet',
      );

      return _mapDtoToDomain(dto);
    } catch (e, stack) {
      developer.log(
        '❌ [CLIENT_EQUIPMENT_REPO] Error obteniendo client_equipment: $e',
        name: 'PolarNet',
        error: e,
        stackTrace: stack,
      );
      return null;
    }
  }

  @override
  Future<void> insert(ClientEquipment clientEquipment) async {
    try {
      developer.log(
        '📡 [CLIENT_EQUIPMENT_REPO] Insertando client_equipment',
        name: 'PolarNet',
      );

      final dto = _mapDomainToDto(clientEquipment);
      await service.insertClientEquipment(dto);

      developer.log(
        '✅ [CLIENT_EQUIPMENT_REPO] Client_equipment insertado exitosamente',
        name: 'PolarNet',
      );
    } catch (e, stack) {
      developer.log(
        '❌ [CLIENT_EQUIPMENT_REPO] Error insertando client_equipment: $e',
        name: 'PolarNet',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  @override
  Future<void> delete(ClientEquipment clientEquipment) async {
    try {
      developer.log(
        '📡 [CLIENT_EQUIPMENT_REPO] Eliminando client_equipment ID: ${clientEquipment.id}',
        name: 'PolarNet',
      );

      await service.deleteClientEquipment(clientEquipment.id);

      developer.log(
        '✅ [CLIENT_EQUIPMENT_REPO] Client_equipment eliminado exitosamente',
        name: 'PolarNet',
      );
    } catch (e, stack) {
      developer.log(
        '❌ [CLIENT_EQUIPMENT_REPO] Error eliminando client_equipment: $e',
        name: 'PolarNet',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  // Mappers
  ClientEquipment _mapDtoToDomain(ClientEquipmentDto dto) {
    return ClientEquipment(
      id: dto.id,
      clientId: dto.clientId,
      equipmentId: dto.equipmentId,
      ownershipType: dto.ownershipType,
      startDate: dto.startDate,
      endDate: dto.endDate,
      status: dto.status,
      notes: dto.notes,
      equipment: dto.equipment != null
          ? Equipment(
              id: dto.equipment!.id,
              providerId: dto.equipment!.providerId,
              name: dto.equipment!.name,
              brand: dto.equipment!.brand,
              model: dto.equipment!.model,
              category: dto.equipment!.category,
              description: dto.equipment!.description,
              thumbnail: dto.equipment!.thumbnail,
              specifications: dto.equipment!.specifications,
              available: dto.equipment!.available,
              location: dto.equipment!.location,
              pricePerMonth: dto.equipment!.pricePerMonth,
              purchasePrice: dto.equipment!.purchasePrice,
              createdAt: dto.equipment!.createdAt,
              updatedAt: dto.equipment!.updatedAt,
            )
          : null,
    );
  }

  ClientEquipmentDto _mapDomainToDto(ClientEquipment domain) {
    return ClientEquipmentDto(
      id: domain.id,
      clientId: domain.clientId,
      equipmentId: domain.equipmentId,
      ownershipType: domain.ownershipType,
      startDate: domain.startDate,
      endDate: domain.endDate,
      status: domain.status,
      notes: domain.notes,
      equipment: null, // No se envía el equipment anidado en POST/DELETE
    );
  }
}
