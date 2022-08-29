import 'package:flutter/material.dart';

class RefundPolicyScreen extends StatefulWidget {
  const RefundPolicyScreen({Key? key}) : super(key: key);

  @override
  _RefundPolicyScreenState createState() => _RefundPolicyScreenState();
}

class _RefundPolicyScreenState extends State<RefundPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    var heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text('Refund Policy'),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 16.0,
            ),
            Container(
              child: Text(
                  'A2 Natural Plus believes in & we can helping its customers as far as possible, and has, therefore, a liberal cancellation policy.'),
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(
              child: Center(
                child: Text(
                  'How do I cancel an order on A2 Natural Plus?',
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
                    "If unfortunately, you have to cancel an order, please do so within 24 hours of placing the order.")),
            SizedBox(
              height: 16.0,
            ),
            Container(
              child: Center(
                child: Text(
                  'For outright cancellations by you:',
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
                    "- If you cancel your order before your product has shipped, we will refund the entire amount..")),
            SizedBox(
              height: 16.0,
            ),
            Container(
              child: Center(
                child: Text(
                  'If the cancellation is after your product has shipped:',
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
                    "- If you received the product, it will be eligible for replacement, only in cases where there are defects found with the product.")),
            Flexible(
                child: Text(
                    "Refunds will be made in the same form that the payment is received within 10 working days from the date of cancellation of the order.")),
            SizedBox(
              height: 16.0,
            ),
            Container(
              child: Text(
                'Return Policy',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Flexible(
                child: Text(
                    "In case of complaints regarding products that come with a warranty from manufacturers, please refer the issue to the concerned manufacturer. Let us know & we’ll help you regarding the same. If you think, you have received the product in a bad condition or if the packaging is tampered with or damaged before delivery, please refuse to accept the package and return the package to the delivery person. Also, please call our customer care at 8169967871 or email us at customercare@a2naturalplus.com mentioning your Order ID. We will personally ensure that a brand new replacement is issued to you with no additional cost. Please make sure that the original product tag and packing is intact when you send us the product back. Apart from the condition reserved herein above, the following products shall not be eligible for return or replacement, viz• Any product that exhibits physical damage to the box or to the product• Any product that is returned without all original packaging and accessories, including the retail box, manuals, cables, and all other items originally included with the product at the time of delivery• Any product without a valid, readable, untampered serial number, including but not limited to products with missing, damaged, altered, or otherwise unreadable serial number• Any product from which the UPC (Universal Product Code) has been removed from its original packaging.")),
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
          ].map((e) {
            return Container(
              child: e,
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            );
          }).toList(),
        ));
  }
}
