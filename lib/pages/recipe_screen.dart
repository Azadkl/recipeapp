import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipeapp/widget/widget_support.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool isLiked = false;
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/screen2.jpg"),
                fit: BoxFit.cover,
              ),
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
                                    "Makarna",
                                    style: AppWidget.semiBoldTextFeildStyle(),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isSelected = !isSelected;
                                      });
                                    },
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
                                          "Azad Köl",
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
                                        "260k beğeni",
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
                              for (var items in [
                                "Bir tencereye suyu koyup kaynatın.",
                                "Kaynayan suya tuz ve sıvı yağı ekleyin.",
                                "Makarnayı suya atarak 8-10 dakika haşlayın.",
                                "Haşlanan makarnayı süzün ve soğuk sudan geçirin.",
                                "Tereyağını tavada eritip makarnayı ekleyin, karıştırın.",
                                "Üzerine rendelenmiş peynir ekleyerek servis edin.",
                              ])
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
                                "Tatlı",
                                style: AppWidget.LightTextFeildStyle(),
                              ),
                              Divider(thickness: 1.0),
                              Text(
                                "Yapılış Süresi(dk)",
                                style: AppWidget.semiBoldTextFeildStyle(),
                              ),
                              Text(
                                "30",
                                style: AppWidget.LightTextFeildStyle(),
                              ),
                               Divider(thickness: 1.0),
                              Text(
                                "Kaç Kişilik",
                                style: AppWidget.semiBoldTextFeildStyle(),
                              ),
                              Text(
                                "4",
                                style: AppWidget.LightTextFeildStyle(),
                              ),
                              Divider(thickness: 1.0),
                              Text(
                                "İçindekiler",
                                style: AppWidget.semiBoldTextFeildStyle(),
                              ),
                              for (var item in [
                                "1 paket makarna",
                                "1,5 litre su",
                                "1 tatlı kaşığı tuz",
                                "1 yemek kaşığı sıvı yağ",
                                "Sos için: Tereyağı ve rendelenmiş peynir",
                              ])
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
              onTap: () {
                setState(() {
                  isLiked = !isLiked;
                });
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
