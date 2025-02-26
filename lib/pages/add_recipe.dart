import 'package:flutter/material.dart';
import 'package:recipeapp/widget/widget_support.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  @override
  Widget build(BuildContext context) {
     return  Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 10.0),
        child: Text(
          "Add Recipe",
          style:AppWidget.boldTextFeildStyle()
        ),
      ),
    );;
  }
}