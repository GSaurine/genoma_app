import 'package:genoma_app/core/network/dio_client.dart';
import '../models/pedido_model.dart';

abstract class PedidosRemoteDataSource {
  Future<List<PedidoModel>> getAllPedidos();
  Future<PedidoModel> getPedidoById(String id);
  Future<PedidoModel> createPedido(PedidoModel pedido);
  Future<PedidoModel> updatePedido(PedidoModel pedido);
  Future<void> deletePedido(String id);
}

class PedidosRemoteDataSourceImpl implements PedidosRemoteDataSource {
  final DioClient dioClient;

  PedidosRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<PedidoModel>> getAllPedidos() async {
    final response = await dioClient.get('/pedidos');
    return (response.data as List).map((p) => PedidoModel.fromJson(p as Map<String, dynamic>)).toList();
  }

  @override
  Future<PedidoModel> getPedidoById(String id) async {
    final response = await dioClient.get('/pedidos/$id');
    return PedidoModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PedidoModel> createPedido(PedidoModel pedido) async {
    final response = await dioClient.post('/pedidos', data: pedido.toJson());
    return PedidoModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PedidoModel> updatePedido(PedidoModel pedido) async {
    final response = await dioClient.put('/pedidos/${pedido.id}', data: pedido.toJson());
    return PedidoModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deletePedido(String id) async {
    await dioClient.delete('/pedidos/$id');
  }
}
