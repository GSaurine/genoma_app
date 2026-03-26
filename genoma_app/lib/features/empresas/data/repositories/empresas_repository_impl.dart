import 'package:dartz/dartz.dart';
import 'package:genoma_app/core/errors/failures.dart';
import 'package:genoma_app/core/network/network_info.dart';
import '../../domain/entities/empresa.dart';
import '../../domain/repositories/empresas_repository.dart';
import '../datasources/empresas_remote_datasource.dart';

class EmpresasRepositoryImpl implements EmpresasRepository {
  final EmpresasRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  EmpresasRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Empresa>>> getAllEmpresas() async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      final result = await remoteDataSource.getAllEmpresas();
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Empresa>> getEmpresaById(String id) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      final result = await remoteDataSource.getEmpresaById(id);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Empresa>> createEmpresa(Empresa empresa) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      final result = await remoteDataSource.createEmpresa(empresa as dynamic);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Empresa>> updateEmpresa(Empresa empresa) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      final result = await remoteDataSource.updateEmpresa(empresa as dynamic);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}