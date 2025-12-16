import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

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
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                _buildHeaderCell("ACTIONS", flex: 1, align: TextAlign.right),
              ],
            ),
          ),
          // Table Rows
          _buildRow(
            name: "Jane Doe",
            email: "jane.doe@example.com",
            status: "Active",
            statusColor: AppColors.accentGreen,
            plan: "Keto Lunch Plan",
            frequency: "5 meals/week",
            startDate: "Oct 12, 2023",
            endDate: "Nov 12, 2023",
          ),
          _buildRow(
            name: "John Smith",
            email: "john.smith@example.com",
            status: "Paused",
            statusColor: AppColors.accentOrange,
            plan: "Vegan Dinner Plan",
            frequency: "3 meals/week",
            startDate: "Sep 01, 2023",
            endDate: "Oct 01, 2023",
          ),
          _buildRow(
            name: "Alice Brown",
            email: "alice.brown@example.com",
            status: "Expired",
            statusColor: Color(0xFF4B5563), // Greyish blue for expired
            plan: "Balanced Meal Plan",
            frequency: "7 meals/week",
            startDate: "Aug 15, 2023",
            endDate: "Sep 15, 2023",
          ),
          _buildRow(
            name: "Robert Fox",
            email: "robert.fox@example.com",
            status: "Active",
            statusColor: AppColors.accentGreen,
            plan: "Paleo Lunch Plan",
            frequency: "5 meals/week",
            startDate: "Oct 20, 2023",
            endDate: "Nov 20, 2023",
          ),
          _buildRow(
            name: "Emily White",
            email: "emily.white@example.com",
            status: "Active",
            statusColor: AppColors.accentGreen,
            plan: "Vegetarian Plan",
            frequency: "7 meals/week",
            startDate: "Oct 22, 2023",
            endDate: "Nov 22, 2023",
          ),
          // Pagination
          _buildPagination(),
        ],
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

  Widget _buildRow({
    required String name,
    required String email,
    required String status,
    required Color statusColor,
    required String plan,
    required String frequency,
    required String startDate,
    required String endDate,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
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
                  backgroundImage: const AssetImage(
                      'assets/images/image.png'), // Using placeholder
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.inter(
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      email,
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
                        status,
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
                  plan,
                  style: GoogleFonts.inter(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  frequency,
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
                  startDate,
                  style: GoogleFonts.inter(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "to $endDate",
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
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Showing 1-5 of 48 subscriptions",
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
              _buildPageButton("2", false),
              _buildPageButton("3", false),
              Text("...",
                  style: TextStyle(color: AppColors.black.withOpacity(0.5))),
              _buildPageButton("8", false),
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
