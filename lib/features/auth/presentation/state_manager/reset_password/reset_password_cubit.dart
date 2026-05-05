import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tupay/features/auth/presentation/state_manager/reset_password/reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(const ResetPasswordInitial());

  void passwordChanged(String value) {
    emit(
      ResetPasswordInitial(
        password: value,
      ),
    );
  }

  Future<void> resetPassword({
    required String password,
    required String confirmPassword,
  }) async {
    final validationError = validatePassword(password) ??
        validateConfirmPassword(
          confirmPassword,
          password,
        );

    if (validationError != null) {
      emit(
        ResetPasswordFailure(
          password: password,
          message: validationError,
        ),
      );
      return;
    }

    emit(
      ResetPasswordLoading(
        password: password,
      ),
    );

    await Future<void>.delayed(const Duration(milliseconds: 900));

    emit(
      ResetPasswordSuccess(
        password: password,
        message: 'Password updated successfully.',
      ),
    );
  }

  String? validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Please enter your new password.';
    }

    final hasMinLength = password.length >= 8;
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecial = RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=]').hasMatch(password);

    if (!hasMinLength || !hasUppercase || !hasNumber || !hasSpecial) {
      return 'Password does not meet all requirements.';
    }

    return null;
  }

  String? validateConfirmPassword(
      String? value,
      String password,
      ) {
    final confirmPassword = value ?? '';

    if (confirmPassword.isEmpty) {
      return 'Please confirm your new password.';
    }

    if (confirmPassword != password) {
      return 'Passwords do not match.';
    }

    return null;
  }
}