import 'package:flutter/material.dart';
import 'package:frusette_admin_operations_web_dashboard/widgets/frusette_loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../controller/meals_controller.dart';
import '../../../../model/meal_plan.dart';

class MealsPlanningScreen extends StatefulWidget {
  const MealsPlanningScreen({super.key});

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
            if (_selectedDuration == '4 Weeks') {
              return plan.durationDays >= 28 && plan.durationDays <= 31;
            }
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
    // Generate some display logic
    final isPopular = plan.price > 6000;
    final imageUrl = plan.name.toLowerCase().contains('veg')
        ? 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&q=80&w=800'
        : 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&q=80&w=800';

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: plan.isActive
              ? const Color(0xFF8AC53D).withOpacity(0.3)
              : Colors.grey.shade200,
          width: plan.isActive ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, 8),
            blurRadius: 24,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top badges row
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Row(
              children: [
                // Active/Inactive Status Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: plan.isActive
                        ? LinearGradient(
                            colors: [
                              const Color(0xFF8AC53D),
                              const Color(0xFF6A9F2E),
                            ],
                          )
                        : null,
                    color: plan.isActive ? null : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        plan.isActive
                            ? Icons.check_circle
                            : Icons.pause_circle_filled,
                        color:
                            plan.isActive ? Colors.white : Colors.grey.shade600,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        plan.isActive ? 'ACTIVE' : 'INACTIVE',
                        style: GoogleFonts.inter(
                          color: plan.isActive
                              ? Colors.white
                              : Colors.grey.shade700,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Popular Badge
                if (isPopular)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFAB40).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xFFFF8F00),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'POPULAR',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFFF8F00),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                // Created date
                if (plan.createdAt != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.grey.shade500,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Created ${plan.formattedCreatedAt}',
                          style: GoogleFonts.inter(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Menu Button
                if (plan.id != null)
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
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
                            const Icon(Icons.edit_outlined,
                                color: Colors.black87, size: 20),
                            const SizedBox(width: 12),
                            Text('Edit Plan',
                                style:
                                    GoogleFonts.inter(color: Colors.black87)),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete_outline,
                                color: Colors.red, size: 20),
                            const SizedBox(width: 12),
                            Text('Delete',
                                style: GoogleFonts.inter(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left content
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Plan name
                      Text(
                        plan.name,
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Description
                      Text(
                        plan.description,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF6B7280),
                          fontSize: 15,
                          height: 1.6,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 20),

                      // Stats Row
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        children: [
                          _buildStatChip(
                            Icons.calendar_today_outlined,
                            '${plan.durationDays} Days',
                            const Color(0xFF3B82F6),
                          ),
                          _buildStatChip(
                            Icons.restaurant_menu,
                            '${plan.mealsPerDay} Meals/Day',
                            const Color(0xFF8B5CF6),
                          ),
                          // Plan Type Badge
                          _buildStatChip(
                            plan.isMonthlyPlan
                                ? Icons.calendar_month
                                : Icons.calendar_view_week,
                            plan.isMonthlyPlan ? 'Monthly Plan' : 'Weekly Plan',
                            plan.isMonthlyPlan
                                ? const Color(0xFFEC4899)
                                : const Color(0xFF10B981),
                          ),
                          // Days configured chip
                          if (plan.configuredDaysCount > 0)
                            _buildStatChip(
                              Icons.check_circle_outline,
                              plan.isMonthlyPlan
                                  ? '${plan.configuredDaysCount}/28 Days Menu'
                                  : '${plan.configuredDaysCount}/7 Days Menu',
                              const Color(0xFF10B981),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Meal Types
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: plan.mealTypes.map((type) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8AC53D).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF8AC53D).withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              type[0].toUpperCase() + type.substring(1),
                              style: GoogleFonts.inter(
                                color: const Color(0xFF65902D),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹',
                            style: GoogleFonts.inter(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            plan.price.toStringAsFixed(0),
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '/ ${plan.durationDays} days',
                              style: GoogleFonts.inter(
                                color: Colors.grey.shade500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                // Image Section with menu preview
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
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
                      // Menu preview (weekly or monthly)
                      if (plan.configuredDaysCount > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    plan.isMonthlyPlan
                                        ? Icons.calendar_month
                                        : Icons.calendar_view_week,
                                    size: 16,
                                    color: const Color(0xFF65902D),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    plan.isMonthlyPlan
                                        ? 'Monthly Menu'
                                        : 'Weekly Menu',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (plan.isMonthlyPlan &&
                                      plan.monthlyMenu != null)
                                    Text(
                                      '${plan.configuredWeeksCount}/4 weeks',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (plan.isMonthlyPlan &&
                                  plan.monthlyMenu != null)
                                _buildMonthlyMenuPreview(plan.monthlyMenu!)
                              else if (plan.weeklyMenu != null)
                                _buildWeeklyMenuPreview(plan.weeklyMenu!),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.inter(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyMenuPreview(WeeklyMenu menu) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final dayNames = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final dayMeals = menu.getDay(dayNames[index]);
        final hasContent = dayMeals != null &&
            ((dayMeals.breakfast != null &&
                    dayMeals.breakfast!.name.isNotEmpty) ||
                (dayMeals.lunch != null && dayMeals.lunch!.name.isNotEmpty) ||
                (dayMeals.dinner != null && dayMeals.dinner!.name.isNotEmpty));

        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: hasContent ? const Color(0xFF8AC53D) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              days[index],
              style: GoogleFonts.inter(
                color: hasContent ? Colors.white : Colors.grey.shade500,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMonthlyMenuPreview(MonthlyMenu menu) {
    final weeks = [menu.week1, menu.week2, menu.week3, menu.week4];
    final weekLabels = ['W1', 'W2', 'W3', 'W4'];

    return Column(
      children: [
        // Week indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(4, (weekIndex) {
            final week = weeks[weekIndex];
            final hasContent = week != null && week.hasAnyMeals;

            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: weekIndex < 3 ? 8 : 0),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: hasContent
                      ? const Color(0xFF8AC53D).withOpacity(0.15)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: hasContent
                        ? const Color(0xFF8AC53D).withOpacity(0.4)
                        : Colors.grey.shade200,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      weekLabels[weekIndex],
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: hasContent
                            ? const Color(0xFF65902D)
                            : Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: hasContent
                            ? const Color(0xFF8AC53D)
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    if (week != null && hasContent)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${week.configuredDaysCount}/7',
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
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
  const CreatePlanDialog({super.key, this.editPlan});

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

  // Plan type
  String _selectedPlanType = 'weekly'; // 'weekly' or 'monthly'

  // Available meal types
  final List<String> _availableMealTypes = [
    'breakfast',
    'lunch',
    'dinner',
    'snack'
  ];
  final List<String> _selectedMealTypes = [];

  // Weekly menu state
  final List<String> _weekDays = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday'
  ];

  // For weekly plans - single week data
  final Map<String, Map<String, Map<String, String>>> _weeklyMenuData = {};

  // For monthly plans - 4 weeks of data
  final List<String> _weeks = ['week1', 'week2', 'week3', 'week4'];
  final Map<String, Map<String, Map<String, Map<String, String>>>> _monthlyMenuData =
      {};
  String _selectedWeek = 'week1';

  String? _expandedDay;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _initializeMenuData();

    if (widget.editPlan != null) {
      _nameController.text = widget.editPlan!.name;
      _descriptionController.text = widget.editPlan!.description;
      _durationController.text = widget.editPlan!.durationDays.toString();
      _mealsPerDayController.text = widget.editPlan!.mealsPerDay.toString();
      _priceController.text = widget.editPlan!.price.toString();
      _selectedMealTypes.addAll(widget.editPlan!.mealTypes);
      _selectedPlanType = widget.editPlan!.planType;

      // Load existing weekly menu if available
      if (widget.editPlan!.weeklyMenu != null) {
        final wm = widget.editPlan!.weeklyMenu!;
        _loadDayMealsToWeekly('monday', wm.monday);
        _loadDayMealsToWeekly('tuesday', wm.tuesday);
        _loadDayMealsToWeekly('wednesday', wm.wednesday);
        _loadDayMealsToWeekly('thursday', wm.thursday);
        _loadDayMealsToWeekly('friday', wm.friday);
        _loadDayMealsToWeekly('saturday', wm.saturday);
        _loadDayMealsToWeekly('sunday', wm.sunday);
      }

      // Load existing monthly menu if available
      if (widget.editPlan!.monthlyMenu != null) {
        final mm = widget.editPlan!.monthlyMenu!;
        _loadWeekToMonthly('week1', mm.week1);
        _loadWeekToMonthly('week2', mm.week2);
        _loadWeekToMonthly('week3', mm.week3);
        _loadWeekToMonthly('week4', mm.week4);
      }
    }
  }

  void _initializeMenuData() {
    // Initialize weekly menu data structure
    for (var day in _weekDays) {
      _weeklyMenuData[day] = {
        'breakfast': {'name': '', 'description': ''},
        'lunch': {'name': '', 'description': ''},
        'dinner': {'name': '', 'description': ''},
      };
    }

    // Initialize monthly menu data structure (4 weeks)
    for (var week in _weeks) {
      _monthlyMenuData[week] = {};
      for (var day in _weekDays) {
        _monthlyMenuData[week]![day] = {
          'breakfast': {'name': '', 'description': ''},
          'lunch': {'name': '', 'description': ''},
          'dinner': {'name': '', 'description': ''},
        };
      }
    }
  }

  void _loadDayMealsToWeekly(String day, DayMeals? dayMeals) {
    if (dayMeals == null) return;
    if (dayMeals.breakfast != null) {
      _weeklyMenuData[day]!['breakfast']!['name'] = dayMeals.breakfast!.name;
      _weeklyMenuData[day]!['breakfast']!['description'] =
          dayMeals.breakfast!.description;
    }
    if (dayMeals.lunch != null) {
      _weeklyMenuData[day]!['lunch']!['name'] = dayMeals.lunch!.name;
      _weeklyMenuData[day]!['lunch']!['description'] =
          dayMeals.lunch!.description;
    }
    if (dayMeals.dinner != null) {
      _weeklyMenuData[day]!['dinner']!['name'] = dayMeals.dinner!.name;
      _weeklyMenuData[day]!['dinner']!['description'] =
          dayMeals.dinner!.description;
    }
  }

  void _loadWeekToMonthly(String weekKey, WeeklyMenu? weeklyMenu) {
    if (weeklyMenu == null) return;
    for (var day in _weekDays) {
      final dayMeals = weeklyMenu.getDay(day);
      if (dayMeals != null) {
        if (dayMeals.breakfast != null) {
          _monthlyMenuData[weekKey]![day]!['breakfast']!['name'] =
              dayMeals.breakfast!.name;
          _monthlyMenuData[weekKey]![day]!['breakfast']!['description'] =
              dayMeals.breakfast!.description;
        }
        if (dayMeals.lunch != null) {
          _monthlyMenuData[weekKey]![day]!['lunch']!['name'] =
              dayMeals.lunch!.name;
          _monthlyMenuData[weekKey]![day]!['lunch']!['description'] =
              dayMeals.lunch!.description;
        }
        if (dayMeals.dinner != null) {
          _monthlyMenuData[weekKey]![day]!['dinner']!['name'] =
              dayMeals.dinner!.name;
          _monthlyMenuData[weekKey]![day]!['dinner']!['description'] =
              dayMeals.dinner!.description;
        }
      }
    }
  }

  WeeklyMenu _buildWeeklyMenu() {
    return _buildWeeklyMenuFromData(_weeklyMenuData);
  }

  WeeklyMenu _buildWeeklyMenuFromData(
      Map<String, Map<String, Map<String, String>>> menuData) {
    DayMeals? buildDayMeals(String day) {
      final dayData = menuData[day]!;
      final hasData = dayData.values.any((meal) =>
          meal['name']!.isNotEmpty || meal['description']!.isNotEmpty);
      if (!hasData) return null;

      return DayMeals(
        breakfast: dayData['breakfast']!['name']!.isNotEmpty ||
                dayData['breakfast']!['description']!.isNotEmpty
            ? MealItem(
                name: dayData['breakfast']!['name']!,
                description: dayData['breakfast']!['description']!,
              )
            : null,
        lunch: dayData['lunch']!['name']!.isNotEmpty ||
                dayData['lunch']!['description']!.isNotEmpty
            ? MealItem(
                name: dayData['lunch']!['name']!,
                description: dayData['lunch']!['description']!,
              )
            : null,
        dinner: dayData['dinner']!['name']!.isNotEmpty ||
                dayData['dinner']!['description']!.isNotEmpty
            ? MealItem(
                name: dayData['dinner']!['name']!,
                description: dayData['dinner']!['description']!,
              )
            : null,
      );
    }

    return WeeklyMenu(
      monday: buildDayMeals('monday'),
      tuesday: buildDayMeals('tuesday'),
      wednesday: buildDayMeals('wednesday'),
      thursday: buildDayMeals('thursday'),
      friday: buildDayMeals('friday'),
      saturday: buildDayMeals('saturday'),
      sunday: buildDayMeals('sunday'),
    );
  }

  MonthlyMenu _buildMonthlyMenu() {
    return MonthlyMenu(
      week1: _buildWeeklyMenuFromData(_monthlyMenuData['week1']!),
      week2: _buildWeeklyMenuFromData(_monthlyMenuData['week2']!),
      week3: _buildWeeklyMenuFromData(_monthlyMenuData['week3']!),
      week4: _buildWeeklyMenuFromData(_monthlyMenuData['week4']!),
    );
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

      final isMonthly = _selectedPlanType == 'monthly';

      final plan = MealPlan(
        name: _nameController.text,
        description: _descriptionController.text,
        durationDays: int.parse(_durationController.text),
        mealsPerDay: int.parse(_mealsPerDayController.text),
        mealTypes: _selectedMealTypes,
        price: double.parse(_priceController.text),
        planType: _selectedPlanType,
        weeklyMenu: isMonthly ? null : _buildWeeklyMenu(),
        monthlyMenu: isMonthly ? _buildMonthlyMenu() : null,
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
          // Refresh the plans list
          await context.read<MealsController>().fetchPlans();

          if (mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(widget.editPlan != null
                    ? 'Plan updated successfully'
                    : 'Plan created successfully'),
                backgroundColor: const Color(0xFF8AC53D),
              ),
            );
          }
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Container(
        width: 700,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF8AC53D),
                      const Color(0xFF6A9F2E),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            widget.editPlan != null
                                ? Icons.edit_note
                                : Icons.restaurant_menu,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.editPlan != null
                                  ? 'Edit Meal Plan'
                                  : 'Create Meal Plan',
                              style: GoogleFonts.inter(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Configure plan details and weekly menu',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Info Section
                      _buildSectionHeader(
                          'Basic Information', Icons.info_outline),
                      const SizedBox(height: 16),

                      // Name
                      _buildLabel('Plan Name'),
                      TextFormField(
                        controller: _nameController,
                        decoration: _inputDecoration(
                            'e.g. Premium Monthly', Icons.label_outline),
                        validator: (v) =>
                            v?.isEmpty == true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),

                      // Description
                      _buildLabel('Description'),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: _inputDecoration(
                            'Describe the plan details...',
                            Icons.description_outlined),
                        validator: (v) =>
                            v?.isEmpty == true ? 'Required' : null,
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
                                  decoration: _inputDecoration(
                                      'e.g. 30', Icons.calendar_today_outlined),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return 'Required';
                                    }
                                    if (int.tryParse(v) == null) {
                                      return 'Invalid number';
                                    }
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
                                  decoration: _inputDecoration(
                                      'e.g. 3', Icons.restaurant_outlined),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return 'Required';
                                    }
                                    if (int.tryParse(v) == null) {
                                      return 'Invalid number';
                                    }
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
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration:
                            _inputDecoration('e.g. 7500', Icons.attach_money),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (double.tryParse(v) == null) {
                            return 'Invalid price';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Meal Types
                      _buildLabel('Meal Types'),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _availableMealTypes.map((type) {
                          final isSelected = _selectedMealTypes.contains(type);
                          return FilterChip(
                            label:
                                Text(type[0].toUpperCase() + type.substring(1)),
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
                            selectedColor:
                                const Color(0xFF8AC53D).withOpacity(0.2),
                            checkmarkColor: const Color(0xFF65902D),
                            labelStyle: GoogleFonts.inter(
                              color: isSelected
                                  ? const Color(0xFF65902D)
                                  : Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                            backgroundColor: Colors.grey.shade100,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            side: BorderSide.none,
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 32),

                      // Plan Type Section
                      _buildSectionHeader('Plan Type', Icons.event_repeat),
                      const SizedBox(height: 12),
                      Text(
                        'Select the type of meal plan you want to create.',
                        style: GoogleFonts.inter(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Plan Type Selector
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildPlanTypeButton(
                                'weekly',
                                'Weekly',
                                Icons.calendar_view_week,
                                '7 days menu',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildPlanTypeButton(
                                'monthly',
                                'Monthly',
                                Icons.calendar_month,
                                '4 weeks menu',
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Menu Section
                      _buildSectionHeader(
                          _selectedPlanType == 'monthly'
                              ? 'Monthly Menu'
                              : 'Weekly Menu',
                          _selectedPlanType == 'monthly'
                              ? Icons.calendar_month
                              : Icons.calendar_view_week),
                      const SizedBox(height: 12),
                      Text(
                        _selectedPlanType == 'monthly'
                            ? 'Configure meals for each week of the month. Select a week and add meals for each day.'
                            : 'Configure meals for each day of the week. Click on a day to expand and add meals.',
                        style: GoogleFonts.inter(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Week Tabs for Monthly Plan
                      if (_selectedPlanType == 'monthly') ...[
                        _buildWeekTabs(),
                        const SizedBox(height: 16),
                      ],

                      // Day Cards
                      ..._weekDays
                          .map((day) => _buildDayCard(
                                day,
                                weekKey: _selectedPlanType == 'monthly'
                                    ? _selectedWeek
                                    : null,
                              ))
                          ,
                    ],
                  ),
                ),
              ),

              // Footer with Submit Button
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(20)),
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8AC53D),
                          foregroundColor: Colors.white,
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
                                    strokeWidth: 2, color: Colors.white),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF8AC53D).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF65902D), size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPlanTypeButton(
      String type, String label, IconData icon, String subtitle) {
    final isSelected = _selectedPlanType == type;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPlanType = type;
          _expandedDay = null; // Reset expanded day when switching
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF8AC53D).withOpacity(0.1)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color:
                    isSelected ? const Color(0xFF65902D) : Colors.grey.shade500,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.black87 : Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF8AC53D),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: _weeks.map((week) {
          final isSelected = _selectedWeek == week;
          final weekNumber = int.parse(week.replaceAll('week', ''));
          final weekData = _monthlyMenuData[week]!;
          final hasContent = weekData.values.any((dayData) => dayData.values
              .any((meal) =>
                  meal['name']!.isNotEmpty || meal['description']!.isNotEmpty));

          return Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedWeek = week;
                  _expandedDay =
                      null; // Reset expanded day when switching weeks
                });
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Text(
                      'Week $weekNumber',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        color:
                            isSelected ? Colors.black87 : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: hasContent
                            ? const Color(0xFF8AC53D)
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDayCard(String day, {String? weekKey}) {
    final isExpanded = _expandedDay == day;

    // Get day data based on whether it's weekly or monthly
    final Map<String, Map<String, String>> dayData;
    if (weekKey != null) {
      dayData = _monthlyMenuData[weekKey]![day]!;
    } else {
      dayData = _weeklyMenuData[day]!;
    }

    final hasContent = dayData.values.any(
        (meal) => meal['name']!.isNotEmpty || meal['description']!.isNotEmpty);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpanded
              ? const Color(0xFF8AC53D)
              : hasContent
                  ? const Color(0xFF8AC53D).withOpacity(0.5)
                  : Colors.grey.shade200,
          width: isExpanded ? 2 : 1,
        ),
        boxShadow: isExpanded
            ? [
                BoxShadow(
                  color: const Color(0xFF8AC53D).withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Column(
        children: [
          // Day Header (always visible)
          InkWell(
            onTap: () {
              setState(() {
                _expandedDay = isExpanded ? null : day;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: hasContent
                            ? [const Color(0xFF8AC53D), const Color(0xFF6A9F2E)]
                            : [Colors.grey.shade300, Colors.grey.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        day.substring(0, 2).toUpperCase(),
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          day[0].toUpperCase() + day.substring(1),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        if (hasContent)
                          Text(
                            _getMealSummary(dayData),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (hasContent)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8AC53D).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Configured',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF65902D),
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expanded Content
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildDayContent(day, weekKey: weekKey),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  String _getMealSummary(Map<String, Map<String, String>> dayData) {
    final meals = <String>[];
    if (dayData['breakfast']!['name']!.isNotEmpty) meals.add('Breakfast');
    if (dayData['lunch']!['name']!.isNotEmpty) meals.add('Lunch');
    if (dayData['dinner']!['name']!.isNotEmpty) meals.add('Dinner');
    return meals.isEmpty ? 'No meals configured' : meals.join(' • ');
  }

  Widget _buildDayContent(String day, {String? weekKey}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          const Divider(),
          const SizedBox(height: 12),
          _buildMealInput(day, 'breakfast', Icons.free_breakfast_outlined,
              const Color(0xFFFFAB40),
              weekKey: weekKey),
          const SizedBox(height: 16),
          _buildMealInput(day, 'lunch', Icons.lunch_dining_outlined,
              const Color(0xFF42A5F5),
              weekKey: weekKey),
          const SizedBox(height: 16),
          _buildMealInput(day, 'dinner', Icons.dinner_dining_outlined,
              const Color(0xFF7E57C2),
              weekKey: weekKey),
        ],
      ),
    );
  }

  Widget _buildMealInput(
      String day, String mealType, IconData icon, Color color,
      {String? weekKey}) {
    // Get meal data based on whether it's weekly or monthly
    final Map<String, String> mealData;
    if (weekKey != null) {
      mealData = _monthlyMenuData[weekKey]![day]![mealType]!;
    } else {
      mealData = _weeklyMenuData[day]![mealType]!;
    }

    // Create a unique key for the TextFormField to force rebuild when switching weeks
    final uniqueKey =
        weekKey != null ? '${weekKey}_${day}_$mealType' : '${day}_$mealType';

    return Container(
      key: ValueKey(uniqueKey),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                mealType[0].toUpperCase() + mealType.substring(1),
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: color.withOpacity(0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: ValueKey('${uniqueKey}_name'),
            initialValue: mealData['name'],
            decoration: InputDecoration(
              hintText: 'Meal name',
              hintStyle:
                  GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 13),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: color),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              isDense: true,
            ),
            onChanged: (value) {
              setState(() {
                if (weekKey != null) {
                  _monthlyMenuData[weekKey]![day]![mealType]!['name'] = value;
                } else {
                  _weeklyMenuData[day]![mealType]!['name'] = value;
                }
              });
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            key: ValueKey('${uniqueKey}_description'),
            initialValue: mealData['description'],
            decoration: InputDecoration(
              hintText: 'Description (optional)',
              hintStyle:
                  GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 13),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: color),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              isDense: true,
            ),
            onChanged: (value) {
              setState(() {
                if (weekKey != null) {
                  _monthlyMenuData[weekKey]![day]![mealType]!['description'] =
                      value;
                } else {
                  _weeklyMenuData[day]![mealType]!['description'] = value;
                }
              });
            },
          ),
        ],
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

  InputDecoration _inputDecoration(String hint, [IconData? icon]) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
      prefixIcon: icon != null
          ? Icon(icon, color: Colors.grey.shade400, size: 20)
          : null,
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
