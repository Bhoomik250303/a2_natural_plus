import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:a2_natural/constants/form_constants.dart';
import 'package:a2_natural/models/cart_orders_product_list_model.dart';
import 'package:a2_natural/models/product_display_details_model.dart';
import 'package:a2_natural/models/user_info_model.dart';
import 'package:a2_natural/screens/cart_screen.dart';
import 'package:a2_natural/screens/milk_screen.dart';
import 'package:a2_natural/screens/milk_screen_subscribed_screen.dart';
import 'package:a2_natural/screens/product_categorywise_detailed_list_screen.dart';
import 'package:a2_natural/services/database_services/database_service.dart';
import 'package:provider/provider.dart';

class ProductDetailsViewScreen extends StatefulWidget {
  ProductDisplayDetailsModel productDetails;

  ProductDetailsViewScreen({
    required this.productDetails,
  });

  @override
  _ProductDetailsViewScreenState createState() =>
      _ProductDetailsViewScreenState();
}

class _ProductDetailsViewScreenState extends State<ProductDetailsViewScreen> {
  ScrollController _scrollControllerDescription = ScrollController();
  ScrollController _scrollControllerMain = ScrollController();

  int quantity = 1;
  Color? colorsOfPackaging = Colors.green;
  List<Color?> _listOfColors = [];
  List<Color?> _listOfButtonColors = [];

  Map mapOfDataToCart = {};
  List cartListFromDatabase = [];
  String selectedPackaging = "";
  int packagingIndex = 0;
  int selectedIndex = 0;
  initState() {
    super.initState();
    _listOfColors = List.generate(
      widget.productDetails.packaging.length,
      (index) {
        return index == 0 ? Colors.white : Colors.black;
      },
    );

    _listOfButtonColors = List.generate(
      widget.productDetails.packaging.length,
      (index) {
        return index == 0 ? Colors.green : Colors.transparent;
      },
    );
  }

  void scrollToAnIndex() {
    final double end = _scrollControllerDescription.position.maxScrollExtent;
    _scrollControllerDescription.animateTo(end,
        duration: Duration(seconds: 1), curve: Curves.decelerate);
  }

  void goToTop() {
    _scrollControllerMain.animateTo(0,
        duration: Duration(seconds: 1), curve: Curves.decelerate);
  }

