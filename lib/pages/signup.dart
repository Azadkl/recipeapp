import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:recipeapp/models/user_model.dart';
import 'package:recipeapp/pages/bottomnav.dart';
import 'package:recipeapp/pages/home.dart';
import 'package:recipeapp/pages/login.dart';
import 'package:recipeapp/repositories/auth_repository.dart';
import 'package:recipeapp/widget/widget_support.dart';
import 'package:recipeapp/widget/widgets.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isLoading = false;

  String email = "", password = "";

  final _formkey = GlobalKey<FormState>();

  TextEditingController usernamecontroller = new TextEditingController();
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
                    colors: [Color.fromARGB(255, 255, 0, 0), Colors.black],
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
                        height: MediaQuery.of(context).size.height / 1.8,
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
                                "Kayıt Ol",
                                style: AppWidget.HeadlineTextFeildStyle(),
                              ),
                              SizedBox(height: 30.0),
                              TextFormField(
                                controller: usernamecontroller,
                                decoration: InputDecoration(
                                  hintText: "Kullanıcı Adı",
                                  hintStyle: AppWidget.semiBoldTextFeildStyle(),
                                  prefixIcon: Icon(Icons.person),
                                ),
                              ),
                              SizedBox(height: 30.0),
                              TextFormField(
                                controller: useremailcontroller,

                                decoration: InputDecoration(
                                  hintText: "Email",
                                  hintStyle: AppWidget.semiBoldTextFeildStyle(),
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                              ),
                              SizedBox(height: 30.0),
                              TextFormField(
                                controller: userpasswordcontroller,

                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: "Şifre",
                                  hintStyle: AppWidget.semiBoldTextFeildStyle(),
                                  prefixIcon: Icon(Icons.key),
                                ),
                              ),
                              SizedBox(height: 80.0),
                              GestureDetector(
                                onTap: isLoading ? null : _handleRegister,
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
                                                "Kayıt Ol",
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
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Zaten bir hesabınız var mı ? Giriş Yap.",
                        style: AppWidget.semiBoldTextFeildStyle(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Bottomnav()),
                        );
                      },
                      child: Text(
                        "Hesap oluşturmadan devam et.",
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

  void _handleRegister() async {
    setState(() {
      isLoading = true;
    });
    if (usernamecontroller.text.isEmpty ||
        useremailcontroller.text.isEmpty ||
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
    } else if (!useremailcontroller.text.contains("@")) {
      Widgets.showSnackBar(
        context,
        "Hata!",
        "Email içinde @ içeren bir ifade olmalıdır.",
        ContentType.failure,
      );
      setState(() {
        isLoading = false;
      });
    } else
      // ignore: curly_braces_in_flow_control_structures
      try {
        AuthRepository authRepository = AuthRepository();
        UserModel user = await authRepository.signup(
          usernamecontroller.text,
          useremailcontroller.text,
          userpasswordcontroller.text,
        );

        Widgets.showSnackBar(
          context,
          "Başarılı!",
          "Kayıt başarılı! Şimdi giriş yapabilirsiniz.",
          ContentType.success,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } catch (e) {
        // NotUniqueError kontrolü
        final errStr = e.toString();
        if (errStr.contains("NotUniqueError") ||
            errStr.contains("already exists") ||
            errStr.contains("unique")) {
          Widgets.showSnackBar(
            context,
            "Kayıt Hatası",
            "Bu kullanıcı adı veya e-posta zaten kayıtlı. Lütfen farklı bir kullanıcı adı veya e-posta deneyin.",
            ContentType.failure,
          );
        } else {
          Widgets.showSnackBar(
            context,
            "Hata!",
            e.toString(),
            ContentType.failure,
          );
        }
      } finally {
        setState(() {
          isLoading = false;
        });
      }
  }
}
