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
    return Scaffold(
      appBar: AppBar(
      automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 4,right: 4),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.32,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 100, color: Colors.white),
                    backgroundColor: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Azad Köl",
                      style: AppWidget.HeadlineTextFeildStyle(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
