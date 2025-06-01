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
  List<RecipeModel> _recentRecipes = [];
  UserModel? user;
  bool isLoading = true;
  final RecipeRepository _recipeRepository = RecipeRepository();
  String? _authToken;
  final SearchController _searchController = SearchController();

  // Maksimum değerler
  double maxPrepTime = 120;
  double maxServings = 10;

  @override
  void initState() {
    super.initState();
    _loadUserAndRecipes().then((value) {
      _initializeFilterRanges();
      setState(() {});
    });
    _loadRecentRecipes();
  }

  void _initializeFilterRanges() {
    if (recipes.isNotEmpty) {
      maxPrepTime = recipes
          .map((recipe) => (recipe.prepTime ?? 0).toDouble())
          .reduce((a, b) => a > b ? a : b);
      maxServings = recipes
          .map((recipe) => (recipe.servings ?? 1).toDouble())
          .reduce((a, b) => a > b ? a : b);
    }
  }

  Future<void> _loadUserAndRecipes() async {
    try {
      final token = await LocalStorageService.getToken();
      if (token != null) {
        _authToken = token;
        final userRemoteDataSource = AuthRemoteDataSource();
        user = await userRemoteDataSource.getUserDetail(token);

        recipes = await _recipeRepository.getAllRecipes();
        print("API'den gelen tarif sayısı: ${recipes.length}");
        displayedRecipes = List.from(recipes);
      } else if (token == null) {
        recipes = await _recipeRepository.getAllRecipes();
        print("API'den gelen tarif sayısı: ${recipes.length}");
        displayedRecipes = List.from(recipes);
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
    print("📦 Toplam tarif yüklendi: ${recipes.length}");
  }

  Future<void> _loadRecentRecipes() async {
    try {
      final recent = await _recipeRepository.getRecentRecipes(limit: 10);
      setState(() {
        _recentRecipes = recent;
      });
    } catch (e) {
      print("Recent recipes error: $e");
    }
  }

  // Çoklu seçim için filtreleme
  List<RecipeModel> _getFilteredRecipes(
    String searchText, {
    List<String>? foodTypes,
    RangeValues? prepTime,
    RangeValues? servings,
  }) {
    return recipes.where((recipe) {
      final titleMatch =
          searchText.isEmpty ||
          recipe.title.toLowerCase().contains(searchText.toLowerCase());

      final foodTypeMatch =
          foodTypes == null ||
          foodTypes.isEmpty ||
          foodTypes.contains(recipe.foodType ?? 'Belirtilmemiş');

      final recipeTime = (recipe.prepTime ?? 0).toDouble();
      final prepTimeMatch =
          prepTime == null ||
          (recipeTime >= prepTime.start && recipeTime <= prepTime.end);

      final recipeServings = (recipe.servings ?? 1).toDouble();
      final servingsMatch =
          servings == null ||
          (recipeServings >= servings.start && recipeServings <= servings.end);

      return titleMatch && foodTypeMatch && prepTimeMatch && servingsMatch;
    }).toList();
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
                    controller: controller,
                    hintText: "Tarifleri Arayın",
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    onTap: () {
                      controller.openView();
                    },
                    leading: const Icon(Icons.search),
                  );
                },
                suggestionsBuilder: (
                  BuildContext context,
                  SearchController controller,
                ) {
                  return [
                    StatefulBuilder(
                      builder: (context, setFilterState) {
                        // Local filtre değişkenleri
                        List<String> localSelectedFoodTypes = [];
                        RangeValues localPrepTimeRange = RangeValues(
                          0,
                          maxPrepTime,
                        );
                        RangeValues localServingsRange = RangeValues(
                          1,
                          maxServings,
                        );
                        bool showFilters = false;

                        return StatefulBuilder(
                          builder: (context, setLocalState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Filtre başlığı ve toggle butonu
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Arama Sonuçları başlığı ve tarif sayısı
                                      Builder(
                                        builder: (context) {
                                          final filteredRecipes =
                                              _getFilteredRecipes(
                                                controller.text,
                                                foodTypes:
                                                    localSelectedFoodTypes
                                                            .isEmpty
                                                        ? null
                                                        : localSelectedFoodTypes,
                                                prepTime: localPrepTimeRange,
                                                servings: localServingsRange,
                                              );
                                          return Text(
                                            "Arama Sonuçları (${filteredRecipes.length})",
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.titleMedium,
                                          );
                                        },
                                      ),
                                      TextButton.icon(
                                        icon: Icon(
                                          showFilters
                                              ? Icons.filter_list_off
                                              : Icons.filter_list,
                                          color:
                                              showFilters
                                                  ? Colors.blue
                                                  : Colors.grey,
                                        ),
                                        label: Text(
                                          "Filtre",
                                          style: TextStyle(
                                            color:
                                                showFilters
                                                    ? Colors.blue
                                                    : Colors.grey,
                                          ),
                                        ),
                                        onPressed: () {
                                          setLocalState(() {
                                            showFilters = !showFilters;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                // Filtre paneli (açılır/kapanır)
                                if (showFilters) ...[
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Tarif türü filtreleri
                                        Row(
                                          children: [
                                            Text(
                                              "Tarif Türü",
                                              style:
                                                  Theme.of(
                                                    context,
                                                  ).textTheme.titleSmall,
                                            ),
                                            if (localSelectedFoodTypes
                                                .isNotEmpty) ...[
                                              const SizedBox(width: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  "${localSelectedFoodTypes.length} seçili",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 8,
                                          children: [
                                            FilterChip(
                                              label: const Text("Yemek"),
                                              selected: localSelectedFoodTypes
                                                  .contains("Yemek"),
                                              onSelected: (selected) {
                                                setLocalState(() {
                                                  if (selected) {
                                                    localSelectedFoodTypes.add(
                                                      "Yemek",
                                                    );
                                                  } else {
                                                    localSelectedFoodTypes
                                                        .remove("Yemek");
                                                  }
                                                });
                                              },
                                            ),
                                            FilterChip(
                                              label: const Text("Tatlı"),
                                              selected: localSelectedFoodTypes
                                                  .contains("Tatlı"),
                                              onSelected: (selected) {
                                                setLocalState(() {
                                                  if (selected) {
                                                    localSelectedFoodTypes.add(
                                                      "Tatlı",
                                                    );
                                                  } else {
                                                    localSelectedFoodTypes
                                                        .remove("Tatlı");
                                                  }
                                                });
                                              },
                                            ),
                                            FilterChip(
                                              label: const Text("Çorba"),
                                              selected: localSelectedFoodTypes
                                                  .contains("Çorba"),
                                              onSelected: (selected) {
                                                setLocalState(() {
                                                  if (selected) {
                                                    localSelectedFoodTypes.add(
                                                      "Çorba",
                                                    );
                                                  } else {
                                                    localSelectedFoodTypes
                                                        .remove("Çorba");
                                                  }
                                                });
                                              },
                                            ),
                                            FilterChip(
                                              label: const Text("İçecek"),
                                              selected: localSelectedFoodTypes
                                                  .contains("İçecek"),
                                              onSelected: (selected) {
                                                setLocalState(() {
                                                  if (selected) {
                                                    localSelectedFoodTypes.add(
                                                      "İçecek",
                                                    );
                                                  } else {
                                                    localSelectedFoodTypes
                                                        .remove("İçecek");
                                                  }
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),

                                        // Hazırlık süresi filtresi
                                        Text(
                                          "Hazırlık Süresi: ${localPrepTimeRange.start.round()}-${localPrepTimeRange.end.round()} dk",
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.titleSmall,
                                        ),
                                        RangeSlider(
                                          values: localPrepTimeRange,
                                          min: 0,
                                          max: maxPrepTime,
                                          divisions: maxPrepTime.round(),
                                          labels: RangeLabels(
                                            "${localPrepTimeRange.start.round()} dk",
                                            "${localPrepTimeRange.end.round()} dk",
                                          ),
                                          onChanged: (values) {
                                            setLocalState(() {
                                              localPrepTimeRange = values;
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 16),

                                        // Porsiyon sayısı filtresi
                                        Text(
                                          "Porsiyon: ${localServingsRange.start.round()}-${localServingsRange.end.round()} kişi",
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.titleSmall,
                                        ),
                                        RangeSlider(
                                          values: localServingsRange,
                                          min: 1,
                                          max: maxServings,
                                          divisions: (maxServings - 1).round(),
                                          labels: RangeLabels(
                                            "${localServingsRange.start.round()}",
                                            "${localServingsRange.end.round()}",
                                          ),
                                          onChanged: (values) {
                                            setLocalState(() {
                                              localServingsRange = values;
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 16),

                                        // Filtreleri temizle butonu
                                        Center(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setLocalState(() {
                                                localSelectedFoodTypes.clear();
                                                localPrepTimeRange =
                                                    RangeValues(0, maxPrepTime);
                                                localServingsRange =
                                                    RangeValues(1, maxServings);
                                              });
                                            },
                                            child: const Text(
                                              "Filtreleri Temizle",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                // Filtrelenmiş sonuçlar
                                ...(() {
                                  final filteredRecipes = _getFilteredRecipes(
                                    controller.text,
                                    foodTypes:
                                        localSelectedFoodTypes.isEmpty
                                            ? null
                                            : localSelectedFoodTypes,
                                    prepTime: localPrepTimeRange,
                                    servings: localServingsRange,
                                  );

                                  // Beğeni sayısına göre azalan sırala
                                  filteredRecipes.sort(
                                    (a, b) =>
                                        b.likesCount.compareTo(a.likesCount),
                                  );

                                  final resultWidgets = <Widget>[];

                                  if (filteredRecipes.isEmpty) {
                                    resultWidgets.add(
                                      const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Center(
                                          child: Text(
                                            'Arama kriterlerinize uygun tarif bulunamadı.',
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    resultWidgets.addAll(
                                      filteredRecipes
                                          .map(
                                            (recipe) => ListTile(
                                              title: Text(recipe.title),
                                              subtitle: Text(
                                                '${recipe.foodType ?? 'Belirtilmemiş'} • ${recipe.servings ?? 1} kişilik • ${recipe.prepTime ?? 0} dk',
                                              ),
                                              leading: CircleAvatar(
                                                backgroundImage:
                                                    recipe.image != null
                                                        ? MemoryImage(
                                                          base64Decode(
                                                            recipe.image!,
                                                          ),
                                                        )
                                                        : null,
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    recipe.likesCount
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                          color: Colors.black,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                              onTap: () {
                                                controller.closeView(
                                                  recipe.title,
                                                );
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            RecipeScreen(
                                                              recipe: recipe,
                                                            ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                          .toList(),
                                    );
                                  }

                                  return resultWidgets;
                                })(),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ];
                },
              ),
            ),
            // Ana sayfa bölümleri
            isLoading
                ? SizedBox(
                  height: 280,
                  child: Center(child: CircularProgressIndicator()),
                )
                : _buildRecipeSection("Popüler Tarifler", displayedRecipes),
            _recentRecipes.isEmpty && isLoading
                ? SizedBox(
                  height: 280,
                  child: Center(child: CircularProgressIndicator()),
                )
                : _buildRecipeSection("Son Yüklenen Tarifler", _recentRecipes),
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
}
