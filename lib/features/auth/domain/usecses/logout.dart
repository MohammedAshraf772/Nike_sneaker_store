import '../repository/auth_repository.dart';

class Logout {
  final AuthRepository repo;

  Logout(this.repo);

  call() {
    return repo.logout();
  }
}
