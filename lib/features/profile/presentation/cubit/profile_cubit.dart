import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  File? profileImage;

  String userName = '';
  String userEmail = '';

  final ImagePicker picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);

      saveUserData();

      emit(ProfileImageUpdated());
    }
  }

  Future<void> saveUserData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_name', userName);

    await prefs.setString('user_email', userEmail);

    if (profileImage != null) {
      await prefs.setString('profile_image', profileImage!.path);
    }
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    userName = prefs.getString('user_name') ?? '';

    userEmail = prefs.getString('user_email') ?? '';

    final imagePath = prefs.getString('profile_image');

    if (imagePath != null) {
      profileImage = File(imagePath);
    }

    emit(ProfileLoaded());
  }
}
