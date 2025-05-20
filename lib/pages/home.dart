import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipeapp/datasources/auth_remote_datasource.dart';
import 'package:recipeapp/models/recipe_model.dart';
import 'package:recipeapp/models/user_model.dart';
import 'package:recipeapp/pages/recipe_screen.dart';
import 'package:recipeapp/repositories/recipe_repository.dart';
import 'package:recipeapp/services/local_storage_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<RecipeModel> recipes = [];
  List<RecipeModel> displayedRecipes = [];
  UserModel? user;
  bool isLoading = true;
  final RecipeRepository _recipeRepository = RecipeRepository();
  String? _authToken;
  final SearchController _searchController = SearchController();

  @override
  void initState() {
    super.initState();
    _loadUserAndRecipes().then((value) {
      setState(() {});
    });
  }

  Future<void> _loadUserAndRecipes() async {
    try {
      final token = await LocalStorageService.getToken();
      if (token != null) {
        _authToken = token;
        final userRemoteDataSource = AuthRemoteDataSource();
        user = await userRemoteDataSource.getUserDetail(token);

        recipes = await _recipeRepository.getAllRecipes();
        print("API'den gelen tarif sayısı: ${recipes.length}"); //
        displayedRecipes = List.from(recipes);
      } else if (token == null) {
        recipes = await _recipeRepository.getAllRecipes();
        print("API'den gelen tarif sayısı: ${recipes.length}"); //
        displayedRecipes = List.from(recipes);
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
    print("📦 Toplam tarif yüklendi: ${recipes.length}");
  }

  Future<void> _searchRecipes(String query) async {
    print("🔍 Aranan kelime: $query");

    setState(() {
      if (query.isEmpty) {
        displayedRecipes = List.from(recipes);
        print("📋 Boş arama: ${displayedRecipes.length} tarif listelendi.");
      } else {
        displayedRecipes =
            recipes.where((recipe) {
              final title = recipe.title.toLowerCase();
              final search = query.toLowerCase();
              final matches = title.contains(search);

              print(
                "🎯 Kontrol edilen tarif: ${recipe.title} - Eşleşme: $matches",
              );

              return matches;
            }).toList();
        print("🔎 Eşleşen tarif sayısı: ${displayedRecipes.length}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            user != null
                ? Text(
                  "Merhaba ${user!.username},",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                )
                : Text(
                  "Merhaba kullanıcı,",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Text(
                "Bugün ne yapmak istersiniz ?",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchAnchor(
                viewHintText: "Tarifleri Arayın",
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    controller: _searchController,
                    hintText: "Tarifleri Arayın",
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (value) {
                      print("🔄 Arama kutusu değişti: $value");
                      _searchController.text = value;
                      _searchRecipes(value);
                    },
                    leading: const Icon(Icons.search),
                  );
                },
                suggestionsBuilder: (
                  BuildContext context,
                  SearchController controller,
                ) {
                  final filteredRecipes =
                      controller.text.isEmpty
                          ? recipes
                          : recipes
                              .where(
                                (recipe) => recipe.title.toLowerCase().contains(
                                  controller.text.toLowerCase(),
                                ),
                              )
                              .toList();

                  // Beğeni sayısına göre azalan sırala
                  filteredRecipes.sort(
                    (a, b) => b.likesCount.compareTo(a.likesCount),
                  );

                  return [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        controller.text.isEmpty
                            ? 'Tüm Tarifler (${filteredRecipes.length})'
                            : 'Arama Sonuçları (${filteredRecipes.length})',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    if (filteredRecipes.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'Arama kriterlerinize uygun tarif bulunamadı.',
                          ),
                        ),
                      )
                    else
                      ...filteredRecipes.map(
                        (recipe) => ListTile(
                          title: Text(recipe.title),
                          subtitle: Text(
                            '${recipe.foodType ?? 'Belirtilmemiş'} • ${recipe.servings ?? 1} • ${recipe.prepTime ?? 0} dk',
                          ),
                          leading: CircleAvatar(
                            backgroundImage:
                                recipe.image != null
                                    ? MemoryImage(base64Decode(recipe.image!))
                                    : null,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.favorite, color: Colors.red, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                recipe.likesCount.toString(),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.black),
                              ),
                            ],
                          ),
                          onTap: () {
                            controller.closeView(recipe.title);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => RecipeScreen(recipe: recipe),
                              ),
                            );
                          },
                        ),
                      ),
                  ];
                },
              ),
            ),
            _buildRecipeSection("Popüler Tarifler", displayedRecipes),
            _buildRecipeSection("Son Yüklenen Tarifler", displayedRecipes),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeSection(String title, List<RecipeModel> recipesToShow) {
    List<RecipeModel> sectionRecipes = List.from(recipesToShow);
    if (title == "Popüler Tarifler") {
      sectionRecipes.sort((a, b) => b.likesCount.compareTo(a.likesCount));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 280,
          child: ListView.separated(
            itemCount: sectionRecipes.length > 10 ? 10 : sectionRecipes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemBuilder: (context, index) {
              final recipe = sectionRecipes[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeScreen(recipe: recipe),
                    ),
                  );
                },
                child: SizedBox(
                  width: 200,
                  child: Stack(
                    children: [
                      Container(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                recipe.foodType ?? 'Belirtilmemiş',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(8),
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
                                        ?.copyWith(color: Colors.white),
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
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      recipe.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.white),
                                      maxLines: 2,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Icon(
                                    Icons.bookmark_outline,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "${recipe.prepTime ?? 0} dk | ${recipe.servings ?? 1} Kişilik",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.white),
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
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Tatlı':
        return Colors.pink;
      case 'Yemek':
        return Colors.orange;
      case 'İçecek':
        return Colors.blue;
      case 'Çorba':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
