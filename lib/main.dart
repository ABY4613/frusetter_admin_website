import 'package:flutter/material.dart';
import 'package:frusette_admin_operations_web_dashboard/view/auth/views/login_screen.dart';
import 'package:frusette_admin_operations_web_dashboard/view/auth/splash_screen.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/view_models/navigation_view_model.dart';
//import 'view/side_bar/screens/company_management/view_models/company_view_model.dart';
import 'view/main_layout_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationViewModel()),
        // ChangeNotifierProvider(create: (_) => CompanyViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frusette Admin ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
