import 'package:polarnet_flutter/features/iot/domain/models/iot_sensor.dart';

abstract class IoTRepository {
  Future<List<IoTSensor>> getEquipmentSensors(int equipmentId);
}
