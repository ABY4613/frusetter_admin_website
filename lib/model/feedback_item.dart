class FeedbackResponse {
  final bool success;
  final FeedbackData data;

  FeedbackResponse({
    required this.success,
    required this.data,
  });

  factory FeedbackResponse.fromJson(Map<String, dynamic> json) {
    return FeedbackResponse(
      success: json['success'] ?? false,
      data: FeedbackData.fromJson(json['data'] ?? {}),
    );
  }
}

class FeedbackData {
  final List<FeedbackItem> feedbacks;
  final FeedbackPagination pagination;
  final FeedbackSummary summary;

  FeedbackData({
    required this.feedbacks,
    required this.pagination,
    required this.summary,
  });

  factory FeedbackData.fromJson(Map<String, dynamic> json) {
    return FeedbackData(
      feedbacks: (json['feedbacks'] as List? ?? [])
          .map((e) => FeedbackItem.fromJson(e))
          .toList(),
      pagination: FeedbackPagination.fromJson(json['pagination'] ?? {}),
      summary: FeedbackSummary.fromJson(json['summary'] ?? {}),
    );
  }
}

class FeedbackItem {
  final String id;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String planName;
  final int rating;
  final int foodQualityRating;
  final int deliveryRating;
  final String feedbackType;
  final String comments;
  final DateTime createdAt;

  FeedbackItem({
    required this.id,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.planName,
    required this.rating,
    required this.foodQualityRating,
    required this.deliveryRating,
    required this.feedbackType,
    required this.comments,
    required this.createdAt,
  });

  factory FeedbackItem.fromJson(Map<String, dynamic> json) {
    return FeedbackItem(
      id: json['id'] ?? '',
      customerName: json['customer_name'] ?? '',
      customerEmail: json['customer_email'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      planName: json['plan_name'] ?? '',
      rating: json['rating'] ?? 0,
      foodQualityRating: json['food_quality_rating'] ?? 0,
      deliveryRating: json['delivery_rating'] ?? 0,
      feedbackType: json['feedback_type'] ?? '',
      comments: json['comments'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class FeedbackPagination {
  final int limit;
  final int page;
  final int total;
  final int totalPages;

  FeedbackPagination({
    required this.limit,
    required this.page,
    required this.total,
    required this.totalPages,
  });

  factory FeedbackPagination.fromJson(Map<String, dynamic> json) {
    return FeedbackPagination(
      limit: json['limit'] ?? 0,
      page: json['page'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
    );
  }
}

class FeedbackSummary {
  final double avgDelivery;
  final double avgFoodQuality;
  final double avgOverall;
  final Map<String, int> ratingDistribution;
  final int totalReviews;

  FeedbackSummary({
    required this.avgDelivery,
    required this.avgFoodQuality,
    required this.avgOverall,
    required this.ratingDistribution,
    required this.totalReviews,
  });

  factory FeedbackSummary.fromJson(Map<String, dynamic> json) {
    Map<String, int> distribution = {};
    if (json['rating_distribution'] != null) {
      (json['rating_distribution'] as Map<String, dynamic>).forEach((key, value) {
        distribution[key] = value as int;
      });
    }
    return FeedbackSummary(
      avgDelivery: (json['avg_delivery'] ?? 0.0).toDouble(),
      avgFoodQuality: (json['avg_food_quality'] ?? 0.0).toDouble(),
      avgOverall: (json['avg_overall'] ?? 0.0).toDouble(),
      ratingDistribution: distribution,
      totalReviews: json['total_reviews'] ?? 0,
    );
  }
}
