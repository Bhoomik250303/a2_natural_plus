import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:a2_natural/models/user_info_model.dart';
import 'package:a2_natural/screens/authenticationScreens/login_authentication.dart';
import 'package:a2_natural/screens/fragment.dart';
import 'package:a2_natural/screens/user_details_form_screen.dart';
import 'package:a2_natural/services/database_services/database_service.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  Location location = Location();
  LocationData? locationData;

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    UserInfoModel? userInfoModel = Provider.of<UserInfoModel?>(context);
    print('userInfoModeluserInfoModeluserInfoModel$userInfoModel');
    if (user != null) {
      DatabaseServices(uid: user.uid);
      print(user);
    }
    // Fluttertoast.showToast(msg: '$locationData');

    Connectivity connectivity = Connectivity();
    ConnectivityResult connectivityResult = ConnectivityResult.none;

    return StreamProvider.value(
      initialData: ConnectivityResult.none,
      value: connectivity.onConnectivityChanged,
      builder: (context, child) {
        ConnectivityResult _connectivityResult =
            Provider.of<ConnectivityResult>(context);
        return _connectivityResult == ConnectivityResult.none
            ? Scaffold(
                appBar: PreferredSize(
                    preferredSize: Size.fromHeight(180.0),
                    child: SafeArea(
                      child: Container(
                        child: Center(
                            child: Image.asset(
                          'assets/company_logo.png',
                        )),
                      ),
                    )),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/noConnection.png'),
                      Text(
                        'OOPS! No Internet',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : user == null
                ? LoginScreen()
                : userInfoModel?.username == ''
                    ? UserDetailsFormScreen(id: 'afterLogin')
                    : Tabs();
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
