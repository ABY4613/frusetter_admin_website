import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class MealsPlanningScreen extends StatefulWidget {
  const MealsPlanningScreen({Key? key}) : super(key: key);

  @override
  State<MealsPlanningScreen> createState() => _MealsPlanningScreenState();
}

class _MealsPlanningScreenState extends State<MealsPlanningScreen> {
  String _selectedPlanType = 'Standard';
  String _selectedWeek = 'Oct 24 - Oct 30';

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
            _buildStatsRow(),
            const SizedBox(height: 32),
            _buildPlanningTools(),
            const SizedBox(height: 24),
            _buildWeeklySchedule(),
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

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Active Recipes',
            value: '124',
            subtitle: '12 new this week',
            icon: Icons.book,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildStatCard(
            title: 'Subscribed Users',
            value: '8,540',
            subtitle: '+5% vs last week',
            icon: Icons.people_outline,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
            child: _buildStatCard(
          title: 'Low Stock Items',
          value: '3',
          subtitle: 'Requires attention',
          icon: Icons.warning_amber_rounded,
          color: AppColors.accentOrange,
          isWarning: true,
        )),
        const SizedBox(width: 24),
        Expanded(
          child: _buildStatCard(
            title: 'Avg. Calories',
            value: '450',
            subtitle: 'Per meal serving',
            icon: Icons.local_fire_department_outlined,
            color: AppColors.accentRed,
          ),
        ),
      ],
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

  Widget _buildPlanningTools() {
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
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedWeek,
              icon:
                  const Icon(Icons.keyboard_arrow_down, color: AppColors.black),
              style: GoogleFonts.inter(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedWeek = newValue!;
                });
              },
              items: <String>[
                'Oct 17 - Oct 23',
                'Oct 24 - Oct 30',
                'Oct 31 - Nov 6'
              ].map<DropdownMenuItem<String>>((String value) {
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
          ),
        ),
      ],
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

  Widget _buildWeeklySchedule() {
    return Column(
      children: [
        _buildDayRow(
          day: 'Monday',
          date: 'Oct 24',
          meals: [
            _MealItem('Oatmeal with Berries', '350 kcal', 'Breakfast',
                AppColors.accentOrange),
            _MealItem('Grilled Chicken Salad', '450 kcal', 'Lunch',
                AppColors.primaryColor),
            _MealItem(
                'Salmon with Asparagus', '550 kcal', 'Dinner', Colors.blue),
          ],
        ),
        const SizedBox(height: 16),
        _buildDayRow(
          day: 'Tuesday',
          date: 'Oct 25',
          meals: [
            _MealItem('Avocado Toast', '320 kcal', 'Breakfast',
                AppColors.accentOrange),
            _MealItem(
                'Quinoa Bowl', '420 kcal', 'Lunch', AppColors.primaryColor),
            _MealItem('Turkey Meatballs', '500 kcal', 'Dinner', Colors.blue),
          ],
        ),
        const SizedBox(height: 16),
        _buildDayRow(
          day: 'Wednesday',
          date: 'Oct 26',
          meals: [
            _MealItem('Greek Yogurt Parfait', '280 kcal', 'Breakfast',
                AppColors.accentOrange),
            _MealItem(
                'Lentil Soup', '300 kcal', 'Lunch', AppColors.primaryColor),
            _MealItem(
                'Stuffed Bell Peppers', '480 kcal', 'Dinner', Colors.blue),
          ],
        )
      ],
    );
  }

  Widget _buildDayRow({
    required String day,
    required String date,
    required List<_MealItem> meals,
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
    return Container(
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
    );
  }
}

class _MealItem {
  final String name;
  final String calories;
  final String type;
  final Color color;

  _MealItem(this.name, this.calories, this.type, this.color);
}
