import 'package:flutter/material.dart';
import 'package:frusette_admin_operations_web_dashboard/widgets/frusette_loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../controller/meals_controller.dart';
import '../../../../model/meal_plan.dart';

class MealsPlanningScreen extends StatefulWidget {
  const MealsPlanningScreen({Key? key}) : super(key: key);

  @override
  State<MealsPlanningScreen> createState() => _MealsPlanningScreenState();
}

class _MealsPlanningScreenState extends State<MealsPlanningScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealsController>().fetchPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Changed from Dark to White
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildFilters(),
                const SizedBox(height: 32),
                _buildPlanCards(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Breadcrumbs
        Row(
          children: [
            Text(
              'Dashboard',
              style: GoogleFonts.inter(
                color: const Color(0xFF6B7280), // Grey 500
                fontSize: 14,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child:
                  Icon(Icons.chevron_right, size: 16, color: Color(0xFF6B7280)),
            ),
            Text(
              'Meals Planning',
              style: GoogleFonts.inter(
                color: Colors.black, // Active text black
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Title and Actions Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Meals Planning',
              style: GoogleFonts.inter(
                color: Colors.black, // Title black
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const CreatePlanDialog(),
                    );
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(
                    'New Plan',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8AC53D), // Brand Green
                    foregroundColor: Colors.black, // Text Black
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Organize weekly menus and manage recipe inventory.',
          style: GoogleFonts.inter(
            color: const Color(0xFF6B7280), // Subtitle grey
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  // State for filters
  String _selectedSort = 'Recommended';
  String _selectedDuration = 'All Durations';
  final List<String> _selectedPreferences = [];

  Widget _buildFilters() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _buildFilterDropdown(
          label:
              _selectedSort == 'Recommended' ? 'Sort by Price' : _selectedSort,
          options: ['Recommended', 'Low to High', 'High to Low'],
          selected: _selectedSort,
          onSelected: (val) {
            setState(() {
              _selectedSort = val;
              // Add sorting logic here if needed
            });
          },
        ),
        _buildFilterDropdown(
          label: _selectedDuration == 'All Durations'
              ? 'Sort by Duration'
              : _selectedDuration,
          options: ['All Durations', '1 Week', '2 Weeks', '4 Weeks'],
          selected: _selectedDuration,
          onSelected: (val) {
            setState(() {
              _selectedDuration = val;
              // Add duration filtering logic here
            });
          },
        ),
        _buildMultiSelectDropdown(
          label: 'Dietary Preferences',
          options: [
            'Vegetarian',
            'Vegan',
            'Keto',
            'Paleo',
            'Gluten Free',
            'Dairy Free'
          ],
          selected: _selectedPreferences,
          onChanged: (val) {
            setState(() {
              if (_selectedPreferences.contains(val)) {
                _selectedPreferences.remove(val);
              } else {
                _selectedPreferences.add(val);
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required List<String> options,
    required String selected,
    required Function(String) onSelected,
  }) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) {
        return options.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(
              choice,
              style: GoogleFonts.inter(
                color: Colors.black,
                fontWeight:
                    selected == choice ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList();
      },
      offset: const Offset(0, 40),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.grey.shade600,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiSelectDropdown({
    required String label,
    required List<String> options,
    required List<String> selected,
    required Function(String) onChanged,
  }) {
    return PopupMenuButton<String>(
      // We manually handle interactions, so we might keep the menu open or just toggle
      // Since standard PopupMenu closes on selection, we'll reopen or just select one by one.
      // For proper multi-select UX inside a popup, we usually need a custom dialog or keep-alive menu.
      // For this simplified version, we will toggle and close (standard simple behavior).
      onSelected: onChanged,
      itemBuilder: (BuildContext context) {
        return options.map((String choice) {
          final isSelected = selected.contains(choice);
          return PopupMenuItem<String>(
            value: choice,
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                  color: isSelected
                      ? const Color(0xFF8AC53D)
                      : Colors.grey.shade400,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  choice,
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
      offset: const Offset(0, 40),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selected.isEmpty ? label : '${selected.length} Selected',
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.filter_list,
              color: Colors.grey.shade600,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCards() {
    return Consumer<MealsController>(
      builder: (context, controller, _) {
        if (controller.isLoading) {
          return const Center(child: FrusetteLoader());
        }

        if (controller.plans.isEmpty) {
          return Center(
            child: Text(
              'No plans found',
              style: GoogleFonts.inter(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        var displayedPlans = List<MealPlan>.from(controller.plans);

        // 1. Filter by Duration
        if (_selectedDuration != 'All Durations') {
          displayedPlans = displayedPlans.where((plan) {
            if (_selectedDuration == '1 Week') return plan.durationDays == 7;
            if (_selectedDuration == '2 Weeks') return plan.durationDays == 14;
            if (_selectedDuration == '4 Weeks')
              return plan.durationDays >= 28 && plan.durationDays <= 31;
            return true;
          }).toList();
        }

        // 2. Filter by Dietary Preferences (Search in Name/Description as they are not separate fields yet)
        if (_selectedPreferences.isNotEmpty) {
          displayedPlans = displayedPlans.where((plan) {
            // Check if ANY of the selected preferences are found in name/desc
            final searchText = '${plan.name} ${plan.description}'.toLowerCase();
            for (final pref in _selectedPreferences) {
              if (searchText.contains(pref.toLowerCase())) return true;
            }
            return false;
          }).toList();
        }

        // 3. Sort
        if (_selectedSort == 'Low to High') {
          displayedPlans.sort((a, b) => a.price.compareTo(b.price));
        } else if (_selectedSort == 'High to Low') {
          displayedPlans.sort((a, b) => b.price.compareTo(a.price));
        }

        if (displayedPlans.isEmpty) {
          return Center(
            child: Text(
              'No plans match your filters.',
              style: GoogleFonts.inter(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        return Column(
          children: displayedPlans.map((plan) => _buildCard(plan)).toList(),
        );
      },
    );
  }

  Widget _buildCard(MealPlan plan) {
    // Generate some display logic since API doesn't have all UI fields
    final isPopular = plan.price > 6000; // Heuristic example
    final imageUrl = plan.name.toLowerCase().contains('veg')
        ? 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&q=80&w=800'
        : 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&q=80&w=800';

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white, // Card background white
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200), // Light grey border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isPopular)
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8AC53D)
                          .withOpacity(0.2), // Light Green bg
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'MOST POPULAR',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF65902D), // Darker Green text
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  plan.name,
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  plan.description,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF6B7280), // Description grey
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        color: const Color(0xFF9CA3AF), size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '${plan.durationDays} Days',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF4B5563), // Darker grey
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Icon(Icons.restaurant_menu,
                        color: const Color(0xFF9CA3AF), size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '${plan.mealsPerDay} Meals/Day',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF4B5563),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '\$${plan.price.toStringAsFixed(2)}',
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // if (plan['billing'] != '')
                          //   TextSpan(
                          //     text: ' ${plan['billing']}',
                          //     style: GoogleFonts.inter(
                          //       color: const Color(0xFF6B7280),
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.normal,
                          //     ),
                          //   ),
                        ],
                      ),
                    ),
                    if (plan.id != null)
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.grey),
                        onSelected: (value) {
                          if (value == 'edit') {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  CreatePlanDialog(editPlan: plan),
                            );
                          } else if (value == 'delete') {
                            _confirmDelete(plan);
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Row(
                              children: [
                                const Icon(Icons.edit,
                                    color: Colors.black, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Edit',
                                  style: GoogleFonts.inter(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                const Icon(Icons.delete,
                                    color: Colors.red, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Delete',
                                  style: GoogleFonts.inter(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                // if (plan.id != null)
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       // Removed bottom row menu
                //     ],
                //   ),
              ],
            ),
          ),
          const SizedBox(width: 32),
          // Image Section
          Expanded(
            flex: 2,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6), // Light grey placeholder
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFF3F4F6),
                      child: const Center(
                        child: Icon(Icons.restaurant,
                            color: Colors.grey, size: 48),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(MealPlan plan) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Plan',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to delete "${plan.name}"? This action cannot be undone.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop(); // Close dialog
              if (plan.id != null) {
                final success =
                    await context.read<MealsController>().deletePlan(plan.id!);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success
                          ? 'Plan deleted successfully'
                          : 'Failed to delete plan'),
                      backgroundColor:
                          success ? const Color(0xFF8AC53D) : Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text('Delete',
                style: GoogleFonts.inter(
                    color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class CreatePlanDialog extends StatefulWidget {
  final MealPlan? editPlan;
  const CreatePlanDialog({Key? key, this.editPlan}) : super(key: key);

  @override
  State<CreatePlanDialog> createState() => _CreatePlanDialogState();
}

class _CreatePlanDialogState extends State<CreatePlanDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _mealsPerDayController = TextEditingController();
  final _priceController = TextEditingController();

  // Available meal types
  final List<String> _availableMealTypes = [
    'breakfast',
    'lunch',
    'dinner',
    'snack'
  ];
  final List<String> _selectedMealTypes = [];

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.editPlan != null) {
      _nameController.text = widget.editPlan!.name;
      _descriptionController.text = widget.editPlan!.description;
      _durationController.text = widget.editPlan!.durationDays.toString();
      _mealsPerDayController.text = widget.editPlan!.mealsPerDay.toString();
      _priceController.text = widget.editPlan!.price.toString();
      _selectedMealTypes.addAll(widget.editPlan!.mealTypes);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _mealsPerDayController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedMealTypes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one meal type')),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      final plan = MealPlan(
        name: _nameController.text,
        description: _descriptionController.text,
        durationDays: int.parse(_durationController.text),
        mealsPerDay: int.parse(_mealsPerDayController.text),
        mealTypes: _selectedMealTypes,
        price: double.parse(_priceController.text),
      );

      bool success;
      if (widget.editPlan != null && widget.editPlan!.id != null) {
        success = await context
            .read<MealsController>()
            .updatePlan(widget.editPlan!.id!, plan);
      } else {
        success = await context.read<MealsController>().createPlan(plan);
      }

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        if (success) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.editPlan != null
                  ? 'Plan updated successfully'
                  : 'Plan created successfully'),
              backgroundColor: const Color(0xFF8AC53D),
            ),
          );
        } else {
          final error = context.read<MealsController>().errorMessage ??
              (widget.editPlan != null
                  ? 'Failed to update plan'
                  : 'Failed to create plan');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Container(
        // Constrain width for desktop
        width: 500,
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.editPlan != null ? 'Edit Plan' : 'Create New Plan',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Name
                _buildLabel('Plan Name'),
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration('e.g. Premium Monthly'),
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Description
                _buildLabel('Description'),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: _inputDecoration('Describe the plan details...'),
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Duration (Days)'),
                          TextFormField(
                            controller: _durationController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('e.g. 30'),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Required';
                              if (int.tryParse(v) == null)
                                return 'Invalid number';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Meals Per Day'),
                          TextFormField(
                            controller: _mealsPerDayController,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration('e.g. 3'),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Required';
                              if (int.tryParse(v) == null)
                                return 'Invalid number';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Price
                _buildLabel('Price'),
                TextFormField(
                  controller: _priceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: _inputDecoration('e.g. 7500'),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    if (double.tryParse(v) == null) return 'Invalid price';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Meal Types
                _buildLabel('Meal Types'),
                Wrap(
                  spacing: 8,
                  children: _availableMealTypes.map((type) {
                    final isSelected = _selectedMealTypes.contains(type);
                    return FilterChip(
                      label: Text(type),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedMealTypes.add(type);
                          } else {
                            _selectedMealTypes.remove(type);
                          }
                        });
                      },
                      selectedColor: const Color(0xFF8AC53D).withOpacity(0.2),
                      checkmarkColor: const Color(0xFF65902D),
                      labelStyle: GoogleFonts.inter(
                        color:
                            isSelected ? const Color(0xFF65902D) : Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      backgroundColor: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      side: BorderSide.none,
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8AC53D),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.black),
                          )
                        : Text(
                            widget.editPlan != null
                                ? 'Update Plan'
                                : 'Create Plan',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
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
        borderSide: const BorderSide(color: Color(0xFF8AC53D)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
