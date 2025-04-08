import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipeapp/widget/widget_support.dart';

class FindFood extends StatefulWidget {
  const FindFood({super.key});

  @override
  State<FindFood> createState() => _FindFoodState();
}

class _FindFoodState extends State<FindFood> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isAnalyzing = false;
  bool _hasAnalyzed = false;
  List<String> _detectedIngredients = [];
  List<Recipe> _matchedRecipes = [];

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _isAnalyzing = true;
          _hasAnalyzed = false;
          _detectedIngredients = [];
          _matchedRecipes = [];
        });

        // Simulate AI processing delay
        await Future.delayed(const Duration(seconds: 2));
        _analyzeImage();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Görüntü alınamadı: $e')));
    }
  }

  void _analyzeImage() {
    // Simulate AI detection of ingredients
    // In a real app, this would call an AI service API
    setState(() {
      _isAnalyzing = false;
      _hasAnalyzed = true;

      // Example detected ingredients - in a real app these would come from the AI
      _detectedIngredients = [
        'Domates',
        'Soğan',
        'Biber',
        'Sarımsak',
        'Zeytinyağı',
      ];

      // Find matching recipes
      _matchedRecipes = _findMatchingRecipes(_detectedIngredients);
    });
  }

  List<Recipe> _findMatchingRecipes(List<String> ingredients) {
    // This would normally query a database or API
    // For demo purposes, we'll use a hardcoded list
    final allRecipes = [
      Recipe(
        name: 'Menemen',
        imageUrl:
            'https://cdn.yemek.com/mncrop/940/625/uploads/2014/06/menemen-tarifi-yeni.jpg',
        ingredients: ['Domates', 'Soğan', 'Biber', 'Yumurta', 'Zeytinyağı'],
        matchScore: 80,
      ),
      Recipe(
        name: 'Domates Çorbası',
        imageUrl:
            'https://cdn.yemek.com/mncrop/940/625/uploads/2015/09/domates-corbasi-yemekcom.jpg',
        ingredients: ['Domates', 'Soğan', 'Un', 'Tereyağı', 'Tuz'],
        matchScore: 60,
      ),
      Recipe(
        name: 'Kızartma',
        imageUrl:
            'https://cdn.yemek.com/mncrop/940/625/uploads/2020/08/patlican-kizartmasi-yemekcom.jpg',
        ingredients: ['Patlıcan', 'Domates', 'Biber', 'Sarımsak', 'Zeytinyağı'],
        matchScore: 70,
      ),
      Recipe(
        name: 'Shakshuka',
        imageUrl:
            'https://cdn.yemek.com/mncrop/940/625/uploads/2018/05/szakszuka-tarifi.jpg',
        ingredients: [
          'Domates',
          'Soğan',
          'Biber',
          'Yumurta',
          'Sarımsak',
          'Zeytinyağı',
        ],
        matchScore: 90,
      ),
    ];

    // Filter and sort recipes based on matching ingredients
    return allRecipes
        .map((recipe) {
          final matchCount =
              recipe.ingredients
                  .where((ingredient) => ingredients.contains(ingredient))
                  .length;
          final matchPercentage =
              (matchCount / recipe.ingredients.length) * 100;
          return recipe.copyWith(matchScore: matchPercentage.round());
        })
        .where(
          (recipe) => recipe.matchScore > 40,
        ) // Only show recipes with at least 40% match
        .toList()
      ..sort((a, b) => b.matchScore.compareTo(a.matchScore));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Malzemelerinle Tarif Bul',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top section with instructions
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Elindeki malzemelerin fotoğrafını çek',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Yapay zeka malzemelerini tanıyacak ve sana uygun tarifleri gösterecek',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _getImage(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        label: const Text('Fotoğraf Çek'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _getImage(ImageSource.gallery),
                        icon: const Icon(
                          Icons.photo_library,
                          color: Colors.white,
                        ),
                        label: const Text('Galeriden Seç'),
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
                ],
              ),
            ),

            // Image preview
            if (_image != null)
              Container(
                height: 200,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),

            // Loading indicator
            if (_isAnalyzing)
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Yapay zeka malzemeleri analiz ediyor...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bu işlem birkaç saniye sürebilir',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

            // Detected ingredients
            if (_hasAnalyzed && _detectedIngredients.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Tespit Edilen Malzemeler',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          _detectedIngredients.map((ingredient) {
                            return Chip(
                              label: Text(
                                ingredient,
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.black,
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),

            // Matched recipes
            if (_hasAnalyzed && _matchedRecipes.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
                      child: Text(
                        'Bu Malzemelerle Yapabileceğin Tarifler',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _matchedRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = _matchedRecipes[index];
                        return RecipeCard(recipe: recipe);
                      },
                    ),
                  ],
                ),
              ),

            // No recipes found
            if (_hasAnalyzed && _matchedRecipes.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Üzgünüz, bu malzemelerle yapabileceğin bir tarif bulamadık',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Farklı malzemeler ile tekrar deneyin veya daha fazla malzeme ekleyin',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class Recipe {
  final String name;
  final String imageUrl;
  final List<String> ingredients;
  final int matchScore;

  const Recipe({
    required this.name,
    required this.imageUrl,
    required this.ingredients,
    required this.matchScore,
  });

  Recipe copyWith({
    String? name,
    String? imageUrl,
    List<String>? ingredients,
    int? matchScore,
  }) {
    return Recipe(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      matchScore: matchScore ?? this.matchScore,
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipe image with match score overlay
          Stack(
            children: [
              Image.network(
                recipe.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 50),
                    ),
                  );
                },
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.thumb_up, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${recipe.matchScore}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Recipe details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'İçindekiler:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children:
                      recipe.ingredients.map((ingredient) {
                        final isDetected = _FindFoodState()._detectedIngredients
                            .contains(ingredient);
                        return Chip(
                          label: Text(
                            ingredient,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDetected ? Colors.white : Colors.black,
                            ),
                          ),
                          backgroundColor:
                              isDetected ? Colors.green : Colors.grey.shade200,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                        );
                      }).toList(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to recipe detail page
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${recipe.name} tarifine gidiliyor'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Tarifi Görüntüle'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
