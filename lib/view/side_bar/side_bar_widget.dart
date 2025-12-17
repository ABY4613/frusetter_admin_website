import 'package:flutter/material.dart';
import 'package:frusette_admin_operations_web_dashboard/view/auth/login_screen.dart';
import '../../core/view_models/navigation_view_model.dart';
import '../../core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class SideBarWidget extends StatelessWidget {
  const SideBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: AppColors.white, // Dark background
      child: Column(
        children: [
          _buildLogo(context),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Consumer<NavigationViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  children: [
                    _buildNavItem(
                      icon: Icons.dashboard,
                      label: 'Dashboard',
                      item: NavigationItem.dashboard,
                      isSelected:
                          viewModel.selectedItem == NavigationItem.dashboard,
                      onTap: () =>
                          viewModel.setNavigationItem(NavigationItem.dashboard),
                    ),
                    const SizedBox(height: 8),
                    _buildNavItem(
                      icon: Icons.restaurant_menu, // Meals Planning
                      label: 'Meals Planning',
                      item: NavigationItem.mealsPlanning,
                      isSelected: viewModel.selectedItem ==
                          NavigationItem.mealsPlanning,
                      onTap: () => viewModel
                          .setNavigationItem(NavigationItem.mealsPlanning),
                    ),
                    const SizedBox(height: 8),
                    _buildNavItem(
                      icon: Icons.people, // Subscriptions
                      label: 'Subscriptions',
                      item: NavigationItem.subscriptions,
                      isSelected: viewModel.selectedItem ==
                          NavigationItem.subscriptions,
                      onTap: () => viewModel
                          .setNavigationItem(NavigationItem.subscriptions),
                    ),
                    const SizedBox(height: 8),
                    _buildNavItem(
                      icon: Icons.local_shipping, // Delivery Fleet
                      label: 'Delivery Fleet',
                      item: NavigationItem.deliveryFleet,
                      isSelected: viewModel.selectedItem ==
                          NavigationItem.deliveryFleet,
                      onTap: () => viewModel
                          .setNavigationItem(NavigationItem.deliveryFleet),
                    ),
                    const SizedBox(height: 8),
                    _buildNavItem(
                      icon: Icons.attach_money, // Financials
                      label: 'Payments & Billing',
                      item: NavigationItem.financials,
                      isSelected:
                          viewModel.selectedItem == NavigationItem.financials,
                      onTap: () => viewModel
                          .setNavigationItem(NavigationItem.financials),
                    ),
                    const SizedBox(height: 8),
                    _buildNavItem(
                      icon: Icons.chat_bubble_outline, // Feedback
                      label: 'Feedback',
                      item: NavigationItem.feedback,
                      isSelected:
                          viewModel.selectedItem == NavigationItem.feedback,
                      onTap: () =>
                          viewModel.setNavigationItem(NavigationItem.feedback),
                    ),
                  ],
                );
              },
            ),
          ),
          const Spacer(),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<NavigationViewModel>(context, listen: false)
            .setNavigationItem(NavigationItem.dashboard);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/image.png',
                width: 16,
                height: 16,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Frusette Admin',
                  style: GoogleFonts.inter(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Operations Center',
                  style: GoogleFonts.inter(
                    color: AppColors.black,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required NavigationItem item,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50), // Rounded pill shape
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : AppColors.black,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                color: isSelected ? Colors.black : AppColors.black,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Divider(color: AppColors.black.withOpacity(0.2), height: 1),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFFE2C499), // Approximate avatar color
                radius: 18,
                child: Icon(Icons.person,
                    color: Colors.white, size: 20), // Placeholder if no image
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin User',
                      style: GoogleFonts.inter(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'View Profile',
                      style: GoogleFonts.inter(
                        color: AppColors.black,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: AppColors.white,
                      title: Text(
                        'Logout',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to logout?',
                        style: GoogleFonts.inter(
                          color: AppColors.black,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                              color: AppColors.textLight,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close dialog
                            // Navigate to Login Screen
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          child: Text(
                            'Logout',
                            style: GoogleFonts.inter(
                              color: AppColors.accentRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(Icons.logout, color: AppColors.black, size: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
