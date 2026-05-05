import 'package:equatable/equatable.dart';

sealed class ResetPasswordState extends Equatable {
  const ResetPasswordState({
    required this.password,
    this.message,
  });

  final String password;
  final String? message;

  bool get isLoading => this is ResetPasswordLoading;
  bool get isSuccess => this is ResetPasswordSuccess;
  bool get isFailure => this is ResetPasswordFailure;

  bool get hasMinLength => password.length >= 8;
  bool get hasUppercase => RegExp('[A-Z]').hasMatch(password);
  bool get hasNumber => RegExp('[0-9]').hasMatch(password);
  bool get hasSpecial => RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=]').hasMatch(password);

  bool get allRequirementsMet =>
      hasMinLength && hasUppercase && hasNumber && hasSpecial;

  @override
  List<Object?> get props => [
    password,
    message,
  ];
}

final class ResetPasswordInitial extends ResetPasswordState {
  const ResetPasswordInitial({
    super.password = '',
    super.message,
  });
}

final class ResetPasswordLoading extends ResetPasswordState {
  const ResetPasswordLoading({
    required super.password,
    super.message,
  });
}

final class ResetPasswordSuccess extends ResetPasswordState {
  const ResetPasswordSuccess({
    required super.password,
    required super.message,
  });
}

final class ResetPasswordFailure extends ResetPasswordState {
  const ResetPasswordFailure({
    required super.password,
    required super.message,
  });
}