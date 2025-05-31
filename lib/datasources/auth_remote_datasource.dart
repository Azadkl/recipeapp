import 'dart:convert';

import '../models/user_model.dart';
import "package:http/http.dart" as http;

class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("https://booknest-7-an7g.onrender.com/users/login/"),
        body: json.encode({'username': username, 'password': password}),
        headers: {
          'Content-Type': 'application/json', // JSON formatı kullanıyoruz
        },
      );

      if (response.statusCode == 200) {
        // JSON'dan UserModel'e dönüşüm
        return UserModel.fromJson(json.decode(response.body));
      } else {
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Giriş başarısız!'); // Hata mesajı
      }
    } catch (e) {
      rethrow; // Hata durumunda tekrar fırlatma
    }
  }

  Future<UserModel> signup(
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("https://booknest-7-an7g.onrender.com/users/register/"),
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return UserModel.fromJson(json.decode(response.body));
      } else {
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Kayıt başarısız!');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> getUserDetail(String token) async {
    final response = await http.get(
      Uri.parse("https://booknest-7-an7g.onrender.com/users/me/"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      print(response.body);
      throw Exception('Kullanıcı bilgileri alınamadı!');
    }
  }
}
