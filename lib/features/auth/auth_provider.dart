import 'package:flutter/material.dart';
import '../../core/storage.dart';
import 'auth_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  AuthStatus status = AuthStatus.unknown;
  bool get hasOrganization => user?['has_organization'] == true;
  Map<String, dynamic>? user;
  String? error;

  AuthProvider() {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final token = await Storage.getAccess();
    if (token != null) {
      try {
        user = await AuthService.getMe();
        status = AuthStatus.authenticated;
      } catch (_) {
        status = AuthStatus.unauthenticated;
      }
    } else {
      status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    error = null;
    status = AuthStatus.unknown;
    notifyListeners();

    try {
      await AuthService.login(username, password);
      user = await AuthService.getMe();
      status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (_) {
      error = 'Identifiants invalides.';
      status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String username, String password, String email) async {
    error = null;
    try {
      await AuthService.register(username, password, email);
      user = await AuthService.getMe();
      status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (_) {
      error = 'Erreur lors de l\'inscription.';
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    user = null;
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> refreshUser() async {
    try {
      user = await AuthService.getMe();
      notifyListeners();
    } catch (_) {}
  }
}