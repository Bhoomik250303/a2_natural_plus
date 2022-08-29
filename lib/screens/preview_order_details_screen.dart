import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:a2_natural/models/user_info_model.dart';
import 'package:a2_natural/screens/gpay_payment.dart';
import 'package:a2_natural/screens/upi_payment_screen.dart';
import 'package:a2_natural/services/database_services/database_service.dart';
import 'package:a2_natural/services/razorpay_services/razorpay_services.dart';
import 'package:provider/provider.dart';

class PreviewScreen extends StatefulWidget {
  Map address;
  PreviewScreen({required this.address});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  int result = 0;
  double totalPrice = 0;
  Map orderDetails = {};
  // Razorpay _razorpay = Razorpay();
  bool start = true;
  bool stop = false;
  String? messageToDeliveryPerson;

  double totalSaved = 0;
  @override
  initState() {
    super.initState();
    //   _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _paymentSuccess);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    User? user = Provider.of<User?>(context);
    return StreamProvider<UserInfoModel?>.value(
        value: DatabaseServices(uid: user?.uid).cartDetailsStream,
        initialData: null,
        builder: (context, child) {
          UserInfoModel? userInfo = Provider.of<UserInfoModel?>(context);
          if (totalPrice == 0) {
            userInfo?.cart!.forEach((element) {
              totalPrice += double.parse(element['price']) *
                  (100 - double.parse(element['discountPercentage'])) *
                  double.parse(element['quantity'].toString()) /
                  100;
            });
          }

          if (totalSaved == 0) {
            userInfo?.cart!.forEach((element) {
              totalSaved += double.parse(element['price']) *
                  double.parse(element['discountPercentage']) /
                  100 *
                  element['quantity'];
            });
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Preview Order',
              ),
              centerTitle: true,
              backgroundColor: Colors.green,
              elevation: 0.0,
            ),
            body: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount:
                  userInfo?.cart != null ? userInfo!.cart!.length + 1 : 0,
              itemBuilder: (context, index) {
                return (index == 0)
                    ? Container(
                        margin: EdgeInsets.only(left: 16.0, top: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                'Delivery Address',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Wrap(
                              direction: Axis.vertical,
                              children: [
                                Text(
                                  userInfo!.username,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  widget.address['flat no'] + ',' ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 6.0,
                                ),
                                Text(
                                  widget.address['building'] + ',' ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 2.0,
                                ),
                                Text(
                                  widget.address['locality'] + ',' ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 2.0,
                                ),
                                Text(
                                  widget.address['landmark'] ?? '' ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 16.0,
                                ),
                                Container(
                                  width: widthScreen,
                                  child: Text(
                                    'Any message you want to give to the delivery person',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Center(
                                    child: DropdownButton<String>(
                                      value: messageToDeliveryPerson,
                                      items: <String>[
                                        'Ring Door Bell',
                                        '  Hand Delivery',
                                        'Ring Bell and Hand Delivery',
                                        'Drop it outside the door',
                                        'Drop it inside the bag',
                                        'others'
                                      ].map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          messageToDeliveryPerson = val;
                                        });
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 24.0,
                            ),
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
                                  'Total Saved of this order: \u{20B9}${totalSaved.round()}',
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
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            16.0,
                          ),
                          color: Colors.white,
                        ),
                        margin: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                CachedNetworkImage(
                                  imageUrl: userInfo!.cart![index - 1]
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
                                  width: 16.0,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userInfo.cart?[index - 1]['product'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      Text(
                                        '\u{20B9}${(double.parse(userInfo.cart![index - 1]['price']) * (100 - double.parse(userInfo.cart![index - 1]['discountPercentage'])) * double.parse(userInfo.cart![index - 1]['quantity'].toString()) / 100).round()}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.green,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        userInfo.cart![index - 1]['packaging']
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
                                            userInfo.cart![index - 1]
                                                    ['quantity']
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
                              ],
                            ),
                          ],
                        ),
                      );
              },
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: Colors.green,
              onPressed: () async {
                orderDetails['address'] = widget.address;
                orderDetails['productList'] = userInfo?.cart;
                orderDetails['totalPrice'] = totalPrice;
                orderDetails['messageToDeliveryPerson'] =
                    messageToDeliveryPerson;
                orderDetails['orderTime'] = DateTime.now().toString();
                orderDetails['totalSaved'] = totalSaved;
                orderDetails['username'] = userInfo?.username;
                orderDetails['isDelivered'] = false;
                ;
                // RazorpayServices(context: context).optionsFunction();
                // Fluttertoast.showToast(
                //     msg: (orderDetails['totalPrice'].toString()));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GpayPayment(
                        cart: userInfo!.cart!,
                        orderDetails: orderDetails,
                        user: user!,
                        isMilkSubs: false,
                      ),
                      settings: RouteSettings(
                        name: 'SecondPage',
                      ),
                    ));
              },
              label: Text(
                'Place Order',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        });
  }
}
