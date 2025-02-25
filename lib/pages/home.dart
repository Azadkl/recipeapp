import 'package:flutter/material.dart';
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
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 10.0),
        child: Text(
          "Hello Username",
          style:AppWidget.boldTextFeildStyle()
        ),
      ),
    );
  }
}
