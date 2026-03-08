import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'widgets/delivery_header.dart';
import 'widgets/drivers_table_widget.dart';

class DeliveriesScreen extends StatelessWidget {
  const DeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            DeliveryHeader(),
            SizedBox(height: 32),
            DriversTableWidget(),
          ],
        ),
      ),
    );
  }
}
