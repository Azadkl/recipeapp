import '../datasources/recipe_remote_datasource.dart';
import '../models/recipe_model.dart';

class RecipeRepository {
  final RecipeRemoteDatasource _remoteDatasource = RecipeRemoteDatasource();

  Future<List<RecipeModel>> getAllRecipes(String authToken) async {
    try {
      return await _remoteDatasource.getAllRecipes(authToken);
    } catch (e) {
      throw Exception('Failed to get recipes: $e');
    }
  }
  // Tarif ID'si ile belirli bir tarifi almak
  Future<RecipeModel> getRecipesById(String id, String token) async {
    return await _remoteDatasource.getRecipesById(id, token);
  }
}
