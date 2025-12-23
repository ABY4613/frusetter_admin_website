import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';
import '../model/payment.dart';

class PaymentController with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  List<Payment> _allPayments = []; // All payments from API
  List<Payment> _filteredPayments = []; // Filtered results
  PaymentPagination? _pagination;
  PaymentSummary? _summary;

  // Filter state
  String _searchQuery = '';
  String _statusFilter = 'all'; // all, pending, paid, overdue
  int _currentPage = 1;
  int _limit = 10;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Returns paginated payments for display
  List<Payment> get payments {
    final startIndex = (_currentPage - 1) * _limit;
    final endIndex = startIndex + _limit;

    if (startIndex >= _filteredPayments.length) {
      return [];
    }

    return _filteredPayments.sublist(
      startIndex,
      endIndex > _filteredPayments.length ? _filteredPayments.length : endIndex,
    );
  }

  /// Get all filtered payments (for display purposes)
  List<Payment> get allFilteredPayments => _filteredPayments;

  PaymentPagination? get pagination => _pagination;
  PaymentSummary? get summary => _summary;
  String get searchQuery => _searchQuery;
  String get statusFilter => _statusFilter;
  int get currentPage => _currentPage;
  int get limit => _limit;

  /// Total filtered items count
  int get totalFilteredCount => _filteredPayments.length;

  /// Get count for specific payment status
  int getStatusCount(String status) {
    if (status == 'all') return _allPayments.length;
    return _allPayments.where((p) {
      return p.paymentStatus.name.toLowerCase() == status.toLowerCase();
    }).length;
  }

  /// Fetch all payments from API
  Future<void> fetchPayments({
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

      // Fetch all payments (large limit to get all for frontend filtering)
      final queryParams = {
        'page': '1',
        'limit': '1000', // Get all payments for frontend filtering
      };

      final uri =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminPayments}')
              .replace(queryParameters: queryParams);

      debugPrint('Fetching payments from: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint(
          'Fetch Payments Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final paymentsResponse = PaymentsResponse.fromJson(data);

        _allPayments = paymentsResponse.payments;
        _summary = paymentsResponse.summary;
        _applyFilters();
      } else {
        _errorMessage = 'Failed to fetch payments: ${response.body}';
        _allPayments = [];
        _filteredPayments = [];
        _summary = null;
        _updatePagination();
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
      debugPrint('Fetch Payments Error: $e');
      _allPayments = [];
      _filteredPayments = [];
      _summary = null;
      _updatePagination();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Apply search and status filters on frontend
  void _applyFilters() {
    _filteredPayments = _allPayments.where((payment) {
      // Apply status filter
      if (_statusFilter != 'all') {
        final paymentStatusStr = payment.paymentStatus.name.toLowerCase();
        if (paymentStatusStr != _statusFilter.toLowerCase()) {
          return false;
        }
      }

      // Apply search filter (case-insensitive)
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesName = payment.customerName.toLowerCase().contains(query);
        final matchesEmail =
            payment.customerEmail.toLowerCase().contains(query);
        final matchesPhone = payment.user.phone.toLowerCase().contains(query);
        final matchesPlan = payment.planName.toLowerCase().contains(query);
        final matchesId = payment.subscriptionId.toLowerCase().contains(query);

        if (!matchesName &&
            !matchesEmail &&
            !matchesPhone &&
            !matchesPlan &&
            !matchesId) {
          return false;
        }
      }

      return true;
    }).toList();

    // Sort by created date (newest first)
    _filteredPayments.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    _updatePagination();
  }

  /// Update pagination based on filtered results
  void _updatePagination() {
    final totalItems = _filteredPayments.length;
    final totalPages = (totalItems / _limit).ceil();

    _pagination = PaymentPagination(
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
    _statusFilter = status.toLowerCase();
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

  /// Refresh payments (refetch from API)
  Future<void> refreshPayments() async {
    await fetchPayments();
  }

  /// Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _statusFilter = 'all';
    _currentPage = 1;
    _applyFilters();
    notifyListeners();
  }

  /// Get formatted total revenue
  String get formattedTotalRevenue {
    if (_summary == null) return '₹0';
    return '₹${_summary!.totalPaymentAmount.toStringAsFixed(0)}';
  }

  /// Get formatted pending amount
  String get formattedPendingAmount {
    if (_summary == null) return '₹0';
    return '₹${_summary!.pendingPaymentAmount.toStringAsFixed(0)}';
  }

  /// Get formatted overdue amount
  String get formattedOverdueAmount {
    if (_summary == null) return '₹0';
    return '₹${_summary!.overduePaymentAmount.toStringAsFixed(0)}';
  }

  /// Get formatted paid amount
  String get formattedPaidAmount {
    if (_summary == null) return '₹0';
    return '₹${_summary!.totalPaidAmount.toStringAsFixed(0)}';
  }
}
