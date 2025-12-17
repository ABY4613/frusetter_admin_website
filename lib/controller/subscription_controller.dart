import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';

class SubscriptionController with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> addSubscription({
    required String userId,
    required String planId,
    required DateTime startDate,
    required DateTime endDate,
    required double totalAmount,
    required String preferences,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.adminSubscriptions}');
      debugPrint('Adding subscription to $url');

      final body = {
        "user_id": userId,
        "plan_id": planId,
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "total_amount": totalAmount,
        "preferences": preferences,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      debugPrint(
          'Add Subscription Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to add subscription: ${response.body}';
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }
}
