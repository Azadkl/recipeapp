import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:recipeapp/datasources/auth_remote_datasource.dart';
import 'package:recipeapp/datasources/recipe_remote_datasource.dart';
import 'package:recipeapp/models/recipe_model.dart';
import 'package:recipeapp/models/user_model.dart';
import 'package:recipeapp/pages/login.dart';
import 'package:recipeapp/services/local_storage_service.dart';
import 'package:recipeapp/widget/widget_support.dart';
import 'package:recipeapp/widget/widgets.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserModel? user;
  List<RecipeModel> userRecipes = []; // Kullanıcının tarifleri için liste
  bool isLoading = true; // Yükleme durumu için flag

  @override
  void initState() {
    super.initState();
    _loadUserAndRecipes();
  }

  // Tarif silme fonksiyonu
  Future<void> _deleteRecipe(RecipeModel recipe) async {
    try {
      final token = await LocalStorageService.getToken();
      if (token == null) {
        throw Exception("Kullanıcı oturumu bulunamadı.");
      }

      // Silme işlemi için onay dialogu göster
      bool confirmDelete =
          await showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text("Tarifi Sil"),
                  content: const Text(
                    "Bu tarifi silmek istediğinizden emin misiniz?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("İptal"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(
                        "Sil",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
          ) ??
          false;

      if (!confirmDelete) return;

      // API'den tarifi sil
      final recipeRemoteDataSource = RecipeRemoteDatasource();
      await recipeRemoteDataSource.deleteRecipeById(recipe.id!, token);

      // UI'dan tarifi kaldır
      setState(() {
        userRecipes.removeWhere((item) => item.id == recipe.id);
      });

      Widgets.showSnackBar(
        context,
        "Silme",
        "Tarif başarıyla silindi.",
        ContentType.success,
      );
    } catch (e) {
      print("Tarif silinirken hata oluştu: $e");
      Widgets.showSnackBar(
        context,
        "Hata",
        "Tarif silinirken hata oluştu: $e",
        ContentType.failure,
      );
    }
  }

  // Kullanıcı bilgilerini ve tariflerini yükle
  Future<void> _loadUserAndRecipes() async {
    setState(() {
      isLoading = true;
    });

    try {
      final token = await LocalStorageService.getToken();
      final userId = await LocalStorageService.getUserId();

      if (token != null) {
        // Kullanıcı bilgilerini yükle
        final userRemoteDataSource = AuthRemoteDataSource();
        final fetchedUser = await userRemoteDataSource.getUserDetail(token);

        // Kullanıcının tariflerini yükle
        final recipeRemoteDataSource = RecipeRemoteDatasource();
        final recipes = await recipeRemoteDataSource.getAllRecipes();

        // Sadece kullanıcıya ait tarifleri filtrele (API'niz bunu destekliyorsa)
        // Eğer API'niz kullanıcıya özel tarif filtreleme desteği sunmuyorsa,
        // bu kısmı uygun şekilde düzenlemeniz gerekebilir

        setState(() {
          user = fetchedUser;
          userRecipes = recipes;
          isLoading = false;
        });
      } else {
        throw Exception("Kullanıcı oturumu bulunamadı.");
      }
    } catch (e) {
      print("Hata: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Çıkış yapma fonksiyonu
  void _logout() async {
    try {
      await LocalStorageService.clearAll(); // Token'ı silin
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false, // Bu parametre, tüm önceki sayfaları siler
      );
    } catch (e) {
      print("Çıkış yapılırken hata oluştu: $e");
    }
  }

  // Tüm tarifleri gösteren bottom sheet'i aç
  void _showAllRecipes() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Tam yükseklikte açılabilmesi için
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AllRecipesBottomSheet(
          recipes: userRecipes,
          onDelete: _deleteRecipe,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Profil"),
        actions: [
          IconButton(icon: const Icon(Icons.exit_to_app), onPressed: _logout),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : user == null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Bu sayfayı görüntülemek için giriş yapmanız gerekiyor.",
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
                      icon: const Icon(Icons.person, color: Colors.white),
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
              )
              : SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile header section
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          // Profile image
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.black,
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          user != null
                              ? Text(
                                "${user!.username}",
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                              : Text(
                                "",
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(color: Colors.black),
                              ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Tariflerim",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: _showAllRecipes, // Tümünü Gör butonuna tıklandığında bottom sheet'i aç
                            child: const Text("Tümünü Gör"),
                          ),
                        ],
                      ),
                    ),
                    // Recipes grid - Gerçek verilerle
                    userRecipes.isEmpty
                        ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              "Henüz tarif eklenmemiş.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                        : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemCount: userRecipes.length > 4 ? 4 : userRecipes.length, // Sadece ilk 4 tarifi göster
                          itemBuilder: (context, index) {
                            final recipe = userRecipes[index];
                            return RecipeCard(
                              recipe: Recipe(
                                id: recipe.id ?? "0",
                                title: recipe.title ?? "İsimsiz Tarif",
                                imageUrl:
                                    recipe.image ??
                                    "https://placeholder.com/food",
                                duration: "${recipe.prepTime ?? '?'} dakika",
                              ),
                              onDelete: () => _deleteRecipe(recipe),
                            );
                          },
                        ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
    );
  }
}

// Tüm tarifleri gösteren bottom sheet widget'ı
class AllRecipesBottomSheet extends StatelessWidget {
  final List<RecipeModel> recipes;
  final Function(RecipeModel) onDelete;

  const AllRecipesBottomSheet({
    Key? key,
    required this.recipes,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8, // Ekranın %80'ini kapla
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Başlık ve kapatma butonu
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Tüm Tariflerim",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          
          // Çekme çubuğu (Drag handle)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Tarifler listesi
          Expanded(
            child: recipes.isEmpty
                ? const Center(
                    child: Text(
                      "Henüz tarif eklenmemiş.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return RecipeListItem(
                        recipe: Recipe(
                          id: recipe.id ?? "0",
                          title: recipe.title ?? "İsimsiz Tarif",
                          imageUrl: recipe.image ?? "https://placeholder.com/food",
                          duration: "${recipe.prepTime ?? '?'} dakika",
                        ),
                        onDelete: () => onDelete(recipe),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Liste görünümü için tarif öğesi
class RecipeListItem extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onDelete;

  const RecipeListItem({
    Key? key,
    required this.recipe,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Tarif resmi
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(base64Decode(recipe.imageUrl)),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      print("Resim yüklenemedi: $exception");
                    },
                  ),
                ),
              ),
            ),
            
            // Tarif bilgileri
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          recipe.duration,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Silme butonu
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              onPressed: onDelete,
              tooltip: "Tarifi Sil",
            ),
          ],
        ),
      ),
    );
  }
}

class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final String duration;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.duration,
  });
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onDelete;

  const RecipeCard({super.key, required this.recipe, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe image
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(base64Decode(recipe.imageUrl)),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {
                        print("Resim yüklenemedi: $exception");
                      },
                    ),
                  ),
                ),
              ),

              // Recipe details
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          recipe.duration,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Delete button overlay
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.white, size: 20),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              padding: EdgeInsets.zero,
              onPressed: onDelete,
              tooltip: "Tarifi Sil",
            ),
          ),
        ),
      ],
    );
  }
}