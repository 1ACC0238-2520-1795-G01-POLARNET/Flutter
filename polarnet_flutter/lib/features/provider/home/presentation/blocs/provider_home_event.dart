import 'package:equatable/equatable.dart';

abstract class ProviderHomeEvent extends Equatable {
  const ProviderHomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllServiceRequests extends ProviderHomeEvent {
  const LoadAllServiceRequests();
}

class LoadServiceRequestsByStatus extends ProviderHomeEvent {
  final String status;

  const LoadServiceRequestsByStatus(this.status);

  @override
  List<Object?> get props => [status];
}

class UpdateServiceRequestStatus extends ProviderHomeEvent {
  final int id;
  final String status;

  const UpdateServiceRequestStatus({
    required this.id,
    required this.status,
  });

  @override
  List<Object?> get props => [id, status];
}

class DeleteServiceRequest extends ProviderHomeEvent {
  final int id;

  const DeleteServiceRequest(this.id);

  @override
  List<Object?> get props => [id];
}

class RefreshServiceRequests extends ProviderHomeEvent {
  const RefreshServiceRequests();
}
