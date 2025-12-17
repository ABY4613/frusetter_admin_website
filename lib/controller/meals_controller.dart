import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';
import '../model/meals_overview_model.dart';

class MealsController with ChangeNotifier {
  MealsOverviewData? _overviewData;
  bool _isLoading = false;
  String? _errorMessage;

  MealsOverviewData? get overviewData => _overviewData;
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
}
