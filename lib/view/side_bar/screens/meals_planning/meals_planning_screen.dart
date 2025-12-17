import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:frusette_admin_operations_web_dashboard/core/data/dummy_data.dart';
import 'package:provider/provider.dart';
import '../../../../controller/meals_controller.dart';
import 'package:frusette_admin_operations_web_dashboard/model/meal_plan.dart';

class MealsPlanningScreen extends StatefulWidget {
  const MealsPlanningScreen({Key? key}) : super(key: key);

  @override
  State<MealsPlanningScreen> createState() => _MealsPlanningScreenState();
}

class _MealsPlanningScreenState extends State<MealsPlanningScreen> {
  String _selectedPlanType = 'Standard';
  String _selectedWeek = 'Oct 24 - Oct 30';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MealsController>(context, listen: false).fetchMealsOverview();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 900;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isMobile),
                const SizedBox(height: 32),
                _buildStatsRow(isMobile),
                const SizedBox(height: 32),
                _buildPlanningTools(isMobile),
                const SizedBox(height: 24),
                _buildWeeklySchedule(isMobile),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  Icon(Icons.chevron_right,
                      size: 16, color: AppColors.textLight),
                  const SizedBox(width: 8),
                  Text(
                    'Meals Planning',
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
                'Meals Planning',
                style: GoogleFonts.inter(
                  color: AppColors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Organize weekly menus and inventory.',
                style: GoogleFonts.inter(
                  color: AppColors.textLight,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Mobile Actions
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.inventory_2_outlined, size: 18),
                label: Text(
                  'Inventory',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  foregroundColor: AppColors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: Text(
                  'New Meal',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                  'Meals Planning',
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
              'Meals Planning',
              style: GoogleFonts.inter(
                color: AppColors.black,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Organize weekly menus and manage recipe inventory.',
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
              onPressed: () {},
              icon: const Icon(Icons.inventory_2_outlined, size: 18),
              label: Text(
                'Inventory',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
                foregroundColor: AppColors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: Text(
                'New Meal',
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

  Widget _buildStatsRow(bool isMobile) {
    return Consumer<MealsController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage != null) {
          return Center(child: Text('Error: ${controller.errorMessage}'));
        }

        final summary = controller.overviewData?.summary;
        if (summary == null) return const SizedBox();

        final cards = [
          _buildStatCard(
            title: 'Breakfast',
            value: '${summary.breakfast}',
            subtitle: 'Daily Count',
            icon: Icons.breakfast_dining,
            color: Colors.orange,
          ),
          const SizedBox(width: 24, height: 16),
          _buildStatCard(
            title: 'Lunch',
            value: '${summary.lunch}',
            subtitle: 'Daily Count',
            icon: Icons.lunch_dining,
            color: Colors.green,
          ),
          const SizedBox(width: 24, height: 16),
          _buildStatCard(
            title: 'Dinner',
            value: '${summary.dinner}',
            subtitle: 'Daily Count',
            icon: Icons.dinner_dining,
            color: Colors.blue,
          ),
          const SizedBox(width: 24, height: 16),
          _buildStatCard(
            title: 'Total Meals',
            value: '${summary.totalMeals}',
            subtitle: 'Summary',
            icon: Icons.restaurant,
            color: AppColors.primaryColor,
          ),
        ];

        if (isMobile) {
          return Column(children: cards);
        }

        return Row(
          children: [
            Expanded(child: cards[0]),
            const SizedBox(width: 24),
            Expanded(child: cards[2]), // spacer
            const SizedBox(width: 24),
            Expanded(child: cards[4]),
            const SizedBox(width: 24),
            Expanded(child: cards[6]),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    bool isWarning = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  color: isWarning ? AppColors.accentOrange : AppColors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: GoogleFonts.inter(
                  color: AppColors.textLight,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  color: isWarning ? AppColors.accentOrange : Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanningTools(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(24),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPlanTab('Standard'),
                  _buildPlanTab('Keto'),
                  _buildPlanTab('Vegan'),
                  _buildPlanTab('Paleo'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Dropdown
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: _buildWeekDropdown(isMobile: true),
          ),
        ],
      );
    }

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
              _buildPlanTab('Standard'),
              _buildPlanTab('Keto'),
              _buildPlanTab('Vegan'),
              _buildPlanTab('Paleo'),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: _buildWeekDropdown(isMobile: false),
        ),
      ],
    );
  }

  Widget _buildWeekDropdown({required bool isMobile}) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _selectedWeek,
        isExpanded: isMobile, // Don't expand in desktop row
        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.black),
        style: GoogleFonts.inter(
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
        onChanged: (String? newValue) {
          setState(() {
            _selectedWeek = newValue!;
          });
        },
        items: <String>['Oct 17 - Oct 23', 'Oct 24 - Oct 30', 'Oct 31 - Nov 6']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 16, color: AppColors.textLight),
                const SizedBox(width: 12),
                Text(value),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPlanTab(String label) {
    final isSelected = _selectedPlanType == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlanType = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : AppColors.textLight,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklySchedule(bool isMobile) {
    // Demo: Generate schedule based on available meal plans
    final days = [
      {'day': 'Monday', 'date': 'Oct 24'},
      {'day': 'Tuesday', 'date': 'Oct 25'},
      {'day': 'Wednesday', 'date': 'Oct 26'},
    ];

    return Column(
      children: days.map((dayInfo) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildDayRow(
            day: dayInfo['day']!,
            date: dayInfo['date']!,
            meals: [
              _MealItem(
                DummyData.mealPlans[0].name,
                '${DummyData.mealPlans[0].calories} kcal',
                'Breakfast',
                AppColors.accentOrange,
                DummyData.mealPlans[0],
              ),
              _MealItem(
                DummyData.mealPlans[1].name,
                '${DummyData.mealPlans[1].calories} kcal',
                'Lunch',
                AppColors.primaryColor,
                DummyData.mealPlans[1],
              ),
              _MealItem(
                DummyData.mealPlans.length > 2
                    ? DummyData.mealPlans[2].name
                    : 'Salmon Special',
                DummyData.mealPlans.length > 2
                    ? '${DummyData.mealPlans[2].calories} kcal'
                    : '600 kcal',
                'Dinner',
                Colors.blue,
                DummyData.mealPlans.length > 2 ? DummyData.mealPlans[2] : null,
              ),
            ],
            isMobile: isMobile,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDayRow({
    required String day,
    required String date,
    required List<_MealItem> meals,
    required bool isMobile,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                day,
                style: GoogleFonts.inter(
                  color: AppColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                date,
                style: GoogleFonts.inter(
                  color: AppColors.textLight,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz),
                color: AppColors.textLight,
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (isMobile)
            Column(
              children: meals
                  .map((meal) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildMealCard(meal),
                      ))
                  .toList(),
            )
          else
            Row(
              children: meals
                  .map((meal) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: _buildMealCard(meal),
                        ),
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildMealCard(_MealItem meal) {
    return InkWell(
      onTap: meal.plan != null ? () => _showMealDetails(meal.plan!) : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: meal.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.restaurant, color: meal.color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.type,
                    style: GoogleFonts.inter(
                      color: meal.color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meal.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: AppColors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meal.calories,
                    style: GoogleFonts.inter(
                      color: AppColors.textLight,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMealDetails(MealPlan plan) {
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
                    'Meal Details',
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
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(plan.imageUrl),
                      fit: BoxFit.cover,
                    )),
              ),
              const SizedBox(height: 24),
              _buildDetailText("Name", plan.name),
              _buildDetailText("Calories", "${plan.calories}"),
              _buildDetailText("Price", "\$${plan.price}"),
              _buildDetailText(
                  "Dietary Info", plan.dietaryPreferences.join(", ")),
              const SizedBox(height: 16),
              Text(
                "Description",
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight),
              ),
              const SizedBox(height: 4),
              Text(
                plan.description,
                style: GoogleFonts.inter(fontSize: 14, color: AppColors.black),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close',
                      style: TextStyle(color: AppColors.textLight)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 100,
              child: Text(label,
                  style: GoogleFonts.inter(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w500))),
          Expanded(
              child: Text(value,
                  style: GoogleFonts.inter(
                      color: AppColors.black, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

class _MealItem {
  final String name;
  final String calories;
  final String type;
  final Color color;
  final MealPlan? plan;

  _MealItem(this.name, this.calories, this.type, this.color, [this.plan]);
}
