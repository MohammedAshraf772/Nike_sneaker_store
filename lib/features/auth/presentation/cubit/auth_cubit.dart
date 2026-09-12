import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nike_sneaker_store/core/services/storage_service.dart';
import 'package:nike_sneaker_store/features/auth/core/cubit/auth_state.dart';

import 'package:nike_sneaker_store/features/auth/domain/usecses/login.dart';
import 'package:nike_sneaker_store/features/auth/domain/usecses/logout.dart';
import 'package:nike_sneaker_store/features/auth/domain/usecses/register.dart';

class AuthCubit extends Cubit<AuthState> {
  final Login loginUseCase;
  final Register registerUseCase;
  final Logout logoutUseCase;

  AuthCubit(this.loginUseCase, this.registerUseCase, this.logoutUseCase)
    : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    try {
      emit(AuthLoading());

      final user = await loginUseCase(email, password);

      await StorageService.saveUser(name: user.name, email: user.email);

      emit(AuthAuthenticated(name: user.name, email: user.email));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Login failed"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      emit(AuthError("Passwords do not match"));
      return;
    }

    try {
      emit(AuthLoading());

      final user = await registerUseCase(name, email, password);

      await StorageService.saveUser(name: user.name, email: user.email);

      emit(AuthAuthenticated(name: user.name, email: user.email));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Register failed"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await logoutUseCase();
      await StorageService.clearUser();

      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
