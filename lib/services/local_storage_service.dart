import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  // Bookmark durumunu kaydetme
  static Future<void> saveBookmarkStatus(String recipeId, bool isBookmarked) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('bookmark_$recipeId', isBookmarked);
  }

  // Bookmark durumunu alma
  static Future<bool?> getBookmarkStatus(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('bookmark_$recipeId');
  }
    // Like durumunu kaydetme
  static Future<void> saveLikeStatus(String recipeId, bool isLiked) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('like_$recipeId', isLiked);
  }

  // Like durumunu alma
  static Future<bool?> getLikeStatus(String recipeId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('like_$recipeId');
  }
}
