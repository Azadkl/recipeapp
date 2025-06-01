import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipeapp/models/bookmark_toggle_model.dart';
import '../models/bookmark_model.dart';

class BookmarkRemoteDataSource {
  final String baseUrl =
      "https://booknest-7-an7g.onrender.com"; // senin IP adresin

  // Yer işaretlerini getirme
  Future<List<BookmarkModel>> getBookmarks(String userId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/bookmarks/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print("API Yanıtı: ${response.body}");
    print("API Yanıtı: ${response.statusCode}"); // API yanıtını yazdırıyoruz
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final dynamic data = json.decode(decodedBody);
      if (data is List) {
        return data.map((e) => BookmarkModel.fromJson(e)).toList();
      } else {
        throw Exception("Geçersiz veri formatı");
      }
    } else {
      throw Exception("Yer işaretleri alınamadı: ${response.statusCode}");
    }
  }

  Future<BookmarkResponse> addBookmark(String recipeId, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/bookmarks/toggle/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'recipe': recipeId}), // Sadece recipeId gönder
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      return BookmarkResponse.fromJson(json.decode(decodedBody));
    } else {
      print("Bookmark eklenemedi: ${utf8.decode(response.bodyBytes)}");
      throw Exception(
        "Bookmark eklenemedi: ${utf8.decode(response.bodyBytes)}",
      );
    }
  }
}
