import 'package:dio/dio.dart';
import 'package:factrack_mobile/features/organization/membership_model.dart';
import '../../core/api_client.dart';
import 'organization_model.dart';


class OrganizationService {
  static Future<Organization> getOrganizationInfo() async {
    try {
      final response = await ApiClient.dio.get('/organizations/');
      return Organization.fromJson(response.data);
    } on DioException catch (e) {
      final message = e.response?.data['error'] ?? 'Erreur de chargement.';
      throw Exception(message);
    }
  }

  static Future<List<Membership>> getOrganizationMembers() async {
    try {
      final response = await ApiClient.dio.get('/organizations/members/');
      return (response.data as List).map((e) => Membership.fromJson(e)).toList();
    } on DioException catch (e) {
      final message = e.response?.data['error'] ?? 'Erreur de chargement.';
      throw Exception(message);
    }
  }

  static Future<void> removeMember(int id) async {
    try {
      await ApiClient.dio.delete('/organizations/members/$id/remove/');
    } on DioException catch (e) {
      final message = e.response?.data['error'] ?? 'Erreur lors de la suppression.';
      throw Exception(message);
    }
  }

  static Future<void> promoteMember(int id) async {
    try {
      await ApiClient.dio.patch('/organizations/members/$id/promote/');
    } on DioException catch (e) {
      final message = e.response?.data['error'] ?? 'Erreur lors de la promotion.';
      throw Exception(message);
    }
  }

  static Future<String> regenerateInviteCode() async {
    try {
      final response = await ApiClient.dio.post('/organizations/regenerate-invite-code/');
      return response.data['invite_code'];
    } on DioException catch (e) {
      final message = e.response?.data['error'] ?? 'Erreur lors de la régénération.';
      throw Exception(message);
    }
  }
}