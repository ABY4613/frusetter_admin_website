/// Model class for the reminder API response
class ReminderResponse {
  final bool success;
  final String message;
  final ReminderData data;

  ReminderResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ReminderResponse.fromJson(Map<String, dynamic> json) {
    return ReminderResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ReminderData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

/// Model class for the reminder data
class ReminderData {
  final int remindersSent;
  final List<String> usersNotified;

  ReminderData({
    required this.remindersSent,
    required this.usersNotified,
  });

  factory ReminderData.fromJson(Map<String, dynamic> json) {
    return ReminderData(
      remindersSent: json['reminders_sent'] ?? 0,
      usersNotified: json['users_notified'] != null
          ? List<String>.from(json['users_notified'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reminders_sent': remindersSent,
      'users_notified': usersNotified,
    };
  }
}
