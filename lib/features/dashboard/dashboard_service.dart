import 'package:dio/dio.dart';

import '../../core/api_client.dart';
import 'dashboard_model.dart';

class DashboardService {
  static Future<DashboardData> getDashboard({String? year}) async {

    try {
      final response = await ApiClient.dio.get(
        '/bills/dashboard/',
        queryParameters: year != null ? {'year': year} : null,
      );
      return DashboardData.fromJson(response.data);
    } on DioException catch (e) {
      final message = e.response?.data['error'] ?? 'Une erreur est survenue.';
      throw Exception(message);
    }

  }
}