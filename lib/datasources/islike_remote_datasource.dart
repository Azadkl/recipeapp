import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipeapp/models/islike_toggle_model.dart';

class LikeRemoteDataSource {
  final String baseUrl =
      "https://booknest-7-an7g.onrender.com"; // Senin IP adresin

  // Beğenme işlemini yapma (toggle like)
  Future<IsLikeResponse> toggleLike(String recipeId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/likes/toggle/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'recipe': recipeId}), // Sadece recipeId gönder
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return IsLikeResponse.fromJson(json.decode(decodedBody));
    } else {
      print("Like eklenemedi: ${utf8.decode(response.bodyBytes)}");
      throw Exception("Like eklenemedi: ${utf8.decode(response.bodyBytes)}");
    }
  }
}
