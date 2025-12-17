enum SubscriptionStatus { active, paused, cancelled, expired, pending }

/// Model for User data from API
class SubscriptionUser {
  final String id;
  final String email;
  final String phone;
  final String fullName;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubscriptionUser({
    required this.id,
    required this.email,
    required this.phone,
    required this.fullName,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubscriptionUser.fromJson(Map<String, dynamic> json) {
    return SubscriptionUser(
      id: json['ID'] ?? '',
      email: json['Email'] ?? '',
      phone: json['Phone'] ?? '',
      fullName: json['FullName'] ?? '',
      role: json['Role'] ?? '',
      isActive: json['IsActive'] ?? false,
      createdAt: DateTime.tryParse(json['CreatedAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['UpdatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

/// Model for Plan data from API
class SubscriptionPlan {
  final String id;
  final String name;
  final String description;
  final int durationDays;
  final int mealsPerDay;
  final List<String> mealTypes;
  final double price;
  final bool isActive;
  final DateTime createdAt;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.durationDays,
    required this.mealsPerDay,
    required this.mealTypes,
    required this.price,
    required this.isActive,
    required this.createdAt,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['ID'] ?? '',
      name: json['Name'] ?? '',
      description: json['Description'] ?? '',
      durationDays: json['DurationDays'] ?? 0,
      mealsPerDay: json['MealsPerDay'] ?? 0,
      mealTypes: (json['MealTypes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      price: (json['Price'] ?? 0).toDouble(),
      isActive: json['IsActive'] ?? false,
      createdAt: DateTime.tryParse(json['CreatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// Returns formatted meal types string (e.g., "Breakfast, Lunch, Dinner")
  String get mealTypesFormatted {
    return mealTypes
        .map((mt) => mt[0].toUpperCase() + mt.substring(1))
        .join(', ');
  }
}

/// Model for Subscription data from API
class Subscription {
  final String id;
  final String userId;
  final String planId;
  final DateTime startDate;
  final DateTime originalEndDate;
  final DateTime adjustedEndDate;
  final SubscriptionStatus status;
  final String paymentStatus;
  final double totalAmount;
  final double amountPaid;
  final int pausedDays;
  final String? preferences;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SubscriptionUser user;
  final SubscriptionPlan plan;

  Subscription({
    required this.id,
    required this.userId,
    required this.planId,
    required this.startDate,
    required this.originalEndDate,
    required this.adjustedEndDate,
    required this.status,
    required this.paymentStatus,
    required this.totalAmount,
    required this.amountPaid,
    required this.pausedDays,
    this.preferences,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.plan,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['ID'] ?? '',
      userId: json['UserID'] ?? '',
      planId: json['PlanID'] ?? '',
      startDate: DateTime.tryParse(json['StartDate'] ?? '') ?? DateTime.now(),
      originalEndDate:
          DateTime.tryParse(json['OriginalEndDate'] ?? '') ?? DateTime.now(),
      adjustedEndDate:
          DateTime.tryParse(json['AdjustedEndDate'] ?? '') ?? DateTime.now(),
      status: _parseStatus(json['Status']),
      paymentStatus: json['PaymentStatus'] ?? '',
      totalAmount: (json['TotalAmount'] ?? 0).toDouble(),
      amountPaid: (json['AmountPaid'] ?? 0).toDouble(),
      pausedDays: json['PausedDays'] ?? 0,
      preferences: json['Preferences']?.toString(),
      createdAt: DateTime.tryParse(json['CreatedAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['UpdatedAt'] ?? '') ?? DateTime.now(),
      user: SubscriptionUser.fromJson(json['user'] ?? {}),
      plan: SubscriptionPlan.fromJson(json['plan'] ?? {}),
    );
  }

  static SubscriptionStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return SubscriptionStatus.active;
      case 'paused':
        return SubscriptionStatus.paused;
      case 'cancelled':
        return SubscriptionStatus.cancelled;
      case 'expired':
        return SubscriptionStatus.expired;
      case 'pending':
        return SubscriptionStatus.pending;
      default:
        return SubscriptionStatus.active;
    }
  }

  // Convenience getters for backward compatibility
  String get userName => user.fullName;
  String get userEmail => user.email;
  String get planName => plan.name;
  String get mealFrequency => '${plan.mealsPerDay} meals/day';
  DateTime get endDate => adjustedEndDate;
  double get price => totalAmount;
}

/// Model for Pagination data
class Pagination {
  final int limit;
  final int page;
  final int total;
  final int totalPages;

  Pagination({
    required this.limit,
    required this.page,
    required this.total,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      limit: json['limit'] ?? 10,
      page: json['page'] ?? 1,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 1,
    );
  }
}

/// Model for Subscriptions API Response
class SubscriptionsResponse {
  final List<Subscription> subscriptions;
  final Pagination pagination;
  final bool success;

  SubscriptionsResponse({
    required this.subscriptions,
    required this.pagination,
    required this.success,
  });

  factory SubscriptionsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return SubscriptionsResponse(
      subscriptions: (data['subscriptions'] as List<dynamic>?)
              ?.map((sub) => Subscription.fromJson(sub))
              .toList() ??
          [],
      pagination: Pagination.fromJson(data['pagination'] ?? {}),
      success: json['success'] ?? false,
    );
  }
}
