import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:recipeapp/models/user_model.dart';
import 'package:recipeapp/pages/bottomnav.dart';
import 'package:recipeapp/pages/forgotpassword.dart';
import 'package:recipeapp/pages/home.dart';
import 'package:recipeapp/pages/signup.dart';
import 'package:recipeapp/repositories/auth_repository.dart';
import 'package:recipeapp/services/local_storage_service.dart';
import 'package:recipeapp/widget/widget_support.dart';
import 'package:recipeapp/widget/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  String email = "", password = "";

  final _formkey = GlobalKey<FormState>();

  TextEditingController useremailcontroller = new TextEditingController();
  TextEditingController userpasswordcontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors:  [Color.fromARGB(255, 255, 0, 0),Colors.black],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 3,
                ),
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Text(""),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: MediaQuery.of(context).size.width / 1.5,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              SizedBox(height: 30.0),
                              Text(
                                "Giriş Yap",
                                style: AppWidget.HeadlineTextFeildStyle(),
                              ),
                              SizedBox(height: 30.0),
                              TextFormField(
                                controller: useremailcontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Lütfen Email Giriniz.";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  hintStyle: AppWidget.semiBoldTextFeildStyle(),
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                              ),
                              SizedBox(height: 30.0),
                              TextFormField(
                                controller: userpasswordcontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Lütfen Şifre Giriniz.";
                                  }
                                  return null;
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: "Şifre",
                                  hintStyle: AppWidget.semiBoldTextFeildStyle(),
                                  prefixIcon: Icon(Icons.key),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ForgotPassword(),
                                    ),
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "Parolamı Unuttum?",
                                    style: AppWidget.semiBoldTextFeildStyle(),
                                  ),
                                ),
                              ),
                              SizedBox(height: 80.0),
                              GestureDetector(
                                onTap: isLoading ? null : _handleLogin,
                                child: Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child:
                                          isLoading
                                              ? SizedBox(
                                                width: 26.0,
                                                height: 26.0,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                              )
                                              : Text(
                                                "Giriş Yap",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontFamily: 'Poppins1',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 70.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Signup()),
                        );
                      },
                      child: Text(
                        "Hesabınız yok mu ? Kayıt olun.",
                        style: AppWidget.semiBoldTextFeildStyle(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    setState(() {
      isLoading = true;
    });
    if (useremailcontroller.text.isEmpty ||
        userpasswordcontroller.text.isEmpty) {
      Widgets.showSnackBar(
        context,
        "Hata!",
        "Lütfen tüm alanları doldurunuz.",
        ContentType.failure,
      );
      setState(() {
        isLoading = false;
      });
    // ignore: curly_braces_in_flow_control_structures
    }  else try {
    AuthRepository authRepository = AuthRepository();
    UserModel user = await authRepository.login(
      useremailcontroller.text,
      userpasswordcontroller.text,
    );

    // Başarılı giriş
    Widgets.showSnackBar(
      context,
      "Hoş Geldin",
      "${user.username}",
      ContentType.success,
    );

    // Token kaydetmek istersen SharedPreferences kullanılabilir
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setString("token", user.token);
    await LocalStorageService.saveUserId(user.id);
    await LocalStorageService.saveToken(user.access);


    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Bottomnav()),
    );
  } catch (e) {
  print("Hata: $e");

    Widgets.showSnackBar(
      context,
      "Hata!",
      "Giriş yapılamadı. ${e.toString()}",
      ContentType.failure,
    );
  }finally{
    setState(() {
        isLoading = false;
      });
  }
  }
}
