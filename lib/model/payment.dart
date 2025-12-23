/// Model for Payment User data from API
class PaymentUser {
  final String id;
  final String email;
  final String phone;
  final String fullName;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentUser({
    required this.id,
    required this.email,
    required this.phone,
    required this.fullName,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentUser.fromJson(Map<String, dynamic> json) {
    return PaymentUser(
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

/// Model for Payment Plan data from API
class PaymentPlan {
  final String id;
  final String name;
  final String description;
  final int durationDays;
  final int mealsPerDay;
  final List<String> mealTypes;
  final double price;
  final bool isActive;
  final DateTime createdAt;

  PaymentPlan({
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

  factory PaymentPlan.fromJson(Map<String, dynamic> json) {
    return PaymentPlan(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      durationDays: json['duration_days'] ?? 0,
      mealsPerDay: json['meals_per_day'] ?? 0,
      mealTypes: (json['meal_types'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      price: (json['price'] ?? 0).toDouble(),
      isActive: json['is_active'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  /// Returns formatted meal types string (e.g., "Breakfast, Lunch, Dinner")
  String get mealTypesFormatted {
    return mealTypes
        .map((mt) => mt[0].toUpperCase() + mt.substring(1))
        .join(', ');
  }
}

/// Enum for Payment Status
enum PaymentStatus { pending, paid, overdue, failed, refunded }

/// Enum for Subscription Status
enum SubscriptionPaymentStatus { active, paused, cancelled, expired, pending }

/// Model for Payment data from API
class Payment {
  final String subscriptionId;
  final String userId;
  final PaymentUser user;
  final PaymentPlan plan;
  final double totalAmount;
  final double amountPaid;
  final double balanceAmount;
  final PaymentStatus paymentStatus;
  final SubscriptionPaymentStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final int daysOverdue;
  final DateTime createdAt;

  Payment({
    required this.subscriptionId,
    required this.userId,
    required this.user,
    required this.plan,
    required this.totalAmount,
    required this.amountPaid,
    required this.balanceAmount,
    required this.paymentStatus,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.daysOverdue,
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      subscriptionId: json['subscription_id'] ?? '',
      userId: json['user_id'] ?? '',
      user: PaymentUser.fromJson(json['user'] ?? {}),
      plan: PaymentPlan.fromJson(json['plan'] ?? {}),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      amountPaid: (json['amount_paid'] ?? 0).toDouble(),
      balanceAmount: (json['balance_amount'] ?? 0).toDouble(),
      paymentStatus: _parsePaymentStatus(json['payment_status']),
      status: _parseSubscriptionStatus(json['status']),
      startDate: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['end_date'] ?? '') ?? DateTime.now(),
      daysOverdue: json['days_overdue'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  static PaymentStatus _parsePaymentStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'paid':
        return PaymentStatus.paid;
      case 'overdue':
        return PaymentStatus.overdue;
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      case 'pending':
      default:
        return PaymentStatus.pending;
    }
  }

  static SubscriptionPaymentStatus _parseSubscriptionStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return SubscriptionPaymentStatus.active;
      case 'paused':
        return SubscriptionPaymentStatus.paused;
      case 'cancelled':
        return SubscriptionPaymentStatus.cancelled;
      case 'expired':
        return SubscriptionPaymentStatus.expired;
      case 'pending':
      default:
        return SubscriptionPaymentStatus.pending;
    }
  }

  // Convenience getters
  String get customerName => user.fullName;
  String get customerEmail => user.email;
  String get planName => plan.name;

  String get paymentStatusLabel {
    switch (paymentStatus) {
      case PaymentStatus.paid:
        return 'PAID';
      case PaymentStatus.overdue:
        return 'OVERDUE';
      case PaymentStatus.failed:
        return 'FAILED';
      case PaymentStatus.refunded:
        return 'REFUNDED';
      case PaymentStatus.pending:
        return 'PENDING';
    }
  }

  String get subscriptionStatusLabel {
    switch (status) {
      case SubscriptionPaymentStatus.active:
        return 'Active';
      case SubscriptionPaymentStatus.paused:
        return 'Paused';
      case SubscriptionPaymentStatus.cancelled:
        return 'Cancelled';
      case SubscriptionPaymentStatus.expired:
        return 'Expired';
      case SubscriptionPaymentStatus.pending:
        return 'Pending';
    }
  }
}

/// Model for Payment Summary data
class PaymentSummary {
  final int overdueCount;
  final double overduePaymentAmount;
  final int paidCount;
  final int pendingCount;
  final double pendingPaymentAmount;
  final double totalPaidAmount;
  final double totalPaymentAmount;
  final int totalSubscriptions;

  PaymentSummary({
    required this.overdueCount,
    required this.overduePaymentAmount,
    required this.paidCount,
    required this.pendingCount,
    required this.pendingPaymentAmount,
    required this.totalPaidAmount,
    required this.totalPaymentAmount,
    required this.totalSubscriptions,
  });

  factory PaymentSummary.fromJson(Map<String, dynamic> json) {
    return PaymentSummary(
      overdueCount: json['overdue_count'] ?? 0,
      overduePaymentAmount: (json['overdue_payment_amount'] ?? 0).toDouble(),
      paidCount: json['paid_count'] ?? 0,
      pendingCount: json['pending_count'] ?? 0,
      pendingPaymentAmount: (json['pending_payment_amount'] ?? 0).toDouble(),
      totalPaidAmount: (json['total_paid_amount'] ?? 0).toDouble(),
      totalPaymentAmount: (json['total_payment_amount'] ?? 0).toDouble(),
      totalSubscriptions: json['total_subscriptions'] ?? 0,
    );
  }
}

/// Model for Pagination data
class PaymentPagination {
  final int limit;
  final int page;
  final int total;
  final int totalPages;

  PaymentPagination({
    required this.limit,
    required this.page,
    required this.total,
    required this.totalPages,
  });

  factory PaymentPagination.fromJson(Map<String, dynamic> json) {
    return PaymentPagination(
      limit: json['limit'] ?? 10,
      page: json['page'] ?? 1,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 1,
    );
  }
}

/// Model for Payments API Response
class PaymentsResponse {
  final List<Payment> payments;
  final PaymentPagination pagination;
  final PaymentSummary summary;
  final bool success;

  PaymentsResponse({
    required this.payments,
    required this.pagination,
    required this.summary,
    required this.success,
  });

  factory PaymentsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return PaymentsResponse(
      payments: (data['payments'] as List<dynamic>?)
              ?.map((payment) => Payment.fromJson(payment))
              .toList() ??
          [],
      pagination: PaymentPagination.fromJson(data['pagination'] ?? {}),
      summary: PaymentSummary.fromJson(data['summary'] ?? {}),
      success: json['success'] ?? false,
    );
  }
}
