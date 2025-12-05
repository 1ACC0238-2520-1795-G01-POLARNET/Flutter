import 'package:polarnet_flutter/features/alerts/data/models/alert_dto.dart';
import 'package:polarnet_flutter/features/alerts/data/remote/alert_service.dart';
import 'package:polarnet_flutter/features/alerts/domain/models/alert.dart';
import 'package:polarnet_flutter/features/alerts/domain/repositories/alert_repository.dart';

class AlertRepositoryImpl implements AlertRepository {
  final AlertService _service;
  final bool _useFakeData = false;

  // Cache local para simular acknowledge en modo fake
  final Set<String> _acknowledgedIds = {};

  AlertRepositoryImpl(this._service);

  @override
  Future<List<Alert>> getAlerts() async {
    if (_useFakeData) {
      return [];
    }

    final dtos = await _service.getAlerts();
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<Alert>> getAlertsByProviderId(String providerId) async {
    if (_useFakeData) {
      return [];
    }

    final dtos = await _service.getAlertsByProviderId(providerId);
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> createAlert(Alert alert) async {
    if (_useFakeData) {
      return;
    }

    final dto = AlertDto(
      id: alert.id,
      type: alert.type,
      value: alert.value,
      minAllowed: alert.minAllowed,
      maxAllowed: alert.maxAllowed,
      timestamp: alert.timestamp.toIso8601String(),
      severity: alert.severity,
      message: alert.message,
      isAcknowledged: alert.isAcknowledged,
      clientId: alert.clientId,
      providerId: alert.providerId,
    );

    await _service.createAlert(dto);
  }

  @override
  Future<void> acknowledgeAlert(String alertId) async {
    if (_useFakeData) {
      _acknowledgedIds.add(alertId);
      return;
    }

    await _service.acknowledgeAlert(alertId);
  }

  @override
  Future<void> acknowledgeAllAlerts() async {
    if (_useFakeData) {
      return;
    }

    await _service.acknowledgeAllAlerts();
  }
}
