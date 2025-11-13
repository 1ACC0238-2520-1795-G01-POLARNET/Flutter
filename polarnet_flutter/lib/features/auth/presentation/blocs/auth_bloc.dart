import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/local_storage_service.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/datasources/auth_local_data_source.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final LocalStorageService localStorage;

  AuthBloc({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.localStorage,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  // ========================= LOGIN =========================
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    developer.log(
      '🚀 [LOGIN] Evento recibido con email: ${event.email}',
      name: 'PolarNet',
    );
    emit(AuthLoading());

    try {
      final user = await remoteDataSource.login(event.email, event.password);

      developer.log(
        '✅ [LOGIN] Usuario autenticado: ${user?.email}',
        name: 'PolarNet',
      );

      // Guardar en caché local
      await localDataSource.cacheUser(user!);
      await localStorage.saveUserId(user.id!);
      await localStorage.saveUserType(user.role);
      await localStorage.setLoggedIn(true);

      emit(AuthAuthenticated(user.toDomain()));
    } catch (e, stack) {
      developer.log(
        '💥 [LOGIN] Error: $e',
        name: 'PolarNet',
        error: e,
        stackTrace: stack,
      );
      emit(AuthError('Error al iniciar sesión: ${e.toString()}'));
    }
  }

  // ========================= REGISTER =========================
  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    developer.log(
      '🚀 [REGISTER] Evento recibido con email: ${event.email}',
      name: 'PolarNet',
    );
    emit(AuthLoading());

    try {
      final user = await remoteDataSource.register(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
        role: event.role,
        companyName: event.companyName,
        phone: event.phone,
        location: event.location,
      );

      developer.log(
        '✅ [REGISTER] Registro exitoso: ${user?.email}',
        name: 'PolarNet',
      );

      // Guardar en caché local
      await localDataSource.cacheUser(user!);
      await localStorage.saveUserId(user.id!);
      await localStorage.saveUserType(user.role);
      await localStorage.setLoggedIn(true);

      emit(AuthAuthenticated(user.toDomain()));
    } catch (e, stack) {
      developer.log(
        '💥 [REGISTER] Error: $e',
        name: 'PolarNet',
        error: e,
        stackTrace: stack,
      );
      emit(AuthError('Error al registrar usuario: ${e.toString()}'));
    }
  }

  // ========================= LOGOUT =========================
  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    developer.log('🚪 [LOGOUT] Evento recibido', name: 'PolarNet');
    emit(AuthLoading());

    try {
      await remoteDataSource.logout();
      await localDataSource.clearCache();
      await localStorage.clearAll();

      developer.log(
        '✅ [LOGOUT] Sesión cerrada correctamente',
        name: 'PolarNet',
      );
      emit(AuthUnauthenticated());
    } catch (e, stack) {
      developer.log(
        '💥 [LOGOUT] Error: $e',
        name: 'PolarNet',
        error: e,
        stackTrace: stack,
      );
      emit(AuthError('Error al cerrar sesión: ${e.toString()}'));
    }
  }

  // ========================= CHECK AUTH STATUS =========================
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    developer.log(
      '🧩 [AUTH STATUS] Verificando estado de autenticación',
      name: 'PolarNet',
    );
    emit(AuthLoading());

    try {
      final isLoggedIn = localStorage.isLoggedIn();

      if (!isLoggedIn) {
        developer.log(
          'ℹ️ [AUTH STATUS] No hay sesión activa',
          name: 'PolarNet',
        );
        emit(AuthUnauthenticated());
        return;
      }

      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        developer.log(
          '✅ [AUTH STATUS] Usuario cargado desde caché',
          name: 'PolarNet',
        );
        emit(AuthAuthenticated(cachedUser.toDomain()));
        return;
      }

      final currentUser = await remoteDataSource.getCurrentUser();
      if (currentUser != null) {
        developer.log(
          '✅ [AUTH STATUS] Usuario cargado desde Supabase',
          name: 'PolarNet',
        );
        await localDataSource.cacheUser(currentUser);
        emit(AuthAuthenticated(currentUser.toDomain()));
      } else {
        developer.log(
          '❌ [AUTH STATUS] No hay usuario en sesión',
          name: 'PolarNet',
        );
        emit(AuthUnauthenticated());
      }
    } catch (e, stack) {
      developer.log(
        '💥 [AUTH STATUS] Error: $e',
        name: 'PolarNet',
        error: e,
        stackTrace: stack,
      );
      emit(AuthUnauthenticated());
    }
  }
}
