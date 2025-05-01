import 'dart:io';
import '../datasources/addRecipe_remote_datasource.dart';
import '../models/recipe_model.dart';

class AddrecipeRepository {
  final AddrecipeRemoteDatasource _remoteDatasource = AddrecipeRemoteDatasource();

  Future<RecipeModel> uploadRecipe({
    required String authToken,
    required String title,
    String? description,
    required List<Map<String, dynamic>> ingredients,
    required List<String> instructions,
    required String foodType,
    required int prepTime,
    required int servings,
    required File imageFile,
  }) async {
    try {
      return await _remoteDatasource.uploadRecipe(
        authToken: authToken,
        title: title,
        description: description ?? '', // Varsayılan değer
        ingredients: ingredients,
        instructions: instructions,
        foodType: foodType,
        prepTime: prepTime,
        servings: servings,
        imageFile: imageFile,
      );
    } catch (e) {
      if (e.toString().contains('401')) {
        throw Exception('Oturum sona erdi. Lütfen tekrar giriş yapın.');
      } else {
        throw Exception('Tarif eklenirken hata oluştu: ${e.toString()}');
      }
    }
  }
}