import 'package:polarnet_flutter/features/dashboard/domain/models/iot_sensor.dart';

abstract class IoTRepository {
  Future<List<IoTSensor>> getEquipmentSensors(int equipmentId);
  void setUserIds({
    String? clientId,
    String? providerId,
    String? equipmentName,
  });
}
