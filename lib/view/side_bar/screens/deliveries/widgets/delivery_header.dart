import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../../controller/driver_controller.dart';
import 'add_driver_dialog.dart';

class DeliveryHeader extends StatelessWidget {
  const DeliveryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Delivery Overview",
          style: GoogleFonts.inter(
            color: AppColors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Container(
              width: 300,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: TextField(
                onChanged: (value) {
                  Provider.of<DriverController>(context, listen: false)
                      .updateSearch(value);
                },
                decoration: InputDecoration(
                  hintText: "Search drivers...",
                  hintStyle: GoogleFonts.inter(color: Colors.grey),
                  icon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(width: 24),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Icon(Icons.notifications_none, color: AppColors.black),
            ),
            const SizedBox(width: 24),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const AddDriverDialog(),
                );
              },
              icon: const Icon(Icons.add, color: AppColors.black, size: 20),
              label: Text(
                "Add Driver",
                style: GoogleFonts.inter(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentGreen,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
