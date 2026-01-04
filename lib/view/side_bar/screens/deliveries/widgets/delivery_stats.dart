import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class DeliveryStatsRow extends StatelessWidget {
  const DeliveryStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DeliveryStatCard(
            title: "Drivers Online",
            value: "12",
            subtitle: "since yesterday",
            subtitlePrefix: "+2",
            subtitleColor: AppColors.accentGreen,
            icon: Icons.two_wheeler,
            iconColor: AppColors.accentGreen,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _DeliveryStatCard(
            title: "Orders Assigned",
            value: "145",
            subtitle: "Active deliveries in progress",
            icon: Icons.assignment,
            iconColor: Colors.blue,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _DeliveryStatCard(
            title: "On-Time Rate",
            value: "98%",
            subtitle: "Top performing day of the week",
            icon: Icons.timer,
            iconColor: Colors.purple,
          ),
        ),
      ],
    );
  }
}

class _DeliveryStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final String? subtitlePrefix;
  final Color? subtitleColor;
  final IconData icon;
  final Color iconColor;

  const _DeliveryStatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    this.subtitlePrefix,
    this.subtitleColor,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: AppColors.black.withOpacity(0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: GoogleFonts.inter(
              color: AppColors.black,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                  fontSize: 12, color: AppColors.black.withOpacity(0.6)),
              children: [
                if (subtitlePrefix != null)
                  TextSpan(
                    text: "$subtitlePrefix ",
                    style: TextStyle(
                      color: subtitleColor ?? AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                TextSpan(text: subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
