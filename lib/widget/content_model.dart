class UnboardingContent {
  String image;
  String title;
  String description;
  UnboardingContent({
    required this.description,
    required this.image,
    required this.title,
  });
}

List<UnboardingContent> contents = [
  UnboardingContent(
    description:
        'Tarifler arasından en beğendiğinizi seçin \n             ve hemen mutfağa girin!',
    image: "assets/images/screen1.png",
    title: 'En Lezzetli Tarifleri Keşfedin',
  ),
  UnboardingContent(
    description:
        '          Favori tariflerinizi kaydedin,kendi tariflerinizi ekleyin ve toplulukla paylaşın.',
    image: "assets/images/screen2.png",
    title:
        '        Tariflerinizi Saklayın ve       \n                      Paylaşın',
  ),
  UnboardingContent(
    description:
        'Mevcut malzemelerinizle hangi yemekleri \n              yapabileceğinizi keşfedin!',
    image: "assets/images/screen3.png",
    title: 'Elinizdeki Malzemelerle Tarif \n                   Bulun',
  ),
];
