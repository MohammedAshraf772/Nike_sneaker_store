import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // LOGIN
  Future<void> login({required String email, required String password}) async {
    try {
      emit(AuthLoading());

      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user!;

      emit(
        AuthAuthenticated(name: user.email!.split('@')[0], email: user.email!),
      );
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Login failed"));
    }
  }

  // REGISTER
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      emit(AuthLoading());

      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = credential.user!;

      emit(AuthAuthenticated(name: name, email: user.email!));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Register failed"));
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
