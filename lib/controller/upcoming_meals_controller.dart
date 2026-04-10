import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';
import '../model/upcoming_meal.dart';

class UpcomingMealsController with ChangeNotifier {
  List<UpcomingMeal> _upcomingMeals = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedUserId;
  String? _selectedUserName;

  List<UpcomingMeal> get upcomingMeals => _upcomingMeals;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedUserId => _selectedUserId;
  String? get selectedUserName => _selectedUserName;

  void setSelectedUser(String? userId, String? userName) {
    _selectedUserId = userId;
    _selectedUserName = userName;
    notifyListeners();
  }

  Future<void> fetchUpcomingMeals(String userId) async {
    _selectedUserId = userId;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminCustomerUpcomingMeals(userId)}');
      debugPrint('Fetching upcoming meals from $url');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Upcoming Meals Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          final List<dynamic> data = body['data'];
          _upcomingMeals = data.map((json) => UpcomingMeal.fromJson(json)).toList();
        } else {
          _errorMessage = 'No upcoming meals found';
          _upcomingMeals = [];
        }
      } else {
        _errorMessage = 'Server error: ${response.statusCode}';
        _upcomingMeals = [];
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
      _upcomingMeals = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> pauseMeal(String userId, String mealId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminPauseMeal(userId, mealId)}');
      debugPrint('Pausing meal: $url');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({}),
      );

      debugPrint('Pause Meal Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        // Find and update the meal status locally
        final index = _upcomingMeals.indexWhere((m) => m.id == mealId);
        if (index != -1) {
          // Since models are often immutable, I'll just refetch for simplicity and data integrity
          await fetchUpcomingMeals(userId);
        }
        return true;
      } else {
        _errorMessage = 'Failed to pause meal: ${response.body}';
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> unpauseMeal(String userId, String mealId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminUnpauseMeal(userId, mealId)}');
      debugPrint('Unpausing meal: $url');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({}),
      );

      debugPrint('Unpause Meal Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        await fetchUpcomingMeals(userId);
        return true;
      } else {
        _errorMessage = 'Failed to unpause meal: ${response.body}';
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }
}
