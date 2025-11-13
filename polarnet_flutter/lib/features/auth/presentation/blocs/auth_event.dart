import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String role;
  final String? companyName;
  final String? phone;
  final String? location;

  const RegisterEvent({
    required this.email,
    required this.password,
    required this.fullName,
    required this.role,
    this.companyName,
    this.phone,
    this.location,
  });

  @override
  List<Object?> get props => [email, password, fullName, role, companyName, phone, location];
}

class LogoutEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}
