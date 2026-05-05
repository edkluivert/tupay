import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tupay/features/auth/presentation/state_manager/forgot_password/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(const ForgotPasswordInitial());

  /// Mock registered emails.
  static const List<String> _registeredEmails = [
    'john@tupay.test',
    'demo@tupay.test',
    'mary@tupay.test',
  ];

  Future<void> sendResetLink({
    required String email,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    final validationError = validateEmail(normalizedEmail);

    if (validationError != null) {
      emit(
        ForgotPasswordFailure(
          message: validationError,
        ),
      );
      return;
    }

    emit(const ForgotPasswordLoading());

    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (!_registeredEmails.contains(normalizedEmail)) {
      emit(
        const ForgotPasswordFailure(
          message: 'No Tupay account was found with this email address.',
        ),
      );
      return;
    }

    emit(
      const ForgotPasswordSuccess(
        message: 'Reset instructions sent successfully.',
      ),
    );
  }

  String? validateEmail(String? value) {
    final email = value?.trim().toLowerCase() ?? '';

    if (email.isEmpty) {
      return 'Please enter your email address.';
    }

    final emailRegex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address.';
    }

    return null;
  }
}