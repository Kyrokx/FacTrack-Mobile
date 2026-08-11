import '../../core/api_client.dart';

class SetupService {
  static Future<void> createOrganization(String name) async {
    await ApiClient.dio.post('/organizations/create/', data: {'name': name});
  }

  static Future<void> joinOrganization(String inviteCode) async {
    await ApiClient.dio.post('/organizations/join/', data: {'invite_code': inviteCode});
  }
}