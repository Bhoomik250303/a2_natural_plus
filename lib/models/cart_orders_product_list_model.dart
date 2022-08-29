class CartOrdersProductListModel {
  String imageUrl;
  String name;
  String price;
  String? cancelledPrice;
  String packaging;
  int quantity;
  String category;
  String index;

  CartOrdersProductListModel(
      {required this.name,
      required this.imageUrl,
      required this.price,
      required this.packaging,
      required this.quantity,
      required this.category,
      required this.index});
}
