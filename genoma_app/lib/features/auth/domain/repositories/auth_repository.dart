import 'package:dartz/dartz.dart';
import 'package:genoma_app/core/errors/failures.dart';
import '../entities/user.dart';
import '../entities/token.dart';

abstract class AuthRepository {
  Future<Either<Failure, Token>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, Token>> refreshToken();
}
