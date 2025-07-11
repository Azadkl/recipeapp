import 'package:flutter/material.dart';
import 'package:recipeapp/pages/bottomnav.dart';
import 'package:recipeapp/pages/login.dart';
import 'package:recipeapp/pages/onboard.dart';
import 'package:recipeapp/pages/recipe_screen.dart';
import 'package:recipeapp/pages/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  Onboard(),
    );
  }
}
