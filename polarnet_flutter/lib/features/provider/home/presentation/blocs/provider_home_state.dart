import 'package:equatable/equatable.dart';
import 'package:polarnet_flutter/features/provider/home/domain/models/provider_service_request.dart';

abstract class ProviderHomeState extends Equatable {
  const ProviderHomeState();

  @override
  List<Object?> get props => [];
}

class ProviderHomeInitial extends ProviderHomeState {
  const ProviderHomeInitial();
}

class ProviderHomeLoading extends ProviderHomeState {
  const ProviderHomeLoading();
}

class ProviderHomeLoaded extends ProviderHomeState {
  final List<ProviderServiceRequest> requests;

  const ProviderHomeLoaded(this.requests);

  @override
  List<Object?> get props => [requests];
}

class ProviderHomeError extends ProviderHomeState {
  final String message;

  const ProviderHomeError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProviderHomeActionSuccess extends ProviderHomeState {
  final String message;
  final List<ProviderServiceRequest> requests;

  const ProviderHomeActionSuccess({
    required this.message,
    required this.requests,
  });

  @override
  List<Object?> get props => [message, requests];
}
