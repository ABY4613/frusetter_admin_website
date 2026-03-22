class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://api.frusette.com';
  // static const String baseUrl = 'http://10.0.2.2:3000'; // For Android Emulator
  // static const String baseUrl = 'http://localhost:3000'; // For iOS Simulator / Web

  // API Version
  static const String apiVersion = '/v1';

  // Auth Endpoints
  static const String authLogin = '$apiVersion/auth/login';
  // Admin Endpoints
  static const String adminOverviewMeals = '$apiVersion/admin/overview/meals';
  static const String adminSubscriptions = '$apiVersion/admin/subscriptions';
  static const String adminPlans = '$apiVersion/admin/plans';
  static const String adminPayments = '$apiVersion/admin/payments';
  static const String adminPaymentReminders =
      '$apiVersion/admin/payments/send-reminders';
  static const String adminCutoffSettings = '$apiVersion/admin/cutoff-settings';
  static const String adminAddons = '$apiVersion/admin/addons';
  static const String adminDrivers = '$apiVersion/admin/drivers';
  static const String adminDriverAssignments =
      '$apiVersion/admin/driver-assignments';
  static const String adminDashboardDaily = '$apiVersion/admin/dashboard/daily';
  static const String adminLogs = '$apiVersion/admin/logs';
  static const String adminFeedbacks = '$apiVersion/admin/feedbacks';
}
