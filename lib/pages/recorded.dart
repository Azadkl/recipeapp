import 'package:flutter/material.dart';
import 'package:recipeapp/pages/add_recipe.dart';
import 'package:recipeapp/widget/widget_support.dart';

class Recorded extends StatefulWidget {
  const Recorded({super.key});

  @override
  State<Recorded> createState() => _RecordedState();
}

class _RecordedState extends State<Recorded> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 24,
          bottom: MediaQuery.of(context).padding.bottom + 24,
        ),
        child: Column(
          children: [
            Text("Tarif Defterirm", style: AppWidget.HeadlineTextFeildStyle()),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddRecipe(),
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
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/screen1.jpg",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "Tür Adı",
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.white),
                                ),
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
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Yemek Adı",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.white),
                                      maxLines: 2,
                                    ),

                                    SizedBox(height: 8),
                                    Text(
                                      "Süre | Kaç Kişilik",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
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

                  itemCount: 10,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.only(bottom: 150, right: 14, left: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
