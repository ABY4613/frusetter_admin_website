import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../../controller/admin_log_controller.dart';
import '../../../../../model/admin_log_model.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../widgets/frusette_loader.dart';

class LogTable extends StatelessWidget {
  const LogTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminLogController>(
      builder: (context, controller, child) {
        if (controller.isLoading && controller.logs.isEmpty) {
          return _buildContainer(
            child: const Center(child: FrusetteLoader(size: 60)),
          );
        }

        if (controller.errorMessage != null && controller.logs.isEmpty) {
          return _buildContainer(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      color: AppColors.accentRed, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage!,
                    style: GoogleFonts.inter(color: AppColors.textLight),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.fetchLogs(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Retry Connection', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.logs.isEmpty) {
          return _buildContainer(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off_outlined, color: AppColors.textLight.withOpacity(0.5), size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'No activities found matching your filters.',
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

        return _buildContainer(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 1000) {
                return _buildMobileCardList(context, controller.logs);
              }
              return _buildDesktopTable(context, controller.logs);
            },
          ),
          pagination: controller.pagination,
          onPageChanged: (page) => controller.fetchLogs(page: page),
        );
      },
    );
  }

  Widget _buildContainer({required Widget child, Pagination? pagination, Function(int)? onPageChanged}) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 400),
            child: child,
          ),
          if (pagination != null && pagination.totalPages > 1)
            _buildPagination(pagination, onPageChanged!),
        ],
      ),
    );
  }

  Widget _buildDesktopTable(BuildContext context, List<AdminLog> logs) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowHeight: 56,
        dataRowMaxHeight: 70,
        headingRowColor: WidgetStateProperty.all(AppColors.black.withOpacity(0.02)),
        dividerThickness: 0.5,
        columnSpacing: 30,
        columns: [
          _buildColumn('TIMELINE'),
          _buildColumn('ROLE'),
          _buildColumn('ACTION'),
          _buildColumn('ENTITY TARGET'),
          _buildColumn('AUDIT INFO'),
        ],
        rows: logs.map((log) {
          return DataRow(
            cells: [
              DataCell(Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('MMM dd, yyyy').format(log.createdAt),
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateFormat('hh:mm:ss a').format(log.createdAt),
                    style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight),
                  ),
                ],
              )),
              DataCell(_buildRoleBadge(log.userRole)),
              DataCell(_buildActionBadge(log.action)),
              DataCell(Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      log.entityType.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '#${log.entityId.substring(log.entityId.length - 8)}',
                    style: GoogleFonts.firaCode(fontSize: 11, color: AppColors.textLight),
                  ),
                ],
              )),
              DataCell(
                InkWell(
                  onTap: () => _showLogDetails(context, log),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.accentGreen.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.remove_red_eye_outlined, size: 14, color: AppColors.accentGreen),
                        const SizedBox(width: 6),
                        Text(
                          'View Audit',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMobileCardList(BuildContext context, List<AdminLog> logs) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final log = logs[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.black.withOpacity(0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildRoleBadge(log.userRole),
                  Text(
                    DateFormat('MMM dd, hh:mm a').format(log.createdAt),
                    style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                log.action.replaceAll('_', ' '),
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Target: ',
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.textLight),
                  ),
                  Text(
                    '${log.entityType} (#${log.entityId.substring(log.entityId.length - 6)})',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => _showLogDetails(context, log),
                  icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
                  label: const Text('View Audit Details'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.accentGreen,
                    backgroundColor: AppColors.accentGreen.withOpacity(0.05),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  DataColumn _buildColumn(String label) {
    return DataColumn(
      label: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.black.withOpacity(0.6),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    Color color;
    IconData icon;
    String label = role.toUpperCase();

    switch (role.toLowerCase()) {
      case 'customer':
        color = Colors.blue;
        icon = Icons.person;
        break;
      case 'driver':
        color = Colors.orange;
        icon = Icons.local_shipping;
        label = 'DELIVERY';
        break;
      case 'kitchen':
      case 'kitchen_staff':
        color = Colors.deepPurple;
        icon = Icons.restaurant;
        label = 'KITCHEN';
        break;
      default:
        color = Colors.grey;
        icon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBadge(String action) {
    Color color = AppColors.primaryColor;
    if (action.contains('PAUSE') || action.contains('CANCEL') || action.contains('DELETE')) {
      color = AppColors.accentRed;
    } else if (action.contains('PICKUP') || action.contains('WAITING')) {
      color = AppColors.accentOrange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Text(
        action.replaceAll('_', ' '),
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildPagination(Pagination pagination, Function(int) onPageChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.black.withOpacity(0.05))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing page ${pagination.page} of ${pagination.totalPages}',
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textLight, fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              _buildPageIconBtn(
                icon: Icons.chevron_left,
                isSelected: pagination.page > 1,
                onTap: pagination.page > 1 ? () => onPageChanged(pagination.page - 1) : null,
              ),
              const SizedBox(width: 8),
              _buildPageIconBtn(
                icon: Icons.chevron_right,
                isSelected: pagination.page < pagination.totalPages,
                onTap: pagination.page < pagination.totalPages ? () => onPageChanged(pagination.page + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageIconBtn({required IconData icon, required bool isSelected, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black : AppColors.black.withOpacity(0.02),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: isSelected ? Colors.white : AppColors.textLight),
      ),
    );
  }

  void _showLogDetails(BuildContext context, AdminLog log) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'LogDetails',
      pageBuilder: (context, _, __) => Center(
        child: Container(
          width: 600,
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 40, offset: const Offset(0, 20)),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.analytics_outlined, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Audit Report',
                              style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              'Activity ID: ${log.id}',
                              style: GoogleFonts.inter(color: Colors.white.withOpacity(0.5), fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryItem(Icons.person_outline, 'Initiated By', '${log.userRole.toUpperCase()} (ID: ${log.userId.substring(0, 8)}...)'),
                        _buildSummaryItem(Icons.touch_app_outlined, 'Action Taken', log.action.replaceAll('_', ' ')),
                        _buildSummaryItem(Icons.calendar_today_outlined, 'Exact Time', DateFormat('MMMM dd, yyyy HH:mm:ss').format(log.createdAt)),
                        const SizedBox(height: 24),
                        Text(
                          'ACTIVITY DATA',
                          style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.textLight, letterSpacing: 1.5),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.black.withOpacity(0.05)),
                          ),
                          child: _buildHumanReadablePayload(log.parsedDetails),
                        ),
                      ],
                    ),
                  ),
                ),
                // Footer
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Close Audit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  Widget _buildHumanReadablePayload(Map<String, dynamic> data) {
    List<Widget> items = [];
    
    // Flatten the common "details" nesting if it exists
    Map<String, dynamic> displayData = {};
    if (data.containsKey('details') && data['details'] is Map) {
      displayData.addAll(Map<String, dynamic>.from(data['details']));
      data.forEach((key, value) {
        if (key != 'details') displayData[key] = value;
      });
    } else {
      displayData = data;
    }

    displayData.forEach((key, value) {
      if (value == null) return;
      
      String label = key.replaceAll('_', ' ').split(' ').map((word) {
        if (word.isEmpty) return '';
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }).join(' ');

      String displayValue = '';
      if (value is List) {
        displayValue = value.map((e) => e.toString().toUpperCase()).join(', ');
      } else if (value is Map) {
        displayValue = value.toString();
      } else {
        displayValue = value.toString();
        // Capitalize if it's a short string
        if (displayValue.length < 20 && !displayValue.contains('-') && !displayValue.contains(':')) {
           displayValue = displayValue.toUpperCase();
        }
      }

      items.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textLight,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Text(
                  displayValue,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      // Add separator except for last item
      items.add(Divider(height: 1, color: AppColors.black.withOpacity(0.05)));
    });

    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text('No additional details provided.', style: GoogleFonts.inter(color: AppColors.textLight)),
      );
    }

    // Remove last divider
    if (items.isNotEmpty) items.removeLast();

    return Column(children: items);
  }

  Widget _buildSummaryItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textLight),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textLight, fontWeight: FontWeight.w500)),
              Text(value, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.black)),
            ],
          ),
        ],
      ),
    );
  }
}
