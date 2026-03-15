import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../../controller/admin_log_controller.dart';
import '../../../../../core/theme/app_colors.dart';

class LogHeader extends StatelessWidget {
  const LogHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;
        
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'System Activity Logs',
                        style: GoogleFonts.inter(
                          fontSize: isMobile ? 24 : 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Monitor and audit all real-time actions across the platform',
                        style: GoogleFonts.inter(
                          fontSize: isMobile ? 12 : 14,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isMobile) _buildRefreshButton(context),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.black.withOpacity(0.05)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        // We could add search logic here if supported by API
                      },
                      decoration: InputDecoration(
                        hintText: 'Search logs (Action, ID, Entity)...',
                        hintStyle: GoogleFonts.inter(
                          color: AppColors.textLight,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(Icons.search, color: AppColors.textLight, size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ),
                if (isMobile) ...[
                  const SizedBox(width: 12),
                  _buildRefreshButton(context, iconOnly: true),
                ],
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildRefreshButton(BuildContext context, {bool iconOnly = false}) {
    return InkWell(
      onTap: () => context.read<AdminLogController>().fetchLogs(page: 1),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: iconOnly ? 12 : 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: AppColors.accentGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.accentGreen.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.refresh, color: AppColors.accentGreen, size: 20),
            if (!iconOnly) ...[
              const SizedBox(width: 8),
              Text(
                'Refresh Logs',
                style: GoogleFonts.inter(
                  color: AppColors.accentGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
