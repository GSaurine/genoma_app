import 'package:genoma/core/config/dioConfig.dart';

class PostosService {
  PostosService._internal();
  static final PostosService _instance = PostosService._internal();
  factory PostosService() => _instance;

  Future<List<Map<String, dynamic>>> fetchPostos() async {
    final api = APIService();
    final resp = await api.getRequest('/postos');
    final body = resp.data;
    if (body is Map && body['data'] is List) {
      return List<Map<String, dynamic>>.from((body['data'] as List).map((e) => Map<String, dynamic>.from(e as Map)));
    }
    return [];
  }

  Future<Map<String, dynamic>?> createPosto(Map<String, dynamic> data) async {
    final api = APIService();
    final resp = await api.postRequest('/postos', data: data);
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      final responseData = resp.data;
      if (responseData is Map) {
        return Map<String, dynamic>.from(responseData['data'] ?? responseData);
      }
    }
    return null;
  }
}
