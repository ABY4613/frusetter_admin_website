import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';
import '../model/meals_overview_model.dart';
import '../model/meal_plan.dart';

class MealsController with ChangeNotifier {
  MealsOverviewData? _overviewData;
  List<MealPlan> _plans = [];
  bool _isLoading = false;
  String? _errorMessage;

  MealsOverviewData? get overviewData => _overviewData;
  List<MealPlan> get plans => _plans;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMealsOverview() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.adminOverviewMeals}');
      debugPrint('Fetching meals overview from $url');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint(
          'Meals Overview Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final overviewResponse = MealsOverviewResponse.fromJson(body);

        if (overviewResponse.success && overviewResponse.data != null) {
          _overviewData = overviewResponse.data;
        } else {
          _errorMessage = 'Failed to load data';
        }
      } else {
        _errorMessage = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createPlan(MealPlan plan) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      final url =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminPlans}');

      debugPrint('Creating plan at $url with data: ${plan.toJson()}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(plan.toJson()),
      );

      debugPrint(
          'Create Plan Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to create plan: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> fetchPlans({bool active = true}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.adminPlans}?active=$active');

      debugPrint('Fetching plans from $url');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint(
          'Fetch Plans Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] != null) {
          final List<dynamic> data = body['data'];
          _plans = data.map((json) => MealPlan.fromJson(json)).toList();
        } else {
          _errorMessage = 'Failed to load plans or no plans found';
        }
      } else {
        _errorMessage = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> deletePlan(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      // Construct URL: /v1/admin/plans/{id}
      final url =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminPlans}/$id');

      debugPrint('Deleting plan at $url');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint(
          'Delete Plan Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Remove locally or refresh
        _plans.removeWhere((p) => p.id == id);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to delete plan: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> updatePlan(String id, MealPlan plan) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      // Construct URL: /v1/admin/plans/{id}
      final url =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminPlans}/$id');

      debugPrint('Updating plan at $url with data: ${plan.toJson()}');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(plan.toJson()),
      );

      debugPrint(
          'Update Plan Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        // Update locally
        final index = _plans.indexWhere((p) => p.id == id);
        if (index != -1) {
          // Keep the ID from the original or response if needed.
          // Assuming response might return the updated object or just success.
          // For now, replace with the new data + existing ID.
          final updatedPlan = MealPlan(
            id: id,
            name: plan.name,
            description: plan.description,
            durationDays: plan.durationDays,
            mealsPerDay: plan.mealsPerDay,
            mealTypes: plan.mealTypes,
            price: plan.price,
            planType: plan.planType,
            weeklyMenu: plan.weeklyMenu,
            monthlyMenu: plan.monthlyMenu,
            isActive: plan.isActive,
            createdAt: plan.createdAt,
          );
          _plans[index] = updatedPlan;
        } else {
          // If not found locally, refetch/refresh might be safer, but for now:
          await fetchPlans();
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to update plan: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }
}
