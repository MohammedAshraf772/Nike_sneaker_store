import '../repository/auth_repository.dart';

class ForgotPassword {
  final AuthRepository repo;

  ForgotPassword(this.repo);

  Future<void> call(String email) {
    return repo.forgotPassword(email);
  }
}
