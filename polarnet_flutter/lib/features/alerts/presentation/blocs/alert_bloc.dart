import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polarnet_flutter/features/alerts/domain/repositories/alert_repository.dart';
import 'package:polarnet_flutter/features/alerts/presentation/blocs/alert_event.dart';
import 'package:polarnet_flutter/features/alerts/presentation/blocs/alert_state.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  final AlertRepository _repository;

  AlertBloc(this._repository) : super(const AlertState()) {
    on<LoadAlerts>(_onLoadAlerts);
    on<LoadAlertsByProviderId>(_onLoadAlertsByProviderId);
    on<AcknowledgeAlert>(_onAcknowledgeAlert);
    on<AcknowledgeAllAlerts>(_onAcknowledgeAllAlerts);
    on<RefreshAlerts>(_onRefreshAlerts);
    on<FilterAlertsBySeverity>(_onFilterBySeverity);
    on<FilterAlertsByType>(_onFilterByType);
    on<ToggleShowAcknowledged>(_onToggleShowAcknowledged);
  }

  Future<void> _onLoadAlerts(LoadAlerts event, Emitter<AlertState> emit) async {
    emit(state.copyWith(status: AlertStatus.loading));

    try {
      developer.log('📢 [AlertBloc] Loading alerts...', name: 'PolarNet');
      final alerts = await _repository.getAlerts();
      developer.log(
        '✅ [AlertBloc] ${alerts.length} alerts loaded',
        name: 'PolarNet',
      );

      emit(state.copyWith(status: AlertStatus.loaded, allAlerts: alerts));
    } catch (e, stack) {
      developer.log(
        '❌ [AlertBloc] Error loading alerts: $e',
        name: 'PolarNet',
        error: e,
        stackTrace: stack,
      );

      emit(
        state.copyWith(
          status: AlertStatus.error,
          errorMessage: 'Error al cargar alertas: $e',
        ),
      );
    }
  }

  Future<void> _onLoadAlertsByProviderId(
    LoadAlertsByProviderId event,
    Emitter<AlertState> emit,
  ) async {
    emit(state.copyWith(status: AlertStatus.loading));

    try {
      developer.log(
        '📢 [AlertBloc] Loading alerts for provider ${event.providerId}...',
        name: 'PolarNet',
      );
      final alerts = await _repository.getAlertsByProviderId(event.providerId);
      developer.log(
        '✅ [AlertBloc] ${alerts.length} alerts loaded for provider',
        name: 'PolarNet',
      );
      emit(state.copyWith(status: AlertStatus.loaded, allAlerts: alerts));
    } catch (e) {
      emit(
        state.copyWith(
          status: AlertStatus.error,
          errorMessage: 'Error al cargar alertas: $e',
        ),
      );
    }
  }

  Future<void> _onAcknowledgeAlert(
    AcknowledgeAlert event,
    Emitter<AlertState> emit,
  ) async {
    try {
      await _repository.acknowledgeAlert(event.alertId);

      // Actualizar localmente
      final updatedAlerts = state.allAlerts.map((alert) {
        if (alert.id == event.alertId) {
          return alert.copyWith(isAcknowledged: true);
        }
        return alert;
      }).toList();

      emit(state.copyWith(allAlerts: updatedAlerts));
    } catch (e) {
      developer.log(
        '❌ [AlertBloc] Error acknowledging alert: $e',
        name: 'PolarNet',
      );
    }
  }

  Future<void> _onAcknowledgeAllAlerts(
    AcknowledgeAllAlerts event,
    Emitter<AlertState> emit,
  ) async {
    try {
      await _repository.acknowledgeAllAlerts();

      // Actualizar localmente
      final updatedAlerts = state.allAlerts
          .map((alert) => alert.copyWith(isAcknowledged: true))
          .toList();

      emit(state.copyWith(allAlerts: updatedAlerts));
    } catch (e) {
      developer.log(
        '❌ [AlertBloc] Error acknowledging all alerts: $e',
        name: 'PolarNet',
      );
    }
  }

  Future<void> _onRefreshAlerts(
    RefreshAlerts event,
    Emitter<AlertState> emit,
  ) async {
    try {
      final alerts = await _repository.getAlerts();
      emit(state.copyWith(allAlerts: alerts));
    } catch (e) {
      // Silent refresh, no emit error
    }
  }

  void _onFilterBySeverity(
    FilterAlertsBySeverity event,
    Emitter<AlertState> emit,
  ) {
    if (event.severity == null) {
      emit(state.copyWith(clearSeverityFilter: true));
    } else {
      emit(state.copyWith(severityFilter: event.severity));
    }
  }

  void _onFilterByType(FilterAlertsByType event, Emitter<AlertState> emit) {
    if (event.type == null) {
      emit(state.copyWith(clearTypeFilter: true));
    } else {
      emit(state.copyWith(typeFilter: event.type));
    }
  }

  void _onToggleShowAcknowledged(
    ToggleShowAcknowledged event,
    Emitter<AlertState> emit,
  ) {
    emit(state.copyWith(showAcknowledged: !state.showAcknowledged));
  }
}
