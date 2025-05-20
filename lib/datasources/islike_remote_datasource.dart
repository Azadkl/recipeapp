import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipeapp/models/islike_toggle_model.dart';

class LikeRemoteDataSource {
  final String baseUrl = "http://10.40.127.2:8000"; // Senin IP adresin

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
      return IsLikeResponse.fromJson(json.decode(response.body));
    } else {
      print("Like eklenemedi: ${response.body}");
      throw Exception("Like eklenemedi: ${response.body}");
    }
  }
}
