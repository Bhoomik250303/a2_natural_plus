import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:a2_natural/models/product_display_details_model.dart';
import 'package:a2_natural/screens/product_detailed_view_screen.dart';

class ListOfCategorywiseProduct extends StatefulWidget {
  List<ProductDisplayDetailsModel> listOfProducts;
  ListOfCategorywiseProduct({required this.listOfProducts});

  @override
  _ListOfCategorywiseProductState createState() =>
      _ListOfCategorywiseProductState();
}

class _ListOfCategorywiseProductState extends State<ListOfCategorywiseProduct> {
  @override
  Widget build(BuildContext context) {
    print('image${widget.listOfProducts[0].imageUrl}');

    return SafeArea(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsViewScreen(
                    productDetails: widget.listOfProducts[index],
                  ),
                ),
              );
            },
            child: Hero(
              transitionOnUserGestures: true,
              tag: widget.listOfProducts[index].name,
              child: Card(
                elevation: 2.0,
                margin: EdgeInsets.only(
                  top: 8.0,
                ),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      widget.listOfProducts[index].imageUrl,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.listOfProducts[index].name,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            /*_listOfProducts[index].*/ "Price for ${widget.listOfProducts[index].packaging[widget.listOfProducts[index].packaging.length - 1]}",
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
                                widget.listOfProducts[index].packaging.length,
                            child: GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              children: widget.listOfProducts[index].packaging
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
                              crossAxisCount:
                                  widget.listOfProducts[index].packaging.length,
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
        itemCount: widget.listOfProducts.length,
      ),
    );
  }
}
