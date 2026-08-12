import 'package:flutter/material.dart';
import 'bill_model.dart';
import 'bill_service.dart';

class BillProvider extends ChangeNotifier {
  List<Bill> _bills = [];
  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;


  // Filtre actuel
  String? typeFilter; // 'SONABEL', 'ONEA', ou null pour tout

  void clearError() {
    _error = null;
    notifyListeners();
  }

  List<Bill> get bills {
    if (typeFilter == null) return _bills;
    return _bills.where((b) => b.type == typeFilter).toList();
  }

  Future<void> load({bool force = false}) async {
    if (_bills.isNotEmpty && !force) return;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _bills = await BillService.getBills();
    } on Exception catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void setFilter(String? type) {
    typeFilter = type;
    notifyListeners();
  }

  Future<void> togglePaid(int id) async {
    try {
      await BillService.togglePaid(id);
      final index = _bills.indexWhere((b) => b.id == id);
      if (index != -1) {
        _bills[index] = Bill(
          id: _bills[index].id,
          type: _bills[index].type,
          period: _bills[index].period,
          deadline: _bills[index].deadline,
          priceTotal: _bills[index].priceTotal,
          previousIndex: _bills[index].previousIndex,
          newIndex: _bills[index].newIndex,
          totalConsumption: _bills[index].totalConsumption,
          paid: !_bills[index].paid,
        );
        notifyListeners();
      }
    } on Exception catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> deleteBill(int id) async {
    try {
      await BillService.deleteBill(id);
      _bills.removeWhere((b) => b.id == id);
      notifyListeners();
    } on Exception catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }
}