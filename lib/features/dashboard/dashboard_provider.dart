import 'package:flutter/material.dart';
import 'dashboard_model.dart';
import 'dashboard_service.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardData? data;
  bool loading = false;
  String? error;
  String? selectedYear;

  Future<void> load({String? year}) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      data = await DashboardService.getDashboard(year: year ?? selectedYear);
    } catch (e) {
      error = 'Erreur de chargement.';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void setYear(String? year) {
    selectedYear = year;
    load(year: year);
  }
}