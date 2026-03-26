import 'package:dartz/dartz.dart';
import 'package:genoma_app/core/errors/failures.dart';
import '../entities/pedido.dart';

abstract class PedidosRepository {
  Future<Either<Failure, List<Pedido>>> getAllPedidos();
  Future<Either<Failure, Pedido>> getPedidoById(String id);
  Future<Either<Failure, Pedido>> createPedido(Pedido pedido);
  Future<Either<Failure, Pedido>> updatePedido(Pedido pedido);
  Future<Either<Failure, void>> deletePedido(String id);
}
