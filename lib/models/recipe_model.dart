class RecipeModel {
  final String id;
  final String title;
  final String? description; // Nullable
  final List<String> ingredients;
  final List<String> instructions;
  final String? image; // Nullable
  final String user;
  final int? prepTime; // Nullable
  final String? foodType; // Nullable
  final int? servings; // Nullable

  RecipeModel({
    required this.id,
    required this.title,
    this.description,
    required this.ingredients,
    required this.instructions,
    this.image,
    required this.user,
    this.prepTime,
    this.foodType,
    this.servings,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['_id'] ?? '', // Null kontrolü
      title: json['title'] ?? '', // Null kontrolü
      description: json['description'] as String?, // Açıkça nullable
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
      image: json['image'] as String?, // Açıkça nullable
      user: (json['user'] is Map ? json['user']['_id'] : json['user']?.toString()) ?? '',
      prepTime: json['prep_time'] is int ? json['prep_time'] : int.tryParse(json['prep_time']?.toString() ?? '0'),
      foodType: json['food_type'] as String?,
      servings: json['servings'] is int ? json['servings'] : int.tryParse(json['servings']?.toString() ?? '1'),
    );
  }
}