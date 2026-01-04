import 'package:flutter/material.dart';

import 'package:frusette_admin_operations_web_dashboard/view/auth/splash_screen.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/view_models/navigation_view_model.dart';
import 'controller/auth_controller.dart';
import 'controller/meals_controller.dart';
import 'controller/subscription_controller.dart';
import 'controller/payment_controller.dart';
import 'controller/cutoff_controller.dart';
import 'controller/addon_food_controller.dart';
//import 'view/side_bar/screens/company_management/view_models/company_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationViewModel()),
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => MealsController()),
        ChangeNotifierProvider(create: (_) => SubscriptionController()),
        ChangeNotifierProvider(create: (_) => PaymentController()),
        ChangeNotifierProvider(create: (_) => CutoffController()),
        ChangeNotifierProvider(create: (_) => AddonFoodController()),
        // ChangeNotifierProvider(create: (_) => CompanyViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frusette Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
