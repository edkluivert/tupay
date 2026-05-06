import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tupay/core/constants/mock_data.dart';
import 'package:tupay/core/injections/injection.dart';
import 'package:tupay/core/services/current_user_service.dart';
import 'package:tupay/features/auth/presentation/state_manager/sign_up/sign_up_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  void countryChanged(SignupCountry country) {
    emit(
      SignupInitial(
        selectedCountry: country,
      ),
    );
  }

  Future<void> signup({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final normalizedName = fullName.trim();
    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPhone = phone.trim();

    final validationError = validateFullName(normalizedName) ??
        validateEmail(normalizedEmail) ??
        validatePhone(normalizedPhone) ??
        validatePassword(password);

    if (validationError != null) {
      emit(
        SignupFailure(
          selectedCountry: state.selectedCountry,
          message: validationError,
        ),
      );
      return;
    }

    emit(
      SignupLoading(
        selectedCountry: state.selectedCountry,
      ),
    );

    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (MockData.emailExists(normalizedEmail)) {
      emit(
        SignupFailure(
          selectedCountry: state.selectedCountry,
          message: 'An account with this email already exists.',
        ),
      );
      return;
    }

    if (MockData.phoneExists(normalizedPhone)) {
      emit(
        SignupFailure(
          selectedCountry: state.selectedCountry,
          message: 'An account with this phone number already exists.',
        ),
      );
      return;
    }

    final user = MockData.createUser(
      fullName: normalizedName,
      email: normalizedEmail,
      phone: normalizedPhone,
      password: password,
    );

    sl<CurrentUserService>().currentUser = user;

    emit(
      SignupSuccess(
        selectedCountry: state.selectedCountry,
        message: 'Account created successfully.',
      ),
    );
  }

  String? validateFullName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Please enter your full name.';
    }

    if (name.split(RegExp(r'\s+')).length < 2) {
      return 'Enter first and last name.';
    }

    return null;
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

  String? validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Please enter your password.';
    }

    final hasMinLength = password.length >= 8;
    final hasUppercase = RegExp('[A-Z]').hasMatch(password);
    final hasLowercase = RegExp('[a-z]').hasMatch(password);
    final hasNumber = RegExp(r'\d').hasMatch(password);
    final hasSymbol = RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=]').hasMatch(password);

    if (!hasMinLength ||
        !hasUppercase ||
        !hasLowercase ||
        !hasNumber ||
        !hasSymbol) {
      return 'Use 8+ chars with upper, lower, number, and symbol.';
    }

    return null;
  }

  String? validatePhone(String? value) {
    final phone = value?.trim() ?? '';
    final country = state.selectedCountry;

    if (phone.isEmpty) {
      return 'Please enter your phone number.';
    }

    if (phone.length != country.maxLength) {
      return '${country.name} phone number must be ${country.maxLength} digits.';
    }

    if (!country.phoneRegex.hasMatch(phone)) {
      return 'Enter a valid ${country.name} number. Example: ${country.example}';
    }

    return null;
  }
}