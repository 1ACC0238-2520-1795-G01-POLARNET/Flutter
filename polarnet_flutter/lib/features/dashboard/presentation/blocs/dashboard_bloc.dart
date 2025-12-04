import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polarnet_flutter/features/dashboard/domain/repositories/iot_repository.dart';
import 'package:polarnet_flutter/features/dashboard/presentation/blocs/dashboard_event.dart';
import 'package:polarnet_flutter/features/dashboard/presentation/blocs/dashboard_state.dart';

class IoTBloc extends Bloc<IoTEvent, IoTState> {
  final IoTRepository repository;
  Timer? _autoRefreshTimer;

  IoTBloc(this.repository) : super(IoTInitial()) {
    on<LoadIoTData>(_onLoadIoTData);
    on<RefreshIoTData>(_onRefreshIoTData);
    on<StartAutoRefresh>(_onStartAutoRefresh);
    on<StopAutoRefresh>(_onStopAutoRefresh);
  }

  Future<void> _onLoadIoTData(LoadIoTData event, Emitter<IoTState> emit) async {
    emit(IoTLoading());
    try {
      final sensors = await repository.getEquipmentSensors(event.equipmentId);
      emit(IoTLoaded(sensors));
    } catch (e) {
      emit(IoTError(e.toString()));
    }
  }

  Future<void> _onRefreshIoTData(
    RefreshIoTData event,
    Emitter<IoTState> emit,
  ) async {
    // Refresh sin mostrar loading (actualización silenciosa)
    try {
      final sensors = await repository.getEquipmentSensors(event.equipmentId);
      emit(IoTLoaded(sensors));
    } catch (e) {
      // En refresh silencioso, no emitir error para no interrumpir la UI
    }
  }

  void _onStartAutoRefresh(StartAutoRefresh event, Emitter<IoTState> emit) {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(event.interval, (_) {
      add(RefreshIoTData(event.equipmentId));
    });
  }

  void _onStopAutoRefresh(StopAutoRefresh event, Emitter<IoTState> emit) {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = null;
  }

  @override
  Future<void> close() {
    _autoRefreshTimer?.cancel();
    return super.close();
  }
}
