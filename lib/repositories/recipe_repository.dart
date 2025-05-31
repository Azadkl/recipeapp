import '../datasources/recipe_remote_datasource.dart';
import '../models/recipe_model.dart';

class RecipeRepository {
  final RecipeRemoteDatasource _remoteDatasource = RecipeRemoteDatasource();

  Future<List<RecipeModel>> getAllRecipes() async {
    try {
      return await _remoteDatasource.getAllRecipes();
    } catch (e) {
      throw Exception('Failed to get recipes: $e');
    }
  }

  // Tarif ID'si ile belirli bir tarifi almak
  Future<RecipeModel> getRecipesById(String id, String token) async {
    return await _remoteDatasource.getRecipesById(id, token);
  }

  Future<void> deleteRecipeById(String id, String token) async {
    await _remoteDatasource.deleteRecipeById(id, token);
  }

  Future<List<RecipeModel>> getRecentRecipes({int limit = 10}) async {
    try {
      return await _remoteDatasource.getRecentRecipes(limit: limit);
    } catch (e) {
      throw Exception('Failed to get recent recipes: $e');
    }
  }

  Future<List<RecipeModel>> getRecipesByIngredients(
    List<String> ingredients,
  ) async {
    try {
      return await _remoteDatasource.getRecipesByIngredients(ingredients);
    } catch (e) {
      throw Exception('Failed to get recipes by ingredients: $e');
    }
  }
}
