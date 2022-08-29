// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:a2_natural/models/cart_orders_product_list_model.dart';
// import 'package:a2_natural/models/product_display_details_model.dart';
// import 'package:a2_natural/models/user_info_model.dart';
// import 'package:a2_natural/screens/checkout_screen.dart';
// import 'package:a2_natural/screens/list_of_existing_address_screen.dart';
// import 'package:a2_natural/screens/maps_address_picker.dart';
// import 'package:a2_natural/screens/picking_address_screen.dart';
// import 'package:a2_natural/services/authentication_services/authentication_service.dart';
// import 'package:a2_natural/services/database_services/database_service.dart';
// import 'package:provider/provider.dart';

// class VerticalCardsOrderHistory extends StatefulWidget {
//   List<CartOrdersProductListModel>? listOfProducts;
//   String screen;
//   VerticalCardsOrderHistory(
//       {Key? key, required this.listOfProducts, required this.screen})
//       : super(key: key);
//   @override
//   _VerticalCardsOrderHistoryState createState() =>
//       _VerticalCardsOrderHistoryState();
// }

// class _VerticalCardsOrderHistoryState extends State<VerticalCardsOrderHistory> {
//   List cartList = [];

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     setState(() {
      
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
   
//     return Scaffold(
//       body: ,
//     );
//   }

//   // functionSomething(DocumentSnapshot userDetials) async {
//   //   _listOfFutureOfDocRef = await gettingFutureData(userDetials);
//   // }

//   // Future gettingFutureData(DocumentSnapshot? userDetails) async {
//   //   List output = [];
//   //   userDetails?['cart'].forEach((val) {
//   //     output.add(val.get());
//   //   });
//   //   return output;
//   // }

//   // Future<ProductDisplayDetailsModel> futureToDisplayModel(
//   //     Future something) async {
//   //   DocumentSnapshot snap = await something;
//   //   return ProductDisplayDetailsModel(
//   //       imageUrl: snap['imageURl'],
//   //       packaging: snap['packaging'],
//   //       name: snap['productName']);
//   // }
// }
