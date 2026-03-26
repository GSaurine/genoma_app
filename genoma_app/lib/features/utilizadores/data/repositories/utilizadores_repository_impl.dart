import 'package:dartz/dartz.dart';
import 'package:genoma_app/core/errors/failures.dart';
import 'package:genoma_app/core/network/network_info.dart';
import '../../domain/entities/utilizadores.dart';
import '../../domain/repositories/utilizadores_repository.dart';
import '../datasources/utilizadores_remote_datasources.dart';
import '../models/utilizadores_model.dart';

class UtilizadoresRepositoryImpl implements UtilizadoresRepository {
  final UtilizadoresRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UtilizadoresRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Utilizador>>> getAllUtilizadores() async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      final result = await remoteDataSource.getAllUtilizadores();
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Utilizador>> getUtilizadorById(String id) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      final result = await remoteDataSource.getUtilizadorById(id);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Utilizador>> createUtilizador(Utilizador utilizador) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      final utilizadorModel = utilizador as UtilizadorModel;
      final result = await remoteDataSource.createUtilizador(utilizadorModel);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Utilizador>> updateUtilizador(Utilizador utilizador) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      final utilizadorModel = utilizador as UtilizadorModel;
      final result = await remoteDataSource.updateUtilizador(utilizadorModel);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUtilizador(String id) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      await remoteDataSource.deleteUtilizador(id);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}