abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}
//
// class Authenticated extends AuthState {
//   const Authenticated(this.token);
//   final String token;
// }
//
class Unauthenticated extends AuthState {
  const Unauthenticated();
}
class FirstTimer extends AuthState {
  const FirstTimer();
}
class LogoutLoading extends AuthState {
  const LogoutLoading();
}

class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
}
