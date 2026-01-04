import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../controller/subscription_controller.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionFilters extends StatefulWidget {
  const SubscriptionFilters({super.key});

  @override
  State<SubscriptionFilters> createState() => _SubscriptionFiltersState();
}

class _SubscriptionFiltersState extends State<SubscriptionFilters> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Immediate filtering since it's frontend-based
    context.read<SubscriptionController>().updateSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionController>(
      builder: (context, controller, _) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            border:
                Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1))),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "SEARCH",
                      style: GoogleFonts.inter(
                        color: AppColors.black.withOpacity(0.5),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 48,
                      child: TextField(
                        controller: _searchController,
                        enableSuggestions: false,
                        autocorrect: false,
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          hintText: "Search by customer name, email...",
                          hintStyle: GoogleFonts.inter(color: Colors.grey),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.grey, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    controller.updateSearch('');
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: AppColors.accentGreen),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        style: GoogleFonts.inter(color: AppColors.black),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "STATUS",
                      style: GoogleFonts.inter(
                        color: AppColors.black.withOpacity(0.5),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.statusFilter,
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: AppColors.black),
                          isExpanded: true,
                          style: GoogleFonts.inter(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500),
                          items: const [
                            DropdownMenuItem(
                                value: "all", child: Text("All Statuses")),
                            DropdownMenuItem(
                                value: "active", child: Text("Active")),
                            DropdownMenuItem(
                                value: "paused", child: Text("Paused")),
                            DropdownMenuItem(
                                value: "expired", child: Text("Expired")),
                            DropdownMenuItem(
                                value: "cancelled", child: Text("Cancelled")),
                            DropdownMenuItem(
                                value: "pending", child: Text("Pending")),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              controller.updateStatusFilter(val);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  // Refresh subscriptions
                  controller.refreshSubscriptions();
                },
                icon: controller.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.accentGreen,
                        ),
                      )
                    : const Icon(Icons.refresh,
                        color: AppColors.black, size: 20),
                label: Text(
                  "Refresh",
                  style: GoogleFonts.inter(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
