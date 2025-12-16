class MealPlan {
  final String id;
  final String name;
  final String description;
  final int calories;
  final List<String> dietaryPreferences; // e.g., Vegan, Keto
  final double price;
  final String imageUrl;
  final bool isAvailable;

  MealPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.calories,
    required this.dietaryPreferences,
    required this.price,
    required this.imageUrl,
    required this.isAvailable,
  });
}
