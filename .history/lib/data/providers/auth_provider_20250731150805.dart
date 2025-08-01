import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _token;
  String? _userId;

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  String? get userId => _userId;

  void login(String token, String userId) {
    _token = token;
    _userId = userId;
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _token = null;
    _userId = null;
    _isAuthenticated = false;
    notifyListeners();
  }
} 