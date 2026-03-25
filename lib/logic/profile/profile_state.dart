import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String name;
  final String email;
  final String phone;
  final bool isDarkMode;
  final bool isNotificationsOn;

  const ProfileState({
    this.name = 'Ahmed Mohamed',
    this.email = 'ahmed@example.com',
    this.phone = '+20 100 000 0000',
    this.isDarkMode = true,
    this.isNotificationsOn = true,
  });

  ProfileState copyWith({
    String? name,
    String? email,
    String? phone,
    bool? isDarkMode,
    bool? isNotificationsOn,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isNotificationsOn: isNotificationsOn ?? this.isNotificationsOn,
    );
  }

  @override
  List<Object?> get props => [
    name,
    email,
    phone,
    isDarkMode,
    isNotificationsOn,
  ];
}
