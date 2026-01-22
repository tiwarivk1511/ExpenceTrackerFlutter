import 'package:expence_tracker/repository/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  bool _isAuthenticated = false;
  int? _userId;

  bool get isAuthenticated => _isAuthenticated;
  int? get userId => _userId;

  Future<void> checkLoginStatus() async {
    _isAuthenticated = await _authRepository.isLoggedIn();
    if (_isAuthenticated) {
      _userId = await _authRepository.getUserId();
    }
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    final success = await _authRepository.login(username, password);
    if (success) {
      _isAuthenticated = true;
      _userId = await _authRepository.getUserId();
      notifyListeners();
    }
    return success;
  }

  Future<bool> signup(
    String name,
    String email,
    String username,
    String mobile,
    String password,
    String confirmPassword,
  ) async {
    return await _authRepository.signup(
      name,
      email,
      username,
      mobile,
      password,
      confirmPassword,
    );
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _isAuthenticated = false;
    _userId = null;
    notifyListeners();
  }
}
