import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frusette_admin_operations_web_dashboard/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../../controller/dashboard_controller.dart';

class DashboardCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const DashboardCard({super.key, required this.child, this.padding});

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

class TodaysMealsCard extends StatelessWidget {
  const TodaysMealsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const DashboardCard(
              child: Center(child: CircularProgressIndicator()));
        }

        final mealsData = controller.dashboardData?.meals;
        final summary = mealsData?.summary;
        final trend = mealsData?.trend;
        
        final total = summary?.total ?? 0;
        final breakfast = summary?.breakfast ?? 0;
        final lunch = summary?.lunch ?? 0;
        final dinner = summary?.dinner ?? 0;

        final trendDirection = trend?.direction ?? 'up';
        final trendPercentage = trend?.percentage ?? 0.0;

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
                  if (trend != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: (trendDirection == 'up' ? AppColors.accentGreen : AppColors.accentRed).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${trendDirection == 'up' ? '+' : '-'}${trendPercentage.toStringAsFixed(1)}% vs yesterday",
                      style: GoogleFonts.inter(
                        color: trendDirection == 'up' ? AppColors.accentGreen : AppColors.accentRed,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Breakdown Label
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Breakdown",
                      style: TextStyle(color: AppColors.black, fontSize: 12)),
                  Text("Total ${summary?.total}",
                      style: TextStyle(color: AppColors.black, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Row(
                  children: [
                    if (total > 0) ...[
                      if (breakfast > 0)
                      Expanded(
                          flex: breakfast,
                          child: Container(height: 8, color: Colors.orange)),
                      if (lunch > 0)
                      Expanded(
                          flex: lunch,
                          child: Container(height: 8, color: Colors.green)),
                      if (dinner > 0)
                      Expanded(
                          flex: dinner,
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
              const SizedBox(height: 20),
              // Status Breakdown
              Text(
                "STATUS BREAKDOWN",
                style: GoogleFonts.inter(
                  color: AppColors.black.withOpacity(0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              if (mealsData != null)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildStatusChip("Scheduled", mealsData.byStatus['scheduled'] ?? 0, Colors.grey),
                    _buildStatusChip("Ready", mealsData.byStatus['ready'] ?? 0, Colors.blue),
                    _buildStatusChip("Delivered", mealsData.byStatus['delivered'] ?? 0, Colors.green),
                    _buildStatusChip("Paused", mealsData.byStatus['paused'] ?? 0, Colors.orange),
                    _buildStatusChip("Cancelled", mealsData.byStatus['cancelled'] ?? 0, Colors.red),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String label, int value, Color color) {
    if (value == 0) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$value ",
            style: GoogleFonts.inter(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              color: color,
              fontSize: 12,
            ),
          ),
        ],
      ),
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
                  text: "$label ",
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
  const DeliveryFleetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardController>(
      builder: (context, controller, child) {
        final deliveries = controller.dashboardData?.deliveries;
        final assigned = deliveries?.total ?? 0;
        final delivered = deliveries?.delivered ?? 0;
        final inTransit = deliveries?.inTransit ?? 0;
        final pickedUp = deliveries?.pickedUp ?? 0;
        final failed = deliveries?.failed ?? 0;

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
                    "$assigned ",
                    style: GoogleFonts.inter(
                      color: AppColors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Total Deliveries",
                    style: GoogleFonts.inter(
                      color: AppColors.black,
                      fontSize: 14,
                      height: 2.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildRow(Icons.check_circle, AppColors.accentGreen, "Delivered", "$delivered")),
                  const SizedBox(width: 8),
                  Expanded(child: _buildRow(Icons.local_shipping, AppColors.accentOrange, "In Transit", "$inTransit")),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildRow(Icons.shopping_bag, Colors.blue, "Picked Up", "$pickedUp")),
                  const SizedBox(width: 8),
                  Expanded(child: _buildRow(Icons.warning, AppColors.accentRed, "Failed", "$failed")),
                ],
              ),
            ],
          ),
        );
      },
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
  const SubscriptionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardController>(
      builder: (context, controller, child) {
        final subscriptions = controller.dashboardData?.subscriptions;
        final active = subscriptions?.active ?? 0;
        final paused = subscriptions?.paused ?? 0;
        final expired = subscriptions?.expired ?? 0;
        final total = subscriptions?.total ?? 0;
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
                              color: AppColors.black,
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
              const SizedBox(height: 20),
              Text(
                "PLAN BREAKDOWN",
                style: GoogleFonts.inter(
                  color: AppColors.black.withOpacity(0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              if (subscriptions != null && subscriptions.byPlan.isNotEmpty)
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: subscriptions.byPlan.length,
                    itemBuilder: (context, index) {
                      final plan = subscriptions.byPlan[index];
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${plan.count}",
                              style: GoogleFonts.inter(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              plan.planName.length > 15 ? "${plan.planName.substring(0, 12)}..." : plan.planName,
                              style: GoogleFonts.inter(
                                color: AppColors.black.withOpacity(0.7),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
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
  const UpcomingVolumeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardController>(
      builder: (context, controller, child) {
        final mealsData = controller.dashboardData?.meals;
        final graphData = mealsData?.graphLast7Days ?? [];

        // Find max total for scaling
        int maxTotal = 0;
        for (var data in graphData) {
          if (data.total > maxTotal) maxTotal = data.total;
        }
        if (maxTotal == 0) maxTotal = 100; // avoid div by zero

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
                    "Last 7 Days",
                    style: GoogleFonts.inter(
                      color: AppColors.accentGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (graphData.isEmpty)
                const Center(child: Text("No data available"))
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: graphData.map((data) {
                      final date = DateTime.parse(data.date);
                      final dayLabel = DateFormat('E').format(date);
                      final isToday = data.date == controller.dashboardData?.date;
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: _buildBar(dayLabel, data.total, isToday, maxTotal),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBar(String day, int value, bool isActive, int maxVal) {
    final double height = (value / maxVal) * 100; 

    return Column(
      children: [
        Text(day,
            style: GoogleFonts.inter(color: AppColors.black, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 120, 
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: 40,
            height: height.clamp(5, 120), 
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
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class PendingPaymentsCard extends StatelessWidget {
  const PendingPaymentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardController>(
      builder: (context, controller, child) {
        final payments = controller.dashboardData?.payments;
        final pendingAmount = payments?.pendingAmount ?? 0.0;
        final collectedToday = payments?.collectedToday ?? 0.0;
        final overdueAmount = payments?.overdueAmount ?? 0.0;
        final pendingCount = payments?.subscriptionsPending ?? 0;

        return DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "FINANCIALS",
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
                      color: AppColors.accentGreen.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.currency_rupee,
                        color: AppColors.accentGreen, size: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "₹${NumberFormat('#,##,###').format(pendingAmount)}",
                style: GoogleFonts.inter(
                  color: AppColors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Pending from $pendingCount Subscriptions",
                style: GoogleFonts.inter(
                  color: AppColors.accentRed,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              _buildFinanceRow("Collected Today", collectedToday, AppColors.accentGreen),
              const SizedBox(height: 8),
              _buildFinanceRow("Overdue Amount", overdueAmount, AppColors.accentRed),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text("Reminders functionality coming soon!")));
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.send, color: Colors.black, size: 14),
                      const SizedBox(width: 8),
                      Text(
                        "Send Reminders",
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFinanceRow(String label, double value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.black.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
        Text(
          "₹${NumberFormat('#,##,###').format(value)}",
          style: GoogleFonts.inter(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class AddonsCard extends StatelessWidget {
  const AddonsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardController>(
      builder: (context, controller, child) {
        final addons = controller.dashboardData?.addons;
        final totalToday = addons?.totalToday ?? 0;

        return DashboardCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ADD-ONS TODAY",
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
                    child: const Icon(Icons.add_shopping_cart,
                        color: AppColors.accentOrange, size: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "$totalToday",
                style: GoogleFonts.inter(
                  color: AppColors.black,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Extra items ordered today",
                style: GoogleFonts.inter(
                  color: AppColors.black.withOpacity(0.6),
                  fontSize: 14,
                ),
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
                    const Icon(Icons.info_outline, color: AppColors.accentOrange, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Track special requests and extra portions here.",
                        style: GoogleFonts.inter(
                          color: AppColors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
