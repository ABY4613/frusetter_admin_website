import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class FinancialsScreen extends StatefulWidget {
  const FinancialsScreen({Key? key}) : super(key: key);

  @override
  State<FinancialsScreen> createState() => _FinancialsScreenState();
}

class _FinancialsScreenState extends State<FinancialsScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildStatsCards(),
            const SizedBox(height: 32),
            _buildFiltersAndSearch(),
            const SizedBox(height: 16),
            _buildTransactionsTable(),
            const SizedBox(height: 16),
            _buildPagination(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.download, size: 18),
          label: Text(
            'Export CSV',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Total Revenue',
            value: '\$12,450.00',
            percentage: '+5%',
            isPositive: true,
            icon: Icons.attach_money,
            iconColor: Colors.green,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildStatCard(
            title: 'Pending Amount',
            value: '\$3,200.00',
            percentage: '+2%',
            isPositive: true,
            icon: Icons.pending_actions,
            iconColor: Colors.orange,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildStatCard(
            title: 'Overdue Invoices',
            value: '15',
            percentage: '-1%',
            isPositive: false,
            icon: Icons.warning_amber,
            iconColor: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String percentage,
    required bool isPositive,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      size: 14,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      percentage,
                      style: GoogleFonts.inter(
                        color: isPositive ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
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
        ],
      ),
    );
  }

  Widget _buildFiltersAndSearch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              _buildFilterTab('All'),
              _buildFilterTab('Pending'),
              _buildFilterTab('Paid'),
              _buildFilterTab('Overdue'),
            ],
          ),
        ),
        Container(
          width: 300,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search customer name...',
              hintStyle: GoogleFonts.inter(color: AppColors.textLight),
              border: InputBorder.none,
              icon: Icon(Icons.search, color: AppColors.textLight),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTab(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
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
            if (label == 'Overdue') ...[
              const SizedBox(width: 4),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsTable() {
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
          0: FlexColumnWidth(2), // Customer Name
          1: FlexColumnWidth(1), // Amount
          2: FlexColumnWidth(1), // Due Date
          3: FlexColumnWidth(1), // Payment Mode
          4: FlexColumnWidth(1), // Status
          5: FixedColumnWidth(50), // Actions
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          _buildTableHeader(),
          _buildTableRow(
            name: 'Jane Cooper',
            id: '#INV-2023-001',
            amount: '\$450.00',
            dueDate: 'Oct 24, 2023',
            paymentMode: 'Credit Card',
            status: 'Paid',
            avatarUrl: 'https://i.pravatar.cc/150?u=1',
            paymentIcon: Icons.credit_card,
          ),
          _buildTableRow(
            name: 'Robert Fox',
            id: '#INV-2023-004',
            amount: '\$1,200.00',
            dueDate: 'Oct 20, 2023',
            paymentMode: 'Bank Transfer',
            status: 'Overdue',
            isOverdue: true,
            avatarUrl: 'https://i.pravatar.cc/150?u=2',
            paymentIcon: Icons.account_balance,
          ),
          _buildTableRow(
            name: 'Cody Fisher',
            id: '#INV-2023-008',
            amount: '\$89.00',
            dueDate: 'Oct 28, 2023',
            paymentMode: 'Apple Pay',
            status: 'Pending',
            isPending: true,
            avatarUrl: 'https://i.pravatar.cc/150?u=3',
            paymentIcon: Icons.phone_iphone,
          ),
          _buildTableRow(
            name: 'Esther Howard',
            id: '#INV-2023-012',
            amount: '\$220.00',
            dueDate: 'Oct 22, 2023',
            paymentMode: 'Credit Card',
            status: 'Paid',
            avatarUrl: 'https://i.pravatar.cc/150?u=4',
            paymentIcon: Icons.credit_card,
          ),
          _buildTableRow(
            name: 'Guy Hawkins',
            id: '#INV-2023-015',
            amount: '\$34.50',
            dueDate: 'Oct 15, 2023',
            paymentMode: 'PayPal',
            status: 'Overdue',
            isOverdue: true,
            avatarUrl: 'https://i.pravatar.cc/150?u=5',
            paymentIcon: Icons.paypal,
          ),
        ],
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      children: [
        _buildHeaderCell('CUSTOMER NAME'),
        _buildHeaderCell('AMOUNT'),
        _buildHeaderCell('DUE DATE'),
        _buildHeaderCell('PAYMENT MODE'),
        _buildHeaderCell('STATUS'),
        _buildHeaderCell('ACTIONS'),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: AppColors.textLight,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  TableRow _buildTableRow({
    required String name,
    required String id,
    required String amount,
    required String dueDate,
    required String paymentMode,
    required String status,
    required String avatarUrl,
    required IconData paymentIcon,
    bool isOverdue = false,
    bool isPending = false,
  }) {
    Color statusColor = Colors.green;
    Color statusBg = Colors.green.withOpacity(0.1);

    if (isOverdue) {
      statusColor = Colors.red;
      statusBg = Colors.red.withOpacity(0.1);
    } else if (isPending) {
      statusColor = Colors.orange;
      statusBg = Colors.orange.withOpacity(0.1);
    }

    // Checking specifically for overdue text color in the design request if needed
    // The design has red text for Overdue date sometimes, but let's stick to standard black unless specified.
    // The image shows "Oct 20, 2023" in RED for overdue row.

    return TableRow(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(avatarUrl),
                backgroundColor: Colors.grey.shade200,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.inter(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    id,
                    style: GoogleFonts.inter(
                      color: AppColors.textLight,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            amount,
            style: GoogleFonts.inter(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            dueDate,
            style: GoogleFonts.inter(
              color: isOverdue ? Colors.red : AppColors.textLight,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(paymentIcon, size: 16, color: AppColors.textLight),
              const SizedBox(width: 8),
              Text(
                paymentMode,
                style: GoogleFonts.inter(
                  color: AppColors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      status,
                      style: GoogleFonts.inter(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Icon(Icons.more_vert, color: AppColors.textLight, size: 20),
        ),
      ],
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            style: GoogleFonts.inter(color: AppColors.textLight, fontSize: 14),
            children: [
              const TextSpan(text: 'Showing '),
              TextSpan(
                text: '1-5',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold, color: AppColors.black),
              ),
              const TextSpan(text: ' of '),
              TextSpan(
                text: '48',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold, color: AppColors.black),
              ),
              const TextSpan(text: ' transactions'),
            ],
          ),
        ),
        Row(
          children: [
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
                foregroundColor: AppColors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                'Previous',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.black, // Dark button for next usually
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Next',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
