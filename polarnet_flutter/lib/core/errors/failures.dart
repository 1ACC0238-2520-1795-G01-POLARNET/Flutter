// ignore_for_file: use_super_parameters

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Error del servidor']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Error de conexión']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Error de caché']) : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Error de autenticación']) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Error de validación']) : super(message);
}
