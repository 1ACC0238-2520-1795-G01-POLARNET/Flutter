import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import 'package:polarnet_flutter/features/client/home/domain/repositories/equipment_repository.dart';
import 'equipment_event.dart';
import 'equipment_state.dart';

class EquipmentBloc extends Bloc<EquipmentEvent, EquipmentState> {
  final EquipmentRepository repository;

  EquipmentBloc({required this.repository}) : super(const EquipmentState()) {
    developer.log(
      '🏗️ [EQUIPMENT BLOC] Constructor - Bloc creado',
      name: 'PolarNet',
    );
    on<LoadEquipments>(_onLoadEquipments);
  }

  Future<void> _onLoadEquipments(
    LoadEquipments event,
    Emitter<EquipmentState> emit,
  ) async {
    developer.log(
      '📥 [EQUIPMENT BLOC] LoadEquipments event recibido',
      name: 'PolarNet',
    );
    
    emit(state.copyWith(status: EquipmentStatus.loading));
    developer.log(
      '⏳ [EQUIPMENT BLOC] Estado cambiado a loading',
      name: 'PolarNet',
    );

    try {
      developer.log(
        '🔄 [EQUIPMENT BLOC] Llamando a repository.getAllEquipments()',
        name: 'PolarNet',
      );
      final equipments = await repository.getAllEquipments();
      
      developer.log(
        '✅ [EQUIPMENT BLOC] Equipos obtenidos: ${equipments.length}',
        name: 'PolarNet',
      );
      
      emit(
        state.copyWith(status: EquipmentStatus.success, equipments: equipments),
      );
      
      developer.log(
        '✅ [EQUIPMENT BLOC] Estado cambiado a success',
        name: 'PolarNet',
      );
    } catch (e, stack) {
      developer.log(
        '❌ [EQUIPMENT BLOC] Error al cargar equipos: $e',
        name: 'PolarNet',
        error: e,
        stackTrace: stack,
      );
      
      emit(
        state.copyWith(status: EquipmentStatus.failure, error: e.toString()),
      );
      
      developer.log(
        '❌ [EQUIPMENT BLOC] Estado cambiado a failure',
        name: 'PolarNet',
      );
    }
  }
}
