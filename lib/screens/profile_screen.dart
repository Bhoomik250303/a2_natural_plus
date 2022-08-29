import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:a2_natural/constants/form_constants.dart';
import 'package:a2_natural/models/user_info_model.dart';
import 'package:a2_natural/screens/authenticationScreens/login_authentication.dart';
import 'package:a2_natural/screens/list_of_existing_address_screen.dart';
import 'package:a2_natural/services/authentication_services/authentication_service.dart';
import 'package:a2_natural/services/database_services/database_service.dart';
import 'package:a2_natural/wrapper.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? imageUrl;
  User? userField;
  UserInfoModel? userInfoModel;
  String? phoneNumber;
  @override
  initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () async {
      if (userInfoModel?.phonenumber == '') {
        return showModalBottomSheet(
          isDismissible: false,
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                margin: EdgeInsets.only(
                  top: 16.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      'We need your phone number',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
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
                    TextButton(
                      style: buttonStyle,
                      onPressed: () async {
                        phoneNumber?.length == 10
                            ? {
                                await DatabaseServices()
                                    .usersList
                                    .doc(userField?.uid)
                                    .update(
                                  {
                                    'phonenumber': phoneNumber,
                                  },
                                ),
                                Navigator.pop(context)
                              }
                            : {
                                Fluttertoast.showToast(
                                  msg: 'Enter a valid phone number',
                                ),
                              };
                      },
                      child: Container(
                        child: Center(
                          child: Text(
                            'Submit',
                            style: textStyleFrom.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }
    });
  }

  phoneForm() async {}

  gettingImageUrl(var imageUrlFut) async {
    var imageUrlFun = await imageUrlFut;
    setState(() {
      imageUrl = imageUrlFun;
    });
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    userInfoModel = Provider.of<UserInfoModel?>(context);

    final ImagePicker _imagePicker = ImagePicker();
    XFile? _image;
    userField = Provider.of<User?>(context);
    print(userField);

    print('profile ${userInfoModel?.address}');
    print('profile ${userInfoModel?.profileImageUrl}');

    if (userInfoModel == null) {
      return Container(
        child: Center(
            child: CircularProgressIndicator(
          color: Colors.green,
        )),
      );
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(
          //     right: 8.0,
          //   ),
          //   child: IconButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => Scaffold(),
          //         ),
          //       );
          //     },
          //     icon: Icon(
          //       Icons.edit,
          //       color: Colors.grey[850],
          //     ),
          //   ),
          // ),
        ],
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.green,
            fontSize: 28,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      // ignore: sized_box_for_whitespace
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          width: widthScreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  top: 32.0,
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 72,
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.green,
                          child: CircleAvatar(
                            radius: 68,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.white,
                            backgroundImage: userInfoModel?.profileImageUrl !=
                                    ''
                                ? NetworkImage(userInfoModel!.profileImageUrl!)
                                : userField != null
                                    ? NetworkImage(userField!.photoURL!)
                                    : null,
                          ),
                        ),
                        Positioned(
                          top: 100,
                          left: 100,
                          child: CircleAvatar(
                            backgroundColor: Colors.green,
                            child: IconButton(
                              onPressed: () async {
                                await Fluttertoast.showToast(msg: 'Pick Image');
                                _image = await _imagePicker.pickImage(
                                    source: ImageSource.gallery);

                                if (_image != null) {
                                  Fluttertoast.showToast(msg: 'Uploading');
                                  var firestore = await FirebaseStorage.instance
                                      .ref(FirebaseAuth
                                          .instance.currentUser?.uid)
                                      .putFile(File(_image!.path));

                                  await gettingImageUrl(FirebaseStorage.instance
                                      .ref(FirebaseAuth
                                          .instance.currentUser?.uid)
                                      .getDownloadURL());

                                  Fluttertoast.showToast(msg: 'Done Uploading');
                                  print('imageUrl $imageUrl');
                                  await DatabaseServices(uid: userField?.uid)
                                      .uploadUserProfileImage(imageUrl!);
                                }
                              },
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 0.1 * widthScreen),
                child: Center(
                  child: Divider(
                    color: Colors.green,
                    indent: 16.0,
                    endIndent: 16.0,
                    height: 32.0,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                height: 0.4 * heightScreen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      userField?.displayName == null
                          ? 'Name'
                          : userField!.displayName!,
                      style: TextStyle(
                        color: Colors.green,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black,
                        decorationStyle: TextDecorationStyle.dotted,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 32.0,
                    ),
                    Text(
                      'Email-Id',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      userInfoModel?.email! != ''
                          ? userInfoModel!.email!
                          : 'Email-ID',
                      style: TextStyle(
                        color: Colors.green,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black,
                        decorationStyle: TextDecorationStyle.dotted,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 32.0,
                    ),
                    Text(
                      'Phone Number',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      userInfoModel?.phonenumber == ''
                          ? 'PhoneNumber'
                          : userInfoModel!.phonenumber!,
                      style: TextStyle(
                        color: Colors.green,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black,
                        decorationStyle: TextDecorationStyle.dotted,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 32.0,
                    ),
                    // GestureDetector(
                    //   onTap: () {},
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         'Address',
                    //         style: TextStyle(
                    //           fontWeight: FontWeight.w500,
                    //           fontSize: 22,
                    //         ),
                    //       ),

                    //     ],
                    //   ),
                    // ),
                    // Text(
                    //   userInfoModel != null
                    //       ? userInfoModel!.address!.isEmpty
                    //           ? 'Address'
                    //           : (userInfoModel!.address![0]['flat no'] +
                    //                   ', ' +
                    //                   userInfoModel!.address![0]['building'] +
                    //                   ', ' +
                    //                   userInfoModel!.address![0]['locality'] +
                    //                   ', ' +
                    //                   userInfoModel!.address![0]['landmark'] ??
                    //               '')
                    //       : 'Address',
                    //   style: TextStyle(
                    //     color: Colors.green,
                    //     decoration: TextDecoration.underline,
                    //     decorationColor: Colors.black,
                    //     decorationStyle: TextDecorationStyle.dotted,
                    //     fontWeight: FontWeight.w500,
                    //     fontSize: 18,
                    //   ),
                    // ),
                  ],
                ),
              ),
              Container(
                child: ListTile(
                  onTap: () async {
                    return (await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Image.asset(
                                'assets/company_logo.png',
                              ),
                            ),
                            Text('Are you sure?'),
                          ],
                        ),
                        content:
                            Text('Do you want to log-out from A2 Natural Plus'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              'No',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              Future.delayed(Duration(seconds: 1));
                              await AuthServices().signOutGoogle();
                            },
                            child: Text(
                              'Yes',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ));
                  },
                  leading: Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 28.0,
                  ),
                  title: Text('Log-Out'),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
