import 'package:genoma/core/config/dioConfig.dart';

class UtilizadoresService {
  UtilizadoresService._internal();
  static final UtilizadoresService _instance = UtilizadoresService._internal();
  factory UtilizadoresService() => _instance;

  Future<List<Map<String, dynamic>>> fetchUtilizadores() async {
    final api = APIService();
    final resp = await api.getRequest('/utilizadores');
    final body = resp.data;
    if (body is Map && body['data'] is List) {
      return List<Map<String, dynamic>>.from((body['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)));
    }
    return [];
  }

  Future<Map<String, dynamic>?> createUtilizador(Map<String, dynamic> data) async {
    final api = APIService();
    final resp = await api.postRequest('/utilizadores', data: data);
    final body = resp.data;
    if (body is Map && body['data'] is Map) {
      return Map<String, dynamic>.from(body['data'] as Map);
    }
    return null;
  }
}
