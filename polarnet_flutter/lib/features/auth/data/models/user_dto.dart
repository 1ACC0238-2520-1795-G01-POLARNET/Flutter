import 'package:polarnet_flutter/features/auth/domain/models/user_role.dart';
import '../../domain/models/user.dart';

class UserDto {
  final int? id;
  final String fullName;
  final String email;
  final String password;
  final String role;
  final String? company;
  final String? phone;
  final String? location;
  final String? createdAt;

  UserDto({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
    this.company,
    this.phone,
    this.location,
    this.createdAt,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'],
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      company: json['company_name'],
      phone: json['phone'],
      location: json['location'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'full_name': fullName,
      'email': email,
      'password': password,
      'role': role,
      'company_name': company,
      'phone': phone,
      'location': location,
      'created_at': createdAt,
    };
  }

  factory UserDto.fromDatabase(Map<String, dynamic> map) {
    return UserDto(
      id: map['id'] as int?,
      fullName: map['full_name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      role: (map['role'] ?? 'client'),
      company: map['company_name'],
      phone: map['phone'],
      location: map['location'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'password': password,
      'role': role,
      'company_name': company,
      'phone': phone,
      'location': location,
      'created_at': createdAt,
    };
  }

  /// Si quieres convertir este DTO a tu modelo de dominio:
  User toDomain() {
    return User(
      id: id,
      fullName: fullName,
      email: email,
      password: password,
      role: UserRolex.fromString(role),
      companyName: company,
      phone: phone,
      location: location,
      createdAt: createdAt,
    );
  }
}
