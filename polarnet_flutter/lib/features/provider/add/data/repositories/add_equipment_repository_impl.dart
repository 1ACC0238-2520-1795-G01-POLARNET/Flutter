import 'package:polarnet_flutter/features/provider/add/data/models/create_equipment_dto.dart';
import 'package:polarnet_flutter/features/provider/add/data/remote/add_equipment_service.dart';
import 'package:polarnet_flutter/features/provider/add/domain/repositories/add_equipment_repository.dart';
import 'package:polarnet_flutter/shared/domain/models/equipment.dart';

class AddEquipmentRepositoryImpl implements AddEquipmentRepository {
  final AddEquipmentService _service;

  AddEquipmentRepositoryImpl(this._service);

  @override
  Future<bool> addEquipment(Equipment equipment) async {
    try {
      final dto = CreateEquipmentDto(
        providerId: equipment.providerId,
        name: equipment.name,
        brand: equipment.brand,
        model: equipment.model,
        category: equipment.category,
        description: equipment.description,
        thumbnail: equipment.thumbnail,
        specifications: equipment.specifications,
        available: equipment.available,
        location: equipment.location,
        pricePerMonth: equipment.pricePerMonth,
        purchasePrice: equipment.purchasePrice,
      );

      final result = await _service.createEquipment(dto);

      if (result != null) {
        return true;
      }

      return false;
    } catch (e) {
      throw Exception('Error adding equipment: $e');
    }
  }
}
