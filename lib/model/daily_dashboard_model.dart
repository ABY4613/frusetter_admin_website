class DailyDashboardResponse {
  final bool success;
  final DailyDashboardData? data;

  DailyDashboardResponse({
    required this.success,
    this.data,
  });

  factory DailyDashboardResponse.fromJson(Map<String, dynamic> json) {
    return DailyDashboardResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? DailyDashboardData.fromJson(json['data']) : null,
    );
  }
}

class DailyDashboardData {
  final String date;
  final String generated;
  final AddonsData addons;
  final DeliveriesData deliveries;
  final MealsData meals;
  final PaymentsData payments;
  final SubscriptionsData subscriptions;

  DailyDashboardData({
    required this.date,
    required this.generated,
    required this.addons,
    required this.deliveries,
    required this.meals,
    required this.payments,
    required this.subscriptions,
  });

  factory DailyDashboardData.fromJson(Map<String, dynamic> json) {
    return DailyDashboardData(
      date: json['date'] ?? '',
      generated: json['generated'] ?? '',
      addons: AddonsData.fromJson(json['addons'] ?? {}),
      deliveries: DeliveriesData.fromJson(json['deliveries'] ?? {}),
      meals: MealsData.fromJson(json['meals'] ?? {}),
      payments: PaymentsData.fromJson(json['payments'] ?? {}),
      subscriptions: SubscriptionsData.fromJson(json['subscriptions'] ?? {}),
    );
  }
}

class AddonsData {
  final dynamic breakdown;
  final int totalToday;

  AddonsData({this.breakdown, required this.totalToday});

  factory AddonsData.fromJson(Map<String, dynamic> json) {
    return AddonsData(
      breakdown: json['breakdown'],
      totalToday: json['total_today'] ?? 0,
    );
  }
}

class DeliveriesData {
  final int assigned;
  final int delivered;
  final int failed;
  final int inTransit;
  final int pickedUp;
  final int total;

  DeliveriesData({
    required this.assigned,
    required this.delivered,
    required this.failed,
    required this.inTransit,
    required this.pickedUp,
    required this.total,
  });

  factory DeliveriesData.fromJson(Map<String, dynamic> json) {
    return DeliveriesData(
      assigned: json['assigned'] ?? 0,
      delivered: json['delivered'] ?? 0,
      failed: json['failed'] ?? 0,
      inTransit: json['in_transit'] ?? 0,
      pickedUp: json['picked_up'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

class MealsData {
  final Map<String, int> byStatus;
  final List<MealGraphData> graphLast7Days;
  final MealSummary summary;
  final MealTrend trend;

  MealsData({
    required this.byStatus,
    required this.graphLast7Days,
    required this.summary,
    required this.trend,
  });

  factory MealsData.fromJson(Map<String, dynamic> json) {
    return MealsData(
      byStatus: Map<String, int>.from(json['by_status'] ?? {}),
      graphLast7Days: (json['graph_last_7_days'] as List? ?? [])
          .map((e) => MealGraphData.fromJson(e))
          .toList(),
      summary: MealSummary.fromJson(json['summary'] ?? {}),
      trend: MealTrend.fromJson(json['trend'] ?? {}),
    );
  }
}

class MealGraphData {
  final int breakfast;
  final String date;
  final int dinner;
  final int lunch;
  final int total;

  MealGraphData({
    required this.breakfast,
    required this.date,
    required this.dinner,
    required this.lunch,
    required this.total,
  });

  factory MealGraphData.fromJson(Map<String, dynamic> json) {
    return MealGraphData(
      breakfast: json['breakfast'] ?? 0,
      date: json['date'] ?? '',
      dinner: json['dinner'] ?? 0,
      lunch: json['lunch'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

class MealSummary {
  final int breakfast;
  final int dinner;
  final int lunch;
  final int total;

  MealSummary({
    required this.breakfast,
    required this.dinner,
    required this.lunch,
    required this.total,
  });

  factory MealSummary.fromJson(Map<String, dynamic> json) {
    return MealSummary(
      breakfast: json['breakfast'] ?? 0,
      dinner: json['dinner'] ?? 0,
      lunch: json['lunch'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

class MealTrend {
  final String direction;
  final double percentage;
  final String previousDate;
  final int today;
  final int yesterday;

  MealTrend({
    required this.direction,
    required this.percentage,
    required this.previousDate,
    required this.today,
    required this.yesterday,
  });

  factory MealTrend.fromJson(Map<String, dynamic> json) {
    return MealTrend(
      direction: json['direction'] ?? '',
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      previousDate: json['previous_date'] ?? '',
      today: json['today'] ?? 0,
      yesterday: json['yesterday'] ?? 0,
    );
  }
}

class PaymentsData {
  final double collectedToday;
  final double overdueAmount;
  final double pendingAmount;
  final int subscriptionsOverdue;
  final int subscriptionsPaid;
  final int subscriptionsPending;
  final double totalCollected;

  PaymentsData({
    required this.collectedToday,
    required this.overdueAmount,
    required this.pendingAmount,
    required this.subscriptionsOverdue,
    required this.subscriptionsPaid,
    required this.subscriptionsPending,
    required this.totalCollected,
  });

  factory PaymentsData.fromJson(Map<String, dynamic> json) {
    return PaymentsData(
      collectedToday: (json['collected_today'] as num?)?.toDouble() ?? 0.0,
      overdueAmount: (json['overdue_amount'] as num?)?.toDouble() ?? 0.0,
      pendingAmount: (json['pending_amount'] as num?)?.toDouble() ?? 0.0,
      subscriptionsOverdue: json['subscriptions_overdue'] ?? 0,
      subscriptionsPaid: json['subscriptions_paid'] ?? 0,
      subscriptionsPending: json['subscriptions_pending'] ?? 0,
      totalCollected: (json['total_collected'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SubscriptionsData {
  final int active;
  final List<SubscriptionPlanCount> byPlan;
  final int expired;
  final int newToday;
  final int paused;
  final int total;

  SubscriptionsData({
    required this.active,
    required this.byPlan,
    required this.expired,
    required this.newToday,
    required this.paused,
    required this.total,
  });

  factory SubscriptionsData.fromJson(Map<String, dynamic> json) {
    return SubscriptionsData(
      active: json['active'] ?? 0,
      byPlan: (json['by_plan'] as List? ?? [])
          .map((e) => SubscriptionPlanCount.fromJson(e))
          .toList(),
      expired: json['expired'] ?? 0,
      newToday: json['new_today'] ?? 0,
      paused: json['paused'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

class SubscriptionPlanCount {
  final String planId;
  final String planName;
  final int count;

  SubscriptionPlanCount({
    required this.planId,
    required this.planName,
    required this.count,
  });

  factory SubscriptionPlanCount.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanCount(
      planId: json['PlanID'] ?? '',
      planName: json['PlanName'] ?? '',
      count: json['Count'] ?? 0,
    );
  }
}
