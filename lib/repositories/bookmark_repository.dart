import 'package:recipeapp/models/bookmark_toggle_model.dart';
import 'package:recipeapp/models/recipe_model.dart';
import 'package:recipeapp/repositories/recipe_repository.dart';

import '../datasources/bookmark_remote_datasource.dart';
import '../models/bookmark_model.dart';

class BookmarkRepository {
  final BookmarkRemoteDataSource _remoteDataSource = BookmarkRemoteDataSource();

  final RecipeRepository _recipeRepository = RecipeRepository();

  // Yer işaretlerini al
  Future<List<RecipeModel>> getBookmarks(String userId, String token) async {
    final bookmarks = await _remoteDataSource.getBookmarks(userId, token);
    List<RecipeModel> recipes = [];

    // Her bookmark için tarif bilgilerini alıyoruz
    for (var bookmark in bookmarks) {
      final recipe = await _recipeRepository.getRecipesById(bookmark.recipeId, token);
      recipes.add(recipe);
    }

    return recipes;
  }

  Future<BookmarkResponse> addBookmark(String recipeId, String token) async {
    return await _remoteDataSource.addBookmark(recipeId, token);
  }
}
