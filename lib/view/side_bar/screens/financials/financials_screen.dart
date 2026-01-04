import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frusette_admin_operations_web_dashboard/core/theme/app_colors.dart';
import 'package:frusette_admin_operations_web_dashboard/controller/payment_controller.dart';
import 'package:frusette_admin_operations_web_dashboard/model/payment.dart';
import 'package:intl/intl.dart';

class FinancialsScreen extends StatefulWidget {
  const FinancialsScreen({super.key});

  @override
  State<FinancialsScreen> createState() => _FinancialsScreenState();
}

class _FinancialsScreenState extends State<FinancialsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch payments when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentController>().fetchPayments();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Send payment reminders and show result dialog
  Future<void> _sendReminders(PaymentController controller) async {
    final result = await controller.sendReminders();

    if (!mounted) return;

    if (result != null && result.success) {
      _showReminderResultDialog(
        title: 'Reminders Sent Successfully!',
        isSuccess: true,
        remindersSent: result.data.remindersSent,
        usersNotified: result.data.usersNotified,
      );
    } else {
      _showReminderResultDialog(
        title: 'Failed to Send Reminders',
        isSuccess: false,
        errorMessage: controller.errorMessage ?? 'Unknown error occurred',
      );
    }
  }

  /// Show dialog with reminder results
  void _showReminderResultDialog({
    required String title,
    required bool isSuccess,
    int remindersSent = 0,
    List<String>? usersNotified,
    String? errorMessage,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          width: 450,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success/Error Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isSuccess
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSuccess ? Icons.check_circle : Icons.error,
                  size: 48,
                  color: isSuccess ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              if (isSuccess) ...[
                // Success Content
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_active,
                            color: Colors.orange.shade600,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '$remindersSent Reminders Sent',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                      if (usersNotified != null &&
                          usersNotified.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 12),
                        Text(
                          'Users Notified:',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          constraints: const BoxConstraints(maxHeight: 150),
                          child: SingleChildScrollView(
                            child: Column(
                              children: usersNotified
                                  .map((user) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    AppColors.primaryColor,
                                                    AppColors.primaryColor
                                                        .withOpacity(0.7),
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  user.isNotEmpty
                                                      ? user[0].toUpperCase()
                                                      : '?',
                                                  style: GoogleFonts.inter(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                user,
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  color: AppColors.black,
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ] else ...[
                // Error Content
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.red.shade400,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          errorMessage ??
                              'An error occurred while sending reminders.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 28),

              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSuccess
                        ? AppColors.primaryColor
                        : Colors.grey.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isSuccess ? 'Done' : 'Close',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Consumer<PaymentController>(
        builder: (context, controller, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 900;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(controller),
                    const SizedBox(height: 32),
                    _buildStatsCards(isMobile, controller),
                    const SizedBox(height: 32),
                    _buildFiltersAndSearch(isMobile, controller),
                    const SizedBox(height: 16),
                    if (controller.isLoading)
                      _buildLoadingState()
                    else if (controller.errorMessage != null)
                      _buildErrorState(controller)
                    else if (controller.payments.isEmpty)
                      _buildEmptyState()
                    else if (isMobile)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: 1000,
                          child: _buildTransactionsTable(controller),
                        ),
                      )
                    else
                      _buildTransactionsTable(controller),
                    const SizedBox(height: 16),
                    _buildPagination(controller),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading payments...',
              style: GoogleFonts.inter(
                color: AppColors.textLight,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(PaymentController controller) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load payments',
              style: GoogleFonts.inter(
                color: AppColors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage ?? 'Unknown error',
              style: GoogleFonts.inter(
                color: AppColors.textLight,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => controller.fetchPayments(),
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(
                'Retry',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No payments found',
              style: GoogleFonts.inter(
                color: AppColors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No payment records match your current filters',
              style: GoogleFonts.inter(
                color: AppColors.textLight,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(PaymentController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Dashboard',
                  style: GoogleFonts.inter(
                    color: AppColors.textLight,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, size: 16, color: AppColors.textLight),
                const SizedBox(width: 8),
                Text(
                  'Payments',
                  style: GoogleFonts.inter(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Payments & Billing',
              style: GoogleFonts.inter(
                color: AppColors.black,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage daily meal operations, subscriptions, and financial records.',
              style: GoogleFonts.inter(
                color: AppColors.textLight,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () => controller.refreshPayments(),
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(
                'Refresh',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.black,
                side: BorderSide(color: Colors.grey.shade300),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: controller.isSendingReminders
                  ? null
                  : () => _sendReminders(controller),
              icon: controller.isSendingReminders
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.notifications_active, size: 18),
              label: Text(
                controller.isSendingReminders ? 'Sending...' : 'Send Reminder',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade600,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.orange.shade300,
                disabledForegroundColor: Colors.white70,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement export CSV functionality
              },
              icon: const Icon(Icons.download, size: 18),
              label: Text(
                'Export CSV',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsCards(bool isMobile, PaymentController controller) {
    final summary = controller.summary;

    final cards = [
      _buildStatCard(
        title: 'Total Revenue',
        value: summary != null
            ? '₹${_formatAmount(summary.totalPaymentAmount)}'
            : '₹0',
        subtitle: '${summary?.totalSubscriptions ?? 0} subscriptions',
        icon: Icons.account_balance_wallet,
        iconColor: AppColors.primaryColor,
        gradient: [
          AppColors.primaryColor.withOpacity(0.1),
          AppColors.primaryColor.withOpacity(0.05)
        ],
      ),
      _buildStatCard(
        title: 'Pending Amount',
        value: summary != null
            ? '₹${_formatAmount(summary.pendingPaymentAmount)}'
            : '₹0',
        subtitle: '${summary?.pendingCount ?? 0} pending payments',
        icon: Icons.pending_actions,
        iconColor: Colors.orange,
        gradient: [
          Colors.orange.withOpacity(0.1),
          Colors.orange.withOpacity(0.05)
        ],
      ),
      _buildStatCard(
        title: 'Overdue Invoices',
        value: '${summary?.overdueCount ?? 0}',
        subtitle: summary != null
            ? '₹${_formatAmount(summary.overduePaymentAmount)} overdue'
            : '₹0 overdue',
        icon: Icons.warning_amber,
        iconColor: Colors.red,
        gradient: [Colors.red.withOpacity(0.1), Colors.red.withOpacity(0.05)],
      ),
    ];

    if (isMobile) {
      return Column(
        children: cards
            .map((card) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: card,
                ))
            .toList(),
      );
    }

    return Row(
      children: [
        Expanded(child: cards[0]),
        const SizedBox(width: 24),
        Expanded(child: cards[1]),
        const SizedBox(width: 24),
        Expanded(child: cards[2]),
      ],
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.inter(
              color: AppColors.textLight,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              color: AppColors.black,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              color: AppColors.textLight,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersAndSearch(bool isMobile, PaymentController controller) {
    Widget filters = Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterTab('All', controller),
            _buildFilterTab('Pending', controller),
            _buildFilterTab('Paid', controller),
            _buildFilterTab('Overdue', controller),
          ],
        ),
      ),
    );

    Widget search = Container(
      width: isMobile ? double.infinity : 300,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => controller.updateSearch(value),
        decoration: InputDecoration(
          hintText: 'Search customer name...',
          hintStyle: GoogleFonts.inter(color: AppColors.textLight),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: AppColors.textLight),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: AppColors.textLight, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    controller.updateSearch('');
                  },
                )
              : null,
        ),
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          filters,
          const SizedBox(height: 16),
          search,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        filters,
        search,
      ],
    );
  }

  Widget _buildFilterTab(String label, PaymentController controller) {
    final filterValue = label.toLowerCase();
    final isSelected = controller.statusFilter == filterValue;
    final count = controller.getStatusCount(filterValue);
    final isOverdue = label == 'Overdue';

    return GestureDetector(
      onTap: () => controller.updateStatusFilter(filterValue),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                color: isSelected ? Colors.white : AppColors.textLight,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.inter(
                  color: isSelected ? Colors.white : AppColors.textLight,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (isOverdue && count > 0) ...[
              const SizedBox(width: 6),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsTable(PaymentController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2.5), // Customer Name
          1: FlexColumnWidth(1.5), // Plan
          2: FlexColumnWidth(1.2), // Amount
          3: FlexColumnWidth(1), // Due Date
          4: FlexColumnWidth(1), // Status
          5: FlexColumnWidth(1), // Sub Status
          6: FixedColumnWidth(60), // Actions
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          _buildTableHeader(),
          ...controller.payments.map((payment) => _buildTableRow(payment)),
        ],
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        color: Colors.grey.shade50,
      ),
      children: [
        _buildHeaderCell('CUSTOMER'),
        _buildHeaderCell('PLAN'),
        _buildHeaderCell('AMOUNT'),
        _buildHeaderCell('DUE DATE'),
        _buildHeaderCell('PAYMENT'),
        _buildHeaderCell('STATUS'),
        _buildHeaderCell(''),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: AppColors.textLight,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  TableRow _buildTableRow(Payment payment) {
    final isOverdue = payment.paymentStatus == PaymentStatus.overdue;
    final isPending = payment.paymentStatus == PaymentStatus.pending;
    final isPaid = payment.paymentStatus == PaymentStatus.paid;

    Color statusColor;
    Color statusBg;

    if (isOverdue) {
      statusColor = Colors.red;
      statusBg = Colors.red.withOpacity(0.1);
    } else if (isPaid) {
      statusColor = Colors.green;
      statusBg = Colors.green.withOpacity(0.1);
    } else if (isPending) {
      statusColor = Colors.orange;
      statusBg = Colors.orange.withOpacity(0.1);
    } else {
      statusColor = Colors.grey;
      statusBg = Colors.grey.withOpacity(0.1);
    }

    // Subscription status colors
    Color subStatusColor;
    Color subStatusBg;

    switch (payment.status) {
      case SubscriptionPaymentStatus.active:
        subStatusColor = Colors.green;
        subStatusBg = Colors.green.withOpacity(0.1);
        break;
      case SubscriptionPaymentStatus.paused:
        subStatusColor = Colors.blue;
        subStatusBg = Colors.blue.withOpacity(0.1);
        break;
      case SubscriptionPaymentStatus.cancelled:
        subStatusColor = Colors.red;
        subStatusBg = Colors.red.withOpacity(0.1);
        break;
      case SubscriptionPaymentStatus.expired:
        subStatusColor = Colors.grey;
        subStatusBg = Colors.grey.withOpacity(0.1);
        break;
      case SubscriptionPaymentStatus.pending:
        subStatusColor = Colors.orange;
        subStatusBg = Colors.orange.withOpacity(0.1);
        break;
    }

    return TableRow(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      children: [
        // Customer Name Cell
        InkWell(
          onTap: () => _showPaymentDetails(payment),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryColor,
                        AppColors.primaryColor.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      payment.customerName.isNotEmpty
                          ? payment.customerName[0].toUpperCase()
                          : '?',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment.customerName.isNotEmpty
                            ? payment.customerName
                            : 'Unknown Customer',
                        style: GoogleFonts.inter(
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        payment.customerEmail,
                        style: GoogleFonts.inter(
                          color: AppColors.textLight,
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
        ),
        // Plan Cell
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              payment.planName.isNotEmpty ? payment.planName : 'N/A',
              style: GoogleFonts.inter(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        // Amount Cell
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '₹${payment.balanceAmount.toStringAsFixed(0)}',
                style: GoogleFonts.inter(
                  color: isOverdue ? Colors.red : AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              if (payment.amountPaid > 0)
                Text(
                  'Paid: ₹${payment.amountPaid.toStringAsFixed(0)}',
                  style: GoogleFonts.inter(
                    color: Colors.green,
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ),
        // Due Date Cell
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMM d, yyyy').format(payment.endDate),
                style: GoogleFonts.inter(
                  color: isOverdue ? Colors.red : AppColors.textLight,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              if (payment.daysOverdue > 0)
                Text(
                  '${payment.daysOverdue} days overdue',
                  style: GoogleFonts.inter(
                    color: Colors.red,
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ),
        // Payment Status Cell
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  payment.paymentStatusLabel,
                  style: GoogleFonts.inter(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Subscription Status Cell
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: subStatusBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: subStatusColor.withOpacity(0.2)),
            ),
            child: Text(
              payment.subscriptionStatusLabel,
              style: GoogleFonts.inter(
                color: subStatusColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Actions Cell
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: AppColors.textLight, size: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            onSelected: (value) {
              switch (value) {
                case 'view':
                  _showPaymentDetails(payment);
                  break;
                case 'mark_paid':
                  // TODO: Implement mark as paid
                  break;
                case 'send_reminder':
                  // TODO: Implement send reminder
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'view',
                child: Row(
                  children: [
                    Icon(Icons.visibility_outlined,
                        size: 18, color: AppColors.textLight),
                    const SizedBox(width: 12),
                    Text('View Details',
                        style: GoogleFonts.inter(fontSize: 14)),
                  ],
                ),
              ),
              if (payment.paymentStatus != PaymentStatus.paid)
                PopupMenuItem(
                  value: 'mark_paid',
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          size: 18, color: Colors.green),
                      const SizedBox(width: 12),
                      Text('Mark as Paid',
                          style: GoogleFonts.inter(fontSize: 14)),
                    ],
                  ),
                ),
              if (payment.paymentStatus == PaymentStatus.overdue)
                PopupMenuItem(
                  value: 'send_reminder',
                  child: Row(
                    children: [
                      Icon(Icons.notifications_outlined,
                          size: 18, color: Colors.orange),
                      const SizedBox(width: 12),
                      Text('Send Reminder',
                          style: GoogleFonts.inter(fontSize: 14)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _showPaymentDetails(Payment payment) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: 550,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.receipt_long,
                            color: AppColors.primaryColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Payment Details',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Customer Info Section
                _buildSectionHeader('Customer Information'),
                const SizedBox(height: 12),
                _buildDetailRow(
                    'Name',
                    payment.customerName.isNotEmpty
                        ? payment.customerName
                        : 'Unknown'),
                _buildDetailRow('Email', payment.customerEmail),
                _buildDetailRow('Phone', payment.user.phone),

                const SizedBox(height: 24),
                Divider(color: Colors.grey.shade200),
                const SizedBox(height: 24),

                // Plan Info Section
                _buildSectionHeader('Plan Information'),
                const SizedBox(height: 12),
                _buildDetailRow('Plan Name', payment.planName),
                _buildDetailRow(
                    'Duration', '${payment.plan.durationDays} days'),
                _buildDetailRow(
                    'Meals Per Day', '${payment.plan.mealsPerDay} meals'),
                _buildDetailRow('Meal Types', payment.plan.mealTypesFormatted),

                const SizedBox(height: 24),
                Divider(color: Colors.grey.shade200),
                const SizedBox(height: 24),

                // Payment Info Section
                _buildSectionHeader('Payment Information'),
                const SizedBox(height: 12),
                _buildDetailRow('Total Amount',
                    '₹${payment.totalAmount.toStringAsFixed(2)}'),
                _buildDetailRow(
                    'Amount Paid', '₹${payment.amountPaid.toStringAsFixed(2)}'),
                _buildDetailRow('Balance Due',
                    '₹${payment.balanceAmount.toStringAsFixed(2)}',
                    valueColor:
                        payment.balanceAmount > 0 ? Colors.red : Colors.green),
                _buildDetailRow('Payment Status', payment.paymentStatusLabel),
                _buildDetailRow(
                    'Subscription Status', payment.subscriptionStatusLabel),
                if (payment.daysOverdue > 0)
                  _buildDetailRow('Days Overdue', '${payment.daysOverdue} days',
                      valueColor: Colors.red),

                const SizedBox(height: 24),
                Divider(color: Colors.grey.shade200),
                const SizedBox(height: 24),

                // Dates Section
                _buildSectionHeader('Subscription Period'),
                const SizedBox(height: 12),
                _buildDetailRow('Start Date',
                    DateFormat('MMM d, yyyy').format(payment.startDate)),
                _buildDetailRow('End Date',
                    DateFormat('MMM d, yyyy').format(payment.endDate)),
                _buildDetailRow('Created At',
                    DateFormat('MMM d, yyyy h:mm a').format(payment.createdAt)),

                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textLight,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: Text('Close',
                          style:
                              GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 12),
                    if (payment.paymentStatus != PaymentStatus.paid)
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement mark as paid
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text('Mark as Paid',
                            style:
                                GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        color: AppColors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                color: valueColor ?? AppColors.black,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(PaymentController controller) {
    final pagination = controller.pagination;
    if (pagination == null) return const SizedBox.shrink();

    final startIndex = (controller.currentPage - 1) * controller.limit + 1;
    final endIndex = (startIndex + controller.payments.length - 1)
        .clamp(0, pagination.total);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            style: GoogleFonts.inter(color: AppColors.textLight, fontSize: 14),
            children: [
              const TextSpan(text: 'Showing '),
              TextSpan(
                text:
                    controller.payments.isEmpty ? '0' : '$startIndex-$endIndex',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold, color: AppColors.black),
              ),
              const TextSpan(text: ' of '),
              TextSpan(
                text: '${pagination.total}',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold, color: AppColors.black),
              ),
              const TextSpan(text: ' payments'),
            ],
          ),
        ),
        Row(
          children: [
            // Page numbers
            if (pagination.totalPages > 1)
              Row(
                children: List.generate(
                  pagination.totalPages > 5 ? 5 : pagination.totalPages,
                  (index) {
                    int pageNum;
                    if (pagination.totalPages <= 5) {
                      pageNum = index + 1;
                    } else {
                      // Smart page number display
                      if (controller.currentPage <= 3) {
                        pageNum = index + 1;
                      } else if (controller.currentPage >=
                          pagination.totalPages - 2) {
                        pageNum = pagination.totalPages - 4 + index;
                      } else {
                        pageNum = controller.currentPage - 2 + index;
                      }
                    }

                    final isCurrentPage = pageNum == controller.currentPage;

                    return GestureDetector(
                      onTap: () => controller.goToPage(pageNum),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isCurrentPage
                              ? AppColors.primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isCurrentPage
                                ? AppColors.primaryColor
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          '$pageNum',
                          style: GoogleFonts.inter(
                            color:
                                isCurrentPage ? Colors.white : AppColors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(width: 16),
            OutlinedButton(
              onPressed: controller.currentPage > 1
                  ? () => controller.previousPage()
                  : null,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
                foregroundColor: AppColors.black,
                disabledForegroundColor: Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Row(
                children: [
                  Icon(Icons.chevron_left, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    'Previous',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: controller.currentPage < pagination.totalPages
                  ? () => controller.nextPage()
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Row(
                children: [
                  Text(
                    'Next',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 18),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
