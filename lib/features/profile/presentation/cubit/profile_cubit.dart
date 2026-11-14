import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState(image: '')) {
    _authSubscription = _auth.authStateChanges().listen(_onAuthChanged);
  }
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<User?>? _authSubscription;
  String _prefsKey(String uid) => 'profile_image_$uid';
  void _onAuthChanged(User? user) {
    if (user == null) {
      emit(const ProfileState(image: ''));
    } else {
      loadProfileImage();
    }
  }

  Future<void> loadProfileImage() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || kIsWeb) return;
    final prefs = await SharedPreferences.getInstance();
    final fileName = prefs.getString(_prefsKey(uid));
    final directory = await getApplicationDocumentsDirectory();
    if (isClosed) return;
    if (fileName == null) {
      emit(const ProfileState(image: ''));
      return;
    }
    final file = File('${directory.path}/$fileName');
    emit(state.copyWith(image: await file.exists() ? file.path : ''));
  }

  Future<void> pickImageFromGallery() => _pickImage(ImageSource.gallery);
  Future<void> pickImageFromCamera() => _pickImage(ImageSource.camera);
  Future<void> _pickImage(ImageSource source) async {
    final uid = _auth.currentUser?.uid;
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (picked == null || uid == null) return;
    if (kIsWeb) {
      emit(state.copyWith(image: picked.path));
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    final extension =
        picked.name.contains('.') ? picked.name.split('.').last : 'jpg';
    final fileName =
        'profile_${uid}_${DateTime.now().millisecondsSinceEpoch}.$extension';
    final saved = await File(picked.path).copy('${directory.path}/$fileName');
    final prefs = await SharedPreferences.getInstance();
    final previous = prefs.getString(_prefsKey(uid));
    await prefs.setString(_prefsKey(uid), fileName);
    if (previous != null) {
      final oldFile = File('${directory.path}/$previous');
      if (await oldFile.exists()) await oldFile.delete();
    }

    emit(state.copyWith(image: saved.path));
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
