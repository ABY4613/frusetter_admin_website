import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';
import '../model/subscription.dart';

class SubscriptionController with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<Subscription> _allSubscriptions = []; // All subscriptions from API
  List<Subscription> _filteredSubscriptions = []; // Filtered results
  Pagination? _pagination;

  // Filter state
  String _searchQuery = '';
  String _statusFilter = 'all';
  int _currentPage = 1;
  int _limit = 10;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Returns paginated subscriptions for display
  List<Subscription> get subscriptions {
    final startIndex = (_currentPage - 1) * _limit;
    final endIndex = startIndex + _limit;

    if (startIndex >= _filteredSubscriptions.length) {
      return [];
    }

    return _filteredSubscriptions.sublist(
      startIndex,
      endIndex > _filteredSubscriptions.length
          ? _filteredSubscriptions.length
          : endIndex,
    );
  }

  Pagination? get pagination => _pagination;
  String get searchQuery => _searchQuery;
  String get statusFilter => _statusFilter;
  int get currentPage => _currentPage;
  int get limit => _limit;

  /// Total filtered items count
  int get totalFilteredCount => _filteredSubscriptions.length;

  /// Fetch all subscriptions from API
  Future<void> fetchSubscriptions({
    int? page,
    int? limit,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (page != null) _currentPage = page;
    if (limit != null) _limit = limit;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      // Fetch all subscriptions (large limit to get all)
      final queryParams = {
        'page': '1',
        'limit': '1000', // Get all subscriptions for frontend filtering
      };

      final uri =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminSubscriptions}')
              .replace(queryParameters: queryParams);

      debugPrint('Fetching subscriptions from: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint(
          'Fetch Subscriptions Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final subscriptionsResponse = SubscriptionsResponse.fromJson(data);

        _allSubscriptions = subscriptionsResponse.subscriptions;
        _applyFilters();
      } else {
        _errorMessage = 'Failed to fetch subscriptions: ${response.body}';
        _allSubscriptions = [];
        _filteredSubscriptions = [];
        _updatePagination();
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
      debugPrint('Fetch Subscriptions Error: $e');
      _allSubscriptions = [];
      _filteredSubscriptions = [];
      _updatePagination();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Apply search and status filters on frontend
  void _applyFilters() {
    _filteredSubscriptions = _allSubscriptions.where((sub) {
      // Apply status filter
      if (_statusFilter != 'all' && sub.status.name != _statusFilter) {
        return false;
      }

      // Apply search filter (case-insensitive)
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesName = sub.userName.toLowerCase().contains(query);
        final matchesEmail = sub.userEmail.toLowerCase().contains(query);
        final matchesPhone = sub.user.phone.toLowerCase().contains(query);
        final matchesPlan = sub.planName.toLowerCase().contains(query);

        if (!matchesName && !matchesEmail && !matchesPhone && !matchesPlan) {
          return false;
        }
      }

      return true;
    }).toList();

    // Sort alphabetically by name
    _filteredSubscriptions.sort(
        (a, b) => a.userName.toLowerCase().compareTo(b.userName.toLowerCase()));

    _updatePagination();
  }

  /// Update pagination based on filtered results
  void _updatePagination() {
    final totalItems = _filteredSubscriptions.length;
    final totalPages = (totalItems / _limit).ceil();

    _pagination = Pagination(
      total: totalItems,
      page: _currentPage,
      limit: _limit,
      totalPages: totalPages > 0 ? totalPages : 1,
    );

    // Ensure current page is valid
    if (_currentPage > _pagination!.totalPages && _pagination!.totalPages > 0) {
      _currentPage = _pagination!.totalPages;
    }
  }

  /// Update search query and filter locally
  void updateSearch(String query) {
    _searchQuery = query;
    _currentPage = 1; // Reset to first page on new search
    _applyFilters();
    notifyListeners();
  }

  /// Update status filter and filter locally
  void updateStatusFilter(String status) {
    _statusFilter = status;
    _currentPage = 1; // Reset to first page on filter change
    _applyFilters();
    notifyListeners();
  }

  /// Go to specific page
  void goToPage(int page) {
    if (_pagination != null && page >= 1 && page <= _pagination!.totalPages) {
      _currentPage = page;
      notifyListeners();
    }
  }

  /// Go to next page
  void nextPage() {
    if (_pagination != null && _currentPage < _pagination!.totalPages) {
      _currentPage++;
      notifyListeners();
    }
  }

  /// Go to previous page
  void previousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      notifyListeners();
    }
  }

  /// Refresh subscriptions (refetch from API)
  Future<void> refreshSubscriptions() async {
    await fetchSubscriptions();
  }

  /// Add new subscription
  Future<bool> addSubscription({
    required String email,
    required String phone,
    required String password,
    required String fullName,
    required String planId,
    required DateTime startDate,
    required DateTime endDate,
    required double totalAmount,
    required String preferences,
    required String status,
    required String paymentStatus,
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

      // Format dates as RFC3339 with 'Z' suffix for UTC timezone
      String formatDateToRFC3339(DateTime date) {
        final utcDate = date.toUtc();
        // toIso8601String() on UTC dates already includes 'Z'
        // Just remove milliseconds if present
        final isoString = utcDate.toIso8601String();
        // Remove milliseconds (.000) but keep the 'Z'
        return isoString.replaceFirst(RegExp(r'\.\d{3}'), '');
      }

      final body = {
        "email": email,
        "phone": phone,
        "password": password,
        "full_name": fullName,
        "plan_id": planId,
        "start_date": formatDateToRFC3339(startDate),
        "end_date": formatDateToRFC3339(endDate),
        "total_amount": totalAmount,
        "preferences": preferences,
        "status": status,
        "payment_status": paymentStatus,
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
        // Refresh subscriptions list after adding
        await fetchSubscriptions();
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

  /// Update an existing subscription
  Future<bool> updateSubscription({
    required String subscriptionId,
    String? email,
    String? phone,
    String? password,
    String? fullName,
    String? planId,
    DateTime? startDate,
    double? totalAmount,
    String? status,
    String? paymentStatus,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.adminSubscriptions}/$subscriptionId');
      debugPrint('Updating subscription at $url');

      // Build body with only provided fields
      final body = <String, dynamic>{};
      if (email != null) body["email"] = email;
      if (phone != null) body["phone"] = phone;
      if (password != null && password.isNotEmpty) body["password"] = password;
      if (fullName != null) body["full_name"] = fullName;
      if (planId != null) body["plan_id"] = planId;
      if (startDate != null) {
        final utcDate = startDate.toUtc();
        body["start_date"] =
            utcDate.toIso8601String().replaceFirst(RegExp(r'\.\d{3}'), '');
      }
      if (totalAmount != null) body["total_amount"] = totalAmount;
      if (status != null) body["status"] = status;
      if (paymentStatus != null) body["payment_status"] = paymentStatus;

      debugPrint('Update body: ${jsonEncode(body)}');

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      debugPrint(
          'Update Subscription Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _isLoading = false;
        notifyListeners();
        // Refresh subscriptions list after updating
        await fetchSubscriptions();
        return true;
      } else {
        _errorMessage = 'Failed to update subscription: ${response.body}';
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
      debugPrint('Update Subscription Error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Toggle subscription status between active and paused
  Future<bool> toggleSubscriptionStatus(
      String subscriptionId, String newStatus) async {
    return await updateSubscription(
      subscriptionId: subscriptionId,
      status: newStatus,
    );
  }
}
