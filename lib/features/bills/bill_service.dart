import 'package:dio/dio.dart';
import '../../core/api_client.dart';
import 'bill_model.dart';

class BillService {
  static Future<List<Bill>> getBills() async {
    try {
      final response = await ApiClient.dio.get('/bills/');
      return (response.data as List).map((e) => Bill.fromJson(e)).toList();
    } on DioException catch (e) {
      final message = e.response?.data['error'] ?? 'Erreur de chargement.';
      throw Exception(message);
    }
  }

  static Future<void> togglePaid(int id) async {
    try {
      await ApiClient.dio.post('/bills/$id/toggle/');
    } on DioException catch (e) {
      final message = e.response?.data['error'] ?? 'Erreur lors de la mise à jour.';
      throw Exception(message);
    }
  }

  static Future<void> deleteBill(int id) async {
    try {
      await ApiClient.dio.delete('/bills/$id/delete/');
    } on DioException catch (e) {
      final message = e.response?.data['error'] ?? 'Erreur lors de la suppression.';
      throw Exception(message);
    }
  }

  static Future<Bill> createBill(Map<String, dynamic> data) async {
    try {
      final response = await ApiClient.dio.post('/bills/create/', data: data);
      return Bill.fromJson(response.data);
    } on DioException catch (e) {
      final message = e.response?.data['error'] ?? 'Erreur lors de la création.';
      throw Exception(message);
    }
  }
}