import 'dart:ui';

sealed class ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileSuccess extends ProfileState {
  ProfileSuccess({
    required this.name,
    required this.email,
    required this.isVerified,
    required this.securityPercent,
    required this.dailyLimit,
    required this.dailyUsed,
    required this.linkedMethods,
  });

  final String name;
  final String email;
  final bool isVerified;
  final int securityPercent;
  final String dailyLimit;
  final String dailyUsed;
  final List<LinkedPaymentMethod> linkedMethods;
}

final class ProfileError extends ProfileState {
  ProfileError(this.message);
  final String message;
}

class LinkedPaymentMethod {
  const LinkedPaymentMethod({
    required this.bankName,
    required this.type,
    required this.maskedNumber,
    required this.initials,
    required this.isDefault,
    required this.bankColor,
  });

  final String bankName;
  final String type;
  final String maskedNumber;
  final String initials;
  final bool isDefault;
  final Color bankColor;
}
