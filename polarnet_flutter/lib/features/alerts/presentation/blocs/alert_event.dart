import 'package:equatable/equatable.dart';

abstract class AlertEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAlerts extends AlertEvent {}

class LoadAlertsByProviderId extends AlertEvent {
  final String providerId;
  LoadAlertsByProviderId(this.providerId);

  @override
  List<Object?> get props => [providerId];
}

class AcknowledgeAlert extends AlertEvent {
  final String alertId;
  AcknowledgeAlert(this.alertId);

  @override
  List<Object?> get props => [alertId];
}

class AcknowledgeAllAlerts extends AlertEvent {}

class RefreshAlerts extends AlertEvent {}

class FilterAlertsBySeverity extends AlertEvent {
  final String? severity; // null = all
  FilterAlertsBySeverity(this.severity);

  @override
  List<Object?> get props => [severity];
}

class FilterAlertsByType extends AlertEvent {
  final String? type; // null = all
  FilterAlertsByType(this.type);

  @override
  List<Object?> get props => [type];
}

class ToggleShowAcknowledged extends AlertEvent {}
