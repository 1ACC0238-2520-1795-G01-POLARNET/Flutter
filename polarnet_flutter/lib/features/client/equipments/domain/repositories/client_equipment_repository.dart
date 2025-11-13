import '../models/client_equipment.dart';

abstract class ClientEquipmentRepository {
  Future<List<ClientEquipment>> getClientEquipments(int clientId);
  Future<ClientEquipment?> getClientEquipmentById(int id);
  Future<void> insert(ClientEquipment clientEquipment);
  Future<void> delete(ClientEquipment clientEquipment);
}
