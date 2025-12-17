class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://frusette-backend-ym62.onrender.com';
  // static const String baseUrl = 'http://10.0.2.2:3000'; // For Android Emulator
  // static const String baseUrl = 'http://localhost:3000'; // For iOS Simulator / Web

  // API Version
  static const String apiVersion = '/v1';

  // Auth Endpoints
  static const String authLogin = '$apiVersion/auth/login';
  // Admin Endpoints
  static const String adminOverviewMeals = '$apiVersion/admin/overview/meals';
}
