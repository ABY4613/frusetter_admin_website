/// Represents a single meal item (breakfast, lunch, or dinner)
class MealItem {
  final String name;
  final String description;

  MealItem({
    required this.name,
    required this.description,
  });

  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }

  MealItem copyWith({String? name, String? description}) {
    return MealItem(
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}

/// Represents a day's meals (breakfast, lunch, dinner)
class DayMeals {
  final MealItem? breakfast;
  final MealItem? lunch;
  final MealItem? dinner;

  DayMeals({
    this.breakfast,
    this.lunch,
    this.dinner,
  });

  factory DayMeals.fromJson(Map<String, dynamic> json) {
    return DayMeals(
      breakfast: json['breakfast'] != null
          ? MealItem.fromJson(json['breakfast'])
          : null,
      lunch: json['lunch'] != null ? MealItem.fromJson(json['lunch']) : null,
      dinner: json['dinner'] != null ? MealItem.fromJson(json['dinner']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (breakfast != null) data['breakfast'] = breakfast!.toJson();
    if (lunch != null) data['lunch'] = lunch!.toJson();
    if (dinner != null) data['dinner'] = dinner!.toJson();
    return data;
  }

  DayMeals copyWith({
    MealItem? breakfast,
    MealItem? lunch,
    MealItem? dinner,
  }) {
    return DayMeals(
      breakfast: breakfast ?? this.breakfast,
      lunch: lunch ?? this.lunch,
      dinner: dinner ?? this.dinner,
    );
  }
}

/// Represents the weekly menu with meals for each day
class WeeklyMenu {
  final DayMeals? monday;
  final DayMeals? tuesday;
  final DayMeals? wednesday;
  final DayMeals? thursday;
  final DayMeals? friday;
  final DayMeals? saturday;
  final DayMeals? sunday;

  WeeklyMenu({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  factory WeeklyMenu.fromJson(Map<String, dynamic> json) {
    return WeeklyMenu(
      monday: json['monday'] != null ? DayMeals.fromJson(json['monday']) : null,
      tuesday:
          json['tuesday'] != null ? DayMeals.fromJson(json['tuesday']) : null,
      wednesday: json['wednesday'] != null
          ? DayMeals.fromJson(json['wednesday'])
          : null,
      thursday:
          json['thursday'] != null ? DayMeals.fromJson(json['thursday']) : null,
      friday: json['friday'] != null ? DayMeals.fromJson(json['friday']) : null,
      saturday:
          json['saturday'] != null ? DayMeals.fromJson(json['saturday']) : null,
      sunday: json['sunday'] != null ? DayMeals.fromJson(json['sunday']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (monday != null) data['monday'] = monday!.toJson();
    if (tuesday != null) data['tuesday'] = tuesday!.toJson();
    if (wednesday != null) data['wednesday'] = wednesday!.toJson();
    if (thursday != null) data['thursday'] = thursday!.toJson();
    if (friday != null) data['friday'] = friday!.toJson();
    if (saturday != null) data['saturday'] = saturday!.toJson();
    if (sunday != null) data['sunday'] = sunday!.toJson();
    return data;
  }

  /// Get DayMeals by day name
  DayMeals? getDay(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return monday;
      case 'tuesday':
        return tuesday;
      case 'wednesday':
        return wednesday;
      case 'thursday':
        return thursday;
      case 'friday':
        return friday;
      case 'saturday':
        return saturday;
      case 'sunday':
        return sunday;
      default:
        return null;
    }
  }

  /// Create a copy with updated day
  WeeklyMenu copyWithDay(String day, DayMeals dayMeals) {
    switch (day.toLowerCase()) {
      case 'monday':
        return WeeklyMenu(
          monday: dayMeals,
          tuesday: tuesday,
          wednesday: wednesday,
          thursday: thursday,
          friday: friday,
          saturday: saturday,
          sunday: sunday,
        );
      case 'tuesday':
        return WeeklyMenu(
          monday: monday,
          tuesday: dayMeals,
          wednesday: wednesday,
          thursday: thursday,
          friday: friday,
          saturday: saturday,
          sunday: sunday,
        );
      case 'wednesday':
        return WeeklyMenu(
          monday: monday,
          tuesday: tuesday,
          wednesday: dayMeals,
          thursday: thursday,
          friday: friday,
          saturday: saturday,
          sunday: sunday,
        );
      case 'thursday':
        return WeeklyMenu(
          monday: monday,
          tuesday: tuesday,
          wednesday: wednesday,
          thursday: dayMeals,
          friday: friday,
          saturday: saturday,
          sunday: sunday,
        );
      case 'friday':
        return WeeklyMenu(
          monday: monday,
          tuesday: tuesday,
          wednesday: wednesday,
          thursday: thursday,
          friday: dayMeals,
          saturday: saturday,
          sunday: sunday,
        );
      case 'saturday':
        return WeeklyMenu(
          monday: monday,
          tuesday: tuesday,
          wednesday: wednesday,
          thursday: thursday,
          friday: friday,
          saturday: dayMeals,
          sunday: sunday,
        );
      case 'sunday':
        return WeeklyMenu(
          monday: monday,
          tuesday: tuesday,
          wednesday: wednesday,
          thursday: thursday,
          friday: friday,
          saturday: saturday,
          sunday: dayMeals,
        );
      default:
        return this;
    }
  }
}

class MealPlan {
  final String? id;
  final String name;
  final String description;
  final int durationDays;
  final int mealsPerDay;
  final List<String> mealTypes;
  final double price;
  final WeeklyMenu? weeklyMenu;
  final bool isActive;
  final DateTime? createdAt;

  MealPlan({
    this.id,
    required this.name,
    required this.description,
    required this.durationDays,
    required this.mealsPerDay,
    required this.mealTypes,
    required this.price,
    this.weeklyMenu,
    this.isActive = true,
    this.createdAt,
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
      weeklyMenu: json['weekly_menu'] != null || json['WeeklyMenu'] != null
          ? WeeklyMenu.fromJson(json['weekly_menu'] ?? json['WeeklyMenu'])
          : null,
      isActive: json['IsActive'] ?? json['is_active'] ?? true,
      createdAt: json['CreatedAt'] != null
          ? DateTime.tryParse(json['CreatedAt'])
          : json['created_at'] != null
              ? DateTime.tryParse(json['created_at'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'duration_days': durationDays,
      'meals_per_day': mealsPerDay,
      'meal_types': mealTypes,
      'price': price,
    };
    if (weeklyMenu != null) {
      data['weekly_menu'] = weeklyMenu!.toJson();
    }
    return data;
  }

  MealPlan copyWith({
    String? id,
    String? name,
    String? description,
    int? durationDays,
    int? mealsPerDay,
    List<String>? mealTypes,
    double? price,
    WeeklyMenu? weeklyMenu,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return MealPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      durationDays: durationDays ?? this.durationDays,
      mealsPerDay: mealsPerDay ?? this.mealsPerDay,
      mealTypes: mealTypes ?? this.mealTypes,
      price: price ?? this.price,
      weeklyMenu: weeklyMenu ?? this.weeklyMenu,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Get formatted creation date
  String get formattedCreatedAt {
    if (createdAt == null) return 'N/A';
    return '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}';
  }

  /// Get number of configured days in weekly menu
  int get configuredDaysCount {
    if (weeklyMenu == null) return 0;
    int count = 0;
    if (weeklyMenu!.monday != null && _hasMeals(weeklyMenu!.monday!)) count++;
    if (weeklyMenu!.tuesday != null && _hasMeals(weeklyMenu!.tuesday!)) count++;
    if (weeklyMenu!.wednesday != null && _hasMeals(weeklyMenu!.wednesday!))
      count++;
    if (weeklyMenu!.thursday != null && _hasMeals(weeklyMenu!.thursday!))
      count++;
    if (weeklyMenu!.friday != null && _hasMeals(weeklyMenu!.friday!)) count++;
    if (weeklyMenu!.saturday != null && _hasMeals(weeklyMenu!.saturday!))
      count++;
    if (weeklyMenu!.sunday != null && _hasMeals(weeklyMenu!.sunday!)) count++;
    return count;
  }

  bool _hasMeals(DayMeals dayMeals) {
    return (dayMeals.breakfast != null &&
            dayMeals.breakfast!.name.isNotEmpty) ||
        (dayMeals.lunch != null && dayMeals.lunch!.name.isNotEmpty) ||
        (dayMeals.dinner != null && dayMeals.dinner!.name.isNotEmpty);
  }
}
