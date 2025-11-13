import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import 'package:polarnet_flutter/features/client/home/domain/repositories/equipment_repository.dart';
import 'equipment_event.dart';
import 'equipment_state.dart';

class EquipmentBloc extends Bloc<EquipmentEvent, EquipmentState> {
  final EquipmentRepository repository;

  EquipmentBloc({required this.repository}) : super(const EquipmentState()) {
    on<LoadEquipments>(_onLoadEquipments);
  }

  Future<void> _onLoadEquipments(
    LoadEquipments event,
    Emitter<EquipmentState> emit,
  ) async {
    emit(state.copyWith(status: EquipmentStatus.loading));

    try {
      final equipments = await repository.getAllEquipments();
      emit(
        state.copyWith(status: EquipmentStatus.success, equipments: equipments),
      );
    } catch (e, stack) {
      developer.log(
        '❌ [EQUIPMENT BLOC] Error: $e',
        name: 'PolarNet',
        error: e,
        stackTrace: stack,
      );
      
      emit(
        state.copyWith(status: EquipmentStatus.failure, error: e.toString()),
      );
    }
  }
}
