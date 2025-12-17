import '../../model/dashboard_stats.dart';
import '../../model/delivery.dart';
import '../../model/feedback_item.dart';
import '../../model/meal_plan.dart';
import '../../model/subscription.dart';
import '../../model/transaction_model.dart'; // import transaction_model

class DummyData {
  static final DashboardStats dashboardStats = DashboardStats(
    totalUsers: 1250,
    activeSubscriptions: 850,
    totalRevenue: 45200.50,
    pendingDeliveries: 12,
  );

  static final List<Delivery> deliveries = [
    Delivery(
      id: 'DEL-001',
      customerName: 'John Doe',
      address: '123 Main St, Springfield',
      scheduledTime: DateTime.now().add(Duration(hours: 1)),
      driverName: 'Mike Ross',
      status: DeliveryStatus.inProgress,
      items: ['Vegan Meal Plan', 'Green Juice'],
    ),
    Delivery(
      id: 'DEL-002',
      customerName: 'Jane Smith',
      address: '456 Elm St, Shelbyville',
      scheduledTime: DateTime.now().add(Duration(hours: 3)),
      driverName: 'Rachel Zane',
      status: DeliveryStatus.pending,
      items: ['Keto Meal Plan'],
    ),
    Delivery(
      id: 'DEL-003',
      customerName: 'Robert Brown',
      address: '789 Oak Ave, Capital City',
      scheduledTime: DateTime.now().subtract(Duration(hours: 2)),
      driverName: 'Louis Litt',
      status: DeliveryStatus.delivered,
      items: ['Standard Meal Plan', 'Protein Bar'],
    ),
  ];

  static final List<FeedbackItem> feedbackList = [
    FeedbackItem(
      id: 'FB-001',
      userName: 'Alice Johnson',
      rating: 5.0,
      comment: 'The food is absolutely amazing! Fresh and healthy.',
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    FeedbackItem(
      id: 'FB-002',
      userName: 'Bob Williams',
      rating: 3.5,
      comment: 'Delivery was a bit late, but the food is good.',
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    FeedbackItem(
      id: 'FB-003',
      userName: 'Charlie Brown',
      rating: 4.0,
      comment: 'Great variety of meals.',
      date: DateTime.now().subtract(Duration(days: 5)),
    ),
  ];

  static final List<TransactionModel> transactions = [
    TransactionModel(
      id: 'TRX-1001',
      description: 'Subscription Payment - Monthly',
      amount: 120.00,
      date: DateTime.now(),
      type: TransactionType.income,
      status: TransactionStatus.completed,
    ),
    TransactionModel(
      id: 'TRX-1002',
      description: 'Grocery Supplier Payment',
      amount: 500.00,
      date: DateTime.now().subtract(Duration(days: 1)),
      type: TransactionType.expense,
      status: TransactionStatus.completed,
    ),
    TransactionModel(
      id: 'TRX-1003',
      description: 'Refund for Order #1234',
      amount: 45.00,
      date: DateTime.now().subtract(Duration(days: 3)),
      type: TransactionType.refund,
      status: TransactionStatus.completed,
    ),
  ];

  static final List<MealPlan> mealPlans = [
    MealPlan(
      id: 'MP-001',
      name: 'Weight Loss Plan',
      description: 'Low calorie, high protein meals designed for weight loss.',
      durationDays: 30,
      mealsPerDay: 3,
      mealTypes: ['breakfast', 'lunch', 'dinner'],
      price: 150.00,
    ),
    MealPlan(
      id: 'MP-002',
      name: 'Vegan Power Plan',
      description: 'Plant-based meals packed with nutrients.',
      durationDays: 14,
      mealsPerDay: 2,
      mealTypes: ['lunch', 'dinner'],
      price: 140.00,
    ),
    MealPlan(
      id: 'MP-003',
      name: 'Keto Kickstart',
      description: 'High fat, low carb meals to get you into ketosis.',
      durationDays: 7,
      mealsPerDay: 3,
      mealTypes: ['breakfast', 'lunch', 'dinner'],
      price: 160.00,
    ),
  ];

  static final List<Subscription> subscriptions = [
    Subscription(
      id: 'SUB-001',
      userName: 'David Miller',
      userEmail: 'david.m@example.com',
      planName: 'Vegan Power Plan',
      mealFrequency: '5 meals/week',
      startDate: DateTime.now().subtract(Duration(days: 15)),
      endDate: DateTime.now().add(Duration(days: 15)),
      status: SubscriptionStatus.active,
      price: 140.00,
      remainingCredit: 10,
      totalCredit: 20,
    ),
    Subscription(
      id: 'SUB-002',
      userName: 'Eva Green',
      userEmail: 'eva.g@example.com',
      planName: 'Weight Loss Plan',
      mealFrequency: '3 meals/week',
      startDate: DateTime.now().subtract(Duration(days: 40)),
      endDate: DateTime.now().subtract(Duration(days: 10)),
      status: SubscriptionStatus.expired,
      price: 150.00,
      remainingCredit: 0,
      totalCredit: 12,
    ),
    Subscription(
      id: 'SUB-003',
      userName: 'Frank Castle',
      userEmail: 'frank.c@example.com',
      planName: 'Keto Kickstart',
      mealFrequency: '7 meals/week',
      startDate: DateTime.now().subtract(Duration(days: 5)),
      endDate: DateTime.now().add(Duration(days: 25)),
      status: SubscriptionStatus.active,
      price: 160.00,
      remainingCredit: 25,
      totalCredit: 30,
    ),
  ];
}
