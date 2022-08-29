import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:a2_natural/constants/form_constants.dart';
import 'package:a2_natural/models/user_info_model.dart';
import 'package:a2_natural/screens/picking_address_screen.dart';
import 'package:a2_natural/screens/preview_order_details_screen.dart';
import 'package:a2_natural/services/database_services/database_service.dart';
import 'package:provider/provider.dart';

class ListOfExistingAddress extends StatefulWidget {
  String? id;
  Function addressCallback;
  ListOfExistingAddress({this.id, required this.addressCallback});
  @override
  _ListOfExistingAddressState createState() => _ListOfExistingAddressState();
}

class _ListOfExistingAddressState extends State<ListOfExistingAddress> {
  int addressIndex = 0;

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    var widthScreen = MediaQuery.of(context).size.width;

    return StreamProvider<UserInfoModel?>.value(
        initialData: null,
        value: DatabaseServices(uid: user?.uid).cartDetailsStream,
        builder: (context, child) {
          UserInfoModel? userInfo = Provider.of<UserInfoModel?>(context);
          print('here  ${userInfo?.address?.length}');
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green,
              elevation: 0.0,
              title: Text('Select an Address'),
              centerTitle: true,
            ),
            body: userInfo?.address?.length == 0
                ? Container(
                    child: Center(
                      child: Text(
                        'Add an Address',
                        style: TextStyle(
                          color: Colors.green.withOpacity(0.7),
                          fontSize: 24,
                        ),
                      ),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(top: 8.0, left: 8.0),
                    child: ListView.builder(
                      itemCount: userInfo?.address != null
                          ? userInfo!.address!.length + 1
                          : 0,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Text(
                            'Select the delivery address',
                          );
                        }
                        return GestureDetector(
                          onTap: () {
                            widget.id == 'milkSubscription'
                                ? {
                                    widget.addressCallback(
                                        userInfo?.address?[index - 1]),
                                    Navigator.pop(context)
                                  }
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PreviewScreen(
                                        address: userInfo?.address?[index - 1],
                                      ),
                                    ),
                                  );
                            // widget.id == 'addressProfileScreen' ?

                            // : {};
                          },
                          child: Card(
                            elevation: 2.0,
                            margin: EdgeInsets.fromLTRB(
                              8.0,
                              8.0,
                              8.0,
                              8.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.symmetric(
                                  horizontal: BorderSide(
                                    color: Colors.green,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 9,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            left: 16.0,
                                          ),
                                          child: Wrap(
                                            direction: Axis.vertical,
                                            children: [
                                              Text(
                                                userInfo?.address?[index - 1]
                                                            ['flat no'] +
                                                        ',' ??
                                                    '',
                                              ),
                                              Text(
                                                userInfo?.address?[index - 1]
                                                            ['building'] +
                                                        ',' ??
                                                    '',
                                              ),
                                              Text(
                                                userInfo?.address?[index - 1]
                                                            ['locality'] +
                                                        ',' ??
                                                    '',
                                              ),
                                              Text(
                                                userInfo?.address?[index - 1]
                                                        ['landmark'] ??
                                                    '' ??
                                                    '',
                                              ),
                                              Text(
                                                userInfo?.address?[index - 1]
                                                        ['pincode'] ??
                                                    '' ??
                                                    '',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                if (userInfo?.address!.length ==
                                                    1) {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser?.uid)
                                                      .update(
                                                    {
                                                      'address': FieldValue
                                                          .arrayRemove(
                                                        [
                                                          userInfo!.address?[
                                                              index - 1]
                                                        ],
                                                      ),
                                                    },
                                                  );
                                                }

                                                FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser?.uid)
                                                    .update({
                                                  'address':
                                                      FieldValue.arrayRemove(
                                                    [
                                                      userInfo
                                                          ?.address?[index - 1]
                                                    ],
                                                  ),
                                                });
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  //TODO
                                  // Container(
                                  //   width: widthScreen,
                                  //   color:  Colors.green,
                                  //   child: Center(
                                  //     child: Text(
                                  //       'Set as Home',
                                  //       style: TextStyle(
                                  //         color: Colors.white,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            bottomNavigationBar: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapsPicker(
                        addressCallback: () {},
                        id: 'onlyAdd',
                      ),
                    ),
                  );
                },
                style: buttonStyle,
                child: Text(
                  'Add an Address',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        });
  }
}
