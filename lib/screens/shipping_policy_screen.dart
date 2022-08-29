import 'package:flutter/material.dart';

class ShippingPolicyScreen extends StatefulWidget {
  const ShippingPolicyScreen({Key? key}) : super(key: key);

  @override
  _ShippingPolicyScreenState createState() => _ShippingPolicyScreenState();
}

class _ShippingPolicyScreenState extends State<ShippingPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    var heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            'Shipping Policy',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0.0,
          centerTitle: true,
        ),
        body: ListView(
            children: [
          SizedBox(
            height: 16.0,
          ),
          Container(
            child: Text(
                'A2 Natural Plus is committed to delivering your order with good quality packaging within a given time frame. We ship throughout the week, except Sunday & Public holidays.s To ensure that your order reaches you in good condition, in the shortest span of time, we ship through reputed courier agencies only. If there is no courier service available in your area, we will ship your items via Government Registered Book post or Speedpost.'),
          ),
          SizedBox(
            height: 16.0,
          ),
          Container(
            child: Center(
              child: Text(
                'How the delivery charge is calculated for multiple units?',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Flexible(
              child: Text(
                  "The shipping charge is specified separately for every product. For multiple products ordered the program adds up the total of all individual shipping charges. Thus, a customer who orders three products is charged the total of all individual delivery charges associated with each product. Thus the delivery fee is calculated separately when a customer orders different products.Our prices are all-inclusive. All taxes are included with the list prices except Octroi, if applicable in your region. There will be an Extra Octroi charges for shipment to Maharashtra Region.")),
          SizedBox(
            height: 16.0,
          ),
          Container(
            child: Center(
              child: Text(
                'How long does it take for an order to arrive?',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Flexible(
              child: Text(
                  "Orders are dispatched within 3 working days or as per the delivery date specified by you at the time of placing the order. Most orders are delivered within 7 to 8 working days. Delivery of all orders will be duly done to the address as mentioned by you at the time of placing the order.")),
          SizedBox(
            height: 16.0,
          ),
          Container(
            child: Center(
              child: Text(
                'What if the product I received in damaged condition?',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Flexible(
              child: Text(
                  "If you think, you have received the product in a bad condition or if the packaging is tampered with or damaged before delivery, please refuse to accept the package and return the package to the delivery person. Also, please call our customer care at +91 8169967871 or email us at customercare@a2naturalplus.com mentioning your Order ID. We will personally ensure that a brand new replacement is issued to you with no additional cost. Please make sure that the original product tag and packing is intact when you send us the product back.")),
          SizedBox(
            height: 16.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                "End of Document.",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ]
                .map(
                  (e) => Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: e,
                  ),
                )
                .toList()));
  }
}
