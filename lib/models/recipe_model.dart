class RecipeModel {
  final String id;
  final String title;
  final String? description;
  final List<String> ingredients;
  final List<String> instructions;
  final String? image;
  final String username;
  final int prepTime;
  final String foodType;
  final int servings;
  final bool? isBookmarked; // Yeni alan
  final bool? isLiked;      // Yeni alan
 final int likesCount; 
  RecipeModel({
    required this.id,
    required this.title,
    this.description,
    required this.ingredients,
    required this.instructions,
    this.image,
    required this.username,
    required this.prepTime,
    required this.foodType,
    required this.servings,
    this.isBookmarked,
    this.isLiked,
    required this.likesCount, 
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] as String?,
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
      image: json['image'] as String?,
      username: _extractUsername(json['user']),
      prepTime: json['prep_time'] is int
          ? json['prep_time']
          : int.tryParse(json['prep_time']?.toString() ?? '0') ?? 0,
      foodType: json['food_type']?.toString() ?? '',
      servings: json['servings'] is int
          ? json['servings']
          : int.tryParse(json['servings']?.toString() ?? '1') ?? 1,
      isBookmarked: json['isBookmarked'] as bool?, // Yeni alan
      isLiked: json['isLiked'] as bool?,           // Yeni alan
      likesCount: json['likes_count'] is int
          ? json['likes_count']
          : int.tryParse(json['likes_count']?.toString() ?? '0') ?? 0,  // Yeni alan
    );
  }

  static String _extractUsername(dynamic userData) {
    if (userData != null && userData is Map<String, dynamic>) {
      return userData['username']?.toString().trim() ?? 'Anonim';
    }
    return 'Anonim';
  }
  
}
