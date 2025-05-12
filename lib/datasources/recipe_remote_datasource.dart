import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe_model.dart';

class RecipeRemoteDatasource {
  final String baseUrl = 'http://192.168.13.74:8000';

Future<List<RecipeModel>> getAllRecipes() async {
  final response = await http.get(
    Uri.parse('$baseUrl/api/recipes/'),
    headers: {
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    print("📥 Gelen veri: $body");

    // Eğer body doğrudan bir listeyse:
    if (body is List) {
      return body.map((json) => RecipeModel.fromJson(json)).toList();
    }

    // Eğer bir map ise ve içinde 'recipes' varsa:
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
// Belirli bir tarifin detaylarını almak
  Future<RecipeModel> getRecipesById(String id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/recipes/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return RecipeModel.fromJson(jsonData);
    } else {
      throw Exception("Tarif alınamadı: ${response.statusCode}");
    }
  }

}
