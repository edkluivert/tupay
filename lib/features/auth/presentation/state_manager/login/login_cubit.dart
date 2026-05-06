import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tupay/core/constants/mock_data.dart';
import 'package:tupay/core/injections/injection.dart';
import 'package:tupay/core/services/current_user_service.dart';
import 'package:tupay/features/auth/presentation/state_manager/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginInitial());

  Future<void> login({
    required String emailOrUsername,
    required String password,
  }) async {
    final normalizedIdentifier = emailOrUsername.trim().toLowerCase();
    final normalizedPassword = password.trim();

    final validationError = validateEmailOrUsername(normalizedIdentifier) ??
        validatePassword(normalizedPassword);

    if (validationError != null) {
      emit(LoginFailure(message: validationError));
      return;
    }

    emit(const LoginLoading());

    await Future<void>.delayed(const Duration(milliseconds: 900));

    try {
      final user = MockData.users.values.firstWhere(
        (u) =>
            (u.email.toLowerCase() == normalizedIdentifier ||
                u.username.toLowerCase() == normalizedIdentifier) &&
            u.password == normalizedPassword,
      );

      sl<CurrentUserService>().currentUser = user;

      emit(
        const LoginSuccess(
          message: 'Welcome back!',
        ),
      );
    } catch (_) {
      emit(
        const LoginFailure(
          message: 'Invalid login details. Try demo@tupay.test / Demo123!',
        ),
      );
    }
  }

  Future<void> loginWithBiometric() async {
    emit(const LoginLoading());

    await Future<void>.delayed(const Duration(milliseconds: 700));

    emit(
      const LoginFailure(
        message: 'Biometric login is not available in mock mode yet.',
      ),
    );
  }

  Future<void> loginWithFaceId() async {
    emit(const LoginLoading());

    await Future<void>.delayed(const Duration(milliseconds: 700));

    emit(
      const LoginFailure(
        message: 'Face ID login is not available in mock mode yet.',
      ),
    );
  }

  String? validateEmailOrUsername(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Please enter your email or username.';
    }

    if (text.contains('@')) {
      final emailRegex = RegExp(
        r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
      );

      if (!emailRegex.hasMatch(text)) {
        return 'Please enter a valid email address.';
      }

      return null;
    }

    if (text.length < 3) {
      return 'Username must be at least 3 characters.';
    }

    return null;
  }

  String? validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Please enter your password.';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters.';
    }

    return null;
  }
}