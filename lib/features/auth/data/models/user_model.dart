import 'package:nike_sneaker_store/features/auth/domain/entities/user_entities.dart';

class UserModel extends UserEntity {
  UserModel({required super.uid, required super.email, required super.name});

  factory UserModel.fromFirebase(user, Map<String, dynamic>? data) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: data?['name'] ?? '',
    );
  }
}
