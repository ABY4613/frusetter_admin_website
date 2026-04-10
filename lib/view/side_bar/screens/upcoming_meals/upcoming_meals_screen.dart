import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../controller/upcoming_meals_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/view_models/navigation_view_model.dart';
import '../../../../model/upcoming_meal.dart';
import '../../../../widgets/frusette_loader.dart';

class UpcomingMealsScreen extends StatefulWidget {
  const UpcomingMealsScreen({super.key});

  @override
  State<UpcomingMealsScreen> createState() => _UpcomingMealsScreenState();
}

class _UpcomingMealsScreenState extends State<UpcomingMealsScreen> {
  final TextEditingController _userIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final controller = context.read<UpcomingMealsController>();
    if (controller.selectedUserId != null) {
      _userIdController.text = controller.selectedUserId!;
    } else {
      _userIdController.text = 'b59bde85-fad6-446c-845c-1d383f7e5f64';
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchMeals();
    });
  }

  void _fetchMeals() {
    if (_userIdController.text.isNotEmpty) {
      context.read<UpcomingMealsController>().fetchUpcomingMeals(_userIdController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < 600;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isMobile),
                  SizedBox(height: isMobile ? 24 : 32),
                  _buildMealsList(isMobile),
                  // Extra padding at bottom to prevent flow issues
                  const SizedBox(height: 50),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Consumer<UpcomingMealsController>(
      builder: (context, controller, child) {
        return Container(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Provider.of<NavigationViewModel>(context, listen: false)
                            .setNavigationItem(NavigationItem.subscriptions);
                      },
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: AppColors.primaryColor, size: 20),
                      tooltip: 'Back to Subscriptions',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upcoming Meals',
                          style: GoogleFonts.inter(
                            fontSize: isMobile ? 20 : 28,
                            fontWeight: FontWeight.w800,
                            color: AppColors.black,
                            letterSpacing: -0.5,
                          ),
                        ),
                        if (controller.selectedUserName != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Row(
                              children: [
                                Icon(Icons.person_outline,
                                    size: 12, color: AppColors.textLight),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    controller.selectedUserName!,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textLight,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!isMobile) ...[
                    IconButton(
                      onPressed: _fetchMeals,
                      icon: const Icon(Icons.refresh_rounded,
                          color: AppColors.textLight),
                      tooltip: 'Refresh',
                    ),
                    const SizedBox(width: 8),
                    _buildPauseButton(),
                  ],
                ],
              ),
              if (isMobile) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildPauseButton()),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _fetchMeals,
                      icon: const Icon(Icons.refresh_rounded,
                          color: AppColors.textLight),
                      tooltip: 'Refresh',
                    ),
                  ],
                ),
              ],
              if (controller.upcomingMeals.isNotEmpty && !isMobile) ...[
                const SizedBox(height: 16),
                _buildMealCountBadge(controller.upcomingMeals.length),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildPauseButton() {
    return ElevatedButton.icon(
      onPressed: () => _showPauseByDateDialog(context),
      icon: const Icon(Icons.pause_circle_filled, size: 18),
      label: const Text('Pause by Date'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentRed,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildMealCountBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accentGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accentGreen.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_month, size: 14, color: AppColors.accentGreen),
          const SizedBox(width: 6),
          Text(
            '$count Scheduled',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.accentGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealsList(bool isMobile) {
    return Consumer<UpcomingMealsController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 100.0),
              child: FrusetteLoader(size: 80),
            ),
          );
        }

        if (controller.errorMessage != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Column(
                children: [
                  Icon(Icons.error_outline_rounded,
                      size: 64, color: AppColors.accentRed.withOpacity(0.3)),
                  const SizedBox(height: 20),
                  Text(
                    controller.errorMessage!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.accentRed,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchMeals,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Retry Connection'),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.upcomingMeals.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Column(
                children: [
                  Icon(Icons.restaurant_rounded,
                      size: 80, color: Colors.grey.withOpacity(0.1)),
                  const SizedBox(height: 24),
                  Text(
                    'No upcoming meals found',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: isMobile ? 600 : 400,
            mainAxisExtent: isMobile ? 240 : 180,
            crossAxisSpacing: isMobile ? 16 : 24,
            mainAxisSpacing: isMobile ? 16 : 24,
          ),
          itemCount: controller.upcomingMeals.length,
          itemBuilder: (context, index) {
            return _buildMealCard(controller.upcomingMeals[index], isMobile);
          },
        );
      },
    );
  }

  Widget _buildMealCard(UpcomingMeal meal, bool isMobile) {
    final bool isPaused = meal.status.toLowerCase() == 'paused';
    final typeColor = _getMealTypeColor(meal.mealType);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPaused
              ? AppColors.accentRed.withOpacity(0.3)
              : Colors.grey.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 6,
              child: Container(color: isPaused ? AppColors.accentRed : typeColor),
            ),
            Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: typeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(_getMealIcon(meal.mealType),
                            color: typeColor, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          meal.mealType.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: typeColor,
                          ),
                        ),
                      ),
                      _buildStatusBadge(meal.status),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    meal.mealName,
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 15 : 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          size: 14, color: AppColors.textLight),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('EEE, MMM dd').format(meal.deliveryDate),
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildActionButtons(meal, isMobile),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(UpcomingMeal meal, bool isMobile) {
    final bool isPaused = meal.status.toLowerCase() == 'paused';
    final controller = context.read<UpcomingMealsController>();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          bool success;
          if (isPaused) {
            success = await controller.unpauseMeal(meal.userId, meal.id);
          } else {
            success = await controller.pauseMeal(meal.userId, meal.id);
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(success
                    ? (isPaused ? 'Meal unpaused' : 'Meal paused')
                    : controller.errorMessage ?? 'Operation failed'),
                backgroundColor:
                    success ? AppColors.accentGreen : AppColors.accentRed,
              ),
            );
          }
        },
        icon: Icon(
          isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
          size: 16,
        ),
        label: Text(
          isPaused ? 'Unpause Meal' : 'Pause Meal',
          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isPaused ? AppColors.accentGreen : AppColors.accentRed.withOpacity(0.1),
          foregroundColor: isPaused ? Colors.white : AppColors.accentRed,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: isPaused
                ? BorderSide.none
                : BorderSide(color: AppColors.accentRed.withOpacity(0.5)),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final bool isPaused = status.toLowerCase() == 'paused';
    final bool isScheduled = status.toLowerCase() == 'scheduled';
    
    Color color = isPaused ? AppColors.accentRed : (isScheduled ? AppColors.accentGreen : AppColors.textLight);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Color _getMealTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'breakfast':
        return Colors.orange;
      case 'lunch':
        return Colors.blue;
      case 'dinner':
        return Colors.indigo;
      default:
        return AppColors.accentGreen;
    }
  }

  IconData _getMealIcon(String type) {
    switch (type.toLowerCase()) {
      case 'breakfast':
        return Icons.wb_sunny_rounded;
      case 'lunch':
        return Icons.lunch_dining_rounded;
      case 'dinner':
        return Icons.nights_stay_rounded;
      default:
        return Icons.restaurant_rounded;
    }
  }

  void _showPauseByDateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _PauseByDateDialog(
        userId: _userIdController.text,
        userName: context.read<UpcomingMealsController>().selectedUserName ?? 'Customer',
      ),
    );
  }
}

