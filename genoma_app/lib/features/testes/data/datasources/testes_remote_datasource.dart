import 'package:genoma_app/core/network/dio_client.dart';
import '../models/teste_model.dart';

abstract class TestesRemoteDataSource {
  Future<List<TesteModel>> getAllTestes();
  Future<TesteModel> getTesteById(String id);
  Future<TesteModel> createTeste(TesteModel teste);
  Future<TesteModel> updateTeste(TesteModel teste);
  Future<void> deleteTeste(String id);
}

class TestesRemoteDataSourceImpl implements TestesRemoteDataSource {
  final DioClient dioClient;

  TestesRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<TesteModel>> getAllTestes() async {
    final response = await dioClient.get('/testes');
    return (response.data as List).map((t) => TesteModel.fromJson(t as Map<String, dynamic>)).toList();
  }

  @override
  Future<TesteModel> getTesteById(String id) async {
    final response = await dioClient.get('/testes/$id');
    return TesteModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<TesteModel> createTeste(TesteModel teste) async {
    final response = await dioClient.post('/testes', data: teste.toJson());
    return TesteModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<TesteModel> updateTeste(TesteModel teste) async {
    final response = await dioClient.put('/testes/${teste.id}', data: teste.toJson());
    return TesteModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteTeste(String id) async {
    await dioClient.delete('/testes/$id');
  }
}
