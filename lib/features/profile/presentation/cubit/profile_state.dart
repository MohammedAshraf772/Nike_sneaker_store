class ProfileState {
  final String image;

  const ProfileState({this.image = ''});

  ProfileState copyWith({String? image}) {
    return ProfileState(image: image ?? this.image);
  }
}
