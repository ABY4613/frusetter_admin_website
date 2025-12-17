class MealsOverviewResponse {
  final bool success;
  final MealsOverviewData? data;

  MealsOverviewResponse({
    required this.success,
    this.data,
  });

  factory MealsOverviewResponse.fromJson(Map<String, dynamic> json) {
    return MealsOverviewResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? MealsOverviewData.fromJson(json['data'])
          : null,
    );
  }
}

class MealsOverviewData {
  final MealsSummary summary;

  MealsOverviewData({required this.summary});

  factory MealsOverviewData.fromJson(Map<String, dynamic> json) {
    return MealsOverviewData(
      summary: MealsSummary.fromJson(json['summary'] ?? {}),
    );
  }
}

class MealsSummary {
  final int breakfast;
  final int lunch;
  final int dinner;
  final int totalMeals;

  MealsSummary({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.totalMeals,
  });

  factory MealsSummary.fromJson(Map<String, dynamic> json) {
    return MealsSummary(
      breakfast: json['breakfast'] ?? 0,
      lunch: json['lunch'] ?? 0,
      dinner: json['dinner'] ?? 0,
      totalMeals: json['total_meals'] ?? 0,
    );
  }
}
