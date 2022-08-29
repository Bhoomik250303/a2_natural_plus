import 'dart:async';
import 'package:page_transition/page_transition.dart';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:a2_natural/main.dart';
import 'package:a2_natural/wrapper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 1500,
      splash: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            'assets/company_logo.png',
          ),
        ),
      ),
      nextScreen: Wrapper(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
      splashIconSize: 200,
      backgroundColor: Colors.white,
    );
  }
}
