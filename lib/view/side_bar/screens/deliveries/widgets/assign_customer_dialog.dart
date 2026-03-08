import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../controller/driver_controller.dart';
import '../../../../../../controller/subscription_controller.dart';
import '../../../../../../model/driver.dart';
import '../../../../../../model/subscription.dart';
import '../../../../../../core/theme/app_colors.dart';

class AssignCustomerDialog extends StatefulWidget {
  final Driver driver;

  const AssignCustomerDialog({super.key, required this.driver});

  @override
  State<AssignCustomerDialog> createState() => _AssignCustomerDialogState();
}

class _AssignCustomerDialogState extends State<AssignCustomerDialog> {
  final List<SubscriptionUser> _selectedCustomers = [];
  String _searchQuery = '';
  bool _isAssigning = false;
  bool _isLoadingAssignments = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final subController =
          Provider.of<SubscriptionController>(context, listen: false);
      if (subController.allSubscriptions.isEmpty && !subController.isLoading) {
        subController.fetchSubscriptions();
      }

      final driverController =
          Provider.of<DriverController>(context, listen: false);
      final assignments = await driverController.fetchDriverAssignments(
          driverId: widget.driver.id);

      if (mounted) {
        setState(() {
          _selectedCustomers.clear();
          for (var assignment in assignments) {
            if (assignment.customer != null && assignment.isActive) {
              _selectedCustomers.add(
                SubscriptionUser(
                  id: assignment.customer!.id,
                  email: assignment.customer!.email,
                  phone: assignment.customer!.phone,
                  fullName: assignment.customer!.fullName,
                  role: assignment.customer!.role,
                  isActive: assignment.customer!.isActive,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
              );
            }
          }
          _isLoadingAssignments = false;
        });
      }
    });
  }

  void _submitForm() async {
    if (_selectedCustomers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one customer'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isAssigning = true;
    });

    final controller = Provider.of<DriverController>(context, listen: false);
    bool allSuccess = true;

    for (var customer in _selectedCustomers) {
      final success = await controller.assignCustomer(
        driverId: widget.driver.id,
        customerId: customer.id,
      );
      if (!success) {
        allSuccess = false;
      }
    }

    if (mounted) {
      setState(() {
        _isAssigning = false;
      });

      if (allSuccess) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${_selectedCustomers.length} Customer(s) assigned successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                controller.errorMessage ?? 'Failed to assign some customers'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 500,
        height: 600, // Fixed height to accommodate list
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
                  'Assign Customers',
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
            const SizedBox(height: 16),

            // Search Box
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Search customers alphabetically...",
                hintStyle: GoogleFonts.inter(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.accentGreen),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),

            // List of Customers
            Expanded(
              child: _buildCustomerList(),
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_selectedCustomers.length} selected',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentGreen,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _isAssigning ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentGreen,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isAssigning
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Assign',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerList() {
    return Consumer<SubscriptionController>(
      builder: (context, subController, _) {
        if (subController.isLoading || _isLoadingAssignments) {
          return const Center(child: CircularProgressIndicator());
        }

        // Extract unique users
        final Map<String, SubscriptionUser> uniqueUsers = {};
        for (var sub in subController.allSubscriptions) {
          if (sub.user.id.isNotEmpty && !uniqueUsers.containsKey(sub.user.id)) {
            uniqueUsers[sub.user.id] = sub.user;
          }
        }

        List<SubscriptionUser> customers = uniqueUsers.values.toList();

        // Filter by search query
        if (_searchQuery.isNotEmpty) {
          customers = customers.where((c) {
            return c.fullName.toLowerCase().contains(_searchQuery) ||
                c.phone.toLowerCase().contains(_searchQuery);
          }).toList();
        }

        // Sort alphabetically always
        customers.sort((a, b) =>
            a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()));

        if (customers.isEmpty) {
          return Center(
            child: Text(
              'No customers found matching criteria.',
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
            itemCount: customers.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: Colors.grey.shade200),
            itemBuilder: (context, index) {
              final customer = customers[index];
              final isSelected =
                  _selectedCustomers.any((c) => c.id == customer.id);

              return CheckboxListTile(
                value: isSelected,
                activeColor: AppColors.accentGreen,
                onChanged: (bool? checked) {
                  setState(() {
                    if (checked == true) {
                      _selectedCustomers.add(customer);
                    } else {
                      _selectedCustomers
                          .removeWhere((c) => c.id == customer.id);
                    }
                  });
                },
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
                secondary: CircleAvatar(
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
              );
            },
          ),
        );
      },
    );
  }
}
