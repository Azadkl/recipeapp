import 'package:flutter/material.dart';
import 'package:recipeapp/widget/widget_support.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data - in a real app, this would come from your database
    final String username = "Azad Köl";

    final List<Recipe> userRecipes = [
      Recipe(
        title: "Köfte",
        imageUrl:
            "https://cdn.pixabay.com/photo/2019/06/03/22/06/meatballs-4250143_1280.jpg",
        duration: "30 dakika",
      ),
      Recipe(
        title: "Mercimek Çorbası",
        imageUrl:
            "https://cdn.pixabay.com/photo/2020/03/22/16/18/soup-4957079_1280.jpg",
        duration: "45 dakika",
      ),
      Recipe(
        title: "Baklava",
        imageUrl:
            "https://cdn.pixabay.com/photo/2015/11/19/11/53/baklava-1050973_1280.jpg",
        duration: "2 saat",
      ),
      Recipe(
        title: "Karnıyarık",
        imageUrl:
            "https://cdn.pixabay.com/photo/2021/01/10/03/43/turkish-food-5904221_1280.jpg",
        duration: "1 saat",
      ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header section
            Container(
              padding: const EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  // Profile image
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.black, // Arka plan rengi
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),

                  const SizedBox(height: 16),
                  // Username
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Stats row
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

            // Recipes grid
            GridView.builder(
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
                return RecipeCard(recipe: userRecipes[index]);
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
                  image: AssetImage("assets/images/screen1.jpg"),
                  fit: BoxFit.cover,
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
