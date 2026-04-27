import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ Login
  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;

      emit(
        AuthAuthenticated(name: user.email!.split('@')[0], email: user.email!),
      );
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Login failed"));
    }
  }

  // ✅ Register
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    emit(AuthLoading());

    if (password != confirmPassword) {
      emit(AuthError("Passwords do not match"));
      return;
    }

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
        'image': '',
      });

      emit(AuthAuthenticated(name: name, email: email));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // ✅ Logout
  Future<void> logout() async {
    await _auth.signOut();
    emit(AuthUnauthenticated());
  }

  // ✅ Forgot Password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Error sending email"));
    }
  }
}
