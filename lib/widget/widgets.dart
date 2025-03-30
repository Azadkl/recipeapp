import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class Widgets {
  static void showSnackBar(
    BuildContext context,
    String title,
    String message,
    ContentType contentType,
  ) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating, // Sayfanın üzerine gelmesini sağlar
      backgroundColor: Colors.transparent, // Şeffaf arkaplan
      elevation: 0,
      duration: Duration(milliseconds: 1500),
      content: AwesomeSnackbarContent(
        title: title, 
        message: message,
        contentType: contentType,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
