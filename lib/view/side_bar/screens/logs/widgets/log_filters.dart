import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../controller/admin_log_controller.dart';
import '../../../../../core/theme/app_colors.dart';

class LogFilters extends StatefulWidget {
  const LogFilters({super.key});

  @override
  State<LogFilters> createState() => _LogFiltersState();
}

class _LogFiltersState extends State<LogFilters> {
  String selectedRole = 'all';

  final List<Map<String, String>> roles = [
    {'label': 'All Activities', 'value': 'all', 'icon': 'dashboard'},
    {'label': 'Customers', 'value': 'customer', 'icon': 'person'},
    {'label': 'Delivery Fleet', 'value': 'driver', 'icon': 'local_shipping'},
    {'label': 'Kitchen Team', 'value': 'kitchen', 'icon': 'restaurant'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          bottom: BorderSide(color: AppColors.black.withOpacity(0.05)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Filter by Entity',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Audit Trail',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: roles.map((role) {
                final isSelected = selectedRole == role['value'];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedRole = role['value']!;
                        });
                        context.read<AdminLogController>().fetchLogs(
                              userRole: selectedRole,
                              page: 1,
                            );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.black
                              : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.black
                                : AppColors.black.withOpacity(0.08),
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : null,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _getIconData(role['icon']!),
                              size: 16,
                              color: isSelected ? Colors.white : AppColors.textLight,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              role['label']!,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color:
                                    isSelected ? Colors.white : AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'dashboard':
        return Icons.dashboard_outlined;
      case 'person':
        return Icons.person_outline;
      case 'local_shipping':
        return Icons.local_shipping_outlined;
      case 'restaurant':
        return Icons.restaurant_outlined;
      default:
        return Icons.circle_outlined;
    }
  }
}
