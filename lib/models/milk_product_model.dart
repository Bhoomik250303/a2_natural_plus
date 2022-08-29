import 'package:cloud_firestore/cloud_firestore.dart';

class MilkProductModel {
  String imageUrl;
  String name;
  List currentPrice;
  String discountPercentage;
  List packaging;
  List productDescription;

  MilkProductModel(
      {required this.imageUrl,
      required this.packaging,
      required this.currentPrice,
      required this.discountPercentage,
      required this.name,
      required this.productDescription,
      });
}
