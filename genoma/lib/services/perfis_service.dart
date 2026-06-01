import 'package:genoma/core/config/dioConfig.dart';

class PerfisService {
  PerfisService._internal();
  static final PerfisService _instance = PerfisService._internal();
  factory PerfisService() => _instance;

  Future<List<Map<String, dynamic>>> fetchPerfis() async {
    final api = APIService();
    final resp = await api.getRequest('/perfis');
    final body = resp.data;
    if (body is Map && body['data'] is List) {
      return List<Map<String, dynamic>>.from((body['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)));
    }
    return [];
  }

  Future<Map<String, dynamic>?> createPerfil(Map<String, dynamic> data) async {
    final api = APIService();
    final resp = await api.postRequest('/perfis', data: data);
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      final responseData = resp.data;
      if (responseData is Map) {
        return Map<String, dynamic>.from(responseData['data'] ?? responseData);
      }
    }
    return null;
  }
}
