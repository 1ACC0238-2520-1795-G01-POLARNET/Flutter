import 'package:polarnet_flutter/features/alerts/domain/models/alert.dart';

abstract class AlertRepository {
  Future<List<Alert>> getAlerts();
  Future<List<Alert>> getAlertsByProviderId(String providerId);
  Future<void> createAlert(Alert alert);
  Future<void> acknowledgeAlert(String alertId);
  Future<void> acknowledgeAllAlerts();
}
