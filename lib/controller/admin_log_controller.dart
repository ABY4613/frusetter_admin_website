import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';
import '../model/admin_log_model.dart';

class AdminLogController with ChangeNotifier {
  List<AdminLog> _logs = [];
  Pagination? _pagination;
  bool _isLoading = false;
  String? _errorMessage;

  List<AdminLog> get logs => _logs;
  Pagination? get pagination => _pagination;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchLogs({int page = 1, String? userRole, String? action, String? entityType}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      String urlStr = '${ApiConstants.baseUrl}${ApiConstants.adminLogs}?page=$page&limit=50';
      
      if (userRole != null && userRole != 'all') {
        urlStr += '&user_role=$userRole';
      }
      if (action != null) {
        urlStr += '&action=$action';
      }
      if (entityType != null) {
        urlStr += '&entity_type=$entityType';
      }

      final url = Uri.parse(urlStr);
      debugPrint('Fetching logs from $url');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Admin Logs Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final logResponse = AdminLogResponse.fromJson(body);

        if (logResponse.success) {
          if (page == 1) {
            _logs = logResponse.data.logs;
          } else {
            _logs.addAll(logResponse.data.logs);
          }
          _pagination = logResponse.data.pagination;
        } else {
          _errorMessage = 'Failed to load logs';
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
