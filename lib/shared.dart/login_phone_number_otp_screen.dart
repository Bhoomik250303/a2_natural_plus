import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:a2_natural/constants/form_constants.dart';
import 'package:a2_natural/services/authentication_services/authentication_service.dart';
import 'package:provider/provider.dart';

class LoginPhoneNumberAndOtp extends StatefulWidget {
  const LoginPhoneNumberAndOtp({Key? key}) : super(key: key);

  @override
  _LoginPhoneNumberAndOtpState createState() => _LoginPhoneNumberAndOtpState();
}

class _LoginPhoneNumberAndOtpState extends State<LoginPhoneNumberAndOtp> {
  String phoneNumber = "";
  String smsCode = "";
  bool getOtp = true;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    LocationData locationData = Provider.of<LocationData>(context);
    double widthScreen = MediaQuery.of(context).size.width;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 32.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Enter Phone Number',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                ),
              ),
              SizedBox(
                height: 32.0,
              ),
              Text(
                'Enter Phone Number',
                style: textStyleFrom,
              ),
              TextFormField(
                maxLength: 10,
                validator: (val) {
                  val!.length < 10 ? "Enter correct phone number" : null;
                },
                onChanged: (String val) {
                  setState(() {
                    phoneNumber = val;
                  });
                },
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefix: Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Text(
                      '+91',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  counterText: '',
                  enabled: true,
                  enabledBorder: inputBorderForm,
                  focusedBorder: inputBorderForm,
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Text(
                'Enter Otp',
                style: textStyleFrom,
              ),
              TextFormField(
                maxLength: 6,
                validator: (value) {
                  value!.length != 6 ? "Enter six digit pin" : null;
                },
                onChanged: (value) => setState(() {
                  smsCode = value;
                }),
                decoration: InputDecoration(
                  counterText: '',
                  enabled: true,
                  enabledBorder: inputBorderForm,
                  focusedBorder: inputBorderForm,
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Container(
                width: widthScreen,
                child: getOtp
                    ? TextButton(
                        style: buttonStyle,
                        onPressed: () async {
                          phoneNumber.length == 10
                              ? {
                                  await AuthServices()
                                      .mobilePhoneSetup(phoneNumber),
                                  setState(() {
                                    getOtp = !getOtp;
                                  })
                                }
                              : {
                                  Fluttertoast.showToast(
                                    msg: 'Enter a valid phone number',
                                  ),
                                };
                        },
                        child: Text(
                          'Get Otp',  
                          style: textStyleFrom.copyWith(color: Colors.white),
                        ),
                      )
                    : TextButton(
                        style: buttonStyle,
                        onPressed: () async {
                          smsCode.length == 6
                              ? {
                                  await AuthServices()
                                      .mobilePhoneSignIn(smsCode, locationData),
                                  Navigator.pop(context)
                                }
                              : Fluttertoast.showToast(
                                  msg: 'Enter a six digit pin');
                        },
                        child: Text(
                          'Submit',
                          style: textStyleFrom.copyWith(color: Colors.white),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
