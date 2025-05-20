import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe_model.dart';

class RecipeRemoteDatasource {
  final String baseUrl = 'http://10.40.127.2:8000';

  Future<List<RecipeModel>> getAllRecipes() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/recipes/'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final body = json.decode(decodedBody);
      print("📥 Gelen veri: $body");

      if (body is List) {
        return body.map((json) => RecipeModel.fromJson(json)).toList();
      }

      if (body is Map<String, dynamic> && body['results'] is List) {
        return (body['results'] as List)
            .map((json) => RecipeModel.fromJson(json))
            .toList();
      }

      throw Exception('Beklenmeyen veri formatı: $body');
    } else {
      throw Exception('Failed to load recipes: ${response.statusCode}');
    }
  }

  Future<RecipeModel> getRecipesById(String id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/recipes/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(decodedBody);
      return RecipeModel.fromJson(jsonData);
    } else {
      throw Exception("Tarif alınamadı: ${response.statusCode}");
    }
  }

  // Belirli bir tarifin detaylarını almak
  Future<void> deleteRecipeById(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/recipes/$id/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 204) {
      // Başarıyla silindi, herhangi bir şey döndürmeye gerek yok
      return;
    } else {
      throw Exception("Tarif silinemedi: ${response.statusCode}");
    }
  }
}
