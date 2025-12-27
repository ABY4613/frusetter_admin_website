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

  /// Check if any day has meals configured
  bool get hasAnyMeals {
    return [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
        .any((day) => day != null && _dayHasMeals(day));
  }

  bool _dayHasMeals(DayMeals day) {
    return (day.breakfast != null && day.breakfast!.name.isNotEmpty) ||
        (day.lunch != null && day.lunch!.name.isNotEmpty) ||
        (day.dinner != null && day.dinner!.name.isNotEmpty);
  }

  /// Get number of days with meals configured
  int get configuredDaysCount {
    int count = 0;
    if (monday != null && _dayHasMeals(monday!)) count++;
    if (tuesday != null && _dayHasMeals(tuesday!)) count++;
    if (wednesday != null && _dayHasMeals(wednesday!)) count++;
    if (thursday != null && _dayHasMeals(thursday!)) count++;
    if (friday != null && _dayHasMeals(friday!)) count++;
    if (saturday != null && _dayHasMeals(saturday!)) count++;
    if (sunday != null && _dayHasMeals(sunday!)) count++;
    return count;
  }
}

/// Represents a monthly menu with 4 weeks of meals
class MonthlyMenu {
  final WeeklyMenu? week1;
  final WeeklyMenu? week2;
  final WeeklyMenu? week3;
  final WeeklyMenu? week4;

  MonthlyMenu({
    this.week1,
    this.week2,
    this.week3,
    this.week4,
  });

  factory MonthlyMenu.fromJson(Map<String, dynamic> json) {
    return MonthlyMenu(
      week1: json['week1'] != null ? WeeklyMenu.fromJson(json['week1']) : null,
      week2: json['week2'] != null ? WeeklyMenu.fromJson(json['week2']) : null,
      week3: json['week3'] != null ? WeeklyMenu.fromJson(json['week3']) : null,
      week4: json['week4'] != null ? WeeklyMenu.fromJson(json['week4']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (week1 != null) data['week1'] = week1!.toJson();
    if (week2 != null) data['week2'] = week2!.toJson();
    if (week3 != null) data['week3'] = week3!.toJson();
    if (week4 != null) data['week4'] = week4!.toJson();
    return data;
  }

  /// Get WeeklyMenu by week number (1-4)
  WeeklyMenu? getWeek(int weekNumber) {
    switch (weekNumber) {
      case 1:
        return week1;
      case 2:
        return week2;
      case 3:
        return week3;
      case 4:
        return week4;
      default:
        return null;
    }
  }

  /// Get WeeklyMenu by week key (week1, week2, etc.)
  WeeklyMenu? getWeekByKey(String weekKey) {
    switch (weekKey.toLowerCase()) {
      case 'week1':
        return week1;
      case 'week2':
        return week2;
      case 'week3':
        return week3;
      case 'week4':
        return week4;
      default:
        return null;
    }
  }

  /// Check if any week has meals configured
  bool get hasAnyMeals {
    return [week1, week2, week3, week4]
        .any((week) => week != null && week.hasAnyMeals);
  }

  /// Get number of weeks with meals configured
  int get configuredWeeksCount {
    int count = 0;
    if (week1 != null && week1!.hasAnyMeals) count++;
    if (week2 != null && week2!.hasAnyMeals) count++;
    if (week3 != null && week3!.hasAnyMeals) count++;
    if (week4 != null && week4!.hasAnyMeals) count++;
    return count;
  }

  /// Get total number of days with meals configured across all weeks
  int get totalConfiguredDaysCount {
    int count = 0;
    if (week1 != null) count += week1!.configuredDaysCount;
    if (week2 != null) count += week2!.configuredDaysCount;
    if (week3 != null) count += week3!.configuredDaysCount;
    if (week4 != null) count += week4!.configuredDaysCount;
    return count;
  }

  /// Create a copy with updated week
  MonthlyMenu copyWithWeek(String weekKey, WeeklyMenu weeklyMenu) {
    switch (weekKey.toLowerCase()) {
      case 'week1':
        return MonthlyMenu(
          week1: weeklyMenu,
          week2: week2,
          week3: week3,
          week4: week4,
        );
      case 'week2':
        return MonthlyMenu(
          week1: week1,
          week2: weeklyMenu,
          week3: week3,
          week4: week4,
        );
      case 'week3':
        return MonthlyMenu(
          week1: week1,
          week2: week2,
          week3: weeklyMenu,
          week4: week4,
        );
      case 'week4':
        return MonthlyMenu(
          week1: week1,
          week2: week2,
          week3: week3,
          week4: weeklyMenu,
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
  final String planType; // 'weekly' or 'monthly'
  final WeeklyMenu? weeklyMenu;
  final MonthlyMenu? monthlyMenu;
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
    this.planType = 'weekly',
    this.weeklyMenu,
    this.monthlyMenu,
    this.isActive = true,
    this.createdAt,
  });

  /// Check if this is a monthly plan
  bool get isMonthlyPlan => planType.toLowerCase() == 'monthly';

  /// Check if this is a weekly plan
  bool get isWeeklyPlan => planType.toLowerCase() == 'weekly';

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    final planType = json['PlanType'] ?? json['plan_type'] ?? 'weekly';

    return MealPlan(
      id: json['ID'] ?? json['_id'] ?? json['id'],
      name: json['Name'] ?? json['name'] ?? '',
      description: json['Description'] ?? json['description'] ?? '',
      durationDays: json['DurationDays'] ?? json['duration_days'] ?? 0,
      mealsPerDay: json['MealsPerDay'] ?? json['meals_per_day'] ?? 0,
      mealTypes:
          List<String>.from(json['MealTypes'] ?? json['meal_types'] ?? []),
      price: (json['Price'] ?? json['price'] ?? 0).toDouble(),
      planType: planType,
      weeklyMenu: json['weekly_menu'] != null || json['WeeklyMenu'] != null
          ? WeeklyMenu.fromJson(json['weekly_menu'] ?? json['WeeklyMenu'])
          : null,
      monthlyMenu: json['monthly_menu'] != null || json['MonthlyMenu'] != null
          ? MonthlyMenu.fromJson(json['monthly_menu'] ?? json['MonthlyMenu'])
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
      'plan_type': planType,
    };

    // Only include the relevant menu based on plan type
    if (isMonthlyPlan && monthlyMenu != null) {
      data['monthly_menu'] = monthlyMenu!.toJson();
    } else if (isWeeklyPlan && weeklyMenu != null) {
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
    String? planType,
    WeeklyMenu? weeklyMenu,
    MonthlyMenu? monthlyMenu,
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
      planType: planType ?? this.planType,
      weeklyMenu: weeklyMenu ?? this.weeklyMenu,
      monthlyMenu: monthlyMenu ?? this.monthlyMenu,
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
    if (isMonthlyPlan) {
      return monthlyMenu?.totalConfiguredDaysCount ?? 0;
    }
    if (weeklyMenu == null) return 0;
    return weeklyMenu!.configuredDaysCount;
  }

  /// Get number of configured weeks (for monthly plans)
  int get configuredWeeksCount {
    if (!isMonthlyPlan || monthlyMenu == null) return 0;
    return monthlyMenu!.configuredWeeksCount;
  }

  /// Get total expected days based on plan type
  int get totalExpectedDays {
    return isMonthlyPlan ? 28 : 7;
  }
}
