class ProfileState {
  final String name;
  final String email;
  final String phone;
  final String image;
  final bool isDarkMode;
  final bool isLoading;

  ProfileState({
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.isDarkMode,
    required this.isLoading,
  });

  factory ProfileState.initial() {
    return ProfileState(
      name: '',
      email: '',
      phone: '',
      image: '',
      isDarkMode: false,
      isLoading: false,
    );
  }

  ProfileState copyWith({
    String? name,
    String? email,
    String? phone,
    String? image,
    bool? isDarkMode,
    bool? isLoading,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
