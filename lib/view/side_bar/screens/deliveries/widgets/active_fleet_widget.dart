import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ActiveFleetWidget extends StatelessWidget {
  const ActiveFleetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Active Fleet",
                  style: GoogleFonts.inter(
                    color: AppColors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    _buildFilterButton("Status: All"),
                    const SizedBox(width: 8),
                    _buildFilterButton("Sort: Delayed"),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
          // Table Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(flex: 3, child: _buildHeaderCell("DRIVER")),
                Expanded(flex: 2, child: _buildHeaderCell("STATUS")),
                Expanded(flex: 3, child: _buildHeaderCell("PROGRESS")),
                Expanded(
                    flex: 1,
                    child:
                        _buildHeaderCell("DELAYED", align: TextAlign.center)),
                SizedBox(width: 40), // Spacer for action button
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
          // Rows
          _buildFleetRow(
              "Marcus J.", "ID: #8821", true, 0.66, "8/12 Assigned", "66%", 0),
          Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
          _buildFleetRow(
              "Sarah L.", "ID: #8824", true, 0.93, "14/15 Assigned", "93%", 1),
          Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
          _buildFleetRow(
              "David K.", "ID #8830", false, 1.0, "10/10 Completed", "100%", 0),
          Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
          _buildFleetRow(
              "Priya M.", "ID: #8832", true, 0.45, "9/20 Assigned", "45%", 0),
          Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
          _buildFleetRow(
              "James T.", "ID: #8841", true, 0.22, "5/22 Assigned", "22%", 2),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(text,
              style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600)),
          const SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.black),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {TextAlign align = TextAlign.left}) {
    return Text(
      text,
      textAlign: align,
      style: GoogleFonts.inter(
        color: AppColors.black.withOpacity(0.5),
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildFleetRow(String name, String id, bool isOnline, double progress,
      String progressText, String percentText, int delayedCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Driver
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: const AssetImage('assets/images/image.png'),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: AppColors.black)),
                    Text(id,
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppColors.black.withOpacity(0.5))),
                  ],
                ),
              ],
            ),
          ),
          // Status
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isOnline
                        ? AppColors.accentGreen.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: isOnline
                            ? AppColors.accentGreen.withOpacity(0.5)
                            : Colors.grey.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.circle,
                          size: 8,
                          color:
                              isOnline ? AppColors.accentGreen : Colors.grey),
                      const SizedBox(width: 6),
                      Text(
                        isOnline ? "Online" : "Offline",
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isOnline
                                ? AppColors.accentGreen
                                : Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Progress
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(progressText,
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppColors.black.withOpacity(0.7))),
                    Text(percentText,
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.withOpacity(0.1),
                    color: AppColors.accentGreen,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          // Delayed
          Expanded(
            flex: 1,
            child: Center(
              child: delayedCount > 0
                  ? Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.accentRed.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        delayedCount.toString(),
                        style: TextStyle(
                            color: AppColors.accentRed,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    )
                  : Text("0",
                      style:
                          TextStyle(color: AppColors.black.withOpacity(0.5))),
            ),
          ),
          // Actions
          IconButton(
            icon: Icon(Icons.more_vert,
                size: 20, color: AppColors.black.withOpacity(0.5)),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
