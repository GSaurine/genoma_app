import 'package:dartz/dartz.dart';
import 'package:genoma_app/core/errors/failures.dart';
import 'package:genoma_app/core/network/network_info.dart';
import '../../domain/entities/pedido.dart';
import '../../domain/repositories/pedidos_repository.dart';
import '../datasources/pedidos_remote_datasource.dart';

class PedidosRepositoryImpl implements PedidosRepository {
  final PedidosRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PedidosRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Pedido>>> getAllPedidos() async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      final result = await remoteDataSource.getAllPedidos();
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Pedido>> getPedidoById(String id) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      final result = await remoteDataSource.getPedidoById(id);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Pedido>> createPedido(Pedido pedido) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      final result = await remoteDataSource.createPedido(pedido as dynamic);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Pedido>> updatePedido(Pedido pedido) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      final result = await remoteDataSource.updatePedido(pedido as dynamic);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePedido(String id) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'Sem conexão com a internet'));
      }
      await remoteDataSource.deletePedido(id);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
