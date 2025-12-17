import 'package:flutter/material.dart';
import 'package:frusette_admin_operations_web_dashboard/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frusette_admin_operations_web_dashboard/core/data/dummy_data.dart';
import 'package:frusette_admin_operations_web_dashboard/model/delivery.dart';
import 'package:frusette_admin_operations_web_dashboard/model/subscription.dart';
import 'package:provider/provider.dart';
import '../../../../../../controller/meals_controller.dart';

class DashboardCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const DashboardCard({Key? key, required this.child, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: padding ?? const EdgeInsets.all(24),
      child: child,
    );
  }
}

class TodaysMealsCard extends StatefulWidget {
  const TodaysMealsCard({Key? key}) : super(key: key);

  @override
  State<TodaysMealsCard> createState() => _TodaysMealsCardState();
}

class _TodaysMealsCardState extends State<TodaysMealsCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MealsController>(context, listen: false).fetchMealsOverview();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MealsController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const DashboardCard(
              child: Center(child: CircularProgressIndicator()));
        }

        final summary = controller.overviewData?.summary;
        final total = summary?.totalMeals ?? 0;
        final breakfast = summary?.breakfast ?? 0;
        final lunch = summary?.lunch ?? 0;
        final dinner = summary?.dinner ?? 0;

        return DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "TODAY'S MEALS",
                    style: GoogleFonts.inter(
                      color: AppColors.black.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.restaurant,
                        color: Colors.black, size: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    total.toString(),
                    style: GoogleFonts.inter(
                      color: AppColors.black,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: AppColors.accentGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "+5% vs yesterday",
                      style: GoogleFonts.inter(
                        color: AppColors.accentGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Progress Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Breakdown",
                      style: TextStyle(color: AppColors.black, fontSize: 12)),
                  Text("Total",
                      style: TextStyle(color: AppColors.black, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Row(
                  children: [
                    if (total > 0) ...[
                      Expanded(
                          flex: (breakfast * 100 ~/ total),
                          child: Container(height: 8, color: Colors.orange)),
                      Expanded(
                          flex: (lunch * 100 ~/ total),
                          child: Container(height: 8, color: Colors.green)),
                      Expanded(
                          flex: (dinner * 100 ~/ total),
                          child: Container(height: 8, color: Colors.blue)),
                    ] else
                      Expanded(
                          child: Container(
                              height: 8, color: Colors.grey.shade200)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Legend
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildLegendItem(Colors.orange, "Breakfast", "$breakfast"),
                  _buildLegendItem(Colors.green, "Lunch", "$lunch"),
                  _buildLegendItem(Colors.blue, "Dinner", "$dinner"),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegendItem(Color color, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 8, color: color),
        const SizedBox(width: 6),
        RichText(
          text: TextSpan(
            style: GoogleFonts.inter(fontSize: 12),
            children: [
              TextSpan(
                  text: label + " ",
                  style: TextStyle(
                      color: AppColors.black, fontWeight: FontWeight.w600)),
              TextSpan(
                  text: "($value)", style: TextStyle(color: AppColors.black)),
            ],
          ),
        ),
      ],
    );
  }
}

class DeliveryFleetCard extends StatelessWidget {
  const DeliveryFleetCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activeDrivers = DummyData.deliveries
        .where((d) => d.status == DeliveryStatus.inProgress)
        .length;
    final delivered = DummyData.deliveries
        .where((d) => d.status == DeliveryStatus.delivered)
        .length;
    final pending = DummyData.deliveries
        .where((d) => d.status == DeliveryStatus.pending)
        .length;

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "DELIVERY FLEET",
                style: GoogleFonts.inter(
                  color: AppColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.accentGreen,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              Text(
                "$activeDrivers ",
                style: GoogleFonts.inter(
                  color: AppColors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Drivers Online",
                style: GoogleFonts.inter(
                  color: AppColors.black,
                  fontSize: 14,
                  height: 2.5, // Align with baseline roughly
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildRow(Icons.check_circle, AppColors.accentGreen, "Delivered",
              "$delivered"),
          const SizedBox(height: 16),
          _buildRow(Icons.local_shipping, AppColors.accentOrange, "In Transit",
              "$activeDrivers"),
          const SizedBox(height: 16),
          _buildRow(Icons.warning, AppColors.accentRed, "Pending", "$pending"),
        ],
      ),
    );
  }

  Widget _buildRow(IconData icon, Color color, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
                color: AppColors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class SubscriptionsCard extends StatelessWidget {
  const SubscriptionsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final active = DummyData.subscriptions
        .where((s) => s.status == SubscriptionStatus.active)
        .length;
    final paused = DummyData.subscriptions
        .where((s) => s.status == SubscriptionStatus.paused)
        .length;
    final expired = DummyData.subscriptions
        .where((s) => s.status == SubscriptionStatus.expired)
        .length;
    final total = DummyData.subscriptions.length;
    final activePercent = total > 0 ? (active / total) : 0.0;

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "SUBSCRIPTIONS",
                style: GoogleFonts.inter(
                  color: AppColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              Icon(Icons.people, color: AppColors.black, size: 16),
            ],
          ),
          SizedBox(
            height: 180,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: activePercent,
                      strokeWidth: 10,
                      backgroundColor: Colors.black.withOpacity(0.1),
                      color: AppColors.accentGreen,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "$total",
                        style: GoogleFonts.inter(
                          color: AppColors.black, // Fixed color
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "TOTAL",
                        style: GoogleFonts.inter(
                          color: AppColors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            alignment: WrapAlignment.spaceBetween,
            children: [
              _buildStat("$active", "Active"),
              _buildStat("$paused", "Paused", color: AppColors.accentOrange),
              _buildStat("$expired", "Expired", color: AppColors.accentRed),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label, {Color color = Colors.white}) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
              color: AppColors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
              color: color == Colors.white ? AppColors.black : color,
              fontSize: 12),
        ),
      ],
    );
  }
}

class UpcomingVolumeCard extends StatelessWidget {
  const UpcomingVolumeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "UPCOMING VOLUME",
                style: GoogleFonts.inter(
                  color: AppColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                "View Calendar",
                style: GoogleFonts.inter(
                  color: AppColors.accentGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 350, // Ensure min width for chart
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildBar("Mon", 400, false),
                  _buildBar("Tue", 420, false),
                  _buildBar("Wed", 480, true), // Active
                  _buildBar("Thu", 410, false),
                  _buildBar("Fri", 450, false),
                  _buildBar("Sat", 300, false),
                  _buildBar("Sun", 150, false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String day, int value, bool isActive) {
    final double maxVal = 500;
    final double height = (value / maxVal) * 100; // rough scale

    return Column(
      children: [
        Text(day,
            style: GoogleFonts.inter(color: AppColors.black, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 120, // fixed max height container
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: 40,
            height: height * 1.0, // multiplier for visual
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.accentGreen
                  : AppColors.accentGreen.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value.toString(),
          style: GoogleFonts.inter(
            color: AppColors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class PendingPaymentsCard extends StatelessWidget {
  const PendingPaymentsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate pending payments from transactions (where type is income and status is pending - assume pending if we had that status, mainly mock using income for now or just hardcode for demo purposes if transactions are all completed)
    // In DummyData transactions are all completed. Let's mock it based on dashboard stats or just show a static value derived from 'Overdue Invoices' logic if we had it.
    // Actually let's use a fixed value but derived from a hypothetical calculation for the demo feel.
    final pendingAmount = 3400.00;
    final pendingCount = 15;

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "PENDING\nPAYMENTS",
                style: GoogleFonts.inter(
                  color: AppColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentRed.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.priority_high,
                    color: AppColors.accentRed, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "\$${pendingAmount.toStringAsFixed(0)}",
            style: GoogleFonts.inter(
              color: AppColors.black,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Due from $pendingCount Customers",
            style: GoogleFonts.inter(
              color: AppColors.accentRed,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          InkWell(
            onTap: () {
              // Demo action
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Reminders sent!")));
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.send, color: Colors.black, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    "Send Reminders",
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeedbackCard extends StatelessWidget {
  const FeedbackCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avgRating = DummyData.feedbackList.isNotEmpty
        ? DummyData.feedbackList.map((f) => f.rating).reduce((a, b) => a + b) /
            DummyData.feedbackList.length
        : 0.0;

    // Complaints logic (mocked for demo as feedback list is positive in dummy data)
    final complaints = 3;

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "FEEDBACK",
                style: GoogleFonts.inter(
                  color: AppColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.accentOrange.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star,
                    color: AppColors.accentOrange, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                avgRating.toStringAsFixed(1),
                style: GoogleFonts.inter(
                  color: AppColors.black,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      if (index < avgRating.floor()) {
                        return Icon(Icons.star,
                            color: AppColors.accentOrange, size: 16);
                      } else if (index < avgRating) {
                        return Icon(Icons.star_half,
                            color: AppColors.accentOrange, size: 16);
                      } else {
                        return Icon(Icons.star_border,
                            color: AppColors.accentOrange, size: 16);
                      }
                    }),
                  ),
                  Text(
                    "Last 30 days",
                    style: GoogleFonts.inter(
                      color: AppColors.black,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.accentRed.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.thumb_down,
                      color: AppColors.accentRed, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$complaints Complaints",
                        style: GoogleFonts.inter(
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Late delivery (2), Cold food (1)",
                        style: GoogleFonts.inter(
                          color: AppColors.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
