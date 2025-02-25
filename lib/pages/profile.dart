import 'package:flutter/material.dart';
import 'package:recipeapp/widget/widget_support.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
   return  Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 10.0),
        child: Text(
          "Profile",
          style:AppWidget.boldTextFeildStyle()
        ),
      ),
    );
  }
}