import 'package:dartz/dartz.dart';
import 'package:genoma_app/core/errors/failures.dart';
import 'package:genoma_app/core/network/network_info.dart';
import '../../domain/entities/medico.dart';
import '../../domain/repositories/medicos_repository.dart';
import '../datasources/medicos_remote_datasource.dart';

class MedicosRepositoryImpl implements MedicosRepository {
  final MedicosRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MedicosRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Medico>>> getAllMedicos() async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      final result = await remoteDataSource.getAllMedicos();
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Medico>> getMedicoById(String id) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      final result = await remoteDataSource.getMedicoById(id);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Medico>> createMedico(Medico medico) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      final result = await remoteDataSource.createMedico(medico as dynamic);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Medico>> updateMedico(Medico medico) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      final result = await remoteDataSource.updateMedico(medico as dynamic);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMedico(String id) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      await remoteDataSource.deleteMedico(id);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
