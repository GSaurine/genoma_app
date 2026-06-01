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

  Future<List<Map<String, dynamic>>> fetchKits({String? postoId, String? status}) async {
    final api = APIService();

    final Map<String, dynamic> queryParameters = {};
    if (postoId != null) queryParameters['posto_id'] = postoId;
    if (status != null) queryParameters['status'] = status;

    final resp = await api.getRequest('/kits', queryParameters: queryParameters);
    final body = resp.data;
    if (body == null) return [];
    if (body is Map && body['data'] is List) {
       return List<Map<String, dynamic>>.from(
           (body['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)));
    }
    return [];
  }
}
