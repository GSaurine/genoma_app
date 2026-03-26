import 'package:dartz/dartz.dart';
import 'package:genoma_app/core/errors/failures.dart';
import '../entities/utilizadores.dart';

abstract class UtilizadoresRepository {
  Future<Either<Failure, List<Utilizador>>> getAllUtilizadores();
  Future<Either<Failure, Utilizador>> getUtilizadorById(String id);
  Future<Either<Failure, Utilizador>> createUtilizador(Utilizador utilizador);
  Future<Either<Failure, Utilizador>> updateUtilizador(Utilizador utilizador);
  Future<Either<Failure, void>> deleteUtilizador(String id);
}
