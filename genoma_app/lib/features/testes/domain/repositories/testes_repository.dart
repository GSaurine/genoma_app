import 'package:dartz/dartz.dart';
import 'package:genoma_app/core/errors/failures.dart';
import '../entities/teste.dart';

abstract class TestesRepository {
  Future<Either<Failure, List<Teste>>> getAllTestes();
  Future<Either<Failure, Teste>> getTesteById(String id);
  Future<Either<Failure, Teste>> createTeste(Teste teste);
  Future<Either<Failure, Teste>> updateTeste(Teste teste);
  Future<Either<Failure, void>> deleteTeste(String id);
}
