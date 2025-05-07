class BookmarkResponse {
  final String detail;
  final bool isBookmarked;

  BookmarkResponse({
    required this.detail,
    required this.isBookmarked,
  });

  factory BookmarkResponse.fromJson(Map<String, dynamic> json) {
    return BookmarkResponse(
      detail: json['detail'] ?? '',
      isBookmarked: json['is_bookmarked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detail': detail,
      'is_bookmarked': isBookmarked,
    };
  }
}
