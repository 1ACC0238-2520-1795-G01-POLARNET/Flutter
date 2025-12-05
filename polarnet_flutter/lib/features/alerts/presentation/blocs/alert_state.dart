import 'package:equatable/equatable.dart';
import 'package:polarnet_flutter/features/alerts/domain/models/alert.dart';

enum AlertStatus { initial, loading, loaded, error }

class AlertState extends Equatable {
  final AlertStatus status;
  final List<Alert> allAlerts;
  final String? errorMessage;
  final String? severityFilter;
  final String? typeFilter;
  final bool showAcknowledged;

  const AlertState({
    this.status = AlertStatus.initial,
    this.allAlerts = const [],
    this.errorMessage,
    this.severityFilter,
    this.typeFilter,
    this.showAcknowledged = true,
  });

  List<Alert> get filteredAlerts {
    return allAlerts.where((alert) {
      // Filtrar por acknowledged
      if (!showAcknowledged && alert.isAcknowledged) {
        return false;
      }

      // Filtrar por severidad
      if (severityFilter != null && alert.severity != severityFilter) {
        return false;
      }

      // Filtrar por tipo
      if (typeFilter != null && alert.type != typeFilter) {
        return false;
      }

      return true;
    }).toList();
  }

  int get unacknowledgedCount =>
      allAlerts.where((a) => !a.isAcknowledged).length;

  int get criticalCount => allAlerts
      .where((a) => a.severity == 'critical' && !a.isAcknowledged)
      .length;

  AlertState copyWith({
    AlertStatus? status,
    List<Alert>? allAlerts,
    String? errorMessage,
    String? severityFilter,
    String? typeFilter,
    bool? showAcknowledged,
    bool clearSeverityFilter = false,
    bool clearTypeFilter = false,
  }) {
    return AlertState(
      status: status ?? this.status,
      allAlerts: allAlerts ?? this.allAlerts,
      errorMessage: errorMessage ?? this.errorMessage,
      severityFilter: clearSeverityFilter
          ? null
          : (severityFilter ?? this.severityFilter),
      typeFilter: clearTypeFilter ? null : (typeFilter ?? this.typeFilter),
      showAcknowledged: showAcknowledged ?? this.showAcknowledged,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allAlerts,
    errorMessage,
    severityFilter,
    typeFilter,
    showAcknowledged,
  ];
}
