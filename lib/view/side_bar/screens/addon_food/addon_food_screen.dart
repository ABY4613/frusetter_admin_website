import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../controller/addon_food_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../model/addon_food.dart';
import '../../../../widgets/frusette_loader.dart';
import 'widgets/create_addon_food_dialog.dart';

class AddonFoodScreen extends StatefulWidget {
  const AddonFoodScreen({super.key});

  @override
  State<AddonFoodScreen> createState() => _AddonFoodScreenState();
}

class _AddonFoodScreenState extends State<AddonFoodScreen> {
  String _selectedCategory = 'All';
  String _selectedSort = 'Newest First';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddonFoodController>().fetchAddonFoods();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildStatsCards(),
                const SizedBox(height: 32),
                _buildFilters(),
                const SizedBox(height: 32),
                _buildAddonFoodList(),
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
                color: const Color(0xFF6B7280),
                fontSize: 14,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child:
                  Icon(Icons.chevron_right, size: 16, color: Color(0xFF6B7280)),
            ),
            Text(
              'Add-on Food',
              style: GoogleFonts.inter(
                color: Colors.black,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add-on Food Management',
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage your add-on food items and inventory',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF6B7280),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const CreateAddonFoodDialog(),
                );
              },
              icon: const Icon(Icons.add, size: 18),
              label: Text(
                'Add New Item',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentGreen,
                foregroundColor: Colors.black,
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

  Widget _buildStatsCards() {
    return Consumer<AddonFoodController>(
      builder: (context, controller, _) {
        final totalItems = controller.addonFoods.length;
        final availableItems =
            controller.addonFoods.where((item) => item.isAvailable).length;
        final unavailableItems = totalItems - availableItems;
        final totalValue = controller.addonFoods.fold<double>(
          0,
          (sum, item) => sum + item.price,
        );

        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Items',
                totalItems.toString(),
                Icons.restaurant_menu,
                const Color(0xFF3B82F6),
                const Color(0xFFDEEBFF),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Available',
                availableItems.toString(),
                Icons.check_circle,
                const Color(0xFF10B981),
                const Color(0xFFD1FAE5),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Unavailable',
                unavailableItems.toString(),
                Icons.cancel,
                const Color(0xFFF87171),
                const Color(0xFFFEE2E2),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                'Avg. Price',
                '₹${totalItems > 0 ? (totalValue / totalItems).toStringAsFixed(0) : '0'}',
                Icons.currency_rupee,
                const Color(0xFFFBBF24),
                const Color(0xFFFEF3C7),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF6B7280),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Consumer<AddonFoodController>(
      builder: (context, controller, _) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildFilterDropdown(
              label: _selectedCategory,
              options: controller.categories,
              selected: _selectedCategory,
              onSelected: (val) {
                setState(() {
                  _selectedCategory = val;
                });
              },
            ),
            _buildFilterDropdown(
              label: _selectedSort,
              options: [
                'Newest First',
                'Oldest First',
                'Price: Low to High',
                'Price: High to Low',
                'Name: A-Z'
              ],
              selected: _selectedSort,
              onSelected: (val) {
                setState(() {
                  _selectedSort = val;
                });
              },
            ),
          ],
        );
      },
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

  Widget _buildAddonFoodList() {
    return Consumer<AddonFoodController>(
      builder: (context, controller, _) {
        if (controller.isLoading) {
          return const Center(child: FrusetteLoader());
        }

        if (controller.addonFoods.isEmpty) {
          return _buildEmptyState();
        }

        var displayedItems = _selectedCategory == 'All'
            ? controller.addonFoods
            : controller.getByCategory(_selectedCategory);

        // Apply sorting
        displayedItems = List.from(displayedItems);
        switch (_selectedSort) {
          case 'Newest First':
            displayedItems.sort((a, b) => (b.createdAt ?? DateTime.now())
                .compareTo(a.createdAt ?? DateTime.now()));
            break;
          case 'Oldest First':
            displayedItems.sort((a, b) => (a.createdAt ?? DateTime.now())
                .compareTo(b.createdAt ?? DateTime.now()));
            break;
          case 'Price: Low to High':
            displayedItems.sort((a, b) => a.price.compareTo(b.price));
            break;
          case 'Price: High to Low':
            displayedItems.sort((a, b) => b.price.compareTo(a.price));
            break;
          case 'Name: A-Z':
            displayedItems.sort((a, b) => a.title.compareTo(b.title));
            break;
        }

        if (displayedItems.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                'No items found in this category',
                style: GoogleFonts.inter(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          );
        }

        return Column(
          children:
              displayedItems.map((item) => _buildAddonFoodCard(item)).toList(),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restaurant_menu,
                size: 64,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Add-on Food Items Yet',
              style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start by adding your first add-on food item',
              style: GoogleFonts.inter(
                color: const Color(0xFF6B7280),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const CreateAddonFoodDialog(),
                );
              },
              icon: const Icon(Icons.add, size: 18),
              label: Text(
                'Add First Item',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentGreen,
                foregroundColor: Colors.black,
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
      ),
    );
  }

  Widget _buildAddonFoodCard(AddonFood item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: item.isAvailable
              ? AppColors.accentGreen.withOpacity(0.3)
              : Colors.grey.shade300,
          width: item.isAvailable ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, 8),
            blurRadius: 24,
          ),
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
                // Availability Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: item.isAvailable
                        ? const LinearGradient(
                            colors: [
                              Color(0xFF8AC53D),
                              Color(0xFF6A9F2E),
                            ],
                          )
                        : null,
                    color: item.isAvailable ? null : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.isAvailable ? Icons.check_circle : Icons.cancel,
                        color: item.isAvailable
                            ? Colors.white
                            : Colors.grey.shade600,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.isAvailable ? 'AVAILABLE' : 'UNAVAILABLE',
                        style: GoogleFonts.inter(
                          color: item.isAvailable
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
                // Category Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.category,
                        color: Color(0xFF3B82F6),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.category.toUpperCase(),
                        style: GoogleFonts.inter(
                          color: const Color(0xFF3B82F6),
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
                if (item.createdAt != null)
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
                          'Added ${item.formattedCreatedAt}',
                          style: GoogleFonts.inter(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Menu Button
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            CreateAddonFoodDialog(editItem: item),
                      );
                    } else if (value == 'delete') {
                      _confirmDelete(item);
                    } else if (value == 'toggle') {
                      context
                          .read<AddonFoodController>()
                          .toggleAvailability(item.id!);
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'toggle',
                      child: Row(
                        children: [
                          Icon(
                            item.isAvailable
                                ? Icons.cancel
                                : Icons.check_circle,
                            color:
                                item.isAvailable ? Colors.orange : Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            item.isAvailable
                                ? 'Mark Unavailable'
                                : 'Mark Available',
                            style: GoogleFonts.inter(color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit_outlined,
                              color: Colors.black87, size: 20),
                          const SizedBox(width: 12),
                          Text('Edit Item',
                              style: GoogleFonts.inter(color: Colors.black87)),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Stock Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Stock Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: item.isOutOfStock
                            ? Colors.red.withOpacity(0.1)
                            : item.isLowStock
                                ? Colors.orange.withOpacity(0.1)
                                : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: item.isOutOfStock
                              ? Colors.red.withOpacity(0.3)
                              : item.isLowStock
                                  ? Colors.orange.withOpacity(0.3)
                                  : Colors.green.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inventory_2,
                            color: item.isOutOfStock
                                ? Colors.red
                                : item.isLowStock
                                    ? Colors.orange
                                    : Colors.green,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Stock: ${item.stockQuantity}',
                            style: GoogleFonts.inter(
                              color: item.isOutOfStock
                                  ? Colors.red
                                  : item.isLowStock
                                      ? Colors.orange
                                      : Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Description
                Text(
                  item.description,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF6B7280),
                    fontSize: 15,
                    height: 1.6,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                // Tags
                if (item.tags.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: item.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accentGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.accentGreen.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          '#$tag',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF65902D),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                if (item.tags.isNotEmpty) const SizedBox(height: 16),
                // Nutrition Info
                if (item.nutritionInfo != null &&
                    item.nutritionInfo!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.blue.shade700, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.nutritionInfo!,
                            style: GoogleFonts.inter(
                              color: Colors.blue.shade900,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (item.nutritionInfo != null &&
                    item.nutritionInfo!.isNotEmpty)
                  const SizedBox(height: 16),
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
                      item.price.toStringAsFixed(0),
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
                        '/ item',
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
        ],
      ),
    );
  }

  void _confirmDelete(AddonFood item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        title: Text(
          'Delete Item',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${item.title}"? This action cannot be undone.',
          style: GoogleFonts.inter(
            color: AppColors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                color: AppColors.textLight,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await context
                  .read<AddonFoodController>()
                  .deleteAddonFood(item.id!);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item.title} deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: Text(
              'Delete',
              style: GoogleFonts.inter(
                color: AppColors.accentRed,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
