import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polarnet_flutter/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:polarnet_flutter/features/profile/presentation/blocs/profile_event.dart';
import 'package:polarnet_flutter/features/profile/presentation/blocs/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthLocalDataSource _localDataSource;

  ProfileBloc(this._localDataSource) : super(const ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));

      final userDto = await _localDataSource.getCachedUser();

      if (userDto != null) {
        final user = userDto.toDomain();
        emit(
          state.copyWith(
            status: ProfileStatus.success,
            user: user,
            error: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ProfileStatus.failure,
            error: 'No se encontró usuario guardado',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    // TODO: Implementar logout
    // Este evento se manejará cuando conectes con el AuthBloc
  }
}
