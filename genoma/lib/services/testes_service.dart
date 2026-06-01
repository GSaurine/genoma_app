import 'package:genoma/core/config/dioConfig.dart';

class TestesService {
  TestesService._internal();
  static final TestesService _instance = TestesService._internal();
  factory TestesService() => _instance;

  Future<List<Map<String, dynamic>>> fetchTestes() async {
    final api = APIService();
    final resp = await api.getRequest('/testes');
    final body = resp.data;
    if (body is Map && body['data'] is List) {
      return List<Map<String, dynamic>>.from((body['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)));
    }
    return [];
  }

  Future<Map<String, dynamic>?> createTeste(Map<String, dynamic> data) async {
    final api = APIService();
    final resp = await api.postRequest('/testes', data: data);
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      final responseData = resp.data;
      if (responseData is Map) {
        return Map<String, dynamic>.from(responseData['data'] ?? responseData);
      }
    }
    return null;
  }

  Future<bool> addItemToTeste(String testeId, String itemId) async {
    final api = APIService();
    final resp = await api.postRequest('/teste-composicao', data: {
      'teste_id': testeId,
      'item_id': itemId,
    });
    return resp.statusCode == 200 || resp.statusCode == 201;
  }
}
