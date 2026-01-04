import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:frusette_admin_operations_web_dashboard/core/theme/app_colors.dart';
import 'package:frusette_admin_operations_web_dashboard/controller/cutoff_controller.dart';
import 'package:frusette_admin_operations_web_dashboard/model/cutoff_setting.dart';

class CutoffSettingsScreen extends StatefulWidget {
  const CutoffSettingsScreen({super.key});

  @override
  State<CutoffSettingsScreen> createState() => _CutoffSettingsScreenState();
}

class _CutoffSettingsScreenState extends State<CutoffSettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch cutoff settings when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CutoffController>().fetchCutoffSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Consumer<CutoffController>(
        builder: (context, controller, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 900;

              return SingleChildScrollView(
                padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(controller),
                    const SizedBox(height: 32),
                    if (controller.isLoading)
                      _buildLoadingState()
                    else if (controller.errorMessage != null)
                      _buildErrorState(controller)
                    else
                      _buildCutoffCards(isMobile, controller),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(CutoffController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Settings',
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
                    'Cutoff Time',
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
                'Cutoff Time Settings',
                style: GoogleFonts.inter(
                  color: AppColors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Configure order cutoff times for each meal. Orders placed after the cutoff time will be scheduled for the next day.',
                style: GoogleFonts.inter(
                  color: AppColors.textLight,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        OutlinedButton.icon(
          onPressed: () => controller.refreshCutoffSettings(),
          icon: const Icon(Icons.refresh, size: 18),
          label: Text(
            'Refresh',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.black,
            side: BorderSide(color: Colors.grey.shade300),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading cutoff settings...',
              style: GoogleFonts.inter(
                color: AppColors.textLight,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(CutoffController controller) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load settings',
              style: GoogleFonts.inter(
                color: AppColors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage ?? 'Unknown error',
              style: GoogleFonts.inter(
                color: AppColors.textLight,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => controller.fetchCutoffSettings(),
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(
                'Retry',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCutoffCards(bool isMobile, CutoffController controller) {
    final mealTypes = ['breakfast', 'lunch', 'dinner'];

    final cards = mealTypes.map((mealType) {
      final setting = controller.getCutoffByMealType(mealType);
      return _buildMealCutoffCard(
        mealType: mealType,
        setting: setting,
        controller: controller,
      );
    }).toList();

    if (isMobile) {
      return Column(
        children: cards
            .map((card) => Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: card,
                ))
            .toList(),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: cards[0]),
        const SizedBox(width: 24),
        Expanded(child: cards[1]),
        const SizedBox(width: 24),
        Expanded(child: cards[2]),
      ],
    );
  }

  Widget _buildMealCutoffCard({
    required String mealType,
    CutoffSetting? setting,
    required CutoffController controller,
  }) {
    final mealConfig = _getMealConfig(mealType);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: mealConfig['gradient'] as List<Color>,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: (mealConfig['color'] as Color).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: (mealConfig['color'] as Color).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    mealConfig['icon'] as IconData,
                    size: 40,
                    color: mealConfig['color'] as Color,
                  ),
                ),
                const SizedBox(height: 20),

                // Meal Type Title
                Text(
                  mealConfig['title'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  mealConfig['description'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textLight,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Cutoff Time Display
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_filled,
                      size: 20,
                      color: mealConfig['color'] as Color,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Current Cutoff Time',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  setting?.formattedCutoffTime ?? 'Not Set',
                  style: GoogleFonts.inter(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color:
                        setting != null ? AppColors.black : AppColors.textLight,
                  ),
                ),
                if (setting != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 14,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Active',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Edit Button
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    _showEditCutoffDialog(mealType, setting, controller),
                icon: Icon(
                  setting != null ? Icons.edit : Icons.add,
                  size: 18,
                ),
                label: Text(
                  setting != null ? 'Edit Cutoff Time' : 'Set Cutoff Time',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mealConfig['color'] as Color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getMealConfig(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return {
          'title': 'Breakfast',
          'description': 'Morning meal cutoff time',
          'icon': Icons.wb_sunny_outlined,
          'color': Colors.orange,
          'gradient': [
            Colors.orange.withOpacity(0.1),
            Colors.orange.withOpacity(0.05),
          ],
        };
      case 'lunch':
        return {
          'title': 'Lunch',
          'description': 'Afternoon meal cutoff time',
          'icon': Icons.lunch_dining,
          'color': AppColors.primaryColor,
          'gradient': [
            AppColors.primaryColor.withOpacity(0.1),
            AppColors.primaryColor.withOpacity(0.05),
          ],
        };
      case 'dinner':
        return {
          'title': 'Dinner',
          'description': 'Evening meal cutoff time',
          'icon': Icons.nightlight_outlined,
          'color': Colors.indigo,
          'gradient': [
            Colors.indigo.withOpacity(0.1),
            Colors.indigo.withOpacity(0.05),
          ],
        };
      default:
        return {
          'title': mealType,
          'description': 'Meal cutoff time',
          'icon': Icons.restaurant,
          'color': Colors.grey,
          'gradient': [
            Colors.grey.withOpacity(0.1),
            Colors.grey.withOpacity(0.05),
          ],
        };
    }
  }

  void _showEditCutoffDialog(
    String mealType,
    CutoffSetting? setting,
    CutoffController controller,
  ) {
    final mealConfig = _getMealConfig(mealType);
    int selectedHour = setting?.cutoffTimeOfDay.hour ?? 20;
    int selectedMinute = setting?.cutoffTimeOfDay.minute ?? 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 420,
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Icon
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color:
                              (mealConfig['color'] as Color).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          mealConfig['icon'] as IconData,
                          size: 30,
                          color: mealConfig['color'] as Color,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title
                      Text(
                        setting != null
                            ? 'Edit ${mealConfig['title']} Cutoff'
                            : 'Set ${mealConfig['title']} Cutoff',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Set the order cutoff time for ${mealConfig['title'].toString().toLowerCase()}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Time Picker
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Select Cutoff Time',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textLight,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Hour Picker
                                _buildTimePickerColumn(
                                  value: selectedHour,
                                  maxValue: 23,
                                  onChanged: (value) {
                                    setDialogState(() {
                                      selectedHour = value;
                                    });
                                  },
                                  color: mealConfig['color'] as Color,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    ':',
                                    style: GoogleFonts.inter(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                                // Minute Picker
                                _buildTimePickerColumn(
                                  value: selectedMinute,
                                  maxValue: 59,
                                  onChanged: (value) {
                                    setDialogState(() {
                                      selectedMinute = value;
                                    });
                                  },
                                  color: mealConfig['color'] as Color,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Display formatted time
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: (mealConfig['color'] as Color)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _formatTime(selectedHour, selectedMinute),
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: mealConfig['color'] as Color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.black,
                                side: BorderSide(color: Colors.grey.shade300),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Consumer<CutoffController>(
                              builder: (context, ctrl, child) {
                                return ElevatedButton(
                                  onPressed: ctrl.isSaving
                                      ? null
                                      : () async {
                                          final timeString =
                                              '${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}';

                                          bool success;
                                          if (setting != null) {
                                            success =
                                                await ctrl.updateCutoffSetting(
                                              mealType: mealType,
                                              cutoffTime: timeString,
                                            );
                                          } else {
                                            success =
                                                await ctrl.createCutoffSetting(
                                              mealType: mealType,
                                              cutoffTime: timeString,
                                            );
                                          }

                                          if (success && context.mounted) {
                                            Navigator.pop(context);
                                            _showSuccessSnackBar(
                                              'Cutoff time for ${mealConfig['title']} updated successfully!',
                                            );
                                          } else if (context.mounted) {
                                            _showErrorSnackBar(
                                              ctrl.errorMessage ??
                                                  'Failed to save cutoff time',
                                            );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        mealConfig['color'] as Color,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor:
                                        (mealConfig['color'] as Color)
                                            .withOpacity(0.5),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: ctrl.isSaving
                                      ? SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        )
                                      : Text(
                                          'Save',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600),
                                        ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimePickerColumn({
    required int value,
    required int maxValue,
    required Function(int) onChanged,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Up Button
          IconButton(
            onPressed: () {
              int newValue = value + 1;
              if (newValue > maxValue) newValue = 0;
              onChanged(newValue);
            },
            icon: Icon(Icons.keyboard_arrow_up, color: color),
            iconSize: 28,
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
          ),
          // Value Display
          Container(
            width: 70,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              value.toString().padLeft(2, '0'),
              style: GoogleFonts.inter(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Down Button
          IconButton(
            onPressed: () {
              int newValue = value - 1;
              if (newValue < 0) newValue = maxValue;
              onChanged(newValue);
            },
            icon: Icon(Icons.keyboard_arrow_down, color: color),
            iconSize: 28,
            padding: const EdgeInsets.all(4),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  String _formatTime(int hour, int minute) {
    final period = hour >= 12 ? 'PM' : 'AM';
    int displayHour = hour;
    if (displayHour > 12) displayHour -= 12;
    if (displayHour == 0) displayHour = 12;
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
