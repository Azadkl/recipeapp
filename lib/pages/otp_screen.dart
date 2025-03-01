import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController mailcontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 70.0),
            Container(
              alignment: Alignment.topCenter,
              child: Text(
                "Emailinizi kontrol ediniz!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "Kodu e-mailinize gönderdik.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 150,),
            Form(
              key:_formKey,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildNode1Box(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildNode2Box(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildNode3Box(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: buildNode4Box(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
      )
    );
  }

  Container buildNode1Box() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8)
      ),
      child: TextFormField(
        autofocus: true,
        textInputAction: TextInputAction.next,
        keyboardAppearance: Brightness.light,
        keyboardType: TextInputType.phone,
        textAlign: TextAlign.center,
        inputFormatters: [LengthLimitingTextInputFormatter(1)],
        decoration:InputDecoration(),

        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Eksik işlem yapıldı.";
          }
          return null;
        },
      ),
    );
  }

  Container buildNode2Box() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8)
      ),
      child: TextFormField(
        autofocus: true,
        textInputAction: TextInputAction.next,
        keyboardAppearance: Brightness.light,
        keyboardType: TextInputType.phone,
        textAlign: TextAlign.center,
        inputFormatters: [LengthLimitingTextInputFormatter(1)],
        decoration:InputDecoration(),

        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Eksik işlem yapıldı.";
          }
          return null;
        },
      ),
    );
  }

  Container buildNode3Box() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8)
      ),
      child: TextFormField(
        autofocus: true,
        textInputAction: TextInputAction.next,
        keyboardAppearance: Brightness.light,
        keyboardType: TextInputType.phone,
        textAlign: TextAlign.center,
        inputFormatters: [LengthLimitingTextInputFormatter(1)],
        decoration:InputDecoration(),

        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Eksik işlem yapıldı.";
          }
          return null;
        },
      ),
    );
  }

  Container buildNode4Box() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8)
      ),
      child: TextFormField(
        autofocus: true,
        textInputAction: TextInputAction.next,
        keyboardAppearance: Brightness.light,
        keyboardType: TextInputType.phone,
        textAlign: TextAlign.center,
        inputFormatters: [LengthLimitingTextInputFormatter(1)],
        decoration:InputDecoration(),

        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Eksik işlem yapıldı.";
          }
          return null;
        },
      ),
    );
  }
}
