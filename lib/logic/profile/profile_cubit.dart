import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  void toggleDarkMode() {
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }

  void toggleNotifications() {
    emit(state.copyWith(isNotificationsOn: !state.isNotificationsOn));
  }

  void updateProfile({String? name, String? email, String? phone}) {
    emit(state.copyWith(name: name, email: email, phone: phone));
  }
}
