class ProductDisplayDetailsModel {
  String imageUrl;
  String name;
  List currentPrice;
  String discountPercentage;
  List packaging;
  List productDescription;
  bool isMilk;
  ProductDisplayDetailsModel({
    required this.imageUrl,
    required this.packaging,
    required this.currentPrice,
    required this.discountPercentage,
    required this.name,
    required this.productDescription,
    required this.isMilk,
  });
}
