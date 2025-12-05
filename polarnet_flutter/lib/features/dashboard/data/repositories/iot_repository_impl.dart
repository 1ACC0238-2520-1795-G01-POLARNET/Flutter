import 'dart:math';
import 'package:polarnet_flutter/features/alerts/data/models/alert_dto.dart';
import 'package:polarnet_flutter/features/alerts/data/remote/alert_service.dart';
import 'package:polarnet_flutter/features/dashboard/data/remote/iot_service.dart';
import 'package:polarnet_flutter/features/dashboard/domain/models/iot_sensor.dart';
import 'package:polarnet_flutter/features/dashboard/domain/repositories/iot_repository.dart';
import 'package:polarnet_flutter/features/notification/data/models/notification_dto.dart';
import 'package:polarnet_flutter/features/notification/data/remote/notification_service.dart';

class IoTRepositoryImpl implements IoTRepository {
  final IoTService _service;
  final AlertService? _alertService;
  final NotificationService? _notificationService;
  // Flag para usar datos fake durante desarrollo
  final bool _useFakeData = true;

  // Contador para generar anomalías cada cierto número de llamadas
  static int _callCounter = 0;
  static const int _anomalyInterval =
      5; // Generar anomalía cada 5 llamadas (15 segundos con refresh de 3s)

  // Para evitar alertas duplicadas
  static final Set<String> _recentAlertIds = {};

  // IDs del cliente y provider, y nombre del equipo
  String? _clientId;
  String? _providerId;
  String? _equipmentName;

  IoTRepositoryImpl(
    this._service, [
    this._alertService,
    this._notificationService,
  ]);

  @override
  void setUserIds({
    String? clientId,
    String? providerId,
    String? equipmentName,
  }) {
    _clientId = clientId;
    _providerId = providerId;
    _equipmentName = equipmentName;
  }

  @override
  Future<List<IoTSensor>> getEquipmentSensors(int equipmentId) async {
    // Obtener el client_id del equipo alquilado si no lo tenemos
    _clientId ??= await _service.getActiveClientForEquipment(equipmentId);

    if (_useFakeData) {
      _callCounter++;
      final shouldGenerateAnomaly = _callCounter % _anomalyInterval == 0;
      return _generateFakeSensors(
        equipmentId,
        forceAnomaly: shouldGenerateAnomaly,
      );
    }

    final data = await _service.getSensorsByEquipment(equipmentId);
    return data.map((e) => e.toDomain()).toList();
  }

