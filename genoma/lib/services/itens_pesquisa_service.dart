import 'package:genoma/core/config/dioConfig.dart';

class ItensPesquisaService {
  ItensPesquisaService._internal();
  static final ItensPesquisaService _instance = ItensPesquisaService._internal();
  factory ItensPesquisaService() => _instance;

  Future<List<Map<String, dynamic>>> fetchItens() async {
    final api = APIService();
    final resp = await api.getRequest('/itens');
    final body = resp.data;
    if (body is Map && body['data'] is List) {
      return List<Map<String, dynamic>>.from((body['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)));
    }
    return [];
  }

  Future<Map<String, dynamic>?> createItem(Map<String, dynamic> data) async {
    final api = APIService();
    final resp = await api.postRequest('/itens', data: data);
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      final responseData = resp.data;
      if (responseData is Map) {
        return Map<String, dynamic>.from(responseData['data'] ?? responseData);
      }
    }
    return null;
  }
}
