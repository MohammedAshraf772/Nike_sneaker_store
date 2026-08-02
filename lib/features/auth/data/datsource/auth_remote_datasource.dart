import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class AuthRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSource(this.auth, this.firestore);

  Future<UserModel> login(String email, String password) async {
    final result = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user!;

    final docRef = firestore.collection('users').doc(user.uid);

    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'name': user.displayName ?? 'User',
        'email': user.email ?? email,
      });
    }

    final updatedDoc = await docRef.get();

    return UserModel.fromFirebase(user, updatedDoc.data());
  }

  Future<UserModel> register(String name, String email, String password) async {
    final result = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user!;

    await user.updateDisplayName(name);

    await firestore.collection('users').doc(user.uid).set({
      'name': name,
      'email': email,
    });

    return UserModel(uid: user.uid, email: email, name: name);
  }

  Future<void> logout() async {
    await auth.signOut();
  }

  Future<void> forgotPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  User? get currentUser => auth.currentUser;
}
