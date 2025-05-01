class UserModel {
  final String id;
  final String username;
  final String email;
  final String password; // Password burada gerekli
  final String access;
  final String refresh;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password, // Password burada gerekli
    required this.access,
    required this.refresh,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'] ?? "", // Password verisini kontrol et
      access: json['access'] ?? "",
      refresh: json['refresh'] ?? "",
    );
  }
}