  /// Genera sensores fake con datos realistas para pruebas
  List<IoTSensor> _generateFakeSensors(
    int equipmentId, {
    bool forceAnomaly = false,
  }) {
    final random = Random();
    final now = DateTime.now();

    // Seleccionar qué tipo de anomalía generar
    final anomalyType = forceAnomaly ? random.nextInt(4) : -1;

    // Generar lecturas de las últimas 24 horas (una cada hora)
    List<IoTReading> generateReadings({
      required double baseValue,
      required double variation,
      required String unit,
      double? criticalThreshold,
      double? warningThreshold,
      double? minAllowed,
      bool isAnomalous = false,
      required String sensorType,
    }) {
      return List.generate(24, (i) {
        final timestamp = now.subtract(Duration(hours: 23 - i));
        // Simular variación diaria (más alto al mediodía)
        final hourFactor = (12 - (timestamp.hour - 12).abs()) / 12;
        double value =
            baseValue +
            (variation * hourFactor) +
            (random.nextDouble() * 2 - 1);

        // Si es la lectura más reciente y debe ser anómala
        if (i == 23 && isAnomalous) {
          // Generar valor anómalo que supere el umbral crítico
          if (criticalThreshold != null) {
            value = criticalThreshold + (random.nextDouble() * 10) + 3;
          } else if (minAllowed != null) {
            value = minAllowed - (random.nextDouble() * 10) - 3;
          }

          // Crear alerta para este valor anómalo
          _createAnomalyAlert(
            sensorType: sensorType,
            value: value,
            minAllowed: minAllowed,
            maxAllowed: criticalThreshold,
            unit: unit,
            equipmentId: equipmentId,
          );
        }

        IoTStatus status = IoTStatus.normal;
        if (criticalThreshold != null && value >= criticalThreshold) {
          status = IoTStatus.critical;
        } else if (warningThreshold != null && value >= warningThreshold) {
          status = IoTStatus.warning;
        } else if (minAllowed != null && value < minAllowed) {
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
    List<IoTReading> generateDoorReadings({bool isAnomalous = false}) {
      return List.generate(24, (i) {
        final timestamp = now.subtract(Duration(hours: 23 - i));
        bool isOpen = random.nextDouble() < 0.1;

        // Si es la lectura más reciente y debe ser anómala (puerta abierta)
        if (i == 23 && isAnomalous) {
          isOpen = true;
          _createAnomalyAlert(
            sensorType: 'doorStatus',
            value: 1,
            unit: 'Abierta',
            equipmentId: equipmentId,
          );
        }

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
          minAllowed: 18.0,
          sensorType: 'temperature',
          isAnomalous: anomalyType == 0,
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
          minAllowed: 30.0,
          sensorType: 'humidity',
          isAnomalous: anomalyType == 1,
        ),
      ),
      IoTSensor(
        id: 'sensor_door_001',
        code: 'DOOR-001',
        type: IoTSensorType.doorStatus,
        equipmentId: equipmentId,
        readings: generateDoorReadings(isAnomalous: anomalyType == 2),
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
          minAllowed: 200.0,
          sensorType: 'voltage',
          isAnomalous: anomalyType == 3,
        ),
      ),
    ];
  }

  /// Crea una alerta por valor anómalo y la guarda en Supabase
  Future<void> _createAnomalyAlert({
    required String sensorType,
    required double value,
    double? minAllowed,
    double? maxAllowed,
    required String unit,
    required int equipmentId,
  }) async {
    if (_alertService == null) return;

    final now = DateTime.now();
    final alertId =
        'alert_${sensorType}_${equipmentId}_${now.millisecondsSinceEpoch}';

    // Evitar crear alertas duplicadas en corto tiempo
    final recentKey = '${sensorType}_$equipmentId';
    if (_recentAlertIds.contains(recentKey)) {
      return;
    }
    _recentAlertIds.add(recentKey);

    // Limpiar alertas recientes después de 30 segundos
    Future.delayed(const Duration(seconds: 30), () {
      _recentAlertIds.remove(recentKey);
    });

    // Determinar severidad y mensaje
    String severity;
    String message;
    String typeName;

    switch (sensorType) {
      case 'temperature':
        typeName = 'Temperatura';
        if (maxAllowed != null && value > maxAllowed) {
          severity = value > maxAllowed + 5 ? 'critical' : 'high';
          message =
              'Temperatura crítica: ${value.toStringAsFixed(1)}$unit supera el máximo de ${maxAllowed.toStringAsFixed(1)}$unit';
        } else if (minAllowed != null && value < minAllowed) {
          severity = value < minAllowed - 5 ? 'critical' : 'high';
          message =
              'Temperatura baja: ${value.toStringAsFixed(1)}$unit por debajo del mínimo de ${minAllowed.toStringAsFixed(1)}$unit';
        } else {
          severity = 'medium';
          message = 'Alerta de temperatura: ${value.toStringAsFixed(1)}$unit';
        }
        break;
      case 'humidity':
        typeName = 'Humedad';
        if (maxAllowed != null && value > maxAllowed) {
          severity = value > maxAllowed + 10 ? 'critical' : 'high';
          message =
              'Humedad elevada: ${value.toStringAsFixed(1)}$unit supera el máximo de ${maxAllowed.toStringAsFixed(1)}$unit';
        } else if (minAllowed != null && value < minAllowed) {
          severity = value < minAllowed - 10 ? 'critical' : 'high';
          message =
              'Humedad baja: ${value.toStringAsFixed(1)}$unit por debajo del mínimo de ${minAllowed.toStringAsFixed(1)}$unit';
        } else {
          severity = 'medium';
          message = 'Alerta de humedad: ${value.toStringAsFixed(1)}$unit';
        }
        break;
      case 'voltage':
        typeName = 'Voltaje';
        if (maxAllowed != null && value > maxAllowed) {
          severity = value > maxAllowed + 5 ? 'critical' : 'high';
          message =
              'Sobrevoltaje detectado: ${value.toStringAsFixed(1)}$unit supera el máximo de ${maxAllowed.toStringAsFixed(1)}$unit';
        } else if (minAllowed != null && value < minAllowed) {
          severity = value < minAllowed - 10 ? 'critical' : 'high';
          message =
              'Bajo voltaje: ${value.toStringAsFixed(1)}$unit por debajo del mínimo de ${minAllowed.toStringAsFixed(1)}$unit';
        } else {
          severity = 'medium';
          message = 'Alerta de voltaje: ${value.toStringAsFixed(1)}$unit';
        }
        break;
      case 'doorStatus':
        typeName = 'Puerta';
        severity = 'medium';
        message = 'Puerta abierta detectada en equipo #$equipmentId';
        break;
      default:
        typeName = 'Sensor';
        severity = 'low';
        message = 'Valor anómalo detectado: ${value.toStringAsFixed(1)}$unit';
    }

    try {
      final alertDto = AlertDto(
        id: alertId,
        type: sensorType,
        value: value,
        minAllowed: minAllowed,
        maxAllowed: maxAllowed,
        timestamp: now.toIso8601String(),
        severity: severity,
        message: message,
        isAcknowledged: false,
        clientId: _clientId ?? equipmentId.toString(),
        providerId: _providerId ?? equipmentId.toString(),
      );

      await _alertService.createAlert(alertDto);
      // ignore: avoid_print
      print('✅ Alerta creada: $typeName - $message');

      // Crear notificaciones para cliente y proveedor
      await _createNotificationsForAlert(
        alertId: alertId,
        sensorType: sensorType,
        typeName: typeName,
        severity: severity,
        message: message,
        equipmentId: equipmentId,
      );
    } catch (e) {
      // ignore: avoid_print
      print('❌ Error al crear alerta: $e');
    }
  }

  /// Crea notificaciones para el cliente y proveedor cuando se genera una alerta
  Future<void> _createNotificationsForAlert({
    required String alertId,
    required String sensorType,
    required String typeName,
    required String severity,
    required String message,
    required int equipmentId,
  }) async {
    if (_notificationService == null) return;

    final now = DateTime.now();
    final equipmentLabel = _equipmentName ?? 'Equipo #$equipmentId';
    final notificationTitle = '⚠️ Alerta de $typeName - $equipmentLabel';

    // Crear notificación para el proveedor
    if (_providerId != null) {
      try {
        final providerNotification = NotificationDto(
          id: 'notif_provider_$alertId',
          userId: _providerId!,
          role: 'provider',
          type: 'alert',
          title: notificationTitle,
          message: '[$equipmentLabel] $message',
          timestamp: now,
          isRead: false,
        );
        await _notificationService.createNotification(providerNotification);
        // ignore: avoid_print
        print('✅ Notificación creada para proveedor: $_providerId');
      } catch (e) {
        // ignore: avoid_print
        print('❌ Error al crear notificación para proveedor: $e');
      }
    }

    // Crear notificación para el cliente
    if (_clientId != null) {
      try {
        final clientNotification = NotificationDto(
          id: 'notif_client_$alertId',
          userId: _clientId!,
          role: 'client',
          type: 'alert',
          title: notificationTitle,
          message:
              'Se detectó una anomalía en "$equipmentLabel": $message. El proveedor ya ha sido notificado y está monitoreando la situación.',
          timestamp: now,
          isRead: false,
        );
        await _notificationService.createNotification(clientNotification);
        // ignore: avoid_print
        print('✅ Notificación creada para cliente: $_clientId');
      } catch (e) {
        // ignore: avoid_print
        print('❌ Error al crear notificación para cliente: $e');
      }
    }
  }
}
