import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frusette_admin_operations_web_dashboard/core/data/dummy_data.dart';
import 'package:frusette_admin_operations_web_dashboard/model/delivery.dart';
import 'package:intl/intl.dart';

class ActiveFleetWidget extends StatelessWidget {
  const ActiveFleetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          Widget tableContent = Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Active Deliveries",
                      style: GoogleFonts.inter(
                        color: AppColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!isMobile)
                      Row(
                        children: [
                          _buildFilterButton("Status: All"),
                          const SizedBox(width: 8),
                          _buildFilterButton("Sort: Time"),
                        ],
                      ),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
              // Table Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(flex: 2, child: _buildHeaderCell("ID")),
                    Expanded(flex: 3, child: _buildHeaderCell("CUSTOMER")),
                    Expanded(flex: 3, child: _buildHeaderCell("DRIVER")),
                    Expanded(flex: 2, child: _buildHeaderCell("STATUS")),
                    Expanded(flex: 2, child: _buildHeaderCell("TIME")),
                    SizedBox(width: 40), // Spacer for action button
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
              // Rows
              ...DummyData.deliveries
                  .map((delivery) => _buildDeliveryRow(context, delivery))
                  .toList(),
            ],
          );

          if (isMobile) {
            return Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 700,
                    child: tableContent,
                  ),
                ),
              ],
            );
          }

          return tableContent;
        },
      ),
    );
  }

  Widget _buildFilterButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(text,
              style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600)),
          const SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.black),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {TextAlign align = TextAlign.left}) {
    return Text(
      text,
      textAlign: align,
      style: GoogleFonts.inter(
        color: AppColors.black.withOpacity(0.5),
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildDeliveryRow(BuildContext context, Delivery delivery) {
    return InkWell(
      onTap: () => _showDeliveryDetails(context, delivery),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            // ID
            Expanded(
              flex: 2,
              child: Text(delivery.id,
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600, color: AppColors.black)),
            ),
            // Customer
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(delivery.customerName,
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600, color: AppColors.black)),
                  Text(delivery.address,
                      style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppColors.black.withOpacity(0.5)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            // Driver
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.grey[200],
                    child: Icon(Icons.person, size: 16, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  Text(delivery.driverName,
                      style: GoogleFonts.inter(color: AppColors.black)),
                ],
              ),
            ),
            // Status
            Expanded(
              flex: 2,
              child: _buildStatusBadge(delivery.status),
            ),
            // Time
            Expanded(
              flex: 2,
              child: Text(
                DateFormat('hh:mm a').format(delivery.scheduledTime),
                style: GoogleFonts.inter(color: AppColors.black),
              ),
            ),
            // Actions
            IconButton(
              icon: Icon(Icons.more_vert,
                  size: 20, color: AppColors.black.withOpacity(0.5)),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(DeliveryStatus status) {
    Color color;
    String text;
    switch (status) {
      case DeliveryStatus.delivered:
        color = AppColors.accentGreen;
        text = 'Delivered';
        break;
      case DeliveryStatus.inProgress:
        color = AppColors.accentOrange;
        text = 'On Route';
        break;
      case DeliveryStatus.pending:
        color = Colors.blue;
        text = 'Pending';
        break;
      case DeliveryStatus.cancelled:
        color = AppColors.accentRed;
        text = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showDeliveryDetails(BuildContext context, Delivery delivery) {
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
                    'Delivery Details',
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
              _buildDetailRow("Delivery ID", delivery.id),
              _buildDetailRow("Customer", delivery.customerName),
              _buildDetailRow("Address", delivery.address),
              _buildDetailRow("Driver", delivery.driverName),
              _buildDetailRow("Scheduled Time",
                  DateFormat('MMM d, hh:mm a').format(delivery.scheduledTime)),
              const SizedBox(height: 16),
              Text(
                "Items:",
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight),
              ),
              const SizedBox(height: 8),
              ...delivery.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle,
                            size: 16, color: AppColors.accentGreen),
                        const SizedBox(width: 8),
                        Text(item,
                            style: GoogleFonts.inter(
                                fontSize: 14, color: AppColors.black)),
                      ],
                    ),
                  )),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Close',
                        style: TextStyle(color: AppColors.textLight)),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    child: Text("Track Driver (Demo)",
                        style: TextStyle(color: Colors.white)),
                  )
                ],
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
            width: 120,
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
}
