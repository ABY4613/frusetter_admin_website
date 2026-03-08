import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';
import '../model/driver.dart';
import '../model/driver_assignment.dart';

class DriverController with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<Driver> _allDrivers = [];
  List<Driver> _filteredDrivers = [];
  String _searchQuery = '';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Driver> get drivers => _filteredDrivers;
  String get searchQuery => _searchQuery;

  Future<void> fetchDrivers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final queryParams = {
        if (_searchQuery.isNotEmpty) 'search': _searchQuery,
      };

      final uri =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminDrivers}')
              .replace(queryParameters: queryParams);

      debugPrint('Fetching drivers from: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint(
          'Fetch Drivers Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> driversList = data['data'];
          _allDrivers = driversList.map((e) => Driver.fromJson(e)).toList();
          _filteredDrivers = List.from(_allDrivers);
        } else {
          _errorMessage = data['message'] ?? 'Failed to parse drivers';
          _allDrivers = [];
          _filteredDrivers = [];
        }
      } else {
        _errorMessage = 'Failed to fetch drivers: ${response.statusCode}';
        _allDrivers = [];
        _filteredDrivers = [];
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
      debugPrint('Fetch Drivers Error: $e');
      _allDrivers = [];
      _filteredDrivers = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void updateSearch(String query) {
    _searchQuery = query;
    fetchDrivers(); // API supports server-side search
  }

  Future<bool> addDriver({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final url =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminDrivers}');
      debugPrint('Adding driver to $url');

      final body = {
        "full_name": fullName,
        "email": email,
        "phone": phone,
        "password": password,
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
          'Add Driver Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          _isLoading = false;
          notifyListeners();

          // Refresh drivers list after adding
          await fetchDrivers();
          return true;
        } else {
          _errorMessage = data['message'] ?? 'Failed to add driver';
        }
      } else {
        try {
          final data = jsonDecode(response.body);
          _errorMessage =
              data['message'] ?? 'Failed to add driver: ${response.statusCode}';
        } catch (_) {
          _errorMessage = 'Failed to add driver: ${response.statusCode}';
        }
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
      debugPrint('Add Driver Error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> updateDriver({
    required String id,
    required String fullName,
    required String email,
    required String phone,
    String? password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final url =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminDrivers}/$id');
      debugPrint('Updating driver at $url');

      final body = <String, dynamic>{
        "full_name": fullName,
        "email": email,
        "phone": phone,
      };

      if (password != null && password.isNotEmpty) {
        body["password"] = password;
      }

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      debugPrint(
          'Update Driver Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          _isLoading = false;
          notifyListeners();

          // Refresh drivers list after updating
          await fetchDrivers();
          return true;
        } else {
          _errorMessage = data['message'] ?? 'Failed to update driver';
        }
      } else {
        try {
          final data = jsonDecode(response.body);
          _errorMessage = data['message'] ??
              'Failed to update driver: ${response.statusCode}';
        } catch (_) {
          _errorMessage = 'Failed to update driver: ${response.statusCode}';
        }
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
      debugPrint('Update Driver Error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> assignCustomer({
    required String driverId,
    required String customerId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.adminDriverAssignments}');
      debugPrint('Assigning customer at $url');

      final body = {
        "driver_id": driverId,
        "customer_id": customerId,
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
          'Assign Customer Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _errorMessage = data['message'] ?? 'Failed to assign customer';
        }
      } else {
        try {
          final data = jsonDecode(response.body);
          _errorMessage = data['message'] ??
              'Failed to assign customer: ${response.statusCode}';
        } catch (_) {
          _errorMessage = 'Failed to assign customer: ${response.statusCode}';
        }
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
      debugPrint('Assign Customer Error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<List<DriverAssignment>> fetchDriverAssignments({
    String? driverId,
    String? customerId,
    String? area,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final queryParams = <String, String>{};
      if (driverId != null && driverId.isNotEmpty) {
        queryParams['driver_id'] = driverId;
      }
      if (customerId != null && customerId.isNotEmpty) {
        queryParams['customer_id'] = customerId;
      }
      if (area != null && area.isNotEmpty) {
        queryParams['area'] = area;
      }

      final uri = Uri.parse(
              '${ApiConstants.baseUrl}${ApiConstants.adminDriverAssignments}')
          .replace(queryParameters: queryParams);

      debugPrint('Fetching driver assignments from: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> assignmentsList = data['data'];
          return assignmentsList
              .map((e) => DriverAssignment.fromJson(e))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('Fetch Driver Assignments Error: $e');
    }
    return [];
  }

  Future<bool> deleteDriver(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final url =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminDrivers}/$id');
      debugPrint('Deleting driver at $url');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint(
          'Delete Driver Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Assume success if no content or 200 OM.
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          if (data['success'] == true) {
            _isLoading = false;
            notifyListeners();

            // Refresh drivers list after deleting
            await fetchDrivers();
            return true;
          } else {
            _errorMessage = data['message'] ?? 'Failed to delete driver';
          }
        } else {
          _isLoading = false;
          notifyListeners();

          await fetchDrivers();
          return true;
        }
      } else {
        try {
          final data = jsonDecode(response.body);
          _errorMessage = data['message'] ??
              'Failed to delete driver: ${response.statusCode}';
        } catch (_) {
          _errorMessage = 'Failed to delete driver: ${response.statusCode}';
        }
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
      debugPrint('Delete Driver Error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }
}
