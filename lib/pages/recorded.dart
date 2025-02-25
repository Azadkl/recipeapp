import 'package:flutter/material.dart';
import 'package:recipeapp/widget/widget_support.dart';

class Recorded extends StatefulWidget {
  const Recorded({super.key});

  @override
  State<Recorded> createState() => _RecordedState();
}

class _RecordedState extends State<Recorded> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 10.0),
        child: Text(
          "Saved",
          style:AppWidget.boldTextFeildStyle()
        ),
      ),
    );
  }
}