import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:a2_natural/models/categorywise/product_catrgory_list_model.dart';
import 'package:a2_natural/models/product_display_details_model.dart';
import 'package:a2_natural/screens/product_categorywise_detailed_list_screen.dart';
import 'package:a2_natural/screens/product_detailed_view_screen.dart';

class HorizontalCardProduct extends StatefulWidget {
  List<ProductDairyCategoryListModel> listOfImagesUrl;
  double spaceBetweenCards;
  double height;
  int? categorySlide;
  String useCase;
  HorizontalCardProduct(
      {required this.listOfImagesUrl,
      required this.spaceBetweenCards,
      required this.height,
      required this.useCase,
      this.categorySlide});

  @override
  _HorizontalCardProductState createState() => _HorizontalCardProductState();
}

class _HorizontalCardProductState extends State<HorizontalCardProduct> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int indexOfMilkModel = 0;
    List tempList = [];
    List _listOfCategories = [];
    ProductDairyCategoryListModel? milkProductModel;
    print('imageURL${widget.listOfImagesUrl}');
    tempList = widget.listOfImagesUrl;

    for (var e in tempList) {
      if (e.name == 'dairyProducts') {
        _listOfCategories.add(e);
        milkProductModel = e;
        break;
      }
      indexOfMilkModel++;
    }
    tempList.remove(milkProductModel);
    _listOfCategories.addAll(tempList);
    tempList.insert(indexOfMilkModel, milkProductModel);

    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    print('tempList$tempList');
    print('_listOfCategories${_listOfCategories}');
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: _listOfCategories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductCategorywiseDetailedListModel(
                    category: _listOfCategories[index].name,
                    displayName: _listOfCategories[index].displayName,
                  ),
                ),
              );
            },
            child: Hero(
              tag: '${index}${widget.useCase}',
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 3,
                child: Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: _listOfCategories[index].imageUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        height: 0.65 * widget.height,
                        width: widget.categorySlide == 0
                            ? widthScreen / 2
                            : widthScreen / 3,
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
                        height: 0.65 * widget.height,
                        width: widget.categorySlide == 0
                            ? widthScreen / 2
                            : widthScreen / 3,
                        child: CircularProgressIndicator(
                          color: Colors.green,
                          strokeWidth: 0.5,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    Expanded(
                      child: Center(
                        child: Wrap(children: [
                          Text(
                            '${_listOfCategories[index].displayName}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
