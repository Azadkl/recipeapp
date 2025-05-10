class IsLikeResponse {
  final String detail;
  final bool isLiked;

  IsLikeResponse({
    required this.detail,
    required this.isLiked,
  });

  factory IsLikeResponse.fromJson(Map<String, dynamic> json) {
    return IsLikeResponse(
      detail: json['detail'] ?? '',
      isLiked: json['is_liked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detail': detail,
      'is_liked': isLiked,
    };
  }
}