class _PauseByDateDialog extends StatefulWidget {
  final String userId;
  final String userName;

  const _PauseByDateDialog({required this.userId, required this.userName});

  @override
  State<_PauseByDateDialog> createState() => _PauseByDateDialogState();
}

class _PauseByDateDialogState extends State<_PauseByDateDialog> {
  DateTime _selectedDate = DateTime.now();
  final Set<String> _selectedTypes = {};
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: isMobile ? double.infinity : 450,
        padding: EdgeInsets.all(isMobile ? 20 : 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pause Specific Meals',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select a date and meal types to pause/unpause for ${widget.userName}',
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.textLight),
            ),
            const SizedBox(height: 24),
            
            Text(
              'Select Date',
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18, color: AppColors.accentGreen),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        DateFormat('EEEE, MMMM dd, yyyy').format(_selectedDate),
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            Text(
              'Select Meal Types',
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildTypeChip('breakfast', Icons.wb_sunny_outlined),
                const SizedBox(width: 8),
                _buildTypeChip('lunch', Icons.lunch_dining_outlined),
                const SizedBox(width: 8),
                _buildTypeChip('dinner', Icons.nights_stay_outlined),
              ],
            ),
            
            const SizedBox(height: 32),
            
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel', style: GoogleFonts.inter(color: AppColors.textLight)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _handleAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isProcessing
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text('Apply Changes', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String type, IconData icon) {
    final isSelected = _selectedTypes.contains(type);
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedTypes.remove(type);
            } else {
              _selectedTypes.add(type);
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accentGreen.withOpacity(0.1) : Colors.transparent,
            border: Border.all(color: isSelected ? AppColors.accentGreen : Colors.grey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? AppColors.accentGreen : AppColors.textLight, size: 20),
              const SizedBox(height: 4),
              Text(
                type[0].toUpperCase() + type.substring(1),
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppColors.accentGreen : AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleAction() async {
    if (_selectedTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one meal type')),
      );
      return;
    }

    setState(() => _isProcessing = true);
    
    final controller = context.read<UpcomingMealsController>();
    final upcomingMeals = controller.upcomingMeals;
    
    int processedCount = 0;

    for (final type in _selectedTypes) {
      try {
        final meal = upcomingMeals.firstWhere(
          (m) => DateFormat('yyyy-MM-dd').format(m.deliveryDate) == DateFormat('yyyy-MM-dd').format(_selectedDate) &&
                 m.mealType.toLowerCase() == type.toLowerCase()
        );

        bool success;
        if (meal.status.toLowerCase() == 'paused') {
          success = await controller.unpauseMeal(widget.userId, meal.id);
        } else {
          success = await controller.pauseMeal(widget.userId, meal.id);
        }

        if (success) {
          processedCount++;
        }
      } catch (e) {
        // Not found
      }
    }

    if (mounted) {
      setState(() => _isProcessing = false);
      if (processedCount > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully processed $processedCount meals.'), backgroundColor: AppColors.accentGreen),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No matching meals found or operation failed.'), backgroundColor: AppColors.accentRed),
        );
      }
    }
  }
}
