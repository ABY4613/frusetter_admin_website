import 'package:flutter/material.dart';
import 'package:frusette_admin_operations_web_dashboard/core/theme/app_theme.dart';
import 'package:frusette_admin_operations_web_dashboard/view/main_layout_screen.dart';
import 'package:frusette_admin_operations_web_dashboard/widgets/frusette_loader.dart';
import 'package:provider/provider.dart';
import '../../../../controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen size for responsiveness
    final size = MediaQuery.of(context).size;
    final bool isSmallScreen = size.width < 900;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Use a high-quality fruit image from Unsplash
    const String fruitImageUrl =
        'https://images.unsplash.com/photo-1610832958506-aa56368176cf?auto=format&fit=crop&q=80';

    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Row(
        children: [
          // LEFT SIDE: Image Section (Visible on large screens)
          if (!isSmallScreen)
            Expanded(
              flex:
                  6, // Gives the image slightly more space for a dramatic effect
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    fruitImageUrl,
                    fit: BoxFit.cover,
                  ),
                  // Gradient Overlay for text readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                  // Branding Text on Image
                  Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Freshness\nDelivered.',
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Manage your inventory, orders, and customers\nfrom one beautiful dashboard.',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white70,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // RIGHT SIDE: Login Form Section
          Expanded(
            flex: 5,
            child: Container(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 48.0, vertical: 24.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo / Icon
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: AppTheme.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Image.asset(
                              'assets/images/image.png',
                              width: 32,
                              height: 32,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Title
                        Text(
                          'Welcome back',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color:
                                isDark ? Colors.white : const Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please enter your details to sign in.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: isDark
                                ? Colors.grey[400]
                                : const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 48),

                        // Form
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Email
                              _buildMinimalTextField(
                                controller: _emailController,
                                label: 'Email address',
                                hint: 'name@company.com',
                                icon: Icons.email_outlined,
                                isDark: isDark,
                              ),
                              const SizedBox(height: 24),

                              // Password
                              _buildMinimalTextField(
                                controller: _passwordController,
                                label: 'Password',
                                hint: '••••••••',
                                icon: Icons.lock_outline,
                                isDark: isDark,
                                isPassword: true,
                                isPasswordVisible: _isPasswordVisible,
                                onVisibilityToggle: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),

                              const SizedBox(height: 16),

                              // Forgot Password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    foregroundColor: theme.primaryColor,
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text('Forgot password?'),
                                ),
                              ),

                              const SizedBox(height: 32),

                              // Login Button
                              SizedBox(
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            final authController =
                                                Provider.of<AuthController>(
                                                    context,
                                                    listen: false);

                                            setState(() {
                                              _isLoading = true;
                                            });

                                            final success =
                                                await authController.login(
                                              _emailController.text.trim(),
                                              _passwordController.text,
                                            );

                                            if (mounted) {
                                              setState(() {
                                                _isLoading = false;
                                              });

                                              if (success) {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MainLayoutScreen(),
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(authController
                                                            .errorMessage ??
                                                        'Login failed'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            }
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.primaryColor,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    disabledBackgroundColor:
                                        theme.primaryColor.withOpacity(0.6),
                                  ),
                                  child: _isLoading
                                      ? const FrusetteLoader(
                                          size: 24,
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          'Sign in',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDark,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onVisibilityToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.grey[300] : const Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword && !isPasswordVisible,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? Colors.grey[600] : Colors.grey[400],
              fontSize: 14,
            ),
            prefixIcon: Icon(
              icon,
              size: 20,
              color: isDark ? Colors.grey[500] : Colors.grey[400],
            ),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: isDark ? Colors.grey[500] : Colors.grey[400],
                    ),
                    onPressed: onVisibilityToggle,
                  )
                : null,
            filled: true,
            fillColor:
                isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? Colors.transparent : const Color(0xFFE5E7EB),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }
}
