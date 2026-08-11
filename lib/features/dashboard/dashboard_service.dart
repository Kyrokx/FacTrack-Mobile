import '../../core/api_client.dart';
import 'dashboard_model.dart';

class DashboardService {
  static Future<DashboardData> getDashboard({String? year}) async {
    final response = await ApiClient.dio.get(
      '/bills/dashboard/',
      queryParameters: year != null ? {'year': year} : null,
    );
    return DashboardData.fromJson(response.data);
  }
}