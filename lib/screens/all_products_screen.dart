import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:a2_natural/models/product_display_details_model.dart';
import 'package:a2_natural/models/user_info_model.dart';
import 'package:a2_natural/screens/cart_screen.dart';
import 'package:a2_natural/screens/product_categorywise_detailed_list_screen.dart';
import 'package:a2_natural/screens/product_detailed_view_screen.dart';
import 'package:a2_natural/services/database_services/database_service.dart';
import 'package:provider/provider.dart';

class ALlProductsScreen extends StatefulWidget {
  const ALlProductsScreen({Key? key}) : super(key: key);

  @override
  _ALlProductsScreenState createState() => _ALlProductsScreenState();
}

class _ALlProductsScreenState extends State<ALlProductsScreen> {
  List<String> _listOfRecentSearches = [];
  UserInfoModel? userInfoModel;

  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    User? user = Provider.of<User?>(context);
    print(user);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            'All Products',
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
                      userInfoModel?.cart?.length.toString() ?? '0',
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
        body: StreamBuilder<UserInfoModel?>(
            initialData: null,
            stream: DatabaseServices(uid: user?.uid).cartDetailsStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.green),
                );
              } else {
                userInfoModel = snapshot.data;

                return StreamBuilder<List<ProductDisplayDetailsModel>>(
                  initialData: [],
                  stream: DatabaseServices(category: 'chemicalFreeColdPressOil')
                      .productCategoryDetailedListMilkProducts,
                  builder: (context, snapshot) {
                    List<ProductDisplayDetailsModel> listChemical = [];
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(color: Colors.green),
                      );
                    } else {
                      listChemical = snapshot.data!;
                      return StreamBuilder<List<ProductDisplayDetailsModel>>(
                        stream: DatabaseServices(category: 'dairyProducts')
                            .productCategoryDetailedListMilkProducts,
                        initialData: [],
                        builder: (context, snapshot) {
                          List<ProductDisplayDetailsModel> listDairy = [];
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                  color: Colors.green),
                            );
                          } else {
                            if (snapshot.hasData) {
                              listDairy = snapshot.data!;
                            }
                            return StreamBuilder<
                                List<ProductDisplayDetailsModel>>(
                              stream: DatabaseServices(
                                      category: 'organicHomeProducts')
                                  .productCategoryDetailedListMilkProducts,
                              builder: (context, snapshot) {
                                List<ProductDisplayDetailsModel> listOrganic =
                                    [];
                                List<ProductDisplayDetailsModel>
                                    _listOfProducts = [];
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.green),
                                  );
                                } else {
                                  listOrganic = snapshot.data!;
                                  _listOfProducts =
                                      listDairy + listOrganic + listChemical;
                                }
                                // if (listChemical == null ||
                                //     listDairy == null ||
                                //     userInfoModel == null ||
                                //     listOrganic == null) {
                                //   return Scaffold(
                                //     body: Container(
                                //       child: Center(
                                //         child: CircularProgressIndicator(
                                //             color: Colors.green),
                                //       ),
                                //     ),
                                //   );
                                // }
                                return Scaffold(
                                  backgroundColor: Colors.grey[300],
                                  body: SafeArea(
                                    child: ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetailsViewScreen(
                                                  productDetails:
                                                      _listOfProducts[index],
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
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  CachedNetworkImage(
                                                    imageUrl:
                                                        _listOfProducts[index]
                                                            .imageUrl,
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      width: 0.3 * widthScreen,
                                                      height:
                                                          0.15 * heightScreen,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.fill),
                                                      ),
                                                    ),
                                                    placeholder: (context,
                                                            url) =>
                                                        CircularProgressIndicator(
                                                      color: Colors.green,
                                                      strokeWidth: 0.5,
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                  SizedBox(
                                                    width: 4.0,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          _listOfProducts[index]
                                                              .name,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        Wrap(
                                                          direction:
                                                              Axis.horizontal,
                                                          children: [
                                                            Text(
                                                              "Actual MRP :",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                            Text(
                                                              " \u{20B9}${(double.parse(_listOfProducts[index].currentPrice[selectedIndex])).round()}",
                                                              style: TextStyle(
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough,
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
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
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 4.0,
                                                        ),
                                                        Container(
                                                          height: 24,
                                                          width: 64.0 *
                                                              _listOfProducts[
                                                                      index]
                                                                  .packaging
                                                                  .length,
                                                          child: GridView.count(
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            children:
                                                                _listOfProducts[
                                                                        index]
                                                                    .packaging
                                                                    .map((e) {
                                                              return Container(
                                                                child: Text(
                                                                  e,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                            crossAxisCount:
                                                                _listOfProducts[
                                                                        index]
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
                          }
                        },
                      );
                    }
                  },
                );
              }
            }));
  }
}
