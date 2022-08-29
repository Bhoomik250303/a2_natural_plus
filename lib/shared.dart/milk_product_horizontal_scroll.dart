import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:a2_natural/models/milk_product_model.dart';
import 'package:a2_natural/screens/milk_product_detailed_view_screen.dart';
import 'package:a2_natural/screens/product_categorywise_detailed_list_screen.dart';
import 'package:a2_natural/services/database_services/database_service.dart';
import 'package:provider/provider.dart';

class MilkProductHorizontalScroll extends StatefulWidget {
  // List<MilkProductModel> listOfMilkProduct;
  String useCase;
  double height;

  MilkProductHorizontalScroll({required this.useCase, required this.height});

  @override
  MilkProductHorizontalScrollState createState() =>
      MilkProductHorizontalScrollState();
}

class MilkProductHorizontalScrollState
    extends State<MilkProductHorizontalScroll> {
  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    return StreamProvider<List<MilkProductModel>?>.value(
        initialData: null,
        value: DatabaseServices().milkProductStream,
        builder: (context, child) {
          List<MilkProductModel>? listOfMilkProduct =
              Provider.of<List<MilkProductModel>?>(context);
          print(listOfMilkProduct);
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: listOfMilkProduct?.length != null
                ? listOfMilkProduct?.length
                : 0,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => MilkProductDetailedViewScreen(
                  //           productDetails: listOfMilkProduct![index])),
                  // );
                },
                child: Hero(
                  tag: '${index}${widget.useCase}',
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 3,
                    child: Container(
                      width: (widthScreen - 16) / 2,
                      child: Column(
                        children: [
                          Container(
                            height: 0.65 * widget.height,
                            width: widthScreen / 2,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    listOfMilkProduct![index].imageUrl,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Center(
                              child: Text(
                                '${listOfMilkProduct[index].name}',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
