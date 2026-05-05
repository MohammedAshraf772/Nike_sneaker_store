import '../repository/auth_repository.dart';

class Login {
  final AuthRepository repo;

  Login(this.repo);

  call(String email, String password) {
    return repo.login(email, password);
  }
}
