import 'package:equatable/equatable.dart';

sealed class LoginState extends Equatable {
  const LoginState({
    this.message,
  });

  final String? message;

  bool get isLoading => this is LoginLoading;
  bool get isSuccess => this is LoginSuccess;
  bool get isFailure => this is LoginFailure;

  @override
  List<Object?> get props => [message];
}

final class LoginInitial extends LoginState {
  const LoginInitial();
}

final class LoginLoading extends LoginState {
  const LoginLoading();
}

final class LoginSuccess extends LoginState {
  const LoginSuccess({
    required super.message,
  });
}

final class LoginFailure extends LoginState {
  const LoginFailure({
    required super.message,
  });
}