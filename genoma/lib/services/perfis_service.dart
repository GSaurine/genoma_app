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
}
