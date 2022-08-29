import 'package:flutter/material.dart';
import 'package:a2_natural/constants/form_constants.dart';
import 'package:a2_natural/screens/fragment.dart';

class UserDetailsFormScreen extends StatefulWidget {
  String id;
  UserDetailsFormScreen({required this.id});
  @override
  _UserDetailsFormScreenState createState() => _UserDetailsFormScreenState();
}

class _UserDetailsFormScreenState extends State<UserDetailsFormScreen> {
  final userDetailsFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'Personal Details',
      //   ),
      //   centerTitle: true,
      //   elevation: 0.0,
      //   backgroundColor: Colors.green,
      // ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Form(
          key: userDetailsFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 16.0,
              ),
              Text(
                'Enter Address',
                style: textStyleFrom.copyWith(
                  fontSize: 24,
                  color: Colors.green,
                ),
              ),
              SizedBox(
                height: 32.0,
              ),
              Text(
                'Enter Locality',
                style: textStyleFrom,
              ),
              TextFormField(
                onChanged: (val) {},
                validator: (val) {
                  return val!.isEmpty ? "Enter a valid detail" : null;
                },
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  enabled: true,
                  isDense: true,
                  focusedBorder: inputBorderForm,
                  enabledBorder: inputBorderForm,
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Text(
                'Enter pincode',
                style: textStyleFrom,
              ),
              TextFormField(
                maxLength: 6,
                onChanged: (val) {},
                validator: (val) {
                  return val!.length != 6 ? "Enter a valid detail" : null;
                },
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  counterText: '',
                  enabled: true,
                  isDense: true,
                  focusedBorder: inputBorderForm,
                  enabledBorder: inputBorderForm,
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Row(
                children: [
                  Text(
                    'Enter Landmark',
                    style: textStyleFrom,
                  ),
                  SizedBox(
                    width: 4.0,
                  ),
                  Text(
                    '(Optional)',
                    style: textStyleFrom.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              TextFormField(
                onChanged: (val) {},
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  enabled: true,
                  isDense: true,
                  focusedBorder: inputBorderForm,
                  enabledBorder: inputBorderForm,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Container(
                width: widthScreen,
                child: Center(
                  child: TextButton(
                    style: buttonStyle,
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Tabs()));
                    },
                    child: Text(
                      'Proceed',
                      style: TextStyle(
                        color: Colors.white,
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
  }
}
