import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';
import '../model/subscription.dart';

class SubscriptionController with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<Subscription> _subscriptions = [];
  Pagination? _pagination;

  // Filter state
  String _searchQuery = '';
  String _statusFilter = 'all';
  int _currentPage = 1;
  int _limit = 10;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Subscription> get subscriptions => _subscriptions;
  Pagination? get pagination => _pagination;
  String get searchQuery => _searchQuery;
  String get statusFilter => _statusFilter;
  int get currentPage => _currentPage;
  int get limit => _limit;

  /// Fetch subscriptions from API with filters
  Future<void> fetchSubscriptions({
    String? search,
    String? status,
    int? page,
    int? limit,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Update filter state
    if (search != null) _searchQuery = search;
    if (status != null) _statusFilter = status;
    if (page != null) _currentPage = page;
    if (limit != null) _limit = limit;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final queryParams = {
        'search': _searchQuery,
        'status': _statusFilter,
        'page': _currentPage.toString(),
        'limit': _limit.toString(),
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

        _subscriptions = subscriptionsResponse.subscriptions;
        _pagination = subscriptionsResponse.pagination;
      } else {
        _errorMessage = 'Failed to fetch subscriptions: ${response.body}';
        _subscriptions = [];
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
      debugPrint('Fetch Subscriptions Error: $e');
      _subscriptions = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Update search query and refetch
  void updateSearch(String query) {
    _searchQuery = query;
    _currentPage = 1; // Reset to first page on new search
    fetchSubscriptions();
  }

  /// Update status filter and refetch
  void updateStatusFilter(String status) {
    _statusFilter = status;
    _currentPage = 1; // Reset to first page on filter change
    fetchSubscriptions();
  }

  /// Go to specific page
  void goToPage(int page) {
    if (_pagination != null && page >= 1 && page <= _pagination!.totalPages) {
      _currentPage = page;
      fetchSubscriptions();
    }
  }

  /// Go to next page
  void nextPage() {
    if (_pagination != null && _currentPage < _pagination!.totalPages) {
      _currentPage++;
      fetchSubscriptions();
    }
  }

  /// Go to previous page
  void previousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      fetchSubscriptions();
    }
  }

  /// Refresh subscriptions (reset filters and refetch)
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
}
