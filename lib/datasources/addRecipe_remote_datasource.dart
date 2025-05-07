import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/recipe_model.dart';

class AddrecipeRemoteDatasource {
  Future<RecipeModel> uploadRecipe({
    required String authToken,
    required String title,
    String? description, // Nullable yapın
    required List<Map<String, dynamic>> ingredients,
    required List<String> instructions,
    required String foodType,
    required int prepTime,
    required int servings,
    required File imageFile,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.150.74:8000/users/recipes/'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $authToken',
        'Accept': 'application/json',
      });

      // Null kontrolü ile description ekleme
      if (description != null) {
        request.fields['description'] = description;
      }

      // Diğer alanlar
      request.fields.addAll({
        'title': title,
        'ingredients': json.encode(
          ingredients.map((ing) {
            final name = ing['name'] ?? '';
            final quantity = ing['quantity'] ?? '';
            final unit = ing['unit'] ?? '';
            return "$name $quantity $unit".trim();
          }).toList(),
        ),

        'instructions': json.encode(instructions),
        'food_type': foodType,
        'prep_time': prepTime.toString(),
        'servings': servings.toString(),
      });

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        return RecipeModel.fromJson(responseBody);
      } else {
        throw Exception(
          'Status: ${response.statusCode}\nBody: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('API Request Failed: ${e.toString()}');
    }
  }
}
