import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'widgets/subscription_header.dart';
import 'widgets/subscription_filters.dart';
import 'widgets/subscription_table.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.white, // Keeping consistent with dashboard background
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const SubscriptionHeader(),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withOpacity(0.05), // A minimal shadow if needed, or remove completely.
                //     blurRadius: 20,
                //     offset: const Offset(0, 10),
                //   ),
                // ],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SubscriptionFilters(),
                  const SubscriptionTable(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
