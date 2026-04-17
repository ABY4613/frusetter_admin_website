class UpcomingMeal {
  final String id;
  final String subscriptionId;
  final String userId;
  final DateTime deliveryDate;
  final String mealType;
  final String mealName;
  final String deliverySlot;
  final String addressId;
  final String status;
  final bool isCustomRequest;
  final String specialInstructions;
  final DateTime createdAt;
  final DateTime updatedAt;

  UpcomingMeal({
    required this.id,
    required this.subscriptionId,
    required this.userId,
    required this.deliveryDate,
    required this.mealType,
    required this.mealName,
    required this.deliverySlot,
    required this.addressId,
    required this.status,
    required this.isCustomRequest,
    required this.specialInstructions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UpcomingMeal.fromJson(Map<String, dynamic> json) {
    return UpcomingMeal(
      id: json['ID'] ?? '',
      subscriptionId: json['SubscriptionID'] ?? '',
      userId: json['UserID'] ?? '',
      deliveryDate: (DateTime.tryParse(json['DeliveryDate'] ?? '') ?? DateTime.now()).toLocal(),
      mealType: json['MealType'] ?? '',
      mealName: json['meal_name'] ?? '',
      deliverySlot: json['DeliverySlot'] ?? '',
      addressId: json['AddressID'] ?? '',
      status: json['Status'] ?? '',
      isCustomRequest: json['is_custom_request'] ?? false,
      specialInstructions: json['SpecialInstructions'] ?? '',
      createdAt: (DateTime.tryParse(json['CreatedAt'] ?? '') ?? DateTime.now()).toLocal(),
      updatedAt: (DateTime.tryParse(json['UpdatedAt'] ?? '') ?? DateTime.now()).toLocal(),
    );
  }
}
