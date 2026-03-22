import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/api_constants.dart';
import '../model/feedback_item.dart';

class FeedbackController with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  FeedbackResponse? _feedbackResponse;
  
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  FeedbackResponse? get feedbackResponse => _feedbackResponse;
  
  List<FeedbackItem> get feedbacks => _feedbackResponse?.data.feedbacks ?? [];
  FeedbackSummary? get summary => _feedbackResponse?.data.summary;
  FeedbackPagination? get pagination => _feedbackResponse?.data.pagination;

  Future<void> fetchFeedbacks({
    int page = 1,
    int limit = 20,
    String? feedbackType,
    int? rating,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (feedbackType != null) 'feedback_type': feedbackType,
        if (rating != null) 'rating': rating.toString(),
      };

      final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.adminFeedbacks}')
          .replace(queryParameters: queryParams);

      debugPrint('Fetching feedbacks from: $uri');

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('Fetch Feedbacks Response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _feedbackResponse = FeedbackResponse.fromJson(data);
      } else {
        _errorMessage = 'Failed to fetch feedbacks: ${response.body}';
        _feedbackResponse = null;
      }
    } catch (e) {
      _errorMessage = 'Connection error: $e';
      debugPrint('Fetch Feedbacks Error: $e');
      _feedbackResponse = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshFeedbacks() async {
    await fetchFeedbacks();
  }
}
