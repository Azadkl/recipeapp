import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:recipeapp/widget/widget_support.dart';

class FindFood extends StatefulWidget {
  const FindFood({super.key});

  @override
  State<FindFood> createState() => _FindFoodState();
}

class _FindFoodState extends State<FindFood> {
  final ImagePicker _picker = ImagePicker();
  bool _isAnalyzing = false;
  bool _hasAnalyzed = false;
  bool _isModelLoaded = false;

  // TensorFlow Lite için değişkenler
  late Interpreter interpreter;
  List<String> labels = [];

  // Çoklu fotoğraf ve malzeme desteği için değişkenler
  List<File> _images = [];
  Map<File, List<String>> _imageIngredients = {};
  List<String> _allDetectedIngredients = [];
  List<Recipe> _matchedRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadModelAndLabels();
  }

  // TensorFlow Lite modelini ve etiketleri yükle
  Future<void> _loadModelAndLabels() async {
    try {
      interpreter = await Interpreter.fromAsset('assets/model_unquant.tflite');

      // labels.txt'yi oku ve numarasız, baş harfi büyük şekilde al
      final labelsTxt = await rootBundle.loadString('assets/labels.txt');
      labels =
          labelsTxt.split('\n').where((line) => line.trim().isNotEmpty).map((
            line,
          ) {
            // Satırdan numarayı kaldır, sadece isim kısmını al
            final parts = line.trim().split(' ');
            if (parts.length > 1) {
              // Sadece isim kısmı, baş harf büyük
              final name = parts.sublist(1).join(' ');
              return name[0].toUpperCase() + name.substring(1);
            } else {
              // Sadece isim varsa
              final name = parts[0];
              return name[0].toUpperCase() + name.substring(1);
            }
          }).toList();

      print("✅ Model yüklendi!");
      print('Input Tensor: ${interpreter.getInputTensor(0).shape}');
      print('Input Type: ${interpreter.getInputTensor(0).type}');
      print('Output Tensor: ${interpreter.getOutputTensor(0).shape}');
      print('Output Type: ${interpreter.getOutputTensor(0).type}');

      setState(() {
        _isModelLoaded = true;
      });
    } catch (e) {
      print("❌ Model yüklenirken hata: $e");
    }
  }

  Future<void> _getImage(ImageSource source) async {
    if (!_isModelLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Model henüz yüklenmedi, lütfen bekleyin...'),
        ),
      );
      return;
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);

        setState(() {
          _images.add(imageFile);
          _isAnalyzing = true;
          _hasAnalyzed = false;
        });

        // Yapay zeka ile malzeme tanıma
        await _analyzeImageWithTFLite(imageFile);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Görüntü alınamadı: $e')));
    }
  }

  // TensorFlow Lite ile görüntü analizi
  Future<void> _analyzeImageWithTFLite(File imageFile) async {
    try {
      // Resmi oku
      var bytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception("Görüntü okunamadı");
      }

      // Görseli 224x224'e resize et
      img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

      // Modelin beklediği input formatına çevir (1,224,224,3)
      List<List<List<List<double>>>> input = List.generate(
        1,
        (_) => List.generate(
          224,
          (_) => List.generate(224, (_) => List.filled(3, 0.0)),
        ),
      );

      for (int y = 0; y < 224; y++) {
        for (int x = 0; x < 224; x++) {
          final pixel = resizedImage.getPixel(x, y);
          final r = pixel.r / 255.0;
          final g = pixel.g / 255.0;
          final b = pixel.b / 255.0;
          input[0][y][x] = [r, g, b];
        }
      }

      // Output için boş tensor oluştur
      var outputShape = interpreter.getOutputTensor(0).shape;
      var output = List.filled(
        outputShape[1],
        0.0,
      ).reshape([1, outputShape[1]]);

      // Modeli çalıştır
      interpreter.run(input, output);

      // Sonuçları al
      var scores = output[0] as List<double>;
      int maxIndex = scores.indexWhere(
        (element) => element == scores.reduce((a, b) => a > b ? a : b),
      );

      // Tahmin edilen malzemeyi kaydet
      String predictedIngredient = labels[maxIndex];

      setState(() {
        _isAnalyzing = false;
        _imageIngredients[imageFile] = [predictedIngredient];

        // Tüm malzemeleri birleştir
        _updateAllIngredients();
      });

      // Kullanıcıya bilgi ver (Snackbar kaldırıldı)
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Tespit edilen malzeme: $predictedIngredient')),
      // );
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Analiz sırasında hata: $e')));
    }
  }

  void _updateAllIngredients() {
    // Tüm resimlerdeki malzemeleri birleştir
    Set<String> uniqueIngredients = {};

    for (var ingredients in _imageIngredients.values) {
      uniqueIngredients.addAll(ingredients);
    }

    _allDetectedIngredients = uniqueIngredients.toList();
  }

  void _finishAndFindRecipes() {
    setState(() {
      _hasAnalyzed = true;

      // Tüm malzemelere göre tarifleri bul
      _matchedRecipes = _findMatchingRecipes(_allDetectedIngredients);
    });
  }

  void _resetAndStartOver() {
    setState(() {
      _images = [];
      _imageIngredients = {};
      _allDetectedIngredients = [];
      _matchedRecipes = [];
      _hasAnalyzed = false;
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
          (recipe) => recipe.matchScore > 0,
        ) // Show all recipes with at least 1 matching ingredient
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
            // Model yükleme durumu
            // if (!_isModelLoaded)
            //   Container(
            //     padding: const EdgeInsets.all(16),
            //     margin: const EdgeInsets.all(16),
            //     decoration: BoxDecoration(
            //       color: Colors.amber.shade100,
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     child: Row(
            //       children: [
            //         const CircularProgressIndicator(
            //           valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            //         ),
            //         const SizedBox(width: 16),
            //         const Expanded(
            //           child: Text(
            //             'Yapay zeka modeli yükleniyor, lütfen bekleyin...',
            //             style: TextStyle(
            //               fontSize: 14,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),

            // Top section with instructions
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Her bir malzemenin ayrı fotoğrafını çek',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Yapay zeka her bir malzemeyi tanıyacak ve bitir dediğinde sana uygun tarifleri gösterecek',
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed:
                            _isModelLoaded
                                ? () => _getImage(ImageSource.camera)
                                : null,
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
                        onPressed:
                            _isModelLoaded
                                ? () => _getImage(ImageSource.gallery)
                                : null,
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

            // Bitir butonu - en az bir resim varsa göster
            if (_images.isNotEmpty && !_hasAnalyzed)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ElevatedButton.icon(
                  onPressed: _finishAndFindRecipes,
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  label: const Text('Malzeme Eklemeyi Bitir ve Tarifleri Bul'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),

            // Yeniden başlat butonu - analiz tamamlandıysa göster
            if (_hasAnalyzed)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ElevatedButton.icon(
                  onPressed: _resetAndStartOver,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text('Yeniden Başla'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),

            // Image previews - horizontal scrollable list
            if (_images.isNotEmpty)
              Container(
                height: 120,
                margin: const EdgeInsets.all(16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    final image = _images[index];
                    final ingredients = _imageIngredients[image] ?? [];

                    return Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                image,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          if (ingredients.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(4),
                              width: double.infinity,
                              color: Colors.black,
                              child: Text(
                                ingredients.join(', '),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
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
                      'Yapay zeka malzemeyi analiz ediyor...',
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
            if (_allDetectedIngredients.isNotEmpty)
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
                          _allDetectedIngredients.map((ingredient) {
                            return Chip(
                              label: Text(
                                ingredient,
                                style: const TextStyle(color: Colors.white),
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
                        return RecipeCard(
                          recipe: recipe,
                          detectedIngredients: _allDetectedIngredients,
                        );
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
  final List<String> detectedIngredients;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.detectedIngredients,
  });

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
                        '${recipe.matchScore}%',
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
                        final isDetected = detectedIngredients.contains(
                          ingredient,
                        );
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
