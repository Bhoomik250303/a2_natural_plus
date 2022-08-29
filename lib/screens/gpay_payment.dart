import 'dart:convert';
import 'dart:io';
import 'package:a2_natural/screens/fragment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:a2_natural/models/zonewise_pincodes_model.dart';
import 'package:a2_natural/services/database_services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class GpayPayment extends StatefulWidget {
  List cart;
  User user;
  Map orderDetails;
  bool isMilkSubs = false;
  GpayPayment(
      {required this.orderDetails,
      required this.cart,
      required this.user,
      required this.isMilkSubs});

  @override
  _GpayPaymentState createState() => _GpayPaymentState();
}

class _GpayPaymentState extends State<GpayPayment> {
  User? user;
  bool testing = true;
  bool paymentDone = false;
  var _razorpay = Razorpay();
  Map mapOfOrders = {};
  String orderZone = '';
  @override
  initState() {
    super.initState();
    mapOfOrders = widget.orderDetails;
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  dispose() {
    super.dispose();
    _razorpay.clear();
  }

  generate_ODID(double amount) async {
    var orderOptions = {
      'amount': amount * 100,
      'currency': "INR",
      'receipt': "order_rcptid_11"
    };
    final client = HttpClient();
    final request =
        await client.postUrl(Uri.parse('https://api.razorpay.com/v1/orders'));
    request.headers
        .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    String basicAuth = 'Basic ' +
        base64Encode(
            utf8.encode('rzp_live_KfED6YoMErGwWw:AnoCJxAChXMneF8ujV9jUfNC'));
    request.headers.set(HttpHeaders.authorizationHeader, basicAuth);
    request.add(utf8.encode(json.encode(orderOptions)));
    final response = await request.close();
    response.transform(utf8.decoder).listen((contents) {
      print('ORDERID' + contents);
      String orderId = contents.split(',')[0].split(":")[1];
      orderId = orderId.substring(1, orderId.length - 1);
      Map<String, dynamic> checkoutOptions = {
        'key': 'rzp_live_KfED6YoMErGwWw',
        'amount': amount * 100,
        'name': 'A2 Natural Plus',
        'order_id': orderId,
        'description': '',
        'prefill': {'contact': '', 'email': ''},
        'external': {
          'wallets': ['paytm', 'google pay']
        },
        'enabled': true,
        'max_count': 1
      };
      try {
        _razorpay.open(checkoutOptions);
      } catch (e) {
        print(e.toString());
      }
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await DatabaseServices(uid: widget.user.uid)
        .addOrder(mapOfOrders, orderZone);
    print('Payment Success');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response);
    print('Payment Error');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg:
            'You have chosen to pay via : ${response.walletName}. It will take some time to reflect your payment.');
  }

  void showPaymentPopupMessage(bool isPaymentSuccess, String message) {}

  String? paymentPreference;

  @override
  Widget build(BuildContext context) {
    user = widget.user;
    return StreamProvider<ZonewisePincodesModel?>.value(
        value: DatabaseServices(uid: widget.user.uid).zonewisePincodeStream,
        initialData: null,
        builder: (context, child) {
          ZonewisePincodesModel? zonewisePincodesModel =
              Provider.of<ZonewisePincodesModel?>(context);

          if (zonewisePincodesModel != null) {
            zonewisePincodesModel.zone1['pincodes']
                    .contains(widget.orderDetails['address']['pinCode'])
                ? orderZone = 'zone1'
                : zonewisePincodesModel.zone2['pincodes']
                        .contains(widget.orderDetails['address']['pinCode'])
                    ? orderZone = 'zone2'
                    : zonewisePincodesModel.zone3['pincodes']
                            .contains(widget.orderDetails['address']['pinCode'])
                        ? orderZone = 'zone3'
                        : zonewisePincodesModel.zone4['pincodes'].contains(
                                widget.orderDetails['address']['pinCode'])
                            ? orderZone = 'zone4'
                            : zonewisePincodesModel.zone5['pincodes'].contains(
                                    widget.orderDetails['address']['pinCode'])
                                ? orderZone = 'zone5'
                                : zonewisePincodesModel.zone6['pincodes']
                                        .contains(widget.orderDetails['address']
                                            ['pinCode'])
                                    ? orderZone = 'zone6'
                                    : {};
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Choose Payment Options',
              ),
              backgroundColor: Colors.green,
              elevation: 0.0,
              centerTitle: true,
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        // Map mapOfOrders = widget.orderDetails;
                        mapOfOrders['paymentPreference'] = 'COD';
                        mapOfOrders['isMilkSubs'] = widget.isMilkSubs;
                        mapOfOrders['orderZone'] = orderZone;
                        await DatabaseServices(uid: widget.user.uid)
                            .addOrder(mapOfOrders, orderZone);
                        Fluttertoast.showToast(
                          msg: 'Order Placed',
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                        );

                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Tabs()),
                            (Route<dynamic> route) => false);
                      },
                      child: Card(
                        child: Container(
                          height: 0.3 * MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(
                              'Cash On Delivery',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'OR',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 16.0),
                    Card(
                      child: Container(
                        height: 0.3 * MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: TextButton(
                          onPressed: () async {
                            mapOfOrders['paymentPreference'] = 'Online Payment';
                            mapOfOrders['isMilkSubs'] = widget.isMilkSubs;
                            mapOfOrders['orderZone'] = orderZone;
                            print(widget.orderDetails['totalPrice']
                                .round()
                                .toString());

                            await generate_ODID(double.parse(widget
                                    .orderDetails['totalPrice']
                                    .toString())
                                .roundToDouble());

                            // Navigator.of(context).pushAndRemoveUntil(
                            //     MaterialPageRoute(builder: (context) => Tabs()),
                            //     (Route<dynamic> route) => false);
                          },
                          child: Text(
                            'UPI payment',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void paymentDoneFunc() {
    setState(() {
      paymentDone = true;
    });
  }
}
