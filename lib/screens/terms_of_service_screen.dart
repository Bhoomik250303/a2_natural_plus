import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatefulWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  @override
  _TermsOfServiceScreenState createState() => _TermsOfServiceScreenState();
}

class _TermsOfServiceScreenState extends State<TermsOfServiceScreen> {
  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0.0,
          title: Text(
            'Terms of service',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 16.0,
            ),
            Container(
              child: Text(
                'Terms of use',
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
                    "Access to and use of A2 Natural Plus and the products and services available through the application are subject to the following terms, conditions, and notices (“Terms of Service”). By browsing through these Terms of Service and using the services provided by our application A2 Natural Plus, you agree to all terms of Service along with the Privacy Policy on our application, which may be updated by us from time to time. Please check this page regularly to take notice of any changes we may have made to the Terms of Service.")),
            SizedBox(
              height: 16.0,
            ),
            Wrap(children: [
              Text(
                  "We reserve the right to review and withdraw or amend the services without notice. We will not be liable if for any reason this Application is unavailable at any time or for any period. From time to time, we may restrict access to some parts or this entire App.")
            ]),
            SizedBox(
              height: 16.0,
            ),
            Container(
              child: Text(
                'Services',
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
            Wrap(children: [
              Text(
                  "A2 Natural Plus is an online retailer of Ghee. It allows customers to purchase a variety of products. Upon placing an order, A2 Natural Plus shall ship the product to you and be entitled to its payment for the service.")
            ]),
            SizedBox(
              height: 32.0,
            ),
            Container(
              child: Text(
                'Third-Party Websites and Content',
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
            Wrap(children: [
              Text(
                  "Our application provides links for sharing our content on Facebook, Twitter, and other such third party application. These are only for sharing and/or listing purposes and we take no responsibility of the third party applications and/or their contents listed on our application A2 Natural Plus and disclaim all our liabilities arising out of any or all third party applications. We disclaim all liabilities and take no responsibility for the content that may be posted on such third party applications by the users of such applications in their personal capacity on any of the above-mentioned links for sharing and/or listing purposes as well as any content and/or comments that may be posted by such user in their personal capacity on any official application of A2 Natural Plus on any social networking platform."),
            ]),
            SizedBox(
              height: 16.0,
            ),
            Container(
              child: Text(
                'Messaging From Third Party application consent',
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
            Wrap(children: [
              Text(
                  "Customers hereby consent to receive communications by SMS or calls from A2 Natural Plus with regards to services provided by them."),
            ]),
            SizedBox(
              height: 16.0,
            ),
            Container(
              child: Text(
                'The exactness of the Product',
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
            Wrap(direction: Axis.horizontal, children: [
              Text(
                  "The images of the items on the application are for illustrative purposes only. Although we have made every effort to display the colours accurately, we cannot guarantee that your computer’s display of the colors accurately reflects the colour of the items. Your items may vary slightly from those images. All sizes and measurements of items are approximate; however, we do make every effort to ensure they are accurate as possible. We take all reasonable care to ensure that all details, descriptions, and prices of items are as accurate as possible."),
            ]),
            SizedBox(
              height: 16.0,
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(
              child: Text(
                'Pricing',
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
            Wrap(direction: Axis.horizontal, children: [
              Text(
                  "We ensure that all details of prices appearing on the application are accurate, however, errors may occur. If we discover an error in the price of any goods which you have ordered, we will inform you of this as soon as possible. If we are unable to contact you we will treat the order as cancelled. If you cancel and you have already paid for the goods, you will receive a full refund. Additionally, prices for items may change from time to time without notice. However, these changes will not affect orders that have already been dispatched. The price of an item includes GST (or similar sales tax) at the prevailing rate for which we are responsible as a seller. Please note that the prices listed on the application are only applicable for items purchased on the application and not through any other source."),
            ]),
            SizedBox(
              height: 16.0,
            ),
            Container(
              child: Text(
                'Payment',
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
            Wrap(direction: Axis.horizontal, children: [
              Text(
                  "Upon receiving your order we carry out a standard pre-authorization check on your payment card to ensure there are sufficient funds to fulfill the transaction. Goods will not be dispatched until this pre-authorization check has been completed. Your card will be debited once the order has been accepted. For any further payment related queries, please check our FAQs on Payment Mode."),
            ]),
            SizedBox(
              height: 16.0,
            ),
            Container(
              child: Text(
                'Delivery',
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
            Wrap(direction: Axis.horizontal, children: [
              Text(
                  "You will be given various options for delivery of items during the order process. The options available to you will vary depending on where you are ordering from. An estimated delivery time is displayed on the order summary page. On placing your order, you will receive an email containing a summary of the order and also the estimated delivery time to your location. Sometimes, delivery may take longer due to unforeseen circumstances. In such cases, we will proactively reach out to you by e-mail and SMS. However, we will not be able to compensate for any mental agony caused due to delay in delivery."),
            ]),
            SizedBox(
              height: 16.0,
            ),
            Container(
              child: Text(
                'Returns & Refund',
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
            Wrap(direction: Axis.horizontal, children: [
              Text(
                  "If you change your mind about any items purchased you can return them to us. For more information on Returns and Refund, please refer to our Return Policy."),
            ]),
            SizedBox(
              height: 16.0,
            ),
            Container(
              child: Text(
                'Intellectual Property Rights',
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
            Wrap(direction: Axis.horizontal, children: [
              Text(
                  "All and any intellectual property rights in connection with the products shall be owned absolutely by A2 Natural Plus."),
            ]),
            SizedBox(
              height: 16.0,
            ),
            Container(
              child: Text(
                'Law and Jurisdiction',
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
            Wrap(direction: Axis.horizontal, children: [
              Text(
                  "These terms shall be governed by and constructed in accordance with the laws of India without reference to conflict of laws principles and disputes arising in relation hereto shall be subject to the exclusive jurisdiction of the courts at Hyderabad."),
            ]),
            SizedBox(
              height: 16.0,
            ),
            Container(
              child: Text(
                'Indemnification',
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
            Wrap(direction: Axis.horizontal, children: [
              Text(
                  "You agree to indemnify, defend and hold harmless the firm, officers, employees, consultants, agents, and affiliates, from any and all third party claims, liability, damages or costs arising from your use of this application, your breach of these Terms of Service, or infringement of any intellectual property right."),
            ]),
            SizedBox(
              height: 16.0,
            ),
            Container(
              child: Text(
                'Violation & Termination',
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
            Wrap(direction: Axis.horizontal, children: [
              Column(
                children: [
                  Text(
                      "You agree that the Company may, in its sole discretion and without prior notice, terminate your access to the application and block your future access if we determine that you have violated these Terms of Service or any other policies. If you or the Company terminates your use of any service, you shall still be liable to pay for any service that you have already ordered till the time of such termination. ."),
                  Text(
                      'If you have any questions, comments or requests regarding our Terms of Service or the application please contact us at customercare@a2naturalplus.com.'),
                ],
              ),
            ]),
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
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: e,
            );
          }).toList(),
        ));
  }
}
