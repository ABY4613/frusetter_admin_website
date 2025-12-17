import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_subscription_dialog.dart';

class SubscriptionHeader extends StatelessWidget {
  const SubscriptionHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Subscription Management",
              style: GoogleFonts.inter(
                color: AppColors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Manage active plans, customer details, and delivery schedules.",
              style: GoogleFonts.inter(
                color: AppColors.black.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const AddSubscriptionDialog(),
            );
          },
          icon: const Icon(Icons.add, color: AppColors.black, size: 20),
          label: Text(
            "Add Subscription",
            style: GoogleFonts.inter(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentGreen,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
      ],
    );
  }
}
