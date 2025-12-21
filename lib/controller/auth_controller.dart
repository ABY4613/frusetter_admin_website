import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';
import '../core/constants/api_constants.dart';

class AuthController with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;
  String? _accessToken;
  DateTime? _loginTime;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _accessToken != null;
  DateTime? get loginTime => _loginTime;

  AuthController() {
    checkAuth();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.authLogin}');
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
          _loginTime = DateTime.now();

          // Save token and login time
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', _accessToken!);
          await prefs.setString(
              'user_data', jsonEncode(_currentUser!.toJson()));
          await prefs.setString('login_time', _loginTime!.toIso8601String());

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
    _loginTime = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('user_data');
    await prefs.remove('login_time');
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
      if (prefs.containsKey('login_time')) {
        try {
          _loginTime = DateTime.parse(prefs.getString('login_time')!);
        } catch (e) {
          _loginTime = null;
        }
      }
      notifyListeners();
    }
  }
}
