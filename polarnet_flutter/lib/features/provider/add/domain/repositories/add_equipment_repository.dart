import 'package:polarnet_flutter/shared/domain/models/equipment.dart';

abstract class AddEquipmentRepository {
  Future<bool> addEquipment(Equipment equipment);
}
