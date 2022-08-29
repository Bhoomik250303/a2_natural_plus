
class UserInfoModel {
  String? location;
  List? cart;
  List? orders;
  // String? name;
  List? address;
  String? phonenumber;
  String? email;
  String? profileImageUrl;
  bool isSubscribed;
  Map? subscriptionData;
  String username;

  UserInfoModel({
    required this.cart,
    required this.location,
    required this.orders,
    this.address,
    this.email,
    // this.name,
    this.phonenumber,
    required this.profileImageUrl,
    required this.isSubscribed,
    this.subscriptionData,
    required this.username,
  });
}
