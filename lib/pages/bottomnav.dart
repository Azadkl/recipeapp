import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:recipeapp/pages/find_food.dart';
import 'package:recipeapp/pages/home.dart';
import 'package:recipeapp/pages/profile.dart';
import 'package:recipeapp/pages/recorded.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  int currentTabIndex = 0;

  late List<Widget> pages;
  late Widget currentPage;
  late Home homepage;
  late Recorded recorded;
  late Profile profile;
  late FindFood findFood;

  @override
  void initState() {
    homepage = Home();
    recorded = Recorded();
    findFood = FindFood();
    profile = Profile();
    pages = [homepage, recorded, findFood, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: Duration(microseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          Icon(Icons.home_outlined, color: Colors.white),
          Icon(Icons.bookmark, color: Colors.white),
          Icon(Icons.smart_toy, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
