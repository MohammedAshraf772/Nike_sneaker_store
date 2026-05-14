import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit()
    : super(
        ProfileState(
          name: "Name",
          email: "E-mail@gmail.com",
          image: "",
          isDarkMode: false,
          phone: '',
          isLoading: false,
        ),
      );

  void toggleTheme() {
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }

  Future<void> pickAndUploadImage() async {}
}
