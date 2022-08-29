import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:location/location.dart';
import 'package:a2_natural/firebase_options.dart';
import 'package:a2_natural/models/categorywise/product_catrgory_list_model.dart';
import 'package:a2_natural/models/milk_product_model.dart';
import 'package:a2_natural/models/milk_quantity_list_model.dart';
import 'package:a2_natural/models/user_info_model.dart';
import 'package:a2_natural/screens/splash_screen.dart';
import 'package:a2_natural/services/authentication_services/authentication_service.dart';
import 'package:a2_natural/services/database_services/database_service.dart';
import 'package:a2_natural/services/location_services.dart';
import 'package:a2_natural/services/shared_preference_service.dart';
import 'package:a2_natural/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'firebaseApp',
    options: DefaultFirebaseOptions.currentPlatform
  );
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  SharedPreferenceServices.settingPreference();
  bool firstRun = await IsFirstRun.isFirstRun();
  await LocationServices().checkingServiceAvailability();
  await LocationServices().gettingPermission();
  runApp(
      MyApp(
    isFirstRun: firstRun,
  ));
}

class MyApp extends StatefulWidget {
  bool? isFirstRun;
  MyApp({this.isFirstRun});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Location location = Location();
  LocationData? locationData;
  _MyAppState() {
    getttingLocData().then((val) {
      setState(() {
        locationData = val;
      });
    });
  }

  getttingLocData() async {
    return await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.isFirstRun!);
    return MultiProvider(
        providers: [
          StreamProvider<User?>(
            create: (context) => AuthServices().userLoginStream,
            initialData: null,
          ),
          StreamProvider<List<ProductDairyCategoryListModel>>.value(
            value: DatabaseServices(category: "").ProductCategoryListStream,
            initialData: [],
          ),
          StreamProvider.value(
            value: location.onLocationChanged,
            initialData: locationData,
          ),
          StreamProvider<MilkQuantityListModel?>.value(
            value: DatabaseServices().listOfMilkQuantityStream,
            initialData: null,
          ),
          StreamProvider<List<MilkProductModel>?>.value(
              value: DatabaseServices().milkProductStream, initialData: null),
        ],
        child: MaterialApp(
          title: 'A2 Natural',
          theme: ThemeData(
            textTheme: TextTheme(
              bodyText1: TextStyle(
                letterSpacing: 1.0,
              ),
              bodyText2: TextStyle(
                letterSpacing: 1.0,
              ),
            ),
            // fontFamily: 'Hel',
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.green,
            ),
            iconTheme: IconThemeData(
              color: Colors.blue.withOpacity(0.5),
              opacity: 1,
              size: 16,
            ),
          ),
          home: SplashScreen(),
        ));
  }
}