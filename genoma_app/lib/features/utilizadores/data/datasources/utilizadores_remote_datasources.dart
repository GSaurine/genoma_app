import 'package:genoma_app/core/network/dio_client.dart';
import '../models/utilizadores_model.dart';

abstract class UtilizadoresRemoteDataSource {
  Future<List<UtilizadorModel>> getAllUtilizadores();
  Future<UtilizadorModel> getUtilizadorById(String id);
  Future<UtilizadorModel> createUtilizador(UtilizadorModel utilizador);
  Future<UtilizadorModel> updateUtilizador(UtilizadorModel utilizador);
  Future<void> deleteUtilizador(String id);
}

class UtilizadoresRemoteDataSourceImpl implements UtilizadoresRemoteDataSource {
  final DioClient dioClient;

  UtilizadoresRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<UtilizadorModel>> getAllUtilizadores() async {
    final response = await dioClient.get('/utilizadores');
    return (response.data as List).map((u) => UtilizadorModel.fromJson(u as Map<String, dynamic>)).toList();
  }

  @override
  Future<UtilizadorModel> getUtilizadorById(String id) async {
    final response = await dioClient.get('/utilizadores/$id');
    return UtilizadorModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<UtilizadorModel> createUtilizador(UtilizadorModel utilizador) async {
    final response = await dioClient.post('/utilizadores', data: utilizador.toJson());
    return UtilizadorModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<UtilizadorModel> updateUtilizador(UtilizadorModel utilizador) async {
    final response = await dioClient.put('/utilizadores/${utilizador.id}', data: utilizador.toJson());
    return UtilizadorModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteUtilizador(String id) async {
    await dioClient.delete('/utilizadores/$id');
  }
}