import 'package:equatable/equatable.dart';

sealed class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.message,
  });

  final String? message;

  bool get isLoading => this is ForgotPasswordLoading;
  bool get isSuccess => this is ForgotPasswordSuccess;
  bool get isFailure => this is ForgotPasswordFailure;

  @override
  List<Object?> get props => [message];
}

final class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial();
}

final class ForgotPasswordLoading extends ForgotPasswordState {
  const ForgotPasswordLoading();
}

final class ForgotPasswordSuccess extends ForgotPasswordState {
  const ForgotPasswordSuccess({
    required super.message,
  });
}

final class ForgotPasswordFailure extends ForgotPasswordState {
  const ForgotPasswordFailure({
    required super.message,
  });
}