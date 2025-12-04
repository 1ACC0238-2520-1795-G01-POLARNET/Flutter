import 'dart:math';
import 'package:polarnet_flutter/features/dashboard/data/remote/iot_service.dart';
import 'package:polarnet_flutter/features/dashboard/domain/models/iot_sensor.dart';
import 'package:polarnet_flutter/features/dashboard/domain/repositories/iot_repository.dart';

class IoTRepositoryImpl implements IoTRepository {
  final IoTService _service;
  // Flag para usar datos fake durante desarrollo
  final bool _useFakeData = true;

  IoTRepositoryImpl(this._service);

  @override
  Future<List<IoTSensor>> getEquipmentSensors(int equipmentId) async {
    if (_useFakeData) {
      return _generateFakeSensors(equipmentId);
    }

    final data = await _service.getSensorsByEquipment(equipmentId);
    return data.map((e) => e.toDomain()).toList();
  }

  /// Genera sensores fake con datos realistas para pruebas
  List<IoTSensor> _generateFakeSensors(int equipmentId) {
    final random = Random();
    final now = DateTime.now();

    // Generar lecturas de las últimas 24 horas (una cada hora)
    List<IoTReading> generateReadings({
      required double baseValue,
      required double variation,
      required String unit,
      double? criticalThreshold,
      double? warningThreshold,
    }) {
      return List.generate(24, (i) {
        final timestamp = now.subtract(Duration(hours: 23 - i));
        // Simular variación diaria (más alto al mediodía)
        final hourFactor = (12 - (timestamp.hour - 12).abs()) / 12;
        final value =
            baseValue +
            (variation * hourFactor) +
            (random.nextDouble() * 2 - 1);

        IoTStatus status = IoTStatus.normal;
        if (criticalThreshold != null && value >= criticalThreshold) {
          status = IoTStatus.critical;
        } else if (warningThreshold != null && value >= warningThreshold) {
          status = IoTStatus.warning;
        }

        return IoTReading(
          id: 'reading_${i}_${random.nextInt(1000)}',
          value: double.parse(value.toStringAsFixed(1)),
          unit: unit,
          timestamp: timestamp,
          status: status,
        );
      });
    }

    // Generar lecturas para sensor de puerta
    List<IoTReading> generateDoorReadings() {
      return List.generate(24, (i) {
        final timestamp = now.subtract(Duration(hours: 23 - i));
        // Puerta abierta ocasionalmente (10% del tiempo)
        final isOpen = random.nextDouble() < 0.1;
        return IoTReading(
          id: 'door_reading_${i}_${random.nextInt(1000)}',
          value: isOpen ? 1 : 0,
          unit: isOpen ? 'Abierta' : 'Cerrada',
          timestamp: timestamp,
          status: isOpen ? IoTStatus.warning : IoTStatus.normal,
        );
      });
    }

    return [
      IoTSensor(
        id: 'sensor_temp_001',
        code: 'TEMP-001',
        type: IoTSensorType.temperature,
        equipmentId: equipmentId,
        readings: generateReadings(
          baseValue: 22.0,
          variation: 5.0,
          unit: '°C',
          warningThreshold: 28.0,
          criticalThreshold: 32.0,
        ),
      ),
      IoTSensor(
        id: 'sensor_hum_001',
        code: 'HUM-001',
        type: IoTSensorType.humidity,
        equipmentId: equipmentId,
        readings: generateReadings(
          baseValue: 45.0,
          variation: 15.0,
          unit: '%',
          warningThreshold: 70.0,
          criticalThreshold: 85.0,
        ),
      ),
      IoTSensor(
        id: 'sensor_door_001',
        code: 'DOOR-001',
        type: IoTSensorType.doorStatus,
        equipmentId: equipmentId,
        readings: generateDoorReadings(),
      ),
      IoTSensor(
        id: 'sensor_volt_001',
        code: 'VOLT-001',
        type: IoTSensorType.other, // Voltaje
        equipmentId: equipmentId,
        readings: generateReadings(
          baseValue: 220.0,
          variation: 5.0,
          unit: 'V',
          warningThreshold: 230.0,
          criticalThreshold: 240.0,
        ),
      ),
    ];
  }
}
