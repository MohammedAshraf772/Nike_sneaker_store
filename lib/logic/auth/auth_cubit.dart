import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/storage_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> checkAuth() async {
    emit(AuthLoading());
    final loggedIn = await StorageService.isLoggedIn();
    if (loggedIn) {
      final user = await StorageService.getUser();
      emit(
        AuthAuthenticated(name: user['name'] ?? '', email: user['email'] ?? ''),
      );
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1));

    if (email.isEmpty || password.isEmpty) {
      emit(const AuthError('Please fill in all fields'));
      return;
    }

    if (!email.contains('@')) {
      emit(const AuthError('Please enter a valid email'));
      return;
    }

    if (password.length < 6) {
      emit(const AuthError('Password must be at least 6 characters'));
      return;
    }

    final name = email.split('@')[0];

    await StorageService.saveUser(name: name, email: email);

    emit(AuthAuthenticated(name: name, email: email));
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1));

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      emit(const AuthError('Please fill in all fields'));
      return;
    }

    if (!email.contains('@')) {
      emit(const AuthError('Please enter a valid email'));
      return;
    }

    if (password.length < 6) {
      emit(const AuthError('Password must be at least 6 characters'));
      return;
    }

    if (password != confirmPassword) {
      emit(const AuthError('Passwords do not match'));
      return;
    }

    await StorageService.saveUser(name: name, email: email);

    emit(AuthAuthenticated(name: name, email: email));
  }

  Future<void> logout() async {
    await StorageService.clearUser();
    emit(AuthUnauthenticated());
  }
}
