import '../repository/auth_repository.dart';

class Register {
  final AuthRepository repo;

  Register(this.repo);

  call(String name, String email, String password) {
    return repo.register(name, email, password);
  }
}
