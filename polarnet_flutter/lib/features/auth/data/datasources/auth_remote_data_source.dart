import 'dart:developer' as developer;

import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/user_dto.dart';

abstract class AuthRemoteDataSource {
  Future<UserDto?> login(String email, String password);
  Future<UserDto?> register({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? companyName,
    String? phone,
    String? location,
  });
  Future<void> logout();
  Future<UserDto?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseService supabaseService;

  AuthRemoteDataSourceImpl(this.supabaseService);

  // 🔐 LOGIN
  @override
  Future<UserDto?> login(String email, String password) async {
    developer.log(
      '🚀 [LOGIN] Iniciando login con email: $email',
      name: 'PolarNet',
    );

    try {
      final cleanEmail = email.trim().toLowerCase();

      // Buscar usuario en tabla "users"
      final user = await supabaseService.supabase
          .from(ApiConstants.usersTable)
          .select()
          .eq('email', cleanEmail)
          .maybeSingle();

      if (user == null) {
        developer.log(
          '❌ [LOGIN] Usuario no encontrado: $cleanEmail',
          name: 'PolarNet',
        );
        return null;
      }

      if (user['password'] != password) {
        developer.log(
          '⚠️ [LOGIN] Contraseña incorrecta para: $cleanEmail',
          name: 'PolarNet',
        );
        return null;
      }

      developer.log(
        '✅ [LOGIN] Login exitoso para: ${user['name']}',
        name: 'PolarNet',
      );
      return UserDto.fromJson(user);
    } catch (e, stackTrace) {
      developer.log(
        '💥 [LOGIN] Error al iniciar sesión: $e',
        name: 'PolarNet',
        error: e,
        stackTrace: stackTrace,
      );
      throw AuthException('Error al iniciar sesión: ${e.toString()}');
    }
  }

  // 🧾 REGISTER
  @override
  Future<UserDto?> register({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String? companyName,
    String? phone,
    String? location,
  }) async {
    developer.log(
      '🚀 [REGISTER] Intentando registrar usuario con email: $email',
      name: 'PolarNet',
    );

    try {
      final cleanEmail = email.trim().toLowerCase();

      // Verificar si el email ya existe
      final existingUser = await supabaseService.supabase
          .from(ApiConstants.usersTable)
          .select()
          .eq('email', cleanEmail)
          .maybeSingle();

      if (existingUser != null) {
        developer.log(
          '⚠️ [REGISTER] El email ya está registrado: $cleanEmail',
          name: 'PolarNet',
        );
        return null;
      }

      final newUser = UserDto(
        id: null,
        fullName: fullName,
        email: email,
        password: password,
        role: role.toLowerCase(),
        company: companyName,
        phone: phone,
        location: location,
        createdAt: null,
      ).toJson();

      /*{
        'email': cleanEmail,
        'password': password, 
        'name': name,
        'role': userType,
        'phone': phone,
        'location': location,
      };*/

      developer.log(
        '📦 [REGISTER] Insertando nuevo usuario: $newUser',
        name: 'PolarNet',
      );

      final insertedUser = await supabaseService.supabase
          .from(ApiConstants.usersTable)
          .insert(newUser)
          .select()
          .single();

      developer.log(
        '✅ [REGISTER] Usuario registrado exitosamente: ${insertedUser['name']}',
        name: 'PolarNet',
      );
      return UserDto.fromJson(insertedUser);
    } catch (e, stackTrace) {
      developer.log(
        '💥 [REGISTER] Error en registro: $e',
        name: 'PolarNet',
        error: e,
        stackTrace: stackTrace,
      );
      throw AuthException('Error al registrar: ${e.toString()}');
    }
  }

  // 🚪 LOGOUT (opcional, solo limpia sesión local)
  @override
  Future<void> logout() async {
    developer.log('🚪 [LOGOUT] Cerrando sesión...', name: 'PolarNet');
    // Si no usas auth, puedes manejar esto localmente (por ejemplo SharedPreferences)
  }

  // 👤 GET CURRENT USER (en proyectos sin auth, retorna null)
  @override
  Future<UserDto?> getCurrentUser() async {
    developer.log(
      'ℹ️ [GET USER] No se usa auth, retorna null',
      name: 'PolarNet',
    );
    return null;
  }
}
