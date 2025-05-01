import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bookmark_model.dart';

class BookmarkRemoteDataSource {
  final String baseUrl = "http://192.168.150.74:8000";

  Future<List<BookmarkModel>> getBookmarks(String userId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/bookmarks/?user=$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => BookmarkModel.fromJson(e)).toList();
    } else {
      throw Exception("Yer işaretleri alınamadı.");
    }
  }

  Future<BookmarkModel> addBookmark(String userId, String recipeId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/bookmarks/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'user': userId, 'recipe': recipeId}),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return BookmarkModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Bookmark eklenemedi.");
    }
  }

  Future<void> deleteBookmark(String bookmarkId, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/bookmarks/$bookmarkId/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 204) {
      throw Exception("Bookmark silinemedi.");
    }
  }
}
