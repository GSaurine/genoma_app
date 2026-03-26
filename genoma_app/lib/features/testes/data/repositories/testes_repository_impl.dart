import 'package:dartz/dartz.dart';
import 'package:genoma_app/core/errors/failures.dart';
import 'package:genoma_app/core/network/network_info.dart';
import '../../domain/entities/teste.dart';
import '../../domain/repositories/testes_repository.dart';
import '../datasources/testes_remote_datasource.dart';

class TestesRepositoryImpl implements TestesRepository {
  final TestesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TestesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Teste>>> getAllTestes() async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      final result = await remoteDataSource.getAllTestes();
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Teste>> getTesteById(String id) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      final result = await remoteDataSource.getTesteById(id);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Teste>> createTeste(Teste teste) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      final result = await remoteDataSource.createTeste(teste as dynamic);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Teste>> updateTeste(Teste teste) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      final result = await remoteDataSource.updateTeste(teste as dynamic);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTeste(String id) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      await remoteDataSource.deleteTeste(id);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
