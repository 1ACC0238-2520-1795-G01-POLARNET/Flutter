import 'package:equatable/equatable.dart';
import 'package:polarnet_flutter/features/client/services/domain/models/service_request.dart';

enum ServiceRequestStatus { initial, loading, success, failure }

class ServiceRequestState extends Equatable {
  final ServiceRequestStatus status;
  final List<ServiceRequest> serviceRequests;
  final String? error;

  const ServiceRequestState({
    this.status = ServiceRequestStatus.initial,
    this.serviceRequests = const [],
    this.error,
  });

  ServiceRequestState copyWith({
    ServiceRequestStatus? status,
    List<ServiceRequest>? serviceRequests,
    String? error,
  }) {
    return ServiceRequestState(
      status: status ?? this.status,
      serviceRequests: serviceRequests ?? this.serviceRequests,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, serviceRequests, error];
}
