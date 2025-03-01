import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipeapp/widget/widget_support.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  PageController controller = PageController();
  String? selectedType;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PageView(
              controller: controller,
              children: [_buildPage1(), _buildPage2()],
            ),
          ),
        ),
      ),
    );
  }

  _buildPage1() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),

          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.hardEdge,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.16,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(20),
                  dashPattern: [8, 4],
                  color: Colors.black,
                  strokeWidth: 2,
                  child: Center(),
                ),
              ),
              InkResponse(
                onTap: () {},
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "assets/images/image.svg",
                      height: MediaQuery.of(context).size.height * 0.06,
                    ),
                    Text(
                      "Resim Ekle",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Text(
                      "(10 Mb'a kadar)",
                      style: AppWidget.LightTextFeildStyle(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          Row(
            children: [
              Text(
                "Tarif Detayları",
                style: AppWidget.semiBoldTextFeildStyle(),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          TextFormField(
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
            style: AppWidget.LightTextFeildStyle().copyWith(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: "Yiyecek/İçecek ismini giriniz",
              filled: false,
              border: OutlineInputBorder(
                // Varsayılan border
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                // Tıklanınca aktif border
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.black, // Odaklanınca mavi border olacak
                  width: 2,
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          Row(
            children: [Text("Tür", style: AppWidget.semiBoldTextFeildStyle())],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),

          // Seçilen değeri saklamak için
          DropdownButtonFormField<String>(
            value: selectedType, // Seçili değer
            hint: Text("Türü Seçiniz"), // Varsayılan hint metni
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            items:
                ["Yemek", "Tatlı", "İçecek", "Çorba"]
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
            onChanged: (value) {
              selectedType = value;
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          Row(
            children: [
              Text("İçindekiler", style: AppWidget.semiBoldTextFeildStyle()),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          TextFormField(
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
            maxLines: 3,
            style: AppWidget.LightTextFeildStyle().copyWith(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: "Kullanılacak Malzemeleri Yazınız",
              filled: false,
              border: OutlineInputBorder(
                // Varsayılan border
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                // Tıklanınca aktif border
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.black, // Odaklanınca mavi border olacak
                  width: 2,
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          GestureDetector(
            onTap: () {
              controller.nextPage(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeIn,
              );
            },
            child: Container(
              width: 240,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "Devam et",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildPage2() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          Row(
            children: [
              Text(
                "Yapılış Süresi(Dakika)",
                style: AppWidget.semiBoldTextFeildStyle(),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),

          TextFormField(
            textAlign: TextAlign.start,
            keyboardType: TextInputType.number,
            style: AppWidget.LightTextFeildStyle().copyWith(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: "Süreyi Giriniz",
              filled: false,
              border: OutlineInputBorder(
                // Varsayılan border
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                // Tıklanınca aktif border
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.black, // Odaklanınca mavi border olacak
                  width: 2,
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          Row(
            children: [
              Text("Nasıl Yapılır", style: AppWidget.semiBoldTextFeildStyle()),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          TextFormField(
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
            maxLines: 3,
            style: AppWidget.LightTextFeildStyle().copyWith(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: "Adım Adım Yazınız",
              filled: false,
              border: OutlineInputBorder(
                // Varsayılan border
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                // Tıklanınca aktif border
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.black, // Odaklanınca mavi border olacak
                  width: 2,
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 240,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "Ekle",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
