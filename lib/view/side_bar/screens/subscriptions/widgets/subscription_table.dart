import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frusette_admin_operations_web_dashboard/model/subscription.dart';
import 'package:frusette_admin_operations_web_dashboard/controller/subscription_controller.dart';
import 'package:intl/intl.dart';

class SubscriptionTable extends StatelessWidget {
  const SubscriptionTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionController>(
      builder: (context, controller, _) {
        return Container(
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              )),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 800;

              // Show loading indicator
              if (controller.isLoading && controller.subscriptions.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(48.0),
                    child: CircularProgressIndicator(
                      color: AppColors.accentGreen,
                    ),
                  ),
                );
              }

              // Show error message
              if (controller.errorMessage != null &&
                  controller.subscriptions.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline,
                            size: 48, color: Colors.red.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load subscriptions',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.errorMessage!,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textLight,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => controller.fetchSubscriptions(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentGreen,
                          ),
                          child: Text(
                            'Retry',
                            style: GoogleFonts.inter(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Show empty state
              if (controller.subscriptions.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inbox_outlined,
                            size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          'No subscriptions found',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create a new subscription to get started',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              Widget tableContent = Column(
                children: [
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Colors.grey.withOpacity(0.1))),
                    ),
                    child: Row(
                      children: [
                        _buildHeaderCell("CUSTOMER NAME", flex: 3),
                        _buildHeaderCell("STATUS", flex: 2),
                        _buildHeaderCell("PLAN TYPE", flex: 3),
                        _buildHeaderCell("DURATION", flex: 2),
                        _buildHeaderCell("AMOUNT", flex: 2),
                        _buildHeaderCell("ACTIONS",
                            flex: 1, align: TextAlign.right),
                      ],
                    ),
                  ),
                  // Table Rows with loading overlay
                  Stack(
                    children: [
                      Column(
                        children: controller.subscriptions
                            .map((sub) => _buildRow(context, sub))
                            .toList(),
                      ),
                      if (controller.isLoading)
                        Positioned.fill(
                          child: Container(
                            color: Colors.white.withOpacity(0.7),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.accentGreen,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              );

              if (isMobile) {
                return Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: 900, // Min width for table
                        child: tableContent,
                      ),
                    ),
                    _buildPagination(controller),
                  ],
                );
              }

              return Column(
                children: [
                  tableContent,
                  _buildPagination(controller),
                ],
              );
            },
          ),
        );
      },
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
        statusColor = const Color(0xFF4B5563);
        break;
      case SubscriptionStatus.cancelled:
        statusColor = AppColors.accentRed;
        break;
      case SubscriptionStatus.pending:
        statusColor = Colors.blue;
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
                    backgroundColor: AppColors.accentGreen.withOpacity(0.1),
                    child: Text(
                      sub.userName.isNotEmpty
                          ? sub.userName[0].toUpperCase()
                          : '?',
                      style: GoogleFonts.inter(
                        color: AppColors.accentGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sub.userName,
                          style: GoogleFonts.inter(
                            color: AppColors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          sub.userEmail,
                          style: GoogleFonts.inter(
                            color: AppColors.black.withOpacity(0.5),
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
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
                    overflow: TextOverflow.ellipsis,
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
            // Amount
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹${sub.totalAmount.toStringAsFixed(0)}',
                    style: GoogleFonts.inter(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    sub.paymentStatus.toUpperCase(),
                    style: GoogleFonts.inter(
                      color: sub.paymentStatus == 'paid'
                          ? AppColors.accentGreen
                          : AppColors.accentOrange,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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
                child: PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert,
                      color: AppColors.black.withOpacity(0.5)),
                  onSelected: (value) {
                    // Handle menu actions
                    switch (value) {
                      case 'view':
                        _showSubscriptionDetails(context, sub);
                        break;
                      case 'edit':
                        // TODO: Implement edit
                        break;
                      case 'pause':
                        // TODO: Implement pause
                        break;
                      case 'cancel':
                        // TODO: Implement cancel
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'view',
                      child: Row(
                        children: [
                          const Icon(Icons.visibility_outlined, size: 18),
                          const SizedBox(width: 8),
                          Text('View Details',
                              style: GoogleFonts.inter(fontSize: 14)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit_outlined, size: 18),
                          const SizedBox(width: 8),
                          Text('Edit', style: GoogleFonts.inter(fontSize: 14)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'pause',
                      child: Row(
                        children: [
                          const Icon(Icons.pause_circle_outline, size: 18),
                          const SizedBox(width: 8),
                          Text('Pause', style: GoogleFonts.inter(fontSize: 14)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'cancel',
                      child: Row(
                        children: [
                          Icon(Icons.cancel_outlined,
                              size: 18, color: Colors.red.shade400),
                          const SizedBox(width: 8),
                          Text('Cancel',
                              style: GoogleFonts.inter(
                                  fontSize: 14, color: Colors.red.shade400)),
                        ],
                      ),
                    ),
                  ],
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
          width: 550,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
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

                // Customer Section
                _buildSectionTitle('Customer Information'),
                _buildDetailRow("Name", sub.userName),
                _buildDetailRow("Email", sub.userEmail),
                _buildDetailRow("Phone", sub.user.phone),
                _buildDetailRow("Role", sub.user.role.toUpperCase()),

                const SizedBox(height: 16),

                // Plan Section
                _buildSectionTitle('Plan Information'),
                _buildDetailRow("Plan Name", sub.planName),
                _buildDetailRow("Description", sub.plan.description),
                _buildDetailRow("Duration", "${sub.plan.durationDays} days"),
                _buildDetailRow("Meals Per Day", "${sub.plan.mealsPerDay}"),
                _buildDetailRow("Meal Types", sub.plan.mealTypesFormatted),

                const SizedBox(height: 16),

                // Subscription Section
                _buildSectionTitle('Subscription Details'),
                _buildDetailRow("Status", sub.status.name.toUpperCase()),
                _buildDetailRow(
                    "Payment Status", sub.paymentStatus.toUpperCase()),
                _buildDetailRow(
                    "Total Amount", "₹${sub.totalAmount.toStringAsFixed(0)}"),
                _buildDetailRow(
                    "Amount Paid", "₹${sub.amountPaid.toStringAsFixed(0)}"),
                _buildDetailRow("Start Date",
                    DateFormat('MMM d, yyyy').format(sub.startDate)),
                _buildDetailRow(
                    "End Date", DateFormat('MMM d, yyyy').format(sub.endDate)),
                _buildDetailRow("Paused Days", "${sub.pausedDays} days"),
                _buildDetailRow("Created",
                    DateFormat('MMM d, yyyy HH:mm').format(sub.createdAt)),

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
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.accentGreen,
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

  Widget _buildPagination(SubscriptionController controller) {
    final pagination = controller.pagination;
    final total = pagination?.total ?? 0;
    final currentPage = controller.currentPage;
    final totalPages = pagination?.totalPages ?? 1;
    final limit = controller.limit;

    final startItem = total > 0 ? ((currentPage - 1) * limit) + 1 : 0;
    final endItem =
        (currentPage * limit) > total ? total : (currentPage * limit);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Showing $startItem-$endItem of $total subscriptions",
            style: GoogleFonts.inter(
              color: AppColors.black.withOpacity(0.5),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed:
                    currentPage > 1 ? () => controller.previousPage() : null,
                icon: Icon(Icons.chevron_left,
                    color: currentPage > 1
                        ? AppColors.black.withOpacity(0.5)
                        : AppColors.black.withOpacity(0.2)),
              ),
              // Page numbers
              ...List.generate(
                totalPages > 5 ? 5 : totalPages,
                (index) {
                  int pageNum;
                  if (totalPages <= 5) {
                    pageNum = index + 1;
                  } else if (currentPage <= 3) {
                    pageNum = index + 1;
                  } else if (currentPage >= totalPages - 2) {
                    pageNum = totalPages - 4 + index;
                  } else {
                    pageNum = currentPage - 2 + index;
                  }
                  return _buildPageButton(
                    pageNum.toString(),
                    pageNum == currentPage,
                    () => controller.goToPage(pageNum),
                  );
                },
              ),
              IconButton(
                onPressed: currentPage < totalPages
                    ? () => controller.nextPage()
                    : null,
                icon: Icon(Icons.chevron_right,
                    color: currentPage < totalPages
                        ? AppColors.black.withOpacity(0.5)
                        : AppColors.black.withOpacity(0.2)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPageButton(String text, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
              color: isActive ? Colors.white : AppColors.black.withOpacity(0.6),
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
