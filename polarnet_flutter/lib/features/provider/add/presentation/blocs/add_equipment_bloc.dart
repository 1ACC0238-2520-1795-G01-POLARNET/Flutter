import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polarnet_flutter/features/provider/add/domain/repositories/add_equipment_repository.dart';
import 'package:polarnet_flutter/features/provider/add/presentation/blocs/add_equipment_event.dart';
import 'package:polarnet_flutter/features/provider/add/presentation/blocs/add_equipment_state.dart';
import 'package:polarnet_flutter/shared/domain/models/equipment.dart';

class AddEquipmentBloc extends Bloc<AddEquipmentEvent, AddEquipmentState> {
  final AddEquipmentRepository _repository;

  AddEquipmentBloc(this._repository) : super(const AddEquipmentState()) {
    on<AddEquipment>(_onAddEquipment);
    on<ResetAddEquipment>(_onResetAddEquipment);
  }

  Future<void> _onAddEquipment(
    AddEquipment event,
    Emitter<AddEquipmentState> emit,
  ) async {
    try {
      emit(state.copyWith(
        status: AddEquipmentStatus.loading,
        successMessage: null,
        errorMessage: null,
      ));

      final equipment = Equipment(
        id: 0, // El ID lo asigna el backend
        providerId: event.providerId,
        name: event.name,
        brand: event.brand,
        model: event.model,
        category: event.category,
        description: event.description,
        thumbnail: event.thumbnail,
        specifications: null,
        available: event.available,
        location: event.location,
        pricePerMonth: event.pricePerMonth,
        purchasePrice: event.purchasePrice,
        createdAt: null,
        updatedAt: null,
      );

      final success = await _repository.addEquipment(equipment);

      if (success) {
        emit(
          state.copyWith(
            status: AddEquipmentStatus.success,
            successMessage: 'Equipo agregado exitosamente',
            errorMessage: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AddEquipmentStatus.failure,
            successMessage: null,
            errorMessage: 'Error al agregar el equipo',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: AddEquipmentStatus.failure,
          successMessage: null,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onResetAddEquipment(
    ResetAddEquipment event,
    Emitter<AddEquipmentState> emit,
  ) {
    emit(const AddEquipmentState());
  }
}
