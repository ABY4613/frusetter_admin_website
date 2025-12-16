enum SubscriptionStatus { active, paused, cancelled, expired }

class Subscription {
  final String id;
  final String userName;
  final String userEmail;
  final String planName;
  final String mealFrequency;
  final DateTime startDate;
  final DateTime endDate;
  final SubscriptionStatus status;
  final double price;
  final int remainingCredit;
  final int totalCredit;

  Subscription({
    required this.id,
    required this.userName,
    required this.userEmail,
    required this.planName,
    required this.mealFrequency,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.price,
    required this.remainingCredit,
    required this.totalCredit,
  });
}
