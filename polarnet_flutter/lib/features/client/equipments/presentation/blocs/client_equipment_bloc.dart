import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import '../../domain/repositories/client_equipment_repository.dart';
import 'client_equipment_event.dart';
import 'client_equipment_state.dart';

class ClientEquipmentBloc
    extends Bloc<ClientEquipmentEvent, ClientEquipmentState> {
  final ClientEquipmentRepository repository;

  ClientEquipmentBloc({required this.repository})
      : super(const ClientEquipmentState()) {
    on<LoadClientEquipments>(_onLoadClientEquipments);
    on<LoadClientEquipmentById>(_onLoadClientEquipmentById);
  }

  Future<void> _onLoadClientEquipments(
    LoadClientEquipments event,
    Emitter<ClientEquipmentState> emit,
  ) async {
    emit(state.copyWith(status: ClientEquipmentStatus.loading));

    try {
      final equipments = await repository.getClientEquipments(event.clientId);
      emit(
        state.copyWith(
          status: ClientEquipmentStatus.success,
          equipments: equipments,
        ),
      );
    } catch (e, stack) {
      developer.log(
        '❌ [CLIENT_EQUIPMENT BLOC] Error: $e',
        name: 'PolarNet',
        error: e,
        stackTrace: stack,
      );

      emit(
        state.copyWith(
          status: ClientEquipmentStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadClientEquipmentById(
    LoadClientEquipmentById event,
    Emitter<ClientEquipmentState> emit,
  ) async {
    emit(state.copyWith(status: ClientEquipmentStatus.loading));

    try {
      final equipment = await repository.getClientEquipmentById(event.id);

      if (equipment != null) {
        emit(
          state.copyWith(
            status: ClientEquipmentStatus.success,
            equipments: [equipment],
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ClientEquipmentStatus.failure,
            error: 'Equipment no encontrado',
          ),
        );
      }
    } catch (e, stack) {
      developer.log(
        '❌ [CLIENT_EQUIPMENT BLOC] Error: $e',
        name: 'PolarNet',
        error: e,
        stackTrace: stack,
      );

      emit(
        state.copyWith(
          status: ClientEquipmentStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }
}
