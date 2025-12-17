import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';

class AuthController with ChangeNotifier {
  // TODO: Replace with your actual base URL. If running locally on emulator use 10.0.2.2 or your IP.
  static const String baseUrl = 'https://frusette-backend-ym62.onrender.com';

  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;
  String? _accessToken;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _accessToken != null;

  AuthController() {
    checkAuth();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = Uri.parse('$baseUrl/v1/auth/login');
      debugPrint('Logging in to $url with $email');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      debugPrint('Response Status: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final authResponse = AuthResponse.fromJson(body);

        if (authResponse.success && authResponse.data != null) {
          _accessToken = authResponse.data!.accessToken;
          _currentUser = authResponse.data!.user;

          // Save token
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', _accessToken!);
          await prefs.setString(
              'user_data', jsonEncode(_currentUser!.toJson()));

          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _errorMessage = 'Login failed: Server indicated failure';
        }
      } else {
        _errorMessage = 'Login failed: ${response.statusCode}';
        try {
          final Map<String, dynamic> body = jsonDecode(response.body);
          if (body.containsKey('message')) {
            _errorMessage = body['message'];
          }
        } catch (_) {}
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    _accessToken = null;
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('user_data');
    notifyListeners();
  }

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('access_token')) {
      _accessToken = prefs.getString('access_token');
      if (prefs.containsKey('user_data')) {
        try {
          _currentUser =
              User.fromJson(jsonDecode(prefs.getString('user_data')!));
        } catch (e) {
          // In case stored data is corrupted
          _accessToken = null;
          await prefs.clear();
        }
      }
      notifyListeners();
    }
  }
}
