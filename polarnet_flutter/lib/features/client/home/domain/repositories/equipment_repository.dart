 import '../../../../../shared/domain/models/equipment.dart';

abstract class EquipmentRepository {
  Future<List<Equipment>> getAllEquipments();
  Future<Equipment?> getEquipmentById(int id);
}
