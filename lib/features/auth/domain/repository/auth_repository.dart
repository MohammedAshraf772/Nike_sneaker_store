import 'package:nike_sneaker_store/features/auth/domain/entities/user_entities.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String name, String email, String password);
  Future<void> logout();
  Future<void> forgotPassword(String email);
  UserEntity? getCurrentUser();
}
