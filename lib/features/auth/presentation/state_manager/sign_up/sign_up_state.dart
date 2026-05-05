import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

sealed class SignupState extends Equatable {
  const SignupState({
    required this.selectedCountry,
    this.message,
  });

  final SignupCountry selectedCountry;
  final String? message;

  bool get isInitial => this is SignupInitial;
  bool get isLoading => this is SignupLoading;
  bool get isSuccess => this is SignupSuccess;
  bool get isFailure => this is SignupFailure;

  @override
  List<Object?> get props => [
    selectedCountry,
    message,
  ];
}

final class SignupInitial extends SignupState {
  SignupInitial({
    SignupCountry? selectedCountry,
    super.message,
  }) : super(
    selectedCountry:
    selectedCountry ?? SignupCountry.supportedCountries.first,
  );
}

final class SignupLoading extends SignupState {
  const SignupLoading({
    required super.selectedCountry,
    super.message,
  });
}

final class SignupSuccess extends SignupState {
  const SignupSuccess({
    required super.selectedCountry,
    super.message,
  });
}

final class SignupFailure extends SignupState {
  const SignupFailure({
    required super.selectedCountry,
    required super.message,
  });
}

@immutable
final class SignupCountry extends Equatable {
  const SignupCountry({
    required this.name,
    required this.dialCode,
    required this.maxLength,
    required this.example,
    required this.phoneRegex,
  });

  final String name;
  final String dialCode;
  final int maxLength;
  final String example;
  final RegExp phoneRegex;

  static final List<SignupCountry> supportedCountries = [
    SignupCountry(
      name: 'Nigeria',
      dialCode: '+234',
      maxLength: 10,
      example: '8012345678',
      phoneRegex: RegExp(r'^[789]\d{9}$'),
    ),
    SignupCountry(
      name: 'United States',
      dialCode: '+1',
      maxLength: 10,
      example: '2125550198',
      phoneRegex: RegExp(r'^[2-9]\d{9}$'),
    ),
    SignupCountry(
      name: 'Canada',
      dialCode: '+1',
      maxLength: 10,
      example: '4165550198',
      phoneRegex: RegExp(r'^[2-9]\d{9}$'),
    ),
    SignupCountry(
      name: 'United Kingdom',
      dialCode: '+44',
      maxLength: 10,
      example: '7123456789',
      phoneRegex: RegExp(r'^7\d{9}$'),
    ),
    SignupCountry(
      name: 'Ghana',
      dialCode: '+233',
      maxLength: 9,
      example: '241234567',
      phoneRegex: RegExp(r'^[235]\d{8}$'),
    ),
  ];

  @override
  List<Object?> get props => [
    name,
    dialCode,
    maxLength,
    example,
    phoneRegex.pattern,
  ];
}