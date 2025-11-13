import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polarnet_flutter/features/provider/home/domain/repositories/provider_home_repository.dart';
import 'provider_home_event.dart';
import 'provider_home_state.dart';

class ProviderHomeBloc extends Bloc<ProviderHomeEvent, ProviderHomeState> {
  final ProviderHomeRepository _repository;

  ProviderHomeBloc(this._repository) : super(const ProviderHomeInitial()) {
    on<LoadAllServiceRequests>(_onLoadAllServiceRequests);
    on<LoadServiceRequestsByStatus>(_onLoadServiceRequestsByStatus);
    on<UpdateServiceRequestStatus>(_onUpdateServiceRequestStatus);
    on<DeleteServiceRequest>(_onDeleteServiceRequest);
    on<RefreshServiceRequests>(_onRefreshServiceRequests);
  }

  Future<void> _onLoadAllServiceRequests(
    LoadAllServiceRequests event,
    Emitter<ProviderHomeState> emit,
  ) async {
    developer.log(
      '🔄 [ProviderHomeBloc] Loading all service requests',
      name: 'PolarNet',
    );

    emit(const ProviderHomeLoading());

    try {
      final requests = await _repository.getAllServiceRequests();

      developer.log(
        '✅ [ProviderHomeBloc] ${requests.length} requests loaded',
        name: 'PolarNet',
      );

      emit(ProviderHomeLoaded(requests));
    } catch (e) {
      developer.log(
        '💥 [ProviderHomeBloc] Error: $e',
        name: 'PolarNet',
        error: e,
      );
      emit(ProviderHomeError('Error al cargar solicitudes: $e'));
    }
  }

  Future<void> _onLoadServiceRequestsByStatus(
    LoadServiceRequestsByStatus event,
    Emitter<ProviderHomeState> emit,
  ) async {
    developer.log(
      '🔄 [ProviderHomeBloc] Loading requests by status: ${event.status}',
      name: 'PolarNet',
    );

    emit(const ProviderHomeLoading());

    try {
      final requests =
          await _repository.getServiceRequestsByStatus(event.status);

      developer.log(
        '✅ [ProviderHomeBloc] ${requests.length} requests loaded',
        name: 'PolarNet',
      );

      emit(ProviderHomeLoaded(requests));
    } catch (e) {
      developer.log(
        '💥 [ProviderHomeBloc] Error: $e',
        name: 'PolarNet',
        error: e,
      );
      emit(ProviderHomeError('Error al cargar solicitudes: $e'));
    }
  }

  Future<void> _onUpdateServiceRequestStatus(
    UpdateServiceRequestStatus event,
    Emitter<ProviderHomeState> emit,
  ) async {
    developer.log(
      '🔄 [ProviderHomeBloc] Updating status for ID ${event.id} to ${event.status}',
      name: 'PolarNet',
    );

    emit(const ProviderHomeLoading());

    try {
      final success =
          await _repository.updateServiceRequestStatus(event.id, event.status);

      if (success) {
        developer.log(
          '✅ [ProviderHomeBloc] Status updated successfully',
          name: 'PolarNet',
        );

        // Reload all requests after update
        final requests = await _repository.getAllServiceRequests();
        emit(ProviderHomeActionSuccess(
          message: 'Estado actualizado exitosamente',
          requests: requests,
        ));
      } else {
        developer.log(
          '❌ [ProviderHomeBloc] Failed to update status',
          name: 'PolarNet',
        );
        emit(const ProviderHomeError('Error al actualizar estado'));
      }
    } catch (e) {
      developer.log(
        '💥 [ProviderHomeBloc] Error: $e',
        name: 'PolarNet',
        error: e,
      );
      emit(ProviderHomeError('Error al actualizar estado: $e'));
    }
  }

  Future<void> _onDeleteServiceRequest(
    DeleteServiceRequest event,
    Emitter<ProviderHomeState> emit,
  ) async {
    developer.log(
      '🔄 [ProviderHomeBloc] Deleting request ID: ${event.id}',
      name: 'PolarNet',
    );

    emit(const ProviderHomeLoading());

    try {
      final success = await _repository.deleteServiceRequest(event.id);

      if (success) {
        developer.log(
          '✅ [ProviderHomeBloc] Request deleted successfully',
          name: 'PolarNet',
        );

        // Reload all requests after deletion
        final requests = await _repository.getAllServiceRequests();
        emit(ProviderHomeActionSuccess(
          message: 'Solicitud eliminada exitosamente',
          requests: requests,
        ));
      } else {
        developer.log(
          '❌ [ProviderHomeBloc] Failed to delete request',
          name: 'PolarNet',
        );
        emit(const ProviderHomeError('Error al eliminar solicitud'));
      }
    } catch (e) {
      developer.log(
        '💥 [ProviderHomeBloc] Error: $e',
        name: 'PolarNet',
        error: e,
      );
      emit(ProviderHomeError('Error al eliminar solicitud: $e'));
    }
  }

  Future<void> _onRefreshServiceRequests(
    RefreshServiceRequests event,
    Emitter<ProviderHomeState> emit,
  ) async {
    developer.log(
      '🔄 [ProviderHomeBloc] Refreshing service requests',
      name: 'PolarNet',
    );

    try {
      final requests = await _repository.getAllServiceRequests();

      developer.log(
        '✅ [ProviderHomeBloc] ${requests.length} requests refreshed',
        name: 'PolarNet',
      );

      emit(ProviderHomeLoaded(requests));
    } catch (e) {
      developer.log(
        '💥 [ProviderHomeBloc] Error: $e',
        name: 'PolarNet',
        error: e,
      );
      emit(ProviderHomeError('Error al refrescar solicitudes: $e'));
    }
  }
}
