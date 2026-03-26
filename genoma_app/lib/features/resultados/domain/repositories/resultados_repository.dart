import 'package:dartz/dartz.dart';
import 'package:genoma_app/core/errors/failures.dart';
import '../entities/resultado.dart';

abstract class ResultadosRepository {
  Future<Either<Failure, List<Resultado>>> getAllResultados();
  Future<Either<Failure, Resultado>> getResultadoById(String id);
  Future<Either<Failure, Resultado>> createResultado(Resultado resultado);
  Future<Either<Failure, Resultado>> updateResultado(Resultado resultado);
  Future<Either<Failure, void>> deleteResultado(String id);
}
