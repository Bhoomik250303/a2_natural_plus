import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:a2_natural/screens/picking_address_screen.dart';
import 'package:a2_natural/shared.dart/vertical_cards_order_history.dart';

class CheckoutScreen extends StatefulWidget {
  DocumentSnapshot? snapOfDataInCart;
  CheckoutScreen({required this.snapOfDataInCart});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          'Checkout',
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 145.0 * widget.snapOfDataInCart?['cart'].length,
              child: Container(),
            ),
            Container(
              width: widthScreen,
              margin: EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        16.0,
                      ),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    Colors.green,
                  ),
                ),
                child: Text(
                  'Select an Address',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  // Fluttertoast.showToast(msg: 'sfsdfffsf');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapsPicker(
                        addressCallback: () {},
                        id: 'addAndProceed',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
