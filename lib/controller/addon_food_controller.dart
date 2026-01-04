import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';
import '../model/addon_food.dart';

class AddonFoodController extends ChangeNotifier {
  List<AddonFood> _addonFoods = [];
  bool _isLoading = false;
  String? _errorMessage;
  PaginationInfo? _paginationInfo;

  List<AddonFood> get addonFoods => _addonFoods;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PaginationInfo? get paginationInfo => _paginationInfo;

  // Fetch all addon foods from API
  Future<void> fetchAddonFoods({int page = 1, int limit = 50}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.adminAddons}?page=$page&limit=$limit',
      );

      debugPrint('Fetching addon foods from $url');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint(
          'Fetch Addons Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final addonResponse = AddonFoodListResponse.fromJson(body);

        if (addonResponse.success) {
          _addonFoods = addonResponse.addons;
          _paginationInfo = addonResponse.pagination;
        } else {
          _errorMessage = 'Failed to load addon foods';
        }
      } else {
        _errorMessage = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
      debugPrint('Error fetching addon foods: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Create new addon food
  Future<bool> createAddonFood(AddonFood addonFood) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.adminAddons}',
      );

      debugPrint(
          'Creating addon food at $url with data: ${addonFood.toJson()}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(addonFood.toJson()),
      );

      debugPrint(
          'Create Addon Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Refresh the list after creating
        await fetchAddonFoods();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final errorBody = jsonDecode(response.body);
        _errorMessage = errorBody['message'] ??
            'Failed to create addon food: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
      debugPrint('Error creating addon food: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Update addon food
  Future<bool> updateAddonFood(AddonFood addonFood) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.adminAddons}/${addonFood.id}',
      );

      debugPrint(
          'Updating addon food at $url with data: ${addonFood.toJson()}');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(addonFood.toJson()),
      );

      debugPrint(
          'Update Addon Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        // Refresh the list after updating
        await fetchAddonFoods();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final errorBody = jsonDecode(response.body);
        _errorMessage = errorBody['message'] ??
            'Failed to update addon food: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
      debugPrint('Error updating addon food: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Delete addon food
  Future<bool> deleteAddonFood(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.adminAddons}/$id',
      );

      debugPrint('Deleting addon food at $url');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint(
          'Delete Addon Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Remove from local list
        _addonFoods.removeWhere((item) => item.id == id);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final errorBody = jsonDecode(response.body);
        _errorMessage = errorBody['message'] ??
            'Failed to delete addon food: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
      debugPrint('Error deleting addon food: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Toggle availability (using update API)
  Future<bool> toggleAvailability(String id) async {
    try {
      final index = _addonFoods.indexWhere((item) => item.id == id);
      if (index != -1) {
        final updatedAddon = _addonFoods[index].copyWith(
          isAvailable: !_addonFoods[index].isAvailable,
        );
        return await updateAddonFood(updatedAddon);
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to toggle availability: $e';
      notifyListeners();
      return false;
    }
  }

  // Filter by category
  List<AddonFood> getByCategory(String category) {
    if (category == 'All') return _addonFoods;
    return _addonFoods.where((item) => item.category == category).toList();
  }

  // Get all categories
  List<String> get categories {
    final cats = _addonFoods.map((item) => item.category).toSet().toList();
    cats.sort();
    cats.insert(0, 'All');
    return cats;
  }

  // Get statistics
  int get totalItems => _addonFoods.length;
  int get availableItems =>
      _addonFoods.where((item) => item.isAvailable).length;
  int get unavailableItems => totalItems - availableItems;
  int get lowStockItems => _addonFoods.where((item) => item.isLowStock).length;
  int get outOfStockItems =>
      _addonFoods.where((item) => item.isOutOfStock).length;

  double get averagePrice {
    if (_addonFoods.isEmpty) return 0;
    final total = _addonFoods.fold<double>(0, (sum, item) => sum + item.price);
    return total / _addonFoods.length;
  }
}
