import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import 'package:polarnet_flutter/features/inventory/domain/repositories/equipment_repository.dart';
import 'package:polarnet_flutter/features/inventory/presentation/blocs/provider_inventory_event.dart';
import 'package:polarnet_flutter/features/inventory/presentation/blocs/provider_inventory_state.dart';

class ProviderInventoryBloc
    extends Bloc<ProviderInventoryEvent, ProviderInventoryState> {
  final EquipmentRepository _repository;

  ProviderInventoryBloc(this._repository) : super(ProviderInventoryState()) {
    on<LoadProviderEquipments>(_onLoadProviderEquipments);
    on<FilterByCategory>(_onFilterByCategory);
    on<ToggleAvailabilityFilter>(_onToggleAvailabilityFilter);
    on<RefreshProviderEquipments>(_onRefreshProviderEquipments);
  }

  Future<void> _onLoadProviderEquipments(
    LoadProviderEquipments event,
    Emitter<ProviderInventoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      developer.log(
        '📦 [ProviderInventoryBloc] Loading equipments for provider: ${event.providerId}',
        name: 'PolarNet',
      );

      final equipments = await _repository.getEquipmentsByProviderId(
        event.providerId,
      );

      developer.log(
        '✅ [ProviderInventoryBloc] ${equipments.length} equipments loaded',
        name: 'PolarNet',
      );

      emit(
        state.copyWith(
          allEquipments: equipments,
          isLoading: false,
          errorMessage: null,
        ),
      );
    } catch (e, stack) {
      developer.log(
        '❌ [ProviderInventoryBloc] Error loading equipments: $e',
        name: 'PolarNet',
        error: e,
        stackTrace: stack,
      );

      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Error al cargar el inventario: ${e.toString()}',
        ),
      );
    }
  }

  void _onFilterByCategory(
    FilterByCategory event,
    Emitter<ProviderInventoryState> emit,
  ) {
    developer.log(
      '🔍 [ProviderInventoryBloc] Filtering by category: ${event.category}',
      name: 'PolarNet',
    );

    emit(state.copyWith(selectedCategory: event.category));
  }

  void _onToggleAvailabilityFilter(
    ToggleAvailabilityFilter event,
    Emitter<ProviderInventoryState> emit,
  ) {
    developer.log(
      '🔄 [ProviderInventoryBloc] Toggling availability filter: ${!state.showOnlyAvailable}',
      name: 'PolarNet',
    );

    emit(state.copyWith(showOnlyAvailable: !state.showOnlyAvailable));
  }

  Future<void> _onRefreshProviderEquipments(
    RefreshProviderEquipments event,
    Emitter<ProviderInventoryState> emit,
  ) async {
    developer.log(
      '🔄 [ProviderInventoryBloc] Refreshing equipments',
      name: 'PolarNet',
    );

    add(LoadProviderEquipments(event.providerId));
  }
}
