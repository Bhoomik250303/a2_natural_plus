import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:a2_natural/models/product_display_details_model.dart';
import 'package:a2_natural/models/user_info_model.dart';
import 'package:a2_natural/screens/cart_screen.dart';
import 'package:a2_natural/screens/product_detailed_view_screen.dart';
import 'package:a2_natural/services/database_services/database_service.dart';
import 'package:provider/provider.dart';

class ProductCategorywiseDetailedListModel extends StatefulWidget {
  String category;
  String displayName;
  ProductCategorywiseDetailedListModel(
      {required this.category, required this.displayName});

  @override
  _ProductCategorywiseDetailedListModelState createState() =>
      _ProductCategorywiseDetailedListModelState();
}

class _ProductCategorywiseDetailedListModelState
    extends State<ProductCategorywiseDetailedListModel> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    User? user = Provider.of<User?>(context);
    // List<ProductDisplayDetailsModel> _listOfProducts =
    //     Provider.of<List<ProductDisplayDetailsModel>>(context);

    return StreamProvider<UserInfoModel?>.value(
        initialData: null,
        value: DatabaseServices(uid: user!.uid).cartDetailsStream,
        builder: (context, child) {
          UserInfoModel? userInfoModel = Provider.of<UserInfoModel?>(context);
          return StreamProvider<List<ProductDisplayDetailsModel>>.value(
            initialData: [],
            value: DatabaseServices(category: widget.category)
                .productCategoryDetailedListMilkProducts,
            builder: (context, child) {
              List<ProductDisplayDetailsModel> _listOfProducts =
                  Provider.of<List<ProductDisplayDetailsModel>>(context);
              print(_listOfProducts.length);
              print('_listOfProducts$_listOfProducts');
              return Scaffold(
                backgroundColor: Colors.grey[300],
                appBar: AppBar(
                  elevation: 0.0,
                  automaticallyImplyLeading: true,
                  title: Text(
                    '${widget.displayName} Products',
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.green,
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartScreen()));
                      },
                      icon: Badge(
                        badgeColor: Colors.orange,
                        badgeContent: Text(
                          userInfoModel?.cart?.length.toString() ?? '0',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
                body: SafeArea(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsViewScreen(
                                productDetails: _listOfProducts[index],
                              ),
                            ),
                          );
                        },
                        child: Hero(
                          transitionOnUserGestures: true,
                          tag: _listOfProducts[index].name,
                          child: Card(
                            elevation: 2.0,
                            margin: EdgeInsets.only(
                              top: 8.0,
                              left: 8.0,
                              right: 8.0,
                            ),
                            child: Row(
                              children: <Widget>[
                                CachedNetworkImage(
                                  imageUrl: _listOfProducts[index].imageUrl,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 0.3 * widthScreen,
                                    height: 0.15 * heightScreen,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill),
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
                                  width: 4,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        _listOfProducts[index].name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Wrap(
                                        direction: Axis.horizontal,
                                        children: [
                                          Text(
                                            "Actual MRP :",
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            " \u{20B9}${(double.parse(_listOfProducts[index].currentPrice[selectedIndex])).round()}",
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.green,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        /*_listOfProducts[index].*/ "Price : \u{20B9}${(double.parse(_listOfProducts[index].currentPrice[selectedIndex]) * (1 - (double.parse(_listOfProducts[index].discountPercentage) / 100))).round()}",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      Container(
                                        height: 24,
                                        width: 64.0 *
                                            _listOfProducts[index]
                                                .packaging
                                                .length,
                                        child: GridView.count(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          children: _listOfProducts[index]
                                              .packaging
                                              .map((e) {
                                            return Container(
                                              child: Text(
                                                e,
                                                style: TextStyle(
                                                  color: Colors.green,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                          crossAxisCount: _listOfProducts[index]
                                              .packaging
                                              .length,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: _listOfProducts.length,
                  ),
                ),
              );
            },
          );
        });
  }
}
