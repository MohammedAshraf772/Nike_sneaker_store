import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileState.initial());

  final _picker = ImagePicker();
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  Future<void> loadProfile() async {
    final doc = await _firestore.collection('users').doc(uid).get();

    if (doc.exists) {
      emit(
        state.copyWith(
          name: doc['name'] ?? '',
          email: doc['email'] ?? '',
          image: doc['image'] ?? '',
        ),
      );
    }
  }

  Future<void> pickAndUploadImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    emit(state.copyWith(isLoading: true));

    final file = File(picked.path);

    final ref = _storage.ref().child('users/$uid/profile.jpg');

    await ref.putFile(file);

    final url = await ref.getDownloadURL();

    await _firestore.collection('users').doc(uid).update({'image': url});

    emit(state.copyWith(image: url, isLoading: false));
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    await _firestore.collection('users').doc(uid).update({
      'name': name,
      'email': email,
      'phone': phone,
    });

    emit(state.copyWith(name: name, email: email, phone: phone));
  }

  void toggleDarkMode() {
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }
}
