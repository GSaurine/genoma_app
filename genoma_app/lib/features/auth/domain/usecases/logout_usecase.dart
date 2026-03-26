import 'package:dartz/dartz.dart';
import 'package:genoma_app/core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase({required this.repository});

  Future<Either<Failure, void>> call() {
    return repository.logout();
  }
}
