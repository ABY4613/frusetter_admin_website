import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';
import '../model/cutoff_setting.dart';

class CutoffController with ChangeNotifier {
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  String? _successMessage;
  List<CutoffSetting> _cutoffSettings = [];

  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  List<CutoffSetting> get cutoffSettings => _cutoffSettings;

  /// Get cutoff setting by meal type
  CutoffSetting? getCutoffByMealType(String mealType) {
    try {
      return _cutoffSettings.firstWhere(
        (setting) => setting.mealType.toLowerCase() == mealType.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Fetch all cutoff settings from API
  Future<void> fetchCutoffSettings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final uri = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.adminCutoffSettings}');

      debugPrint('Fetching cutoff settings from: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint(
          'Fetch Cutoff Settings Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final cutoffResponse = CutoffSettingsResponse.fromJson(data);
        _cutoffSettings = cutoffResponse.data;
      } else {
        _errorMessage = 'Failed to fetch cutoff settings: ${response.body}';
        _cutoffSettings = [];
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
      debugPrint('Fetch Cutoff Settings Error: $e');
      _cutoffSettings = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Create a new cutoff setting
  Future<bool> createCutoffSetting({
    required String mealType,
    required String cutoffTime,
  }) async {
    _isSaving = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final uri = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.adminCutoffSettings}');

      debugPrint('Creating cutoff setting at: $uri');

      final body = jsonEncode({
        'meal_type': mealType.toLowerCase(),
        'cutoff_time': cutoffTime,
      });

      debugPrint('Request body: $body');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: body,
      );

      debugPrint(
          'Create Cutoff Setting Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _successMessage = 'Cutoff setting created successfully!';
        _isSaving = false;
        notifyListeners();
        // Refresh the list
        await fetchCutoffSettings();
        return true;
      } else {
        final data = jsonDecode(response.body);
        _errorMessage = data['message'] ?? 'Failed to create cutoff setting';
        _isSaving = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
      debugPrint('Create Cutoff Setting Error: $e');
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  /// Update an existing cutoff setting
  Future<bool> updateCutoffSetting({
    required String mealType,
    required String cutoffTime,
  }) async {
    _isSaving = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final uri = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.adminCutoffSettings}');

      debugPrint('Updating cutoff setting at: $uri');

      final body = jsonEncode({
        'meal_type': mealType.toLowerCase(),
        'cutoff_time': cutoffTime,
      });

      debugPrint('Request body: $body');

      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: body,
      );

      debugPrint(
          'Update Cutoff Setting Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _successMessage = 'Cutoff time updated successfully!';
        _isSaving = false;
        notifyListeners();
        // Refresh the list
        await fetchCutoffSettings();
        return true;
      } else {
        final data = jsonDecode(response.body);
        _errorMessage = data['message'] ?? 'Failed to update cutoff setting';
        _isSaving = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
      debugPrint('Update Cutoff Setting Error: $e');
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear messages
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Refresh cutoff settings
  Future<void> refreshCutoffSettings() async {
    await fetchCutoffSettings();
  }
}
