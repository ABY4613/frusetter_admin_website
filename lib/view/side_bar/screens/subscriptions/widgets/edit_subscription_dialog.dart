import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../../../controller/subscription_controller.dart';
import '../../../../../../controller/meals_controller.dart';
import '../../../../../../model/subscription.dart';
import '../../../../../../model/meal_plan.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class EditSubscriptionDialog extends StatefulWidget {
  final Subscription subscription;

  const EditSubscriptionDialog({super.key, required this.subscription});

  @override
  State<EditSubscriptionDialog> createState() => _EditSubscriptionDialogState();
}

class _EditSubscriptionDialogState extends State<EditSubscriptionDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _fullNameController;
  late TextEditingController _addressController;
  late TextEditingController _amountPaidController;
  late TextEditingController _pendingAmountController;

  late DateTime _selectedDate;
  late DateTime _endDate;
  late TextEditingController _prefsController;

  // Selected plan from dropdown
  MealPlan? _selectedPlan;

  // Status dropdowns
  late String _selectedStatus;
  late String _selectedPaymentStatus;

  // Dropdown options
  final List<String> _statusOptions = [
    'active',
    'paused',
    'expired',
    'cancelled',
    'pending'
  ];
  final List<String> _paymentStatusOptions = ['pending', 'paid', 'overdue'];

  @override
  void initState() {
    super.initState();

    _amountPaidController = TextEditingController();
    _amountPaidController.addListener(_calculatePendingAmount);

    // Initialize controllers with existing subscription data
    _emailController =
        TextEditingController(text: widget.subscription.userEmail);
    _phoneController =
        TextEditingController(text: widget.subscription.user.phone);
    _passwordController =
        TextEditingController(); // Password is empty by default
    _fullNameController =
        TextEditingController(text: widget.subscription.userName);
    _addressController =
        TextEditingController(); // Address isn't in model readily
    _amountPaidController.text =
        widget.subscription.amountPaid.toStringAsFixed(2);
    _pendingAmountController = TextEditingController(
        text: widget.subscription.pendingAmount.toStringAsFixed(2));

    _selectedDate = widget.subscription.startDate;
    _endDate = widget.subscription.endDate;
    _prefsController =
        TextEditingController(text: widget.subscription.preferences ?? '[]');
    _selectedStatus = widget.subscription.status.name;

    // Normalize payment status
    final paymentStatusRaw = widget.subscription.paymentStatus.toLowerCase();
    _selectedPaymentStatus = _paymentStatusOptions.contains(paymentStatusRaw)
        ? paymentStatusRaw
        : _paymentStatusOptions.first;

    // Always default to initial proxy version of current plan so it never shows placeholder
    final subPlan = widget.subscription.plan;
    _selectedPlan = MealPlan(
      id: widget.subscription.planId.isNotEmpty
          ? widget.subscription.planId
          : subPlan.id,
      name:
          subPlan.name.isNotEmpty ? subPlan.name : widget.subscription.planName,
      description: subPlan.description,
      durationDays: subPlan.durationDays,
      mealsPerDay: subPlan.mealsPerDay,
      mealTypes: subPlan.mealTypes,
      price:
          subPlan.price > 0 ? subPlan.price : widget.subscription.totalAmount,
    );

    // Fetch plans when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MealsController>(context, listen: false)
          .fetchPlans()
          .then((_) {
        // Try to find the matching plan
        final plans =
            Provider.of<MealsController>(context, listen: false).plans;
        final matchingPlan =
            plans.where((p) => p.id == _selectedPlan?.id).toList();
        if (matchingPlan.isNotEmpty) {
          setState(() {
            _selectedPlan = matchingPlan.first;
          });
        }
      });
    });
  }

  void _calculatePendingAmount() {
    if (_selectedPlan != null) {
      final planPrice = _selectedPlan!.price;
      final amountPaid = double.tryParse(_amountPaidController.text) ?? 0.0;
      final pendingAmount = planPrice - amountPaid;
      _pendingAmountController.text = pendingAmount.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _addressController.dispose();
    _amountPaidController.removeListener(_calculatePendingAmount);
    _amountPaidController.dispose();
    _pendingAmountController.dispose();
    _prefsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 500,
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Subscription',
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

                // Full Name Field
                _buildTextField(
                  controller: _fullNameController,
                  label: 'Full Name',
                  hint: 'Enter customer full name',
                ),
                const SizedBox(height: 16),

                // Address Field
                _buildTextField(
                  controller: _addressController,
                  label: 'Address',
                  hint: 'Enter full address',
                  isRequired: false,
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                // Email Field
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'customer@example.com',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Phone Field
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone',
                  hint: '+919876543210',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                // Password Field (optional for edit)
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password (leave empty to keep current)',
                  hint: 'Enter new password',
                  isPassword: true,
                  isRequired: false,
                ),
                const SizedBox(height: 16),

                // Plan ID Dropdown
                _buildPlanDropdown(),
                const SizedBox(height: 16),

                // Start Date
                _buildDateField("Start Date", _selectedDate, (date) {
                  setState(() => _selectedDate = date);
                }),
                const SizedBox(height: 16),

                // End Date
                _buildDateField("End Date", _endDate, (date) {
                  setState(() => _endDate = date);
                }),
                const SizedBox(height: 16),

                // Amount Paid and Pending Amount
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _amountPaidController,
                        label: 'Amount Paid',
                        hint: '1000.00',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _pendingAmountController,
                        label: 'Pending Amount (Total)',
                        hint: 'Automatically calculated',
                        keyboardType: TextInputType.number,
                        readOnly: true,
                        isRequired: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Status Dropdown
                _buildStatusDropdown(),
                const SizedBox(height: 16),

                // Payment Status Dropdown
                _buildPaymentStatusDropdown(),
                const SizedBox(height: 16),

                // Preferences (JSON/Array)
                _buildTextField(
                  controller: _prefsController,
                  label: 'Preferences (e.g. ["allergy"])',
                  hint: '["peanut", "dairy"]',
                  maxLines: 3,
                  isRequired: false,
                ),

                const SizedBox(height: 32),

                // Actions
                Consumer<SubscriptionController>(
                  builder: (context, controller, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
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
                          onPressed: controller.isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentGreen,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: controller.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Update Subscription',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build the Plan dropdown using MealsController
  Widget _buildPlanDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plan',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        Consumer<MealsController>(
          builder: (context, mealsController, _) {
            if (mealsController.isLoading) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Loading plans...',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              );
            }

            final plans = mealsController.plans;

            if (plans.isEmpty) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        size: 16, color: Colors.orange.shade600),
                    const SizedBox(width: 12),
                    Text(
                      'No plans available',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }

            return DropdownButtonFormField<MealPlan>(
              value: _selectedPlan,
              decoration: InputDecoration(
                hintText: 'Select a plan',
                hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              ),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: (() {
                final Map<String, MealPlan> uniquePlans = {};
                if (_selectedPlan != null) {
                  final id =
                      _selectedPlan!.id ?? 'proxy_${_selectedPlan.hashCode}';
                  uniquePlans[id] = _selectedPlan!;
                }
                for (var plan in plans) {
                  final id = plan.id ?? 'plan_${plan.hashCode}';
                  if (!uniquePlans.containsKey(id)) {
                    uniquePlans[id] = plan;
                  }
                }
                return uniquePlans.values.map((plan) {
                  return DropdownMenuItem<MealPlan>(
                    value: plan,
                    child: Text(
                      '${plan.name} (${plan.durationDays} days - ₹${plan.price.toStringAsFixed(0)})',
                      style: GoogleFonts.inter(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList();
              })(),
              onChanged: (MealPlan? newValue) {
                setState(() {
                  _selectedPlan = newValue;
                  // Auto-fill amount with the plan price
                  if (newValue != null) {
                    _calculatePendingAmount();
                  }
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a plan';
                }
                return null;
              },
            );
          },
        ),
      ],
    );
  }

  /// Build the Status dropdown
  Widget _buildStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedStatus,
          decoration: InputDecoration(
            hintText: 'Select status',
            hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: _statusOptions.map((status) {
            return DropdownMenuItem<String>(
              value: status,
              child: Text(
                status.substring(0, 1).toUpperCase() + status.substring(1),
                style: GoogleFonts.inter(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedStatus = newValue;
              });
            }
          },
        ),
      ],
    );
  }

  /// Build the Payment Status dropdown
  Widget _buildPaymentStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Status',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedPaymentStatus,
          decoration: InputDecoration(
            hintText: 'Select payment status',
            hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          ),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: _paymentStatusOptions.map((status) {
            return DropdownMenuItem<String>(
              value: status,
              child: Text(
                status.substring(0, 1).toUpperCase() + status.substring(1),
                style: GoogleFonts.inter(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedPaymentStatus = newValue;
              });
            }
          },
        ),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final controller =
          Provider.of<SubscriptionController>(context, listen: false);

      final success = await controller.updateSubscription(
        subscriptionId: widget.subscription.id,
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim().isNotEmpty
            ? _passwordController.text.trim()
            : null,
        fullName: _fullNameController.text.trim(),
        address: _addressController.text.trim().isNotEmpty
            ? _addressController.text.trim()
            : null,
        planId: _selectedPlan?.id,
        startDate: _selectedDate,
        endDate: _endDate,
        amountPaid: double.tryParse(_amountPaidController.text) ?? 0.0,
        pendingAmount: double.tryParse(_pendingAmountController.text) ?? 0.0,
        preferences: _prefsController.text.trim(),
        status: _selectedStatus,
        paymentStatus: _selectedPaymentStatus,
      );

      if (success && mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Subscription updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                controller.errorMessage ?? 'Failed to update subscription'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool isRequired = true,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          obscureText: isPassword,
          readOnly: readOnly,
          style: GoogleFonts.inter(
              fontSize: 14,
              color: readOnly ? Colors.grey.shade700 : AppColors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          ),
          validator: (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateField(
      String label, DateTime date, Function(DateTime) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (picked != null) {
              onSelect(picked);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  DateFormat('yyyy-MM-dd').format(date),
                  style:
                      GoogleFonts.inter(fontSize: 14, color: AppColors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
