/// Model class for Cutoff Setting
class CutoffSetting {
  final String id;
  final String mealType;
  final String cutoffTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  CutoffSetting({
    required this.id,
    required this.mealType,
    required this.cutoffTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CutoffSetting.fromJson(Map<String, dynamic> json) {
    return CutoffSetting(
      id: json['id'] ?? '',
      mealType: json['meal_type'] ?? '',
      cutoffTime: json['cutoff_time'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'meal_type': mealType,
      'cutoff_time': cutoffTime,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Get display name for meal type
  String get displayMealType {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return 'Breakfast';
      case 'lunch':
        return 'Lunch';
      case 'dinner':
        return 'Dinner';
      default:
        return mealType;
    }
  }

  /// Get formatted cutoff time (e.g., "8:00 PM")
  String get formattedCutoffTime {
    try {
      final parts = cutoffTime.split(':');
      if (parts.length >= 2) {
        int hours = int.parse(parts[0]);
        int minutes = int.parse(parts[1]);

        final period = hours >= 12 ? 'PM' : 'AM';
        if (hours > 12) hours -= 12;
        if (hours == 0) hours = 12;

        return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $period';
      }
      return cutoffTime;
    } catch (e) {
      return cutoffTime;
    }
  }

  /// Get CutoffTimeOfDay from cutoff time
  CutoffTimeOfDay get cutoffTimeOfDay {
    try {
      final parts = cutoffTime.split(':');
      if (parts.length >= 2) {
        return CutoffTimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
      return const CutoffTimeOfDay(hour: 0, minute: 0);
    } catch (e) {
      return const CutoffTimeOfDay(hour: 0, minute: 0);
    }
  }

  CutoffSetting copyWith({
    String? id,
    String? mealType,
    String? cutoffTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CutoffSetting(
      id: id ?? this.id,
      mealType: mealType ?? this.mealType,
      cutoffTime: cutoffTime ?? this.cutoffTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// CutoffTimeOfDay class for time representation
class CutoffTimeOfDay {
  final int hour;
  final int minute;

  const CutoffTimeOfDay({required this.hour, required this.minute});

  String format24Hour() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}

/// Response wrapper for cutoff settings API
class CutoffSettingsResponse {
  final bool success;
  final List<CutoffSetting> data;

  CutoffSettingsResponse({
    required this.success,
    required this.data,
  });

  factory CutoffSettingsResponse.fromJson(Map<String, dynamic> json) {
    return CutoffSettingsResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => CutoffSetting.fromJson(item))
              .toList()
          : [],
    );
  }
}
