import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipeapp/models/recipe_model.dart';
import 'package:recipeapp/pages/add_recipe.dart';
import 'package:recipeapp/pages/login.dart';
import 'package:recipeapp/pages/recipe_screen.dart';
import 'package:recipeapp/repositories/bookmark_repository.dart';
import 'package:recipeapp/services/local_storage_service.dart';
import 'package:recipeapp/widget/widget_support.dart';

class Recorded extends StatefulWidget {
  const Recorded({super.key});

  @override
  State<Recorded> createState() => _RecordedState();
}

class _RecordedState extends State<Recorded> {
  List<RecipeModel> _recipes = [];
  bool isLoading = true;
  bool isLoggedIn = false;

  final BookmarkRepository _bookmarkRepository = BookmarkRepository();

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    try {
      final token = await LocalStorageService.getToken();
      final userId = await LocalStorageService.getUserId();
      // Token ve userId'yi kontrol et
      print("Token: $token, UserId: $userId");
      if (token == null || userId == null) {
        print("Token veya userId null. Token: $token, userId: $userId");
        setState(() {
          isLoading = false;
          isLoggedIn = true;
        });
        return;
      }

      print("Yer işaretleri yükleniyor...");
      final recipes = await _bookmarkRepository.getBookmarks(userId, token);

      // Beğeni sayısına göre azalan sırala
      recipes.sort((a, b) => b.likesCount.compareTo(a.likesCount));

      print("Alınan tarif sayısı: ${recipes.length}");
      print(
        "İlk tarif (varsa): ${recipes.isNotEmpty ? recipes.first.title : 'N/A'}",
      );

      setState(() {
        _recipes = recipes;
        isLoading = false;
      });
    } catch (e) {
      print("Yer işaretleri yüklenirken hata: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
      "Build çalışıyor. isLoading: $isLoading, _recipes.length: ${_recipes.length}",
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Tarif Defterim', textAlign: TextAlign.center),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  bottom: MediaQuery.of(context).padding.bottom + 24,
                ),
                child: Column(
                  children: [
                    if (isLoggedIn)
                      SizedBox(
                        height:
                            MediaQuery.of(context).size.height *
                            0.7, // Yüksekliği ayarla
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Kayıtlı tarifleri görmek için giriş yapmanız gerekiyor.",
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoginScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                                label: Text("Giriş yap/Kayıt ol"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,

                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (_recipes.isEmpty)
                      Center(
                        child: Text(
                          "Kayıtlı tarif bulunamadı.",
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    else
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            final recipe = _recipes[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              RecipeScreen(recipe: recipe),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 200,
                                      width: 550,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        image:
                                            recipe.image != null
                                                ? DecorationImage(
                                                  image: MemoryImage(
                                                    base64Decode(recipe.image!),
                                                  ),
                                                  fit: BoxFit.cover,
                                                )
                                                : null,
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      right: 8,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(
                                                0.6,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              recipe.foodType,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium?.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(
                                                0.6,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.favorite,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  recipe.likesCount.toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        color: Colors.white,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      left: 8,
                                      right: 8,
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.6),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              recipe.title,
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium?.copyWith(
                                                color: Colors.white,
                                              ),
                                              maxLines: 2,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "${recipe.prepTime} dk | ${recipe.servings} Kişilik",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium?.copyWith(
                                                color: Colors.white,
                                              ),
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: _recipes.length,
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.only(
                            bottom: 150,
                            right: 14,
                            left: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
    );
  }
}
