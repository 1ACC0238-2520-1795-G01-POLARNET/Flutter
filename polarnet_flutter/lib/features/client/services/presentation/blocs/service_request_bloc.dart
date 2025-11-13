import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polarnet_flutter/features/client/services/domain/repositories/service_request_repository.dart';
import 'package:polarnet_flutter/features/client/services/presentation/blocs/service_request_event.dart';
import 'package:polarnet_flutter/features/client/services/presentation/blocs/service_request_state.dart';

class ServiceRequestBloc
    extends Bloc<ServiceRequestEvent, ServiceRequestState> {
  final ServiceRequestRepository _repository;

  ServiceRequestBloc(this._repository) : super(const ServiceRequestState()) {
    on<LoadServiceRequests>(_onLoadServiceRequests);
  }

  Future<void> _onLoadServiceRequests(
    LoadServiceRequests event,
    Emitter<ServiceRequestState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ServiceRequestStatus.loading));

      final serviceRequests =
          await _repository.getServiceRequestsByClient(event.clientId);

      emit(
        state.copyWith(
          status: ServiceRequestStatus.success,
          serviceRequests: serviceRequests,
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ServiceRequestStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }
}
