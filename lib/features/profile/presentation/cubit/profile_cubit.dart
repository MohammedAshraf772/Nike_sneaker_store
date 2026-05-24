import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState(image: '')) {
    loadProfileImage();
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();

    final image = prefs.getString('profile_image') ?? '';

    emit(state.copyWith(image: image));
  }

  Future<void> pickImageFromGallery() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('profile_image', pickedImage.path);

      emit(state.copyWith(image: pickedImage.path));
    }
  }

  Future<void> pickImageFromCamera() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('profile_image', pickedImage.path);

      emit(state.copyWith(image: pickedImage.path));
    }
  }
}
