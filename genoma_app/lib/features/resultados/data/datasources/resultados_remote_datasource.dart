import 'package:genoma_app/core/network/dio_client.dart';
import '../models/resultado_model.dart';

abstract class ResultadosRemoteDataSource {
  Future<List<ResultadoModel>> getAllResultados();
  Future<ResultadoModel> getResultadoById(String id);
  Future<ResultadoModel> createResultado(ResultadoModel resultado);
  Future<ResultadoModel> updateResultado(ResultadoModel resultado);
  Future<void> deleteResultado(String id);
}

class ResultadosRemoteDataSourceImpl implements ResultadosRemoteDataSource {
  final DioClient dioClient;

  ResultadosRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<ResultadoModel>> getAllResultados() async {
    final response = await dioClient.get('/resultados');
    return (response.data as List).map((r) => ResultadoModel.fromJson(r as Map<String, dynamic>)).toList();
  }

  @override
  Future<ResultadoModel> getResultadoById(String id) async {
    final response = await dioClient.get('/resultados/$id');
    return ResultadoModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ResultadoModel> createResultado(ResultadoModel resultado) async {
    final response = await dioClient.post('/resultados', data: resultado.toJson());
    return ResultadoModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ResultadoModel> updateResultado(ResultadoModel resultado) async {
    final response = await dioClient.put('/resultados/${resultado.id}', data: resultado.toJson());
    return ResultadoModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteResultado(String id) async {
    await dioClient.delete('/resultados/$id');
  }
}
