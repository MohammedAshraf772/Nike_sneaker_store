import 'package:nike_sneaker_store/features/auth/data/datsource/auth_remote_datasource.dart';
import 'package:nike_sneaker_store/features/auth/domain/entities/user_entities.dart';
import '../../domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<UserEntity> login(String email, String password) {
    return remote.login(email, password);
  }

  @override
  Future<UserEntity> register(String name, String email, String password) {
    return remote.register(name, email, password);
  }

  @override
  Future<void> logout() {
    return remote.logout();
  }

  @override
  UserEntity? getCurrentUser() {
    final user = remote.currentUser;
    if (user == null) return null;

    return UserEntity(
      uid: user.uid,
      email: user.email ?? '',
      name: user.email!.split('@')[0],
    );
  }

  @override
  Future<void> forgotPassword(String email) {
    throw UnimplementedError();
  }
}