  int lengthListOfCart = 0;
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    selectedPackaging = widget.productDetails.packaging[0];
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    print('packagingIndex$packagingIndex');
    return StreamProvider.value(
        initialData: null,
        value: DatabaseServices(uid: user?.uid).cartDetailsStream,
        builder: (context, child) {
          // int totalNumberOfLinesInProductDescription = 0;
          UserInfoModel? userInfo = Provider.of<UserInfoModel?>(context);
          double textScale = MediaQuery.of(context).textScaleFactor;

          // widget.productDetails.productDescription.forEach((element) {
          //   totalNumberOfLinesInProductDescription++;
          //   (element.length) * textScale > widthScreen
          //       ? totalNumberOfLinesInProductDescription++
          //       : null;
          // });

          // print(
          //     'totalNumberOfLinesInProductDescription$totalNumberOfLinesInProductDescription');
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              foregroundColor: Colors.black,
            ),
            body: SingleChildScrollView(
              controller: _scrollControllerMain,
              physics: BouncingScrollPhysics(),
              child: SafeArea(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 4.0,
                      ),
                      CachedNetworkImage(
                        imageUrl: widget.productDetails.imageUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          height: 0.4 * heightScreen,
                          width: widthScreen,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          height: 0.25 * heightScreen,
                          width: widthScreen,
                          child: CircularProgressIndicator(
                            color: Colors.green,
                            strokeWidth: 0.5,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        contentPadding: EdgeInsets.zero,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              widget.productDetails.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Price -',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Actual MRP: ',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          '\u{20B9}${int.parse(widget.productDetails.currentPrice[packagingIndex]) * quantity}',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 16,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4.0,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            color: Colors.green,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${(double.parse(widget.productDetails.discountPercentage)).round()}% Off',
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
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'You get at: ',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          '\u{20B9}${(int.parse(widget.productDetails.currentPrice[packagingIndex]) * (100 - double.parse(widget.productDetails.discountPercentage)) * quantity / 100).round()}',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6.0,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'You save: ',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          '\u{20B9}${((int.parse(widget.productDetails.currentPrice[packagingIndex]) * (double.parse(widget.productDetails.discountPercentage)) / 100) * quantity).round()}',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 16.0,
                              ),
                              height: 32,
                              width: widthScreen,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    widget.productDetails.packaging.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: TextButton(
                                      style: ButtonStyle(
                                        side: MaterialStateProperty.all(
                                            BorderSide(color: Colors.green)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          _listOfButtonColors[index],
                                        ),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          packagingIndex = index;
                                          selectedPackaging = widget
                                              .productDetails.packaging[index];
                                        });
                                        for (int i = 0;
                                            i < _listOfColors.length;
                                            i++) {
                                          if (index == i) {
                                            if (_listOfColors[index] ==
                                                Colors.black) {
                                              setState(() {
                                                for (int j = 0;
                                                    j < _listOfColors.length;
                                                    j++) {
                                                  _listOfColors[j] =
                                                      Colors.black;
                                                }
                                                _listOfColors[index] =
                                                    Colors.white;
                                              });
                                            } else if (_listOfColors[index] ==
                                                Colors.white) {
                                              setState(() {
                                                _listOfColors[index] =
                                                    Colors.black;
                                              });
                                            }

                                            if (_listOfButtonColors[index] ==
                                                Colors.transparent) {
                                              setState(() {
                                                for (int j = 0;
                                                    j <
                                                        _listOfButtonColors
                                                            .length;
                                                    j++) {
                                                  _listOfButtonColors[j] =
                                                      Colors.transparent;
                                                }
                                                _listOfButtonColors[index] =
                                                    Colors.green;
                                              });
                                            } else if (_listOfButtonColors[
                                                    index] ==
                                                Colors.green) {
                                              setState(() {
                                                _listOfButtonColors[index] =
                                                    Colors.transparent;
                                              });
                                            }
                                          }
                                        }
                                      },
                                      child: Text(
                                        widget.productDetails.packaging[index],
                                        style: TextStyle(
                                          color: _listOfColors[index],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 16.0,
                            ),
                            Text('Quantity'),
                            SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    if (quantity > 1) {
                                      setState(() {
                                        quantity--;
                                      });
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.red,
                                    child: Icon(
                                      Icons.arrow_drop_down_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Text(
                                  '$quantity',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue,
                                  ),
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.green.withOpacity(
                                      0.8,
                                    ),
                                    child: Icon(
                                      Icons.arrow_drop_up_rounded,
                                      size: 24,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16.0,
                            )
                          ],
                        ),
                      ),
                      widget.productDetails.isMilk
                          ? Container(
                              width: widthScreen,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: TextButton(
                                style: buttonStyle,
                                onPressed: () {
                                  userInfo!.isSubscribed
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MilkScreenSubcribedScreen(
                                              userInfoModel: userInfo,
                                            ),
                                          ),
                                        )
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MilkScreen(
                                                orderDetails: {
                                                  'quantity':
                                                      quantity.toString(),
                                                  'product': widget
                                                      .productDetails.name,
                                                },
                                                price: ((double.parse(widget
                                                                    .productDetails
                                                                    .currentPrice[
                                                                packagingIndex]) *
                                                            (1 -
                                                                double.parse(widget
                                                                        .productDetails
                                                                        .discountPercentage) /
                                                                    100))
                                                        .toInt())
                                                    .toString()),
                                          ),
                                        );
                                },
                                child: Text(
                                  'Subscribe',
                                  style: textStyleFrom.copyWith(
                                      color: Colors.white),
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: 16,
                      ),
                      ListTile(
                        onTap: () {
                          showModalBottomSheet(
                              barrierColor: Colors.green.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(32.0),
                                      topRight: Radius.circular(32.0))),
                              context: context,
                              builder: (context) {
                                return Container(
                                  margin: EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.2),
                                      borderRadius:
                                          BorderRadius.circular(32.0)),
                                  child: ListView.builder(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    controller: _scrollControllerDescription,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: widget.productDetails
                                            .productDescription.length +
                                        1,
                                    itemBuilder: (context, index) {
                                      if (index == 0) {
                                        return Column(
                                          children: [
                                            Text(
                                              'Product Description',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 32.0,
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Container(
                                          margin: EdgeInsets.only(top: 6.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                String.fromCharCode(0x2022),
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 24,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8.0,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  widget.productDetails
                                                          .productDescription[
                                                      index - 1],
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                );
                                ;
                              });
                        },
                        title: Text(
                          'Product Description',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          'Tap to know the nutritional benefits',
                          style: TextStyle(
                              color: Colors.grey[850],
                              fontWeight: FontWeight.w500),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      // Container(
                      //   padding: EdgeInsets.symmetric(
                      //       horizontal: 8.0, vertical: 2.0),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(16.0),
                      //     color: Colors.green.withOpacity(0.2),
                      //   ),
                      //   height: (36.0 *
                      //           widget
                      //               .productDetails.productDescription.length) *
                      //       textScale,
                      //   child: Center(
                      //     child: ListView.builder(
                      //       controller: _scrollControllerDescription,
                      //       physics: BouncingScrollPhysics(),
                      //       itemCount:
                      //           widget.productDetails.productDescription.length,
                      //       itemBuilder: (context, index) {
                      //         return Container(
                      //           margin: EdgeInsets.only(top: 6.0),
                      //           child: Row(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             children: [
                      //               Text(
                      //                 String.fromCharCode(0x2022),
                      //                 style: TextStyle(
                      //                   color: Colors.green,
                      //                   fontSize: 24,
                      //                 ),
                      //               ),
                      //               SizedBox(
                      //                 width: 8.0,
                      //               ),
                      //               Flexible(
                      //                 child: Text(
                      //                   widget.productDetails
                      //                       .productDescription[index],
                      //                   style: TextStyle(
                      //                     fontSize: 18,
                      //                     color: Colors.black,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         );
                      //       },
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     goToTop();
            //   },
            //   child: Icon(Icons.arrow_upward_outlined),
            //   splashColor: Colors.greenAccent,
            //   backgroundColor: Colors.green,
            // ),
            bottomNavigationBar: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: TextButton(
                onPressed: () async {
                  await DatabaseServices(uid: user?.uid).addToCartFunction(
                    selectedPackaging,
                    widget.productDetails.currentPrice[packagingIndex],
                    widget.productDetails.name,
                    quantity,
                    widget.productDetails.imageUrl,
                    widget.productDetails.discountPercentage,
                  );
                  Fluttertoast.showToast(
                      msg: '${widget.productDetails.name} added to cart');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartScreen()));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.green,
                  ),
                ),
                child: Text(
                  'Add to Cart',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        });
  }

  addToCartFunction() async {
    await DatabaseServices(uid: FirebaseAuth.instance.currentUser?.uid)
        .usersList
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      'cart': FieldValue.arrayRemove(
        ['No items in cart'],
      ),
    });

    await DatabaseServices(uid: FirebaseAuth.instance.currentUser?.uid)
        .usersList
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update(
      {
        'cart': FieldValue.arrayUnion(
          [
            {
              'packaging': selectedPackaging,
              'price': widget.productDetails.currentPrice[packagingIndex],
              'product': widget.productDetails.name,
              'quantity': quantity,
              'imageUrl': widget.productDetails.imageUrl,
            },
          ],
        ),
      },
    );
  }
}
