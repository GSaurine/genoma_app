import 'package:genoma/core/config/dioConfig.dart';

class ResultadosService {
  ResultadosService._internal();
  static final ResultadosService _instance = ResultadosService._internal();
  factory ResultadosService() => _instance;

  Future<List<Map<String, dynamic>>> fetchResultados() async {
    final api = APIService();
    final resp = await api.getRequest('/resultados');
    final body = resp.data;
    if (body is Map && body['data'] is List) {
      return List<Map<String, dynamic>>.from((body['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)));
    }
    return [];
  }

  Future<Map<String, dynamic>?> createResultado(Map<String, dynamic> data) async {
    final api = APIService();
    final resp = await api.postRequest('/resultados', data: data);
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      final responseData = resp.data;
      if (responseData is Map) {
        return Map<String, dynamic>.from(responseData['data'] ?? responseData);
      }
    }
    return null;
  }
}
