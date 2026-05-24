part of 'profile_cubit.dart';

class ProfileState {
  final String image;

  const ProfileState({required this.image});

  ProfileState copyWith({String? image}) {
    return ProfileState(image: image ?? this.image);
  }
}
