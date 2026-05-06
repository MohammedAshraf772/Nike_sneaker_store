import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase(email, password);
      emit(AuthAuthenticated(name: user.name, email: user.email));
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

      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await credential.user!.updateDisplayName(name);

      emit(AuthAuthenticated(name: name, email: email));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    await logoutUseCase();
    emit(AuthUnauthenticated());
  }
}
