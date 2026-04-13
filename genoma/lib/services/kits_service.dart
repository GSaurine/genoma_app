import 'package:genoma/core/config/dioConfig.dart';

class KitsService {
  KitsService._internal();
  static final KitsService _instance = KitsService._internal();
  factory KitsService() => _instance;

  Future<Map<String, dynamic>?> createKit(Map<String, dynamic> data) async {
    final api = APIService();
    final resp = await api.postRequest('/kits', data: data);
    final body = resp.data;
    if (body is Map && body['data'] is Map) {
      return Map<String, dynamic>.from(body['data'] as Map);
    }
    return null;
  }
}
