class MealPlan {
  final String? id;
  final String name;
  final String description;
  final int durationDays;
  final int mealsPerDay;
  final List<String> mealTypes;
  final double price;

  MealPlan({
    this.id,
    required this.name,
    required this.description,
    required this.durationDays,
    required this.mealsPerDay,
    required this.mealTypes,
    required this.price,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['ID'] ?? json['_id'] ?? json['id'],
      name: json['Name'] ?? json['name'] ?? '',
      description: json['Description'] ?? json['description'] ?? '',
      durationDays: json['DurationDays'] ?? json['duration_days'] ?? 0,
      mealsPerDay: json['MealsPerDay'] ?? json['meals_per_day'] ?? 0,
      mealTypes:
          List<String>.from(json['MealTypes'] ?? json['meal_types'] ?? []),
      price: (json['Price'] ?? json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'duration_days': durationDays,
      'meals_per_day': mealsPerDay,
      'meal_types': mealTypes,
      'price': price,
    };
  }
}
