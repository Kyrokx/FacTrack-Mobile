import '../../core/api_client.dart';
import '../../core/storage.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await ApiClient.dio.post('/auth/login/', data: {
      'username': username,
      'password': password,
    });
    await Storage.saveTokens(
      response.data['access'],
      response.data['refresh'],
    );
    return response.data;
  }

  static Future<Map<String, dynamic>> register(String username, String password, String email) async {
    final response = await ApiClient.dio.post('/auth/register/', data: {
      'username': username,
      'password': password,
      'email': email,
    });
    await Storage.saveTokens(
      response.data['access'],
      response.data['refresh'],
    );
    return response.data;
  }

  static Future<void> logout() async {
    final refresh = await Storage.getRefresh();
    try {
      await ApiClient.dio.post('/auth/logout/', data: {'refresh': refresh});
    } catch (_) {}
    await Storage.clear();
  }

  static Future<Map<String, dynamic>> getMe() async {
    final response = await ApiClient.dio.get('/auth/me/');
    return response.data;
  }
}