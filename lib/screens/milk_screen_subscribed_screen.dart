import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:a2_natural/constants/form_constants.dart';
import 'package:a2_natural/models/user_info_model.dart';
import 'package:a2_natural/models/zonewise_pincodes_model.dart';
import 'package:a2_natural/services/database_services/database_service.dart';
import 'package:a2_natural/shared.dart/milk_screen_weekdays_shared.dart';
import 'package:provider/provider.dart';

class MilkScreenSubcribedScreen extends StatefulWidget {
  UserInfoModel? userInfoModel;
  MilkScreenSubcribedScreen({required this.userInfoModel});

  @override
  _MilkScreenSubcribedScreenState createState() =>
      _MilkScreenSubcribedScreenState();
}

class _MilkScreenSubcribedScreenState extends State<MilkScreenSubcribedScreen> {
  List alternateDays = List.generate(31, (index) {
    return DateFormat("yyyy-MM-dd")
        .format(DateTime.now().add(Duration(days: (2 * index) - 1)));
  });
  DateTime? skipForADay;
  DateTime? startingDateOfSubscription;
  double quantity = 0.5;
  String? changedPlan;
  List skipDates = [];
  String subscriptionPlan = '';
  List listOfTypesOfSkippingMilk = [
    'Skip milk for a day',
    'Skip days in week',
    'Skip for a range of days',
  ];
  Map orderToBeDeleted = {};

  weekDaysCallback(List dateTime) {
    setState(() {
      skipDates = dateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Milk Subscription'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: StreamProvider<UserInfoModel?>.value(
        initialData: null,
        value: DatabaseServices(uid: user?.uid).cartDetailsStream,
        builder: (context, child) {
          UserInfoModel? userInfo = Provider.of<UserInfoModel?>(context);
          double widthScreen = MediaQuery.of(context).size.width;

          if (userInfo == null || userInfo.subscriptionData!.isEmpty) {
            return Container(
              child: CircularProgressIndicator(color: Colors.green),
            );
          } else {
            return StreamBuilder(
                stream: DatabaseServices()
                    .orders
                    .doc(userInfo.subscriptionData!['orderZone'])
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<DocumentSnapshot<Object?>> snapshotOfOrders) {
                  if (!snapshotOfOrders.hasData) {
                    return CircularProgressIndicator(
                      color: Colors.green,
                    );
                  } else {
                    for (var i = 0;
                        i < snapshotOfOrders.data!['order'].length;
                        i++) {
                      if (snapshotOfOrders.data!['order'][i]['user'] ==
                              userInfo.subscriptionData!['uid'] &&
                          snapshotOfOrders.data!['order'][i]['isMilkSubs']) {
                        print('found0');
                        orderToBeDeleted = snapshotOfOrders.data!['order'][i];
                        print('orderToBeDeleted${orderToBeDeleted}');
                      }
                    }

                    subscriptionPlan =
                        userInfo.subscriptionData!['subscriptionPlan'];
                    return Container(
                      width: widthScreen,
                      margin: EdgeInsets.only(
                        top: 8.0,
                        left: 8.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 16.0, left: 8.0),
                            child: Text(
                              'Your Milk Subscription',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            width: widthScreen,
                            child: Card(
                              elevation: 2.0,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Plan : ',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${userInfo.subscriptionData!['subscriptionPlan']}',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Wrap(children: [
                                            userInfo.subscriptionData![
                                                        'subscriptionPlan'] ==
                                                    'Week Days'
                                                ? Text(
                                                    '${userInfo.subscriptionData!['weekDaysSelections'].map((e) {
                                                      return e.toString();
                                                    })}',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                : Container(),
                                          ]),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 16.0,
                                      ),
                                      Text(
                                        'Quantity : ',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '${userInfo.subscriptionData!['quantity']} litre',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16.0,
                                      ),
                                      Text(
                                        'Price : ',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '\u{20B9}${double.parse(userInfo.subscriptionData!['price'].toString()).round().toString()}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16.0,
                                      ),
                                      Text(
                                        'Address : ',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "${userInfo.subscriptionData?['address']['flat no'] ?? ''}, ${userInfo?.subscriptionData?['address']['building'] ?? ''}, ${userInfo?.subscriptionData?['address']['locality'] ?? ''}, ${userInfo?.subscriptionData?['address']['landmark'] ?? ''}, ${userInfo?.subscriptionData?['address']['pinCode'] ?? ''}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextButton(
                                onPressed: () async {
                                  await showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      var skippedDates;

                                      return Scaffold(
                                        bottomNavigationBar: Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                          ),
                                          child: TextButton(
                                              style: buttonStyle,
                                              child: Text(
                                                'Done',
                                                style: textStyleFrom.copyWith(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onPressed: () async {
                                                await DatabaseServices(
                                                        uid: user?.uid)
                                                    .skippingMilk(skippedDates
                                                        .toString());
                                                Navigator.pop(context);
                                              }),
                                        ),
                                        body: ListView.builder(
                                          itemCount: 3,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () async {
                                                if (index == 0) {
                                                  skippedDates =
                                                      await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now()
                                                                .hour <
                                                            17
                                                        ? DateTime.now()
                                                        : DateTime.now().add(
                                                            Duration(days: 1)),
                                                    firstDate: DateTime.now()
                                                                .hour <
                                                            17
                                                        ? DateTime.now()
                                                        : DateTime.now().add(
                                                            Duration(days: 1),
                                                          ),
                                                    lastDate: DateTime(2050),
                                                  );
                                                } else if (index == 1) {
                                                  await showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content:
                                                              SingleChildScrollView(
                                                            child: Container(
                                                              height: 0.5 *
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height,
                                                              child:
                                                                  MilkScreenWeekdaysShared(
                                                                weekDaysCallback:
                                                                    weekDaysCallback,
                                                                listOfDayClass: userInfo
                                                                    ?.subscriptionData![
                                                                        'weekDaysSelections']
                                                                    .map(
                                                                  (e) {
                                                                    return DayClass(
                                                                        day: e,
                                                                        status:
                                                                            false);
                                                                  },
                                                                ).toList(),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                  String res = '';
                                                  skipDates.forEach((element) {
                                                    res = res + element + ',';
                                                  });
                                                  skippedDates = res;
                                                } else if (index == 2) {
                                                  skippedDates =
                                                      await showDateRangePicker(
                                                          context: context,
                                                          firstDate: DateTime
                                                                          .now()
                                                                      .hour <
                                                                  17
                                                              ? DateTime.now()
                                                              : DateTime.now()
                                                                  .add(Duration(
                                                                      days: 1)),
                                                          lastDate:
                                                              DateTime(2050));
                                                }
                                              },
                                              child: userInfo?.subscriptionData![
                                                              'subscriptionPlan'] !=
                                                          'Week Days' &&
                                                      index == 1
                                                  ? Container()
                                                  : ListTile(
                                                      leading: Text(
                                                        listOfTypesOfSkippingMilk[
                                                            index],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      trailing: Icon(
                                                        Icons
                                                            .arrow_forward_ios_rounded,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                                style: buttonStyle,
                                child: Text(
                                  'Skip milk',
                                  style: textStyleFrom.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.0),
                              TextButton(
                                  onPressed: () async {
                                    return (await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(32.0)),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Are you sure?'),
                                          ],
                                        ),
                                        content:
                                            Text('Do you want to Unsubscribe?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: Text(
                                              'No',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await DatabaseServices()
                                                  .unSubscribingFromMilk(
                                                      user!.uid);
                                              await DatabaseServices()
                                                  .milkSubscriptionList
                                                  .doc(subscriptionPlan)
                                                  .update({
                                                'address':
                                                    FieldValue.arrayRemove([
                                                  userInfo.subscriptionData
                                                ])
                                              });
                                              print('map${orderToBeDeleted}');
                                              await DatabaseServices()
                                                  .orders
                                                  .doc(userInfo
                                                          .subscriptionData![
                                                      'orderZone'])
                                                  .update({
                                                'order': FieldValue.arrayRemove(
                                                    [orderToBeDeleted]),
                                              });
                                              await DatabaseServices()
                                                  .usersList
                                                  .doc(user.uid)
                                                  .update({
                                                'subscriptionData': {},
                                              });
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'Yes',
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                                  },
                                  style: buttonStyle.copyWith(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                  ),
                                  child: Text(
                                    'Cancel Subscription',
                                    style: textStyleFrom.copyWith(
                                      color: Colors.white,
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                });
          }
        },
      ),
    );
  }
}

/* 
{
  
}
*/