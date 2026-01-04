import 'package:flutter/material.dart';
import 'package:frusette_admin_operations_web_dashboard/core/theme/app_colors.dart';
import 'package:frusette_admin_operations_web_dashboard/view/side_bar/screens/dashboard/widgets/dashboard_cards.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime _selectedDate = DateTime.now();

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppColors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String get _formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected =
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);

    if (selected == today) {
      return "Today, ${DateFormat('MMM d').format(_selectedDate)}";
    } else if (selected == today.subtract(const Duration(days: 1))) {
      return "Yesterday, ${DateFormat('MMM d').format(_selectedDate)}";
    } else if (selected == today.add(const Duration(days: 1))) {
      return "Tomorrow, ${DateFormat('MMM d').format(_selectedDate)}";
    }

    return DateFormat('EEE, MMM d').format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 900;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                if (isMobile)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dashboard Overview",
                        style: GoogleFonts.inter(
                          color: AppColors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Welcome back, Admin.", // Shortened for mobile
                        style: GoogleFonts.inter(
                          color: AppColors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDatePicker(context, isMobile: true),
                    ],
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dashboard Overview",
                            style: GoogleFonts.inter(
                              color: AppColors.black,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Welcome back, Admin. Here is your daily summary.",
                            style: GoogleFonts.inter(
                              color: AppColors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      // Date Picker Button
                      _buildDatePicker(context),
                    ],
                  ),
                const SizedBox(height: 32),

                // Content Grid
                if (isMobile)
                  Column(
                    children: [
                      const TodaysMealsCard(),
                      const SizedBox(height: 16),
                      const DeliveryFleetCard(),
                      const SizedBox(height: 16),
                      const SubscriptionsCard(),
                      const SizedBox(height: 16),
                      const UpcomingVolumeCard(),
                      const SizedBox(height: 16),
                      const PendingPaymentsCard(),
                      const SizedBox(height: 16),
                      const FeedbackCard(),
                    ],
                  )
                else
                  Column(
                    children: [
                      // Row 1
                      SizedBox(
                        height: 320, // Fixed height for alignment
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: const TodaysMealsCard(),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 1,
                              child: const DeliveryFleetCard(),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 1,
                              child: const SubscriptionsCard(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Row 2
                      SizedBox(
                        height: 320,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: const UpcomingVolumeCard(),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 1,
                              child: const PendingPaymentsCard(),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 1,
                              child: const FeedbackCard(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, {bool isMobile = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: isMobile ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment:
            isMobile ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _changeDate(-1),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.chevron_left, color: Colors.white, size: 16),
            ),
          ),
          if (isMobile) const Spacer(),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today,
                      color: AppColors.accentGreen, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    _formattedDate,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMobile) const Spacer(),
          InkWell(
            onTap: () => _changeDate(1),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.chevron_right,
                  color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
