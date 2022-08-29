import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:a2_natural/models/cart_orders_product_list_model.dart';
import 'package:a2_natural/models/user_info_model.dart';
import 'package:a2_natural/screens/list_of_existing_address_screen.dart';
import 'package:a2_natural/screens/picking_address_screen.dart';
import 'package:a2_natural/services/database_services/database_service.dart';
import 'package:a2_natural/shared.dart/vertical_cards_order_history.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // List<DocumentReference> _listOfProductsInCart = [];

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    User? user = Provider.of<User?>(context);

    return StreamProvider.value(
        initialData: null,
        value: DatabaseServices(uid: user?.uid).cartDetailsStream,
        builder: (context, child) {
          UserInfoModel? userInfoModel = Provider.of<UserInfoModel?>(context);
          print('userInfoModel ${userInfoModel?.cart?.length}');

          if (userInfoModel == null) {
            return Scaffold(
              body: Container(
                child: Center(
                  child: CircularProgressIndicator(color: Colors.green),
                ),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: Text('Cart'),
              centerTitle: true,
              backgroundColor: Colors.green,
            ),
            body: userInfoModel.cart?.length != 0 && userInfoModel != null
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: userInfoModel.cart!.length + 1,
                    itemBuilder: (context, int index) {
                      double totalPrice = 0;
                      double totalSaved = 0;
                      userInfoModel.cart!.forEach((element) {
                        totalPrice += double.parse(element['price']) *
                            (100 -
                                double.parse(element['discountPercentage'])) *
                            double.parse(element['quantity'].toString()) /
                            100;
                      });

                      userInfoModel.cart!.forEach((element) {
                        totalSaved += double.parse(element['price']) *
                            double.parse(element['discountPercentage']) /
                            100 *
                            element['quantity'];
                      });

                      if (index == 0) {
                        return Container(
                          margin: EdgeInsets.only(left: 16.0, top: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Center(
                                  child: Text(
                                    'Total price of your order: \u{20B9}${totalPrice.round()}',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              Container(
                                child: Center(
                                  child: Text(
                                    'Total Money Saved: \u{20B9}${totalSaved.round()}',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                            ],
                          ),
                        );
                      }

                      return Card(
                        elevation: 15,
                        shadowColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            16.0,
                          ),
                        ),
                        color: Colors.white,
                        margin: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                CachedNetworkImage(
                                  imageUrl: userInfoModel.cart![
                                          userInfoModel.cart!.length - index]
                                      ['imageUrl'],
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 0.3 * widthScreen,
                                    height: 0.15 * heightScreen,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16.0),
                                      ),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(
                                    color: Colors.green,
                                    strokeWidth: 0.5,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        children: [
                                          Text(
                                            '${userInfoModel.cart![userInfoModel.cart!.length - index]['product']}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        'Price : \u{20B9}${(double.parse(userInfoModel.cart![userInfoModel.cart!.length - index]['price']) * (100 - double.parse(userInfoModel.cart![userInfoModel.cart!.length - index]['discountPercentage'])) * userInfoModel.cart![userInfoModel.cart!.length - index]['quantity'] / 100).round()}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.green,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        'Saved : \u{20B9}${(double.parse(userInfoModel.cart![userInfoModel.cart!.length - index]['price']) * double.parse(userInfoModel.cart![userInfoModel.cart!.length - index]['discountPercentage']) / 100 * userInfoModel.cart![userInfoModel.cart!.length - index]['quantity']).round()}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.green,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        userInfoModel.cart![
                                                userInfoModel.cart!.length -
                                                    index]['packaging']
                                            .toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2.0,
                                      ),
                                      Text(
                                        'Quantity : ' +
                                            userInfoModel.cart![
                                                    userInfoModel.cart!.length -
                                                        index]['quantity']
                                                .toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    if (userInfoModel.cart?.length == 1) {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser?.uid)
                                          .update(
                                        {
                                          'cart': FieldValue.arrayRemove(
                                            [
                                              userInfoModel.cart?[
                                                  userInfoModel.cart!.length -
                                                      index]
                                            ],
                                          ),
                                        },
                                      );
                                    }

                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser?.uid)
                                        .update({
                                      'cart': FieldValue.arrayRemove(
                                        [
                                          userInfoModel.cart?[
                                              userInfoModel.cart!.length -
                                                  index]
                                        ],
                                      ),
                                    });
                                    setState(() {});
                                    // setState(() {
                                    //   totalSaved -= (double.parse(userInfoModel
                                    //           .cart?[index - 1]['price']) *
                                    //       double.parse(
                                    //           userInfoModel.cart?[index - 1]
                                    //               ['discountPercentage']) /
                                    //       100 *
                                    //       userInfoModel.cart?[index - 1]
                                    //           ['quantity']);

                                    //   totalPrice -= double.parse(userInfoModel
                                    //           .cart?[index - 1]['price']) *  userInfoModel.cart?[index - 1]
                                    //           ['quantity'] *
                                    //       (100 -
                                    //           double.parse(
                                    //               userInfoModel.cart?[index - 1]
                                    //                   ['discountPercentage'])) /
                                    //       100;
                                    // });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                ),
                                color: Colors.green,
                              ),
                              width: widthScreen,
                              child: Center(
                                child: Text(
                                  ' ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Container(
                    child: Center(
                      child: Text(
                        'No item in cart',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
            bottomNavigationBar: userInfoModel.cart?.length == 0
                ? null
                : Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              16.0,
                            ),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Colors.green,
                        ),
                      ),
                      child: Text(
                        'Proceed to checkout',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => userInfoModel.address!.isEmpty
                                ? MapsPicker(
                                    id: 'addAndProceed',
                                    addressCallback: () {},
                                  )
                                : ListOfExistingAddress(
                                    addressCallback: () {},
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
          );
        });
  }

  docSnapToList(DocumentSnapshot docDetails) {
    List listDetails = docDetails['cart']..toList();
    return listDetails;
  }

  listDocrefToSnap(List docRefList) {
    List listOfDocSnapshot = docRefList.map((e) => e.get()).toList();
  }
}
