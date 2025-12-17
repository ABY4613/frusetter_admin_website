import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../controller/subscription_controller.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'widgets/subscription_header.dart';
import 'widgets/subscription_filters.dart';
import 'widgets/subscription_table.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch subscriptions when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionController>().fetchSubscriptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const SubscriptionHeader(),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  SubscriptionFilters(),
                  SubscriptionTable(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
