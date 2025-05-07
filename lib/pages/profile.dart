import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipeapp/datasources/auth_remote_datasource.dart';
import 'package:recipeapp/datasources/recipe_remote_datasource.dart'; // Eklendi
import 'package:recipeapp/models/recipe_model.dart'; // Eklendi
import 'package:recipeapp/models/user_model.dart';
import 'package:recipeapp/pages/login.dart';
import 'package:recipeapp/services/local_storage_service.dart';
import 'package:recipeapp/widget/widget_support.dart';

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
        final recipes = await recipeRemoteDataSource.getAllRecipes(token);
        
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
      await LocalStorageService.clearAll();  // Token'ı silin
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false, // Bu parametre, tüm önceki sayfaları siler
      );
    } catch (e) {
      print("Çıkış yapılırken hata oluştu: $e");
    }
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
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _logout,  // Çıkış yap butonuna tıklandığında _logout çağrılır
          ),
        ],
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
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
                      backgroundColor: Colors.black, // Arka plan rengi
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),

                    const SizedBox(height: 16),
                    user != null
                        ? Text(
                            "${user!.username}",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                          )
                        : Text(
                            "",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to all recipes page
                      },
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
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  )
                : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: userRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = userRecipes[index];
                    return RecipeCard(
                      recipe: Recipe(
                        title: recipe.title ?? "İsimsiz Tarif",
                        imageUrl: recipe.image ?? "https://placeholder.com/food",
                        duration: "${recipe.prepTime ?? '?'} dakika",
                      ),
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

class Recipe {
  final String title;
  final String imageUrl;
  final String duration;

  Recipe({required this.title, required this.imageUrl, required this.duration});
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipe image
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  // Gerçek resim URL'si kullanılıyor
                  image: MemoryImage(base64Decode(recipe.imageUrl)),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    // Resim yüklenemezse varsayılan resim göster
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
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      recipe.duration,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}