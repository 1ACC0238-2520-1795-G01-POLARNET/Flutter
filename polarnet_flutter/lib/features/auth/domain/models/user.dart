import 'package:polarnet_flutter/features/auth/domain/models/user_role.dart';

class User {
  final int? id;
  final String fullName;
  final String email;
  final String password;
  final UserRole role;
  final String? companyName;
  final String? phone;
  final String? location;
  final String? createdAt;

  User({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
    this.companyName,
    this.phone,
    this.location,
    this.createdAt,
  });
}
