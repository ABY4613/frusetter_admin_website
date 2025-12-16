import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frusette_admin_operations_web_dashboard/core/data/dummy_data.dart';
import 'package:frusette_admin_operations_web_dashboard/model/subscription.dart';
import 'package:intl/intl.dart';

class SubscriptionTable extends StatelessWidget {
  const SubscriptionTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          )),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 800;

          Widget tableContent = Column(
            children: [
              // Table Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
                ),
                child: Row(
                  children: [
                    _buildHeaderCell("CUSTOMER NAME", flex: 3),
                    _buildHeaderCell("STATUS", flex: 2),
                    _buildHeaderCell("PLAN TYPE", flex: 3),
                    _buildHeaderCell("DURATION", flex: 2),
                    _buildHeaderCell("ACTIONS",
                        flex: 1, align: TextAlign.right),
                  ],
                ),
              ),
              // Table Rows
              ...DummyData.subscriptions
                  .map((sub) => _buildRow(context, sub))
                  .toList(),
            ],
          );

          if (isMobile) {
            return Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 800, // Min width for table
                    child: tableContent,
                  ),
                ),
                _buildPagination(),
              ],
            );
          }

          return Column(
            children: [
              tableContent,
              _buildPagination(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderCell(String text,
      {int flex = 1, TextAlign align = TextAlign.left}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: GoogleFonts.inter(
          color: AppColors.black.withOpacity(0.5),
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, Subscription sub) {
    Color statusColor;
    switch (sub.status) {
      case SubscriptionStatus.active:
        statusColor = AppColors.accentGreen;
        break;
      case SubscriptionStatus.paused:
        statusColor = AppColors.accentOrange;
        break;
      case SubscriptionStatus.expired:
        statusColor = Color(0xFF4B5563);
        break;
      case SubscriptionStatus.cancelled:
        statusColor = AppColors.accentRed;
        break;
    }

    return InkWell(
      onTap: () => _showSubscriptionDetails(context, sub),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
        ),
        child: Row(
          children: [
            // Customer
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[200],
                    child: Icon(Icons.person, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sub.userName,
                        style: GoogleFonts.inter(
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        sub.userEmail,
                        style: GoogleFonts.inter(
                          color: AppColors.black.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Status
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 6, color: statusColor),
                        const SizedBox(width: 8),
                        Text(
                          sub.status.name.toUpperCase(),
                          style: GoogleFonts.inter(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Plan
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sub.planName,
                    style: GoogleFonts.inter(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    sub.mealFrequency,
                    style: GoogleFonts.inter(
                      color: AppColors.black.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Duration
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('MMM d, yyyy').format(sub.startDate),
                    style: GoogleFonts.inter(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "to ${DateFormat('MMM d, yyyy').format(sub.endDate)}",
                    style: GoogleFonts.inter(
                      color: AppColors.black.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Actions
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.more_vert,
                      color: AppColors.black.withOpacity(0.5)),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubscriptionDetails(BuildContext context, Subscription sub) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subscription Details',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDetailRow("Subscriber", sub.userName),
              _buildDetailRow("Email", sub.userEmail),
              _buildDetailRow("Plan", sub.planName),
              _buildDetailRow("Frequency", sub.mealFrequency),
              _buildDetailRow("Status", sub.status.name.toUpperCase()),
              _buildDetailRow("Start Date",
                  DateFormat('MMM d, yyyy').format(sub.startDate)),
              _buildDetailRow(
                  "End Date", DateFormat('MMM d, yyyy').format(sub.endDate)),
              _buildDetailRow("Remaining Meals",
                  "${sub.remainingCredit} / ${sub.totalCredit}"),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close',
                      style: TextStyle(color: AppColors.textLight)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: AppColors.textLight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Showing 1-${DummyData.subscriptions.length} of ${DummyData.subscriptions.length} subscriptions",
            style: GoogleFonts.inter(
              color: AppColors.black.withOpacity(0.5),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.chevron_left,
                    color: AppColors.black.withOpacity(0.5)),
              ),
              _buildPageButton("1", true),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.chevron_right,
                    color: AppColors.black.withOpacity(0.5)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPageButton(String text, bool isActive) {
    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.accentGreen : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.inter(
            color:
                isActive ? AppColors.black : AppColors.black.withOpacity(0.6),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
