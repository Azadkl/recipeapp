import 'package:flutter/material.dart';
import 'package:recipeapp/pages/recipe_screen.dart';
import 'package:recipeapp/widget/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 24,
          bottom: MediaQuery.of(context).padding.bottom + 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Merhaba Azad,",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.black),
              ),
            ),
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
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    controller: controller,
                    hintText: "Tarifleri Arayın.",
                    backgroundColor: MaterialStateProperty.all(
                      Colors.white,
                    ), // Renk değişimi
                    
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (_) {
                      controller.openView();
                    },
                    leading: const Icon(Icons.search),
                  );
                },
                suggestionsBuilder: (
                  BuildContext context,
                  SearchController controller,
                ) {
                  List<String> allItems = [
                    'item 1',
                    'item 2',
                    'item 3',
                    'item 4',
                    'item 5',
                  ];

                  // Eğer kullanıcı bir şey yazmamışsa boş liste döndür
                  if (controller.text.isEmpty) {
                    return [];
                  }

                  // Kullanıcının girdiği metne göre filtreleme yap
                  List<String> filteredItems =
                      allItems
                          .where(
                            (item) => item.toLowerCase().contains(
                              controller.text.toLowerCase(),
                            ),
                          )
                          .toList();

                  return List<ListTile>.generate(filteredItems.length, (
                    int index,
                  ) {
                    final String item = filteredItems[index];
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        setState(() {
                          controller.closeView(item);
                        });
                      },
                    );
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Popüler Tarifler",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextButton(onPressed: () {}, child: Text("Tümünü gör")),
                ],
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 280,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecipeScreen()),
                  );
                },
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 280,
                      width: 200,
                      child: Stack(
                        children: [
                          Container(
                            height: 280,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: AssetImage("assets/images/screen1.jpg"),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Yemek Adı",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(color: Colors.white),
                                          maxLines: 2,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Icon(
                                        Icons.bookmark_outline,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ],
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
                    );
                  },
                  separatorBuilder: (_, __) {
                    return SizedBox(width: 16);
                  },
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 24),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Son Yüklenen Tarifler",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  TextButton(onPressed: () {}, child: Text("Tümünü gör")),
                ],
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 280,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecipeScreen()),
                  );
                },
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          height: 280,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: AssetImage("assets/images/screen1.jpg"),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Yemek Adı",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.white),
                                        maxLines: 2,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Icon(
                                      Icons.bookmark_outline,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Süre | Kaç Kişilik",
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.white),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (_, __) {
                    return SizedBox(width: 16);
                  },
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
