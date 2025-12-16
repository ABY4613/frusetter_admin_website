import 'package:flutter/material.dart';
import 'package:frusette_admin_operations_web_dashboard/core/theme/app_colors.dart';
import 'package:frusette_admin_operations_web_dashboard/view/auth/views/login_screen.dart';
import 'package:frusette_admin_operations_web_dashboard/widgets/frusette_loader.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate initialization process (e.g., checking auth, loading config)
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LoginScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutQuart;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1419) : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo / Title area
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primaryColor.withOpacity(0.05),
              ),
              child: Image.asset(
                'assets/images/image.png',
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'FRUSETTE',
              style: theme.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
            Text(
              'ADMIN CONSOLE',
              style: theme.textTheme.labelLarge?.copyWith(
                letterSpacing: 6,
                color: isDark ? Colors.grey[400] : const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 60),
            // Standard Loader
            const FrusetteLoader(),
            const SizedBox(height: 20),
            Text(
              'Initializing...',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.disabledColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
