abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String name;
  final String email;

  AuthAuthenticated({required this.name, required this.email});
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
