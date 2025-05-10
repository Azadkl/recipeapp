import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipeapp/models/bookmark_model.dart';
import 'package:recipeapp/models/recipe_model.dart';
import 'package:recipeapp/repositories/bookmark_repository.dart';
import 'package:recipeapp/repositories/islike_repository.dart';
import 'package:recipeapp/services/local_storage_service.dart';
import 'package:recipeapp/widget/widget_support.dart';

class RecipeScreen extends StatefulWidget {
  final RecipeModel recipe;
  const RecipeScreen({super.key, required this.recipe});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool isLiked = false;
  bool isSelected = false;
  Uint8List? imageBytes;
  @override
  void initState() {
    super.initState();
    if (widget.recipe.image != null) {
      imageBytes = base64Decode(widget.recipe.image!);
    }
    // Yerel depolamadan beğeni durumunu al
    LocalStorageService.getLikeStatus(widget.recipe.id).then((status) {
      setState(() {
        isLiked = status ?? widget.recipe.isLiked ?? false;
      });
    });

    // Yerel depolamadan yer işareti durumunu al
    LocalStorageService.getBookmarkStatus(widget.recipe.id).then((status) {
      setState(() {
        isSelected = status ?? widget.recipe.isBookmarked ?? false;
      });
    });
  }

  Future<void> toggleBookmarkStatus() async {
    final token = await LocalStorageService.getToken();
    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lütfen giriş yapın!")));
      return;
    }

    try {
      // API'ye toggle isteği gönder (ekle/kaldır)
      final response = await BookmarkRepository().addBookmark(
        widget.recipe.id,
        token,
      );

      // Backend yanıtına göre durumu güncelle
      setState(() {
        isSelected = response.isBookmarked;
      });

      // Yerel depolamaya güncellenmiş durumu kaydet
      await LocalStorageService.saveBookmarkStatus(
        widget.recipe.id,
        isSelected,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
  }

  // Yeni fonksiyon: Like durumu değiştirme
  Future<void> toggleLikeStatus() async {
    final token = await LocalStorageService.getToken();
    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lütfen giriş yapın!")));
      return;
    }

    try {
      // API'ye toggle isteği gönder (like ekle/kaldır)
      final response = await LikeRepository().toggleLike(
        widget.recipe.id,
        token,
      ); // Burada `addBookmark` yerine beğeni API'yi çağırmalısınız.

      // Backend yanıtına göre durumu güncelle
      setState(() {
        isLiked = response.isLiked;
        
      });

      // Yerel depolamaya güncellenmiş durumu kaydet
      await LocalStorageService.saveLikeStatus(
        widget.recipe.id,
        isLiked,
      ); // Yerel depolama için yeni bir fonksiyon yazılabilir
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image:
                  imageBytes != null
                      ? DecorationImage(
                        image: MemoryImage(imageBytes!),
                        fit: BoxFit.cover,
                      )
                      : null,
            ),

            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black87.withOpacity(0.5),
              ),
              child: DraggableScrollableSheet(
                maxChildSize: 0.8,
                minChildSize: 0.2,
                initialChildSize: 0.3,
                builder: (context, scrollController) {
                  return Container(
                    padding: EdgeInsets.only(right: 20, left: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: const Divider(
                              color: Colors.black,
                              thickness: 3.0,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    recipe.title,
                                    style: AppWidget.semiBoldTextFeildStyle(),
                                  ),
                                  InkWell(
                                    onTap: toggleBookmarkStatus,
                                    child: Row(
                                      children: [
                                        Text(
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          "Deftere ekle",
                                          style:
                                              AppWidget.LightTextFeildStyle(),
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.02,
                                        ),
                                        Icon(
                                          isSelected
                                              ? Icons.bookmark
                                              : Icons.bookmark_outline,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {},
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                          ),
                                          backgroundColor: Colors.black,
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.03,
                                        ),
                                        Text(
                                          recipe.username,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.01,
                                      ),
                                      Text(
                                        "${recipe.likesCount} beğeni",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium?.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Divider(thickness: 1.0),

                              Text(
                                "Nasıl Yapılır ?",
                                style: AppWidget.semiBoldTextFeildStyle(),
                              ),
                              for (var items in recipe.instructions)
                                Row(
                                  children: [
                                    Icon(
                                      Icons.local_fire_department,
                                      color: Colors.orange,
                                    ),

                                    Text(
                                      items,
                                      style: AppWidget.LightTextFeildStyle()
                                          .copyWith(fontSize: 13),
                                    ),
                                  ],
                                ),
                              Divider(thickness: 1.0),
                              Text(
                                "Tür",
                                style: AppWidget.semiBoldTextFeildStyle(),
                              ),
                              Text(
                                recipe.foodType,
                                style: AppWidget.LightTextFeildStyle(),
                              ),
                              Divider(thickness: 1.0),
                              Text(
                                "Yapılış Süresi(dk)",
                                style: AppWidget.semiBoldTextFeildStyle(),
                              ),
                              Text(
                                "${recipe.prepTime}",
                                style: AppWidget.LightTextFeildStyle(),
                              ),
                              Divider(thickness: 1.0),
                              Text(
                                "Kaç Kişilik",
                                style: AppWidget.semiBoldTextFeildStyle(),
                              ),
                              Text(
                                "${recipe.servings}",
                                style: AppWidget.LightTextFeildStyle(),
                              ),
                              Divider(thickness: 1.0),
                              Text(
                                "İçindekiler",
                                style: AppWidget.semiBoldTextFeildStyle(),
                              ),
                              for (var item in recipe.ingredients)
                                Row(
                                  children: [
                                    Icon(Icons.check_box, color: Colors.amber),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        item,
                                        style: AppWidget.LightTextFeildStyle(),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 10,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.12,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  color: Color(0xFF61666F).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Color(0x0FFFFFFF), blurRadius: 4),
                  ],
                ),
                child: Icon(CupertinoIcons.back),
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: 10,
            child: InkWell(
              onTap: toggleLikeStatus,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.12,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  color: Color(0xFF61666F).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Color(0x0FFFFFFF), blurRadius: 4),
                  ],
                ),
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
