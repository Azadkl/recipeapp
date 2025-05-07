class BookmarkModel {
  final String id;
  final String userId;
  final String recipeId;

  BookmarkModel({
    required this.id,
    required this.userId,
    required this.recipeId,
  });

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      id: json['id'] ?? '',
      userId: json['user'] ?? '',
      recipeId: json['recipe'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': userId,
      'recipe': recipeId,
    };
  }
}
