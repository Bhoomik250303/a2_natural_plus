import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:a2_natural/models/user_info_model.dart';
import 'package:a2_natural/screens/picking_address_screen.dart';
import 'package:a2_natural/services/database_services/database_service.dart';
import 'package:a2_natural/shared.dart/vertical_cards_order_history.dart';
import 'package:provider/provider.dart';

import 'list_of_existing_address_screen.dart';

class OrderHistoryDetailsScreen extends StatefulWidget {
  Map? orderDetails;
  OrderHistoryDetailsScreen({required this.orderDetails});

  @override
  _OrderHistoryDetailsScreenState createState() =>
      _OrderHistoryDetailsScreenState();
}

class _OrderHistoryDetailsScreenState extends State<OrderHistoryDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    User? user = Provider.of<User?>(context);
    print('widget ${widget.orderDetails?['orderTime']}');

    return StreamProvider<UserInfoModel?>.value(
        initialData: null,
        value: DatabaseServices(uid: user?.uid).cartDetailsStream,
        builder: (context, child) {
          return Scaffold(
              body: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: widget.orderDetails?['productList'].length + 1 ?? 0,
            itemBuilder: (context, int index) {
              if (index == 0) {
                return Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16.0,
                      ),
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Order Date: ${widget.orderDetails?['orderTime'].toString().split(' ')[0]}'),
                            SizedBox(
                              height: 16.0,
                            ),
                            Wrap(
                              children: [
                                Text(
                                  widget.orderDetails?['address']['flat no'] +
                                          ',' ??
                                      '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 6.0,
                                ),
                                Text(
                                  widget.orderDetails?['address']['building'] +
                                          ',' ??
                                      '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 2.0,
                                ),
                                Text(
                                  widget.orderDetails?['address']['locality'] +
                                          ',' ??
                                      '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 2.0,
                                ),
                                Text(
                                  widget.orderDetails?['address']['landmark'] ??
                                      '' ??
                                      '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Container(
                          margin: EdgeInsets.only(top: 6),
                          child: Text(
                              'Payment Preference: ${widget.orderDetails?['paymentPreference']}'),
                        ),
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
                          imageUrl: widget.orderDetails?['productList']
                              [index - 1]['imageUrl'],
                          imageBuilder: (context, imageProvider) => Container(
                            width: 0.3 * widthScreen,
                            height: 0.15 * heightScreen,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                              ),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.fill),
                            ),
                          ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(
                            color: Colors.green,
                            strokeWidth: 0.5,
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.error,
                          ),
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                children: [
                                  Text(
                                    '${widget.orderDetails?['productList'][index - 1]['product']}',
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
                                '\u{20B9}${(double.parse(widget.orderDetails?['productList'][index - 1]['price']) * (100 - double.parse(widget.orderDetails?['productList'][index - 1]['discountPercentage'])) * widget.orderDetails?['productList'][index - 1]['quantity'] / 100).round()}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                widget.orderDetails?['productList'][index - 1]
                                    ['packaging'],
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
                                    '${widget.orderDetails?['productList'][index - 1]['quantity']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
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
          ));
        });
  }
}
