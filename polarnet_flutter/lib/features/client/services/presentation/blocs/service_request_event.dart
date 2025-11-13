import 'package:equatable/equatable.dart';

abstract class ServiceRequestEvent extends Equatable {
  const ServiceRequestEvent();

  @override
  List<Object?> get props => [];
}

class LoadServiceRequests extends ServiceRequestEvent {
  final int clientId;

  const LoadServiceRequests(this.clientId);

  @override
  List<Object?> get props => [clientId];
}
