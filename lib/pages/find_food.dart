import 'package:flutter/material.dart';
import 'package:recipeapp/widget/widget_support.dart';

class FindFood extends StatefulWidget {
  const FindFood({super.key});

  @override
  State<FindFood> createState() => _FindFoodState();
}

class _FindFoodState extends State<FindFood> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 10.0),
        child: Text(
          "Find Food",
          style:AppWidget.boldTextFeildStyle()
        ),
      ),
    );;
  }
}