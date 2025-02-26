import 'package:flutter/material.dart';
import 'package:recipeapp/pages/login.dart';
import 'package:recipeapp/widget/widget_support.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isLoading = false;

  void _handleLogin() async {
    setState(() {
      isLoading = true;
    });

    // Burada async işlemi simüle ediyoruz (örneğin API çağrısı)
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });

    // İşlem tamamlandıktan sonra başka bir sayfaya yönlendirme vb. işlemler yapılabilir
  }

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
                    colors: [
                      Color.fromARGB(255, 255, 0, 0),
                      Color.fromARGB(255, 255, 0, 0),
                    ],
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
                margin: EdgeInsets.only(top: 50, left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: MediaQuery.of(context).size.width / 1.5,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 50.0),
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Lütfen Kullanıcı Adı Giriniz.";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Kullanıcı Adı",
                                  hintStyle:AppWidget.semiBoldTextFeildStyle(),
                                  prefixIcon: Icon(Icons.person),
                                ),
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
                                  hintStyle:AppWidget.semiBoldTextFeildStyle(),
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
                              SizedBox(height: 80.0),
                              GestureDetector(
                                onTap: isLoading ? null : _handleLogin,
                                child: Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: Color(0Xffff5722),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child:
                                          isLoading
                                              ? SizedBox(
                                                width: 26.0,
                                                height: 26.0,
                                                child: CircularProgressIndicator(
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
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text(
                        "Zaten bir hesabınız var mı ? Giriş Yap.",
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
}
