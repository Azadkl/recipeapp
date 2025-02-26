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
        'Tarifler arasından en beğendiğinizi seçin ve hemen mutfağa girin!',
    image: "assets/images/screen3.jpg",
    title: 'En Lezzetli Tarifleri Keşfedin',
  ),
  UnboardingContent(
    description:
        'Favori tariflerinizi kaydedin,kendi tariflerinizi ekleyin ve toplulukla paylaşın.',
    image: "assets/images/screen2.jpg",
    title:
        'Tariflerinizi Saklayın ve Paylaşın',
  ),
  UnboardingContent(
    description:
        'Mevcut malzemelerinizle hangi yemekleri yapabileceğinizi keşfedin!',
    image: "assets/images/screen1.jpg",
    title: 'Elinizdeki Malzemelerle Tarif Bulun',
  ),
];
