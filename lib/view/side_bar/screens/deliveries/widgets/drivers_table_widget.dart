import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../controller/driver_controller.dart';
import '../../../../../../model/driver.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_driver_dialog.dart';
import 'assign_customer_dialog.dart';
import 'view_assignments_dialog.dart';

class DriversTableWidget extends StatefulWidget {
  const DriversTableWidget({super.key});

  @override
  State<DriversTableWidget> createState() => _DriversTableWidgetState();
}

class _DriversTableWidgetState extends State<DriversTableWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DriverController>(context, listen: false).fetchDrivers();
    });
  }

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

          Widget tableContent = Consumer<DriverController>(
            builder: (context, controller, child) {
              if (controller.isLoading && controller.drivers.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(48.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.errorMessage != null &&
                  controller.drivers.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: Center(
                    child: Text(
                      controller.errorMessage!,
                      style: GoogleFonts.inter(color: Colors.red),
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Drivers List",
                          style: GoogleFonts.inter(
                            color: AppColors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: _buildHeaderCell("DRIVER")),
                        Expanded(flex: 3, child: _buildHeaderCell("EMAIL")),
                        Expanded(flex: 3, child: _buildHeaderCell("PHONE")),
                        Expanded(flex: 2, child: _buildHeaderCell("STATUS")),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
                  if (controller.drivers.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(48),
                      child: Center(
                        child: Text(
                          "No drivers found.",
                          style: GoogleFonts.inter(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...controller.drivers
                        .map((driver) => _buildDriverRow(context, driver)),
                ],
              );
            },
          );

          if (isMobile) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 700,
                child: tableContent,
              ),
            );
          }

          return tableContent;
        },
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

  Widget _buildDriverRow(BuildContext context, Driver driver) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                  child: Text(
                    driver.fullName.isNotEmpty
                        ? driver.fullName[0].toUpperCase()
                        : 'D',
                    style: GoogleFonts.inter(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    driver.fullName,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600, color: AppColors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              driver.email,
              style: GoogleFonts.inter(color: AppColors.black.withOpacity(0.7)),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              driver.phone,
              style: GoogleFonts.inter(color: AppColors.black),
            ),
          ),
          Expanded(
            flex: 2,
            child: _buildStatusBadge(driver.isActive),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert,
                size: 20, color: AppColors.black.withOpacity(0.5)),
            onSelected: (value) {
              if (value == 'edit') {
                showDialog(
                  context: context,
                  builder: (context) => EditDriverDialog(driver: driver),
                );
              } else if (value == 'assign') {
                showDialog(
                  context: context,
                  builder: (context) => AssignCustomerDialog(driver: driver),
                );
              } else if (value == 'view') {
                showDialog(
                  context: context,
                  builder: (context) => ViewAssignmentsDialog(driver: driver),
                );
              } else if (value == 'delete') {
                _confirmDelete(context, driver);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'view',
                child: Row(
                  children: [
                    const Icon(Icons.list_alt, size: 16),
                    const SizedBox(width: 8),
                    Text('View Assignments',
                        style: GoogleFonts.inter(fontSize: 14)),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'assign',
                child: Row(
                  children: [
                    const Icon(Icons.person_add, size: 16),
                    const SizedBox(width: 8),
                    Text('Assign Customer',
                        style: GoogleFonts.inter(fontSize: 14)),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(Icons.edit, size: 16),
                    const SizedBox(width: 8),
                    Text('Edit Driver', style: GoogleFonts.inter(fontSize: 14)),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete, size: 16, color: Colors.red),
                    const SizedBox(width: 8),
                    Text('Delete',
                        style:
                            GoogleFonts.inter(fontSize: 14, color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    Color color = isActive ? AppColors.accentGreen : Colors.grey;
    String text = isActive ? 'Active' : 'Inactive';

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

  void _confirmDelete(BuildContext context, Driver driver) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Driver',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete ${driver.fullName}?',
            style: GoogleFonts.inter()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context)
                  .pop(); // Close dialog first to avoid async gaps with its context

              final driverController =
                  Provider.of<DriverController>(this.context, listen: false);
              final success = await driverController.deleteDriver(driver.id);

              if (!mounted) return;

              if (success) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                      content: Text('Driver deleted successfully'),
                      backgroundColor: Colors.green),
                );
              } else {
                final error = driverController.errorMessage;
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                      content: Text(error ?? 'Failed to delete driver'),
                      backgroundColor: Colors.red),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child:
                Text('Delete', style: GoogleFonts.inter(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
