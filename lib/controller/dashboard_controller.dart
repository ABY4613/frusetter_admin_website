import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';
import '../model/daily_dashboard_model.dart';

class DashboardController with ChangeNotifier {
  DailyDashboardData? _dashboardData;
  bool _isLoading = false;
  String? _errorMessage;

  DailyDashboardData? get dashboardData => _dashboardData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDailyDashboard({DateTime? date}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      String urlStr = '${ApiConstants.baseUrl}${ApiConstants.adminDashboardDaily}';
      if (date != null) {
        final formattedDate = DateFormat('yyyy-MM-dd').format(date);
        urlStr += '?date=$formattedDate';
      }
      
      final url = Uri.parse(urlStr);
      debugPrint('Fetching daily dashboard from $url');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint(
          'Daily Dashboard Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final dashboardResponse = DailyDashboardResponse.fromJson(body);

        if (dashboardResponse.success && dashboardResponse.data != null) {
          _dashboardData = dashboardResponse.data;
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
