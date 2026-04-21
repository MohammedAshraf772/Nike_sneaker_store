import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // LOGIN
  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      emit(
        AuthAuthenticated(
          name: user.user?.email ?? '',
          email: user.user?.email ?? '',
        ),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // REGISTER
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

    emit(AuthLoading());
    try {
      final user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      emit(AuthAuthenticated(name: name, email: user.user?.email ?? ''));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
    emit(AuthInitial());
  }

  // RESET PASSWORD
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
