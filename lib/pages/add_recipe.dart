import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipeapp/pages/bottomnav.dart';
import 'package:recipeapp/pages/home.dart';
import 'package:recipeapp/pages/login.dart';
import 'package:recipeapp/repositories/addRecipe_repository.dart';
import 'package:recipeapp/services/local_storage_service.dart';
import 'package:recipeapp/widget/widget_support.dart';
import 'package:recipeapp/widget/widgets.dart';
import 'ingredient_selector.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  bool isLoading = false;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  PageController controller = PageController();
  String? selectedType;
  TextEditingController _stepController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _portionController = TextEditingController();
  List<String> steps = [];

  // İçindekiler listesi artık Map formatında
  List<Map<String, dynamic>> ingredients = [];

  String? _authToken;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    _authToken = await LocalStorageService.getToken();
    if (_authToken == null) {
      // Kullanıcı giriş yapmamış, giriş sayfasına yönlendir
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }

  void _addStep() {
    if (_stepController.text.isNotEmpty) {
      setState(() {
        steps.add(_stepController.text);
        _stepController.clear();
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
    });
  }

  void _updateIngredients(List<Map<String, dynamic>> updatedIngredients) {
    setState(() {
      ingredients = updatedIngredients;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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

  Widget _buildPage1() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          _image != null
              ? Stack(
                children: [
                  Container(
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
                  ),
                  // Sağ üstte X ikonu ile resmi kaldır
                  Positioned(
                    top: 28,
                    right: 28,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _image = null;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
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
                      radius: const Radius.circular(20),
                      dashPattern: const [8, 4],
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
                          "Galeriden Resim Ekle",
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
          GestureDetector(
            onTap: () => _getImage(ImageSource.camera),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.06,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Resim Çek", style: AppWidget.semiBoldTextFeildStyle()),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                  const Icon(
                    CupertinoIcons.photo_camera_solid,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
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
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 2),
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
            value: selectedType,
            hint: const Text("Türü Seçiniz"),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 2),
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
              setState(() {
                selectedType = value;
              });
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          Row(
            children: [
              Text("İçindekiler", style: AppWidget.semiBoldTextFeildStyle()),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),

          // Yeni İçindekiler Seçici Widget
          IngredientSelector(
            selectedIngredients: ingredients,
            onIngredientsChanged: _updateIngredients,
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.001),
          GestureDetector(
            onTap: () {
              controller.nextPage(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
              );
            },
            child: Container(
              width: 240,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPage2() {
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
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 2),
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
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 2),
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
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLines: 3,
            controller: _stepController,
            style: AppWidget.LightTextFeildStyle().copyWith(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: "Adım Adım Yazınız",
              filled: false,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
            ),
          ),

          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _addStep,
            icon: const Icon(Icons.add),
            label: const Text("Adım Ekle"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 10),

          // Eklenen adımları liste halinde gösteriyoruz
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: steps.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.black,
                ),
                title: Text(steps[index]),
                trailing: IconButton(
                  onPressed: () => _removeStep(index),
                  icon: const Icon(Icons.remove),
                  color: Colors.red,
                  iconSize: 30,
                ),
              );
            },
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          GestureDetector(
            onTap: isLoading ? null : _saveRecipe,
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
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
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                          : Text(
                            "Ekle",
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // _saveRecipe() metodundaki hatalı kısmı düzeltelim
  Future<void> _saveRecipe() async {
    setState(() {
      isLoading = true;
    });
    // Token kontrolü
    final token = await LocalStorageService.getToken();
    if (token == null) {
      setState(() => isLoading = false);
      Widgets.showSnackBar(
        context,
        "Hata",
        "Oturum açmanız gerekiyor",
        ContentType.failure,
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
      return;
    }
    // Form doğrulama
    if (_detailController.text.isEmpty) {
      Widgets.showSnackBar(
        context,
        "Eksik Bilgi",
        "Lütfen tarif adını girin",
        ContentType.warning,
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    if (selectedType == null) {
      Widgets.showSnackBar(
        context,
        "Eksik Bilgi",
        "Lütfen tarif türünü seçin",
        ContentType.warning,
      );
      setState(() => isLoading = false);
      return;
    }
    if (ingredients.isEmpty) {
      Widgets.showSnackBar(
        context,
        "Eksik Bilgi",
        "Lütfen en az bir malzeme ekleyin",
        ContentType.warning,
      );
      setState(() => isLoading = false);
      return;
    }

    if (_durationController.text.isEmpty) {
      Widgets.showSnackBar(
        context,
        "Eksik Bilgi",
        "Lütfen yapılış süresini girin",
        ContentType.warning,
      );
      setState(() => isLoading = false);
      return;
    }

    if (_portionController.text.isEmpty) {
      Widgets.showSnackBar(
        context,
        "Eksik Bilgi",
        "Lütfen porsiyon sayısını girin",
        ContentType.warning,
      );
      setState(() => isLoading = false);
      return;
    }
    if (steps.isEmpty) {
      Widgets.showSnackBar(
        context,
        "Eksik Bilgi",
        "Lütfen en az bir yapılış adımı ekleyin",
        ContentType.warning,
      );
      setState(() => isLoading = false);
      return;
    }

    if (_image == null) {
      Widgets.showSnackBar(
        context,
        "Eksik Bilgi",
        "Lütfen bir tarif görseli ekleyin",
        ContentType.warning,
      );
      setState(() => isLoading = false);
      return;
    }

    try {
      print("Tarif adı: ${_detailController.text}");
      print("Süre: ${_durationController.text}");
      print("Porsiyon: ${_portionController.text}");
      print("Adımlar: $steps");
      print("Seçilen malzemeler: $ingredients");
      print("Resim yolu: ${_image?.path}");
      final repository = AddrecipeRepository();

      // Debug logları
      print("Gönderilen Token: ${token.substring(0, 20)}..."); // Kısmi gösterim
      print("API Endpoint: http://192.168.150.74:8000/users/recipes/");

      await repository.uploadRecipe(
        authToken: token, // Token'ı açıkça geç
        title: _detailController.text,
        description: "",
        ingredients: ingredients,
        instructions: steps,
        foodType: selectedType!,
        prepTime: int.tryParse(_durationController.text) ?? 0,
        servings: int.tryParse(_portionController.text) ?? 1,
        imageFile: _image!,
      );

      Widgets.showSnackBar(
        context,
        "Başarılı",
        "Tarif başarıyla eklendi",
        ContentType.success,
      );
      // 1. SEÇENEK: Tüm sayfaları temizleyip ana sayfaya git
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Bottomnav(),
        ), // HomePage yerine ana sayfanızın widget adını yazın
        (route) => false,
      );
    } catch (e) {
      setState(() => isLoading = false);

      if (e.toString().contains("Authentication") ||
          e.toString().contains("401")) {
        await LocalStorageService.clearAll();
        Widgets.showSnackBar(
          context,
          "Oturum Sonlandı",
          "Lütfen tekrar giriş yapın",
          ContentType.failure,
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      } else {
        print(e);
        Widgets.showSnackBar(
          context,
          "Hata",
          e.toString(),
          ContentType.failure,
        );
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
