import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:a2_natural/constants/form_constants.dart';
import 'package:a2_natural/services/authentication_services/authentication_service.dart';
import 'package:a2_natural/shared.dart/login_phone_number_otp_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom -
        MediaQuery.of(context).padding.top;

    double widthScreen = MediaQuery.of(context).size.width;
    LocationData locationData = Provider.of<LocationData>(context);
    // Fluttertoast.showToast(msg: '$locationData');

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0.0,
      //   title: Text(
      //     'Login',
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       color: Colors.green,
      //       fontSize: 36,
      //     ),
      //   ),
      //   centerTitle: true,
      // ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          constraints:
              BoxConstraints(minHeight: heightScreen, minWidth: widthScreen),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.scaleDown,
              image: AssetImage(
                'assets/company_logo.png',
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                width: widthScreen,
                child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            16.0,
                          ),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    onPressed: () async {
                      await AuthServices().googleSignIn(locationData);
                    },
                    child: Row(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              foregroundImage: AssetImage(
                                'assets/googleImage.png',
                              ),
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            Text(
                              'Login through Google',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: 8.0,
              ),
              // Padding(
              //   padding: EdgeInsets.only(
              //     bottom: 0.01 * heightScreen,
              //   ),
              //   child: Container(
              //     margin: EdgeInsets.symmetric(
              //       horizontal: 16.0,
              //     ),
              //     width: widthScreen,
              //     child: TextButton(
              //       style: ButtonStyle(
              //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //           RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(
              //               16.0,
              //             ),
              //           ),
              //         ),
              //         backgroundColor: MaterialStateProperty.all(Colors.green),
              //       ),
              //       onPressed: () async {
              //         showModalBottomSheet(
              //           isScrollControlled: true,
              //           context: context,
              //           builder: (_) => Container(
              //             decoration: const BoxDecoration(
              //               borderRadius: BorderRadius.only(
              //                 topLeft: Radius.circular(16.0),
              //                 topRight: Radius.circular(16.0),
              //               ),
              //             ),
              //             child: const LoginPhoneNumberAndOtp(),
              //           ),
              //         );
              //       },
              //       child: Row(
              //         children: [
              //           Row(
              //             children: [
              //               CircleAvatar(
              //                 foregroundImage: AssetImage(
              //                   'assets/mobileImage.png',
              //                 ),
              //               ),
              //               SizedBox(
              //                 width: 16.0,
              //               ),
              //               Text(
              //                 'Login through Mobile Number',
              //                 style: TextStyle(
              //                   color: Colors.white,
              //                   fontWeight: FontWeight.bold,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
