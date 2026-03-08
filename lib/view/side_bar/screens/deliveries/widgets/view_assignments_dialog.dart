import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../controller/driver_controller.dart';
import '../../../../../../model/driver.dart';
import '../../../../../../model/driver_assignment.dart';
import '../../../../../../core/theme/app_colors.dart';

class ViewAssignmentsDialog extends StatefulWidget {
  final Driver driver;

  const ViewAssignmentsDialog({super.key, required this.driver});

  @override
  State<ViewAssignmentsDialog> createState() => _ViewAssignmentsDialogState();
}

class _ViewAssignmentsDialogState extends State<ViewAssignmentsDialog> {
  bool _isLoading = true;
  List<DriverAssignment> _assignments = [];

  @override
  void initState() {
    super.initState();
    _fetchAssignments();
  }

  Future<void> _fetchAssignments() async {
    setState(() => _isLoading = true);
    final controller = Provider.of<DriverController>(context, listen: false);
    final results =
        await controller.fetchDriverAssignments(driverId: widget.driver.id);
    if (mounted) {
      setState(() {
        _assignments = results;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 500,
        height: 600,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Assigned Customers',
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
            const SizedBox(height: 16),
            Text(
              "Driver: ${widget.driver.fullName}",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_assignments.isEmpty) {
      return Center(
        child: Text(
          'No customers assigned to this driver.',
          style: GoogleFonts.inter(color: Colors.grey),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.separated(
        itemCount: _assignments.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1, color: Colors.grey.shade200),
        itemBuilder: (context, index) {
          final assignment = _assignments[index];
          final customer = assignment.customer;

          if (customer == null) {
            return const SizedBox();
          }

          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryColor.withOpacity(0.1),
              child: Text(
                customer.fullName.isNotEmpty
                    ? customer.fullName[0].toUpperCase()
                    : 'C',
                style: GoogleFonts.inter(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              customer.fullName,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
            subtitle: Text(
              customer.phone,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: assignment.isActive
                    ? AppColors.accentGreen.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                assignment.isActive ? 'Active' : 'Inactive',
                style: GoogleFonts.inter(
                  color:
                      assignment.isActive ? AppColors.accentGreen : Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
