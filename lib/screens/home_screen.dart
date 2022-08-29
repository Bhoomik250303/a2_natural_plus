import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:badges/badges.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:a2_natural/constants/form_constants.dart';
import 'package:a2_natural/models/categorywise/product_catrgory_list_model.dart';
import 'package:a2_natural/models/milk_product_model.dart';
import 'package:a2_natural/models/product_display_details_model.dart';
import 'package:a2_natural/models/user_info_model.dart';
import 'package:a2_natural/screens/cart_screen.dart';
import 'package:a2_natural/screens/milk_screen.dart';
import 'package:a2_natural/screens/milk_screen_subscribed_screen.dart';
import 'package:a2_natural/screens/user_details_form_screen.dart';
import 'package:a2_natural/services/authentication_services/authentication_service.dart';
import 'package:a2_natural/services/database_services/database_service.dart';
import 'package:a2_natural/shared.dart/drawer_screen_shared.dart';
import 'package:a2_natural/shared.dart/horizontal_banner_scrollview_home.dart';
import 'package:a2_natural/shared.dart/horizontal_card_product.dart';
import 'package:a2_natural/shared.dart/milk_product_horizontal_scroll.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  User? user;

  HomeScreen({this.user});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? imageUrl;
  User? userField;
  UserInfoModel? userInfoModel;
  String? phoneNumber;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 0), () {
      if (userInfoModel?.phonenumber == '') {
        return showModalBottomSheet(
          isDismissible: false,
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: Container(
                height: 0.2 * MediaQuery.of(context).size.height,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        'We need your phone number',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                      ),
                      TextFormField(
                        maxLength: 10,
                        validator: (val) {
                          val!.length < 10
                              ? "Enter correct phone number"
                              : null;
                        },
                        onChanged: (String val) {
                          setState(() {
                            phoneNumber = val;
                          });
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefix: Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Text(
                              '+91',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          counterText: '',
                          enabled: true,
                          enabledBorder: inputBorderForm,
                          focusedBorder: inputBorderForm,
                        ),
                      ),
                      TextButton(
                        style: buttonStyle,
                        onPressed: () async {
                          phoneNumber?.length == 10
                              ? {
                                  await AuthServices()
                                      .mobilePhoneSetup(phoneNumber!),
                                  await DatabaseServices()
                                      .usersList
                                      .doc(userField?.uid)
                                      .update(
                                    {
                                      'phonenumber': phoneNumber,
                                    },
                                  )
                                }
                              : {
                                  Fluttertoast.showToast(
                                    msg: 'Enter a valid phone number',
                                  ),
                                };
                        },
                        child: Container(
                          child: Center(
                            child: Text(
                              'Submit',
                              style:
                                  textStyleFrom.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
    });
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<ProductDairyCategoryListModel> listOfCategoriesWithMilkFirst = [];
  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    double heightOne = 0.20 * heightScreen;
    double heightTwo = 0.25 * heightScreen;

    User? user = Provider.of<User?>(context);

    List<ProductDairyCategoryListModel>? _listOfCategories =
        Provider.of<List<ProductDairyCategoryListModel>>(context);

    List<MilkProductModel>? _listOfMilkProducts =
        Provider.of<List<MilkProductModel>?>(context);

    UserInfoModel? userInfoModel = Provider.of<UserInfoModel?>(context);

    return userInfoModel == null
        ? Scaffold(
            body: Container(
              child: Center(
                  child: CircularProgressIndicator(
                color: Colors.green,
              )),
            ),
          )
        : Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              titleSpacing: 0,
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                },
              ),
              elevation: 0.5,
              backgroundColor: Colors.green,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello ${userInfoModel.username}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  userInfoModel != null && userInfoModel.isSubscribed
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Center(
                                child: Text(
                                  String.fromCharCode(0x2022),
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 4.0,
                            ),
                            Container(
                              child: Center(
                                child: Text(
                                  'Subscribed',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.0,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 12.0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Badge(
                        badgeColor: Colors.orange,
                        badgeContent: Text(
                          userInfoModel.cart?.length.toString() ?? '0',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Icon(
                          Icons.shopping_cart,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(
                        left: 8.0,
                        top: 16.0,
                      ),
                      child: RichText(
                        text: const TextSpan(
                          text: 'Get',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' Milk,',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: 'Vegetable',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: ' &',
                            ),
                            TextSpan(
                              text: ' Oil',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 8.0,
                      ),
                      child: const Text(
                        'At your doorsteps',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Container(
                      height: 210,
                      width: widthScreen,
                      margin: const EdgeInsets.only(
                        top: 8.0,
                      ),
                      child: HorizontalBannerScrollWidget(
                        height: heightOne,
                        listOfImagesUrls: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                0.0,
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/milk.jpg',
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                0.0,
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/oil.jpg',
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                0.0,
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/organics.jpg',
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    Container(
                      height: heightTwo,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                            'assets/a.jpg',
                          ),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          userInfoModel.isSubscribed
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MilkScreenSubcribedScreen(
                                      userInfoModel: userInfoModel,
                                    ),
                                  ),
                                )
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MilkScreen(orderDetails: {}, price: ''),
                                  ),
                                );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 32.0,
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Categories",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        )),
                    //TODO
                    SizedBox(
                      height: heightTwo,
                      width: widthScreen,
                      child: HorizontalCardProduct(
                        listOfImagesUrl: _listOfCategories,
                        useCase: 'Categories',
                        height: heightTwo,
                        categorySlide: 0,
                        spaceBetweenCards: 16.0,
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),

                    Container(
                      margin: const EdgeInsets.only(left: 8.0),
                      child: const Text(
                        "Our Milk Products",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    SizedBox(
                      height: heightOne,
                      width: widthScreen,
                      child: MilkProductHorizontalScroll(
                        useCase: 'milkProducts',
                        height: heightTwo,
                      ),
                    ),
                    // Container(
                    //     margin: const EdgeInsets.only(left: 8.0),
                    //     child: const Text(
                    //       "What's New",
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     )),
                    // SizedBox(
                    //   height: heightTwo,
                    //   width: widthScreen,
                    //   child: HorizontalCardProduct(
                    //     useCase: 'WhatsNew',
                    //     height: heightTwo,
                    //     spaceBetweenCards: 8.0,
                    //     listOfImagesUrl: _listOfCategories,
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 16.0,
                    // ),
                    // Container(
                    //   margin: EdgeInsets.only(left: 8.0),
                    //   child: Text(
                    //     "Most Purchased",
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: heightTwo,
                    //   width: widthScreen,
                    //   child: HorizontalCardProduct(
                    //     useCase: 'MostPurchased',
                    //     height: heightTwo,
                    //     spaceBetweenCards: 8.0,
                    //     listOfImagesUrl: _listOfCategories,
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 16.0,
                    // ),
                    // Container(
                    //     margin: const EdgeInsets.only(left: 8.0),
                    //     child: const Text(
                    //       "Today's offers",
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     )),
                    // SizedBox(
                    //   height: heightTwo,
                    //   width: widthScreen,
                    //   child: HorizontalCardProduct(
                    //     listOfImagesUrl: _listOfCategories,
                    //     useCase: 'TodaysOffers',
                    //     height: heightTwo,
                    //     spaceBetweenCards: 8.0,
                    //   ),
                    // ),
                    // Container(
                    //   width: widthScreen,
                    // ),
                    Container(
                      height: heightTwo,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                            'assets/a.jpg',
                          ),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                  ],
                ),
              ),
            ),
            drawer: Drawer(
              child: Container(
                width: 0.75 * widthScreen,
                child: DrawerScreenShared(),
              ),
            ),
          );
  }
}
