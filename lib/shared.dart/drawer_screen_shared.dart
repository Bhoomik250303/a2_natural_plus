import 'package:flutter/material.dart';
import 'package:a2_natural/screens/refund_policy_screen.dart';
import 'package:a2_natural/screens/shipping_policy_screen.dart';
import 'package:a2_natural/screens/terms_of_service_screen.dart';

class DrawerScreenShared extends StatefulWidget {
  const DrawerScreenShared({Key? key}) : super(key: key);

  @override
  _DrawerScreenSharedState createState() => _DrawerScreenSharedState();
}

class _DrawerScreenSharedState extends State<DrawerScreenShared> {
  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: 0.75 * widthScreen,
                height: 0.3 * heightScreen,
                child: Image.asset(
                  'assets/company_logo.png',
                  scale: 1,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TermsOfServiceScreen(),
                      ));
                },
                child: ListTile(
                  tileColor: Colors.grey.withOpacity(0.01),
                  title: Text(
                    'Terms of service',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShippingPolicyScreen(),
                      ));
                },
                child: ListTile(
                  tileColor: Colors.grey.withOpacity(0.01),
                  title: Text(
                    'Shipping policy',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RefundPolicyScreen(),
                      ));
                },
                child: ListTile(
                  tileColor: Colors.grey.withOpacity(0.01),
                  title: Text(
                    'Refund policy',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
