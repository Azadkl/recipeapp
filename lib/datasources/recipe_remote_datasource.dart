import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe_model.dart';

class RecipeRemoteDatasource {
  final String baseUrl = 'https://booknest-7-an7g.onrender.com';

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

  // Son eklenen tarifleri getir
  Future<List<RecipeModel>> getRecentRecipes({int limit = 10}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/recipes/recent/?limit=$limit'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final body = json.decode(decodedBody);

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
      throw Exception('Failed to load recent recipes: ${response.statusCode}');
    }
  }

  // Malzemelere göre tarifleri getir
  Future<List<RecipeModel>> getRecipesByIngredients(
    List<String> ingredients,
  ) async {
    print("🟢 Gönderilen malzemeler: $ingredients");
    final response = await http.post(
      Uri.parse('$baseUrl/api/recipes/by-ingredients/'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({'ingredients': ingredients}), // <-- Dict olarak gönder
    );

    print("🔵 Dönen response status: ${response.statusCode}");
    print("🔵 Dönen response body: ${utf8.decode(response.bodyBytes)}");

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final body = json.decode(decodedBody);

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
      throw Exception(
        'Failed to load recipes by ingredients: ${response.statusCode}',
      );
    }
  }
}
