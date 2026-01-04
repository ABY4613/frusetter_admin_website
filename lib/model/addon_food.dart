class AddonFood {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String category;
  final bool isAvailable;
  final int stockQuantity;
  final List<String> tags;
  final String? nutritionInfo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AddonFood({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    this.isAvailable = true,
    this.stockQuantity = 0,
    this.tags = const [],
    this.nutritionInfo,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor from JSON
  factory AddonFood.fromJson(Map<String, dynamic> json) {
    return AddonFood(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
      isAvailable: json['is_available'] ?? true,
      stockQuantity: json['stock_quantity'] ?? 0,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      nutritionInfo: json['nutrition_info'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  // Convert to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'is_available': isAvailable,
      'stock_quantity': stockQuantity,
      'tags': tags,
      if (nutritionInfo != null && nutritionInfo!.isNotEmpty)
        'nutrition_info': nutritionInfo,
    };
  }

  // Copy with method for updates
  AddonFood copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? category,
    bool? isAvailable,
    int? stockQuantity,
    List<String>? tags,
    String? nutritionInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AddonFood(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      tags: tags ?? this.tags,
      nutritionInfo: nutritionInfo ?? this.nutritionInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Formatted created date
  String get formattedCreatedAt {
    if (createdAt == null) return 'N/A';
    final now = DateTime.now();
    final difference = now.difference(createdAt!);

    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return 'Just now';
    }
  }

  // Get stock status
  String get stockStatus {
    if (stockQuantity == 0) return 'Out of Stock';
    if (stockQuantity < 20) return 'Low Stock';
    return 'In Stock';
  }

  // Get stock status color
  bool get isLowStock => stockQuantity < 20 && stockQuantity > 0;
  bool get isOutOfStock => stockQuantity == 0;
}

// Response model for list API
class AddonFoodListResponse {
  final List<AddonFood> addons;
  final PaginationInfo pagination;
  final bool success;

  AddonFoodListResponse({
    required this.addons,
    required this.pagination,
    required this.success,
  });

  factory AddonFoodListResponse.fromJson(Map<String, dynamic> json) {
    return AddonFoodListResponse(
      addons: (json['data']['addons'] as List)
          .map((item) => AddonFood.fromJson(item))
          .toList(),
      pagination: PaginationInfo.fromJson(json['data']['pagination']),
      success: json['success'] ?? false,
    );
  }
}

// Pagination info model
class PaginationInfo {
  final int limit;
  final int page;
  final int total;
  final int totalPages;

  PaginationInfo({
    required this.limit,
    required this.page,
    required this.total,
    required this.totalPages,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      limit: json['limit'] ?? 50,
      page: json['page'] ?? 1,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
    );
  }
}
