import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipeapp/widget/widget_support.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  PageController controller = PageController();
  String? selectedType;
  TextEditingController _stepController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  TextEditingController _ingredientController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _portionController = TextEditingController();
  List<String> steps = [];
  List<String> ingredient = [];

  void _addStep() {
    if (_stepController.text.isNotEmpty) {
      setState(() {
        steps.add("${_stepController.text}");

        _stepController.clear(); // TextField'ı temizle
      });
    }
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });

        // Simulate AI processing delay
        await Future.delayed(const Duration(seconds: 2));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Görüntü alınamadı: $e')));
    }
  }

  void _removeStep(int index) {
    setState(() {
      steps.removeAt(index);

      _stepController.clear(); // TextField'ı temizle
    });
  }

  void _addIngredient() {
    if (_ingredientController.text.isNotEmpty) {
      setState(() {
        ingredient.add("${_ingredientController.text}");

        _ingredientController.clear(); // TextField'ı temizle
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      ingredient.removeAt(index);

      _ingredientController.clear(); // TextField'ı temizle
    });
  }

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
          _image != null
              ? Container(
                height: 200,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              )
              : Stack(
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
                      child: const Center(),
                    ),
                  ),
                  InkResponse(
                    onTap: () => _getImage(ImageSource.gallery),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          "assets/images/image.svg",
                          height: MediaQuery.of(context).size.height * 0.06,
                        ),
                        Text(
                          "Resim Ekle",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
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
            controller: _detailController,
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
            keyboardType: TextInputType.multiline, // Çok satırlı giriş desteği
            textInputAction: TextInputAction.newline, // ✔ yerine ↵ tuşu
            maxLines: 3,
            controller: _ingredientController,
            style: AppWidget.LightTextFeildStyle().copyWith(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: "Kullanılacak malzemeleri madde olarak ekleyiniz.",
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

          SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _addIngredient,
            icon: Icon(Icons.add),
            label: Text("Malzeme Ekle"),
          ),
          SizedBox(height: 10),
          // Eklenen adımları liste halinde gösteriyoruz
          ListView.builder(
            shrinkWrap: true, // Parent widget ile uyumlu hale getirir
            physics:
                NeverScrollableScrollPhysics(), // Tekrardan kaydırma engellenir
            itemCount: ingredient.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.black,
                ),
                title: Text(ingredient[index]),
                trailing: IconButton(
                  onPressed: () => _removeIngredient(index),
                  icon: Icon(Icons.remove),
                  color: Colors.red,
                  iconSize: 30,
                ),
              );
            },
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
            controller: _durationController,
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
              Text("Kaç Kişilik", style: AppWidget.semiBoldTextFeildStyle()),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),

          TextFormField(
            textAlign: TextAlign.start,
            keyboardType: TextInputType.number,
            controller: _portionController,
            style: AppWidget.LightTextFeildStyle().copyWith(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: "Kişi Sayısını Giriniz",
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
            keyboardType: TextInputType.multiline, // Çok satırlı giriş desteği
            textInputAction: TextInputAction.newline, // ✔ yerine ↵ tuşu
            maxLines: 3,
            controller: _stepController,
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

          SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _addStep,
            icon: Icon(Icons.add),
            label: Text("Adım Ekle"),
          ),
          SizedBox(height: 10),
          // Eklenen adımları liste halinde gösteriyoruz
          ListView.builder(
            shrinkWrap: true, // Parent widget ile uyumlu hale getirir
            physics:
                NeverScrollableScrollPhysics(), // Tekrardan kaydırma engellenir
            itemCount: steps.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.black,
                ),
                title: Text(steps[index]),
                trailing: IconButton(
                  onPressed: () => _removeStep(index),
                  icon: Icon(Icons.remove),
                  color: Colors.red,
                  iconSize: 30,
                ),
              );
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          GestureDetector(
            onTap: () => _getImage(ImageSource.camera),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.06,

              child: Icon(
                CupertinoIcons.photo_camera_solid,
                color: Colors.black,
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
