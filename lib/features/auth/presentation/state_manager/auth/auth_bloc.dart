import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:tupay/core/handlers/shared_preferences_wrapper.dart';
import 'package:tupay/features/auth/presentation/state_manager/auth/auth_event.dart';
import 'package:tupay/features/auth/presentation/state_manager/auth/auth_state.dart';
import 'package:tupay/features/features.dart';


@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {

  AuthBloc({
    required this.sharedPreferencesWrapper,
  }) : super(const AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  final SharedPreferencesWrapper sharedPreferencesWrapper;


  Future<void> _onAppStarted(
      AppStarted event,
      Emitter<AuthState> emit,
      ) async {
    final isFirstTime = sharedPreferencesWrapper.getString(
      SharedPrefsKey.firstTimer,
    );

    if (isFirstTime == null || isFirstTime.isEmpty) {
      AppLogger.i('User is a first time user, redirecting to onboarding.');
      emit(const FirstTimer());
      return;
    }

    AppLogger.i('User has opened the app before, redirecting to login.');
    emit(const Unauthenticated());
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const LogoutLoading());
    try {
      emit(const Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
