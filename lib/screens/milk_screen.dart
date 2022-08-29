import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:http/retry.dart';
import 'package:intl/intl.dart';
import 'package:a2_natural/constants/form_constants.dart';
import 'package:a2_natural/models/milk_product_model.dart';

import 'package:a2_natural/models/user_info_model.dart';
import 'package:a2_natural/models/zonewise_pincodes_model.dart';
import 'package:a2_natural/screens/list_of_existing_address_screen.dart';
import 'package:a2_natural/screens/milk_screen_subscribed_screen.dart';
import 'package:a2_natural/screens/picking_address_screen.dart';
import 'package:a2_natural/services/authentication_services/authentication_service.dart';
import 'package:a2_natural/services/database_services/database_service.dart';
import 'package:a2_natural/services/razorpay_services/razorpay_services.dart';
import 'package:a2_natural/shared.dart/horizontal_banner_scrollview_home.dart';
import 'package:a2_natural/shared.dart/milk_product_horizontal_scroll.dart';
import 'package:a2_natural/shared.dart/milk_screen_subscription_pick_date.dart';
import 'package:a2_natural/shared.dart/milk_screen_weekdays_shared.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class MilkScreen extends StatefulWidget {
  String price;
  Map? orderDetails;
  MilkScreen({required this.price, this.orderDetails});

  @override
  _MilkScreenState createState() => _MilkScreenState();
}

class _MilkScreenState extends State<MilkScreen> {
  bool showPaymentOptions = false;

  weekDaysCallback(List selectedDaysFromDaysScreen) {
    setState(() {
      selectedDays = selectedDaysFromDaysScreen;
    });
  }

  List<PaymentItem> _paymentItems = [
    PaymentItem(
      label: 'Total Amount',
      amount: '100',
      status: PaymentItemStatus.final_price,
    )
  ];
  List alternateDays = List.generate(31, (index) {
    return DateFormat("yyyy-MM-dd")
        .format(DateTime.now().add(Duration(days: (2 * index) - 1)));
  });
  int currentStep = 0;
  var _razorpay = Razorpay();
  String? subscriptionPlan;
  int? selectedAddressIndex;
  Map addressFromAddressScreen = {'nothing': 'nothing'};
  double quantity = 0.5;
  String? paymentPreference;
  bool showFloatingBar = false;
  String milkProduct = '';
  String? milkProductPrice = '';
  double glassBottleMilkPrice = 0;
  double pasterizedMilkPrice = 0;
  bool paymentDone = false;
  DateTime startingDateOfSubscription = DateTime.now();

// paytm fields
  User? user;
  ScrollController _scrollController = ScrollController();
  List selectedDays = [];
  Map mapOfOrders = {};
  String orderZone = '';
  @override
  initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  dispose() {
    super.dispose();
    _razorpay.clear();
  }

  generate_ODID(double amount) async {
    var orderOptions = {
      'amount': amount * 100,
      'currency': "INR",
      'receipt': "order_rcptid_11"
    };
    final client = HttpClient();
    final request =
        await client.postUrl(Uri.parse('https://api.razorpay.com/v1/orders'));
    request.headers
        .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    String basicAuth = 'Basic ' +
        base64Encode(
            utf8.encode('rzp_live_KfED6YoMErGwWw:AnoCJxAChXMneF8ujV9jUfNC'));
    request.headers.set(HttpHeaders.authorizationHeader, basicAuth);
    request.add(utf8.encode(json.encode(orderOptions)));
    final response = await request.close();
    response.transform(utf8.decoder).listen((contents) {
      print('ORDERID' + contents);
      String orderId = contents.split(',')[0].split(":")[1];
      orderId = orderId.substring(1, orderId.length - 1);
      Map<String, dynamic> checkoutOptions = {
        'key': 'rzp_live_KfED6YoMErGwWw',
        'amount': amount * 100,
        'name': 'A2 Natural Plus',
        'order_id': orderId,
        'description': '',
        'prefill': {'contact': '', 'email': ''},
        'external': {
          'wallets': ['paytm', 'google pay']
        },
        'enabled': true,
        'max_count': 1
      };
      try {
        _razorpay.open(checkoutOptions);
      } catch (e) {
        print(e.toString());
      }
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print(
        'startingDateOfSubscriptionSucces${startingDateOfSubscription.toString()}');
    await DatabaseServices(uid: user?.uid).addOrder(mapOfOrders, orderZone);
    await DatabaseServices().uploadingSubscriptionStatus(
      quantity,
      addressFromAddressScreen,
      (double.parse(milkProductPrice!) * quantity).toString(),
      subscriptionPlan!,
      selectedDays,
      paymentPreference!,
      user!.uid,
      user!.displayName!,
      mapOfOrders['startingDateOfSubscription'],
      milkProduct,
      DateTime.now().toString(),
      orderZone,
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            Image.asset(
              'assets/checked.png',
              height: 80,
              width: 45,
            ),
            Container(
              child: Text("Yay! You're subscribed"),
            )
          ],
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Okay'),
          ),
        ],
      ),
    );
    print('Payment Success');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response);
    print('Payment Error');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg:
            'You have chosen to pay via : ${response.walletName}. It will take some time to reflect your payment.');
  }

  gettingAddress(Map address) {
    setState(() {
      addressFromAddressScreen = address;
    });
  }

  gettingWeekDaysSelection(List selectedDaysFromOption) {
    setState(() {
      selectedDays = selectedDaysFromOption;
    });
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    String dropDownMenuInitialValue = "1 litre";
    double heightOne = 0.25 * heightScreen;
    print('addressFromAddressScreen$addressFromAddressScreen');
    print('currentStep$currentStep');
    return StreamProvider<User?>.value(
        initialData: null,
        value: AuthServices().userLoginStream,
        builder: (context, child) {
          user = Provider.of<User?>(context);
          return StreamProvider<UserInfoModel?>.value(
              initialData: null,
              value: DatabaseServices(uid: user?.uid).cartDetailsStream,
              builder: (context, child) {
                UserInfoModel? userInfo = Provider.of<UserInfoModel?>(context);
                print('userInfo$userInfo');

                return StreamProvider<ZonewisePincodesModel?>.value(
                    initialData: null,
                    value:
                        DatabaseServices(uid: user?.uid).zonewisePincodeStream,
                    builder: (context, child) {
                      ZonewisePincodesModel? zonewisePincodesModel =
                          Provider.of<ZonewisePincodesModel?>(context);

                      if (zonewisePincodesModel != null) {
                        zonewisePincodesModel.zone1['pincodes']
                                .contains(addressFromAddressScreen['pinCode'])
                            ? orderZone = 'zone1'
                            : zonewisePincodesModel.zone2['pincodes'].contains(
                                    addressFromAddressScreen['pinCode'])
                                ? orderZone = 'zone2'
                                : zonewisePincodesModel.zone3['pincodes'].contains(
                                        addressFromAddressScreen['pinCode'])
                                    ? orderZone = 'zone3'
                                    : zonewisePincodesModel.zone4['pincodes'].contains(
                                            addressFromAddressScreen['pinCode'])
                                        ? orderZone = 'zone4'
                                        : zonewisePincodesModel
                                                .zone5['pincodes']
                                                .contains(
                                                    addressFromAddressScreen[
                                                        'pinCode'])
                                            ? orderZone = 'zone5'
                                            : zonewisePincodesModel
                                                    .zone6['pincodes']
                                                    .contains(
                                                        addressFromAddressScreen[
                                                            'pinCode'])
                                                ? orderZone = 'zone6'
                                                : {};
                      }
                      print(orderZone);
                      return StreamProvider<List<MilkProductModel>?>.value(
                          initialData: null,
                          value: DatabaseServices().milkProductStream,
                          builder: (context, child) {
                            print(milkProduct);
                            List<MilkProductModel> milkProductModel =
                                Provider.of<List<MilkProductModel>>(context);

                            return Scaffold(
                              appBar: AppBar(
                                title: Text('Milk Products'),
                                centerTitle: true,
                                backgroundColor: Colors.green,
                                elevation: 0.0,
                              ),
                              body: SafeArea(
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  physics: BouncingScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Image.asset('assets/milkScreenBannerFinal.jpg',),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                          top: 16.0,
                                          left: 16.0,
                                          right: 16.0,
                                        ),
                                        child: FittedBox(
                                          child: Text(
                                            'Subscribe below in 3 easy steps',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                                      widget.orderDetails!.isNotEmpty
                                          ? Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  16.0, 32.0, 16.0, 0),
                                              alignment: Alignment.center,
                                              width: widthScreen,
                                              child: Text(
                                                'You are subscribing to ${widget.orderDetails!['product']}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ),
                                            )
                                          : Container(
                                              width: widthScreen,
                                              child: Center(
                                                child: RadioButtonGroup(
                                                  orientation:
                                                      GroupedButtonsOrientation
                                                          .VERTICAL,
                                                  activeColor: Colors.green,
                                                  labels: [
                                                    'Glass Bottle',
                                                    'Pasterized Milk'
                                                  ],
                                                  onSelected: (String val) {
                                                    setState(() {
                                                      milkProduct = val;
                                                      val == 'Glass Bottle'
                                                          ? {
                                                              milkProductPrice =
                                                                  milkProductModel[
                                                                          0]
                                                                      .currentPrice[
                                                                          0]
                                                                      .toString(),
                                                            }
                                                          : {
                                                              milkProductPrice =
                                                                  milkProductModel[
                                                                          1]
                                                                      .currentPrice[
                                                                          0]
                                                                      .toString(),
                                                            };
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                      Container(
                                        margin: EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Theme(
                                          data: ThemeData(
                                            colorScheme:
                                                ColorScheme.fromSwatch()
                                                    .copyWith(
                                              primary: Colors.green,
                                            ),
                                          ),
                                          child: Stepper(
                                            controlsBuilder:
                                                (BuildContext context,
                                                    ControlsDetails details) {
                                              return Row(children: [
                                                TextButton(
                                                  style: buttonStyle,
                                                  onPressed: () async {
                                                    await details
                                                        .onStepContinue;
                                                    if (currentStep == 0) {
                                                      if (milkProduct == '' &&
                                                          widget.orderDetails!
                                                              .isEmpty) {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'Select product to proceed');
                                                      } else {
                                                        if (!widget
                                                            .orderDetails!
                                                            .isEmpty) {
                                                          setState(() {
                                                            milkProduct = widget
                                                                    .orderDetails![
                                                                'product'];
                                                            milkProductPrice =
                                                                widget.price;
                                                          });
                                                        }
                                                        if (quantity >= 0.5) {
                                                          setState(() {
                                                            currentStep++;
                                                          });
                                                        }
                                                      }
                                                    } else if (currentStep ==
                                                        2) {
                                                      if (subscriptionPlan !=
                                                          null) {
                                                        setState(() {
                                                          showPaymentOptions =
                                                              true;
                                                          _scrollController.animateTo(
                                                              _scrollController
                                                                      .position
                                                                      .maxScrollExtent +
                                                                  150,
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          1),
                                                              curve: Curves
                                                                  .decelerate);
                                                        });
                                                      }
                                                    } else if (currentStep ==
                                                        1) {
                                                      print(
                                                          'userInfo?.address?.length${userInfo?.address?.length}');
                                                      userInfo!.address
                                                                  ?.length ==
                                                              0
                                                          ? Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        MapsPicker(
                                                                  id: 'milkAddress',
                                                                  addressCallback:
                                                                      gettingAddress,
                                                                ),
                                                              ),
                                                            )
                                                          : Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ListOfExistingAddress(
                                                                        addressCallback:
                                                                            gettingAddress,
                                                                        id: 'milkSubscription'),
                                                              ),
                                                            );

                                                      setState(() {
                                                        currentStep++;
                                                      });
                                                    }
                                                  },
                                                  child: Text(
                                                    'Next',
                                                    style:
                                                        textStyleFrom.copyWith(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 6.0,
                                                ),
                                                TextButton(
                                                  style: buttonStyle.copyWith(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(
                                                      Colors.white,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      currentStep == 0
                                                          ? currentStep = 0
                                                          : currentStep--;
                                                    });
                                                  },
                                                  child: Text(
                                                    'Back',
                                                    style:
                                                        textStyleFrom.copyWith(
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ),
                                              ]);
                                            },
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            elevation: 5.0,
                                            currentStep: currentStep,
                                            type: StepperType.vertical,
                                            // onStepContinue: () async {},
                                            // onStepCancel: () {},
                                            steps: [
                                              !widget.orderDetails!.isEmpty
                                                  ? Step(
                                                      isActive:
                                                          currentStep == 0,
                                                      state: currentStep > 0
                                                          ? StepState.complete
                                                          : StepState.indexed,
                                                      subtitle: Text(
                                                        'Selected quantity of milk.',
                                                        style: TextStyle(
                                                            fontFamily: 'Hel'),
                                                      ),
                                                      title: Text(
                                                        'Selected Quantity',
                                                        style: TextStyle(
                                                            fontFamily: 'Hel'),
                                                      ),
                                                      content: Container(
                                                        child: Column(
                                                          children: <Widget>[
                                                            Row(
                                                              children: <
                                                                  Widget>[
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    if (quantity >
                                                                        0.5) {
                                                                      setState(
                                                                          () {
                                                                        quantity -=
                                                                            0.5;
                                                                      });
                                                                    }
                                                                  },
                                                                  child:
                                                                      CircleAvatar(
                                                                    radius: 12,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                    child: Icon(
                                                                      Icons
                                                                          .arrow_drop_down_rounded,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 24,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 16.0,
                                                                ),
                                                                Text(
                                                                  '$quantity ltr',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Hel',
                                                                    fontSize:
                                                                        24,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 16.0,
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      quantity +=
                                                                          0.5;
                                                                    });
                                                                  },
                                                                  child:
                                                                      CircleAvatar(
                                                                    radius: 12,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .green
                                                                            .withOpacity(
                                                                      0.8,
                                                                    ),
                                                                    child: Icon(
                                                                      Icons
                                                                          .arrow_drop_up_rounded,
                                                                      size: 24,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 8.0,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Step(
                                                      isActive:
                                                          currentStep == 0,
                                                      state: currentStep > 0
                                                          ? StepState.complete
                                                          : StepState.indexed,
                                                      subtitle: Text(
                                                        'Select the quantitiy of milk.',
                                                        style: TextStyle(
                                                            fontFamily: 'Hel'),
                                                      ),
                                                      title: Text(
                                                        'Select Quantity',
                                                        style: TextStyle(
                                                            fontFamily: 'Hel'),
                                                      ),
                                                      content: Container(
                                                        child: Column(
                                                          children: <Widget>[
                                                            widget.orderDetails!
                                                                    .isEmpty
                                                                ? Row(
                                                                    children: <
                                                                        Widget>[
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          if (quantity >
                                                                              0.5) {
                                                                            setState(() {
                                                                              quantity -= 0.5;
                                                                            });
                                                                          }
                                                                        },
                                                                        child:
                                                                            CircleAvatar(
                                                                          radius:
                                                                              12,
                                                                          backgroundColor:
                                                                              Colors.red,
                                                                          child:
                                                                              Icon(
                                                                            Icons.arrow_drop_down_rounded,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                24,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            16.0,
                                                                      ),
                                                                      Text(
                                                                        '$quantity ltr',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Hel',
                                                                          fontSize:
                                                                              24,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          color:
                                                                              Colors.blue,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            16.0,
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            quantity +=
                                                                                0.5;
                                                                          });
                                                                        },
                                                                        child:
                                                                            CircleAvatar(
                                                                          radius:
                                                                              12,
                                                                          backgroundColor: Colors
                                                                              .green
                                                                              .withOpacity(
                                                                            0.8,
                                                                          ),
                                                                          child:
                                                                              Icon(
                                                                            Icons.arrow_drop_up_rounded,
                                                                            size:
                                                                                24,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Container(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          '${widget.orderDetails?['quantity']} ltr',
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Hel',
                                                                            fontSize:
                                                                                24,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color:
                                                                                Colors.blue,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                            SizedBox(
                                                              height: 8.0,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                              Step(
                                                isActive: currentStep == 1,
                                                state: currentStep > 1
                                                    ? StepState.complete
                                                    : StepState.indexed,
                                                subtitle: Text(
                                                  'Select the address where you want the milk delivery',
                                                  style: TextStyle(
                                                      fontFamily: 'Hel'),
                                                ),
                                                title: Text(
                                                  'Select Address',
                                                  style: TextStyle(
                                                      fontFamily: 'Hel'),
                                                ),
                                                content: Container(),
                                              ),
                                              Step(
                                                isActive: currentStep == 2,
                                                state: currentStep > 2
                                                    ? StepState.complete
                                                    : StepState.indexed,
                                                title: Text(
                                                  'Select Subscription Plan',
                                                  style: TextStyle(
                                                      fontFamily: 'Hel'),
                                                ),
                                                subtitle: Text(
                                                  'Select a subscription plan.',
                                                  style: TextStyle(
                                                      fontFamily: 'Hel'),
                                                ),
                                                content: Container(
                                                  child: RadioButtonGroup(
                                                    onSelected:
                                                        (String val) async {
                                                      setState(() {
                                                        subscriptionPlan = val;
                                                      });
                                                      if (val ==
                                                          'Alternate Days') {
                                                        var start =
                                                            await showDatePicker(
                                                          helpText:
                                                              'Select when to start your subscription',
                                                          selectableDayPredicate:
                                                              (DateTime val) {
                                                            if (alternateDays
                                                                .contains(DateFormat(
                                                                        "yyyy-MM-dd")
                                                                    .format(
                                                                        val))) {
                                                              print('contains');
                                                              return false;
                                                            } else {
                                                              print(
                                                                  'not contains');
                                                              return true;
                                                            }
                                                          },
                                                          currentDate:
                                                              DateTime.now(),
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime.now(),
                                                          lastDate:
                                                              DateTime.utc(
                                                                  2050, 12, 31),
                                                        );
                                                        setState(() {
                                                          startingDateOfSubscription =
                                                              start ??
                                                                  DateTime
                                                                      .now();
                                                        });
                                                      }
                                                      if (val == 'Daily') {
                                                        var start =
                                                            await showDatePicker(
                                                          helpText:
                                                              'Select when to start your subscription',
                                                          currentDate:
                                                              DateTime.now(),
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime.now(),
                                                          lastDate:
                                                              DateTime.utc(
                                                                  2050, 12, 31),
                                                        );
                                                        setState(() {
                                                          startingDateOfSubscription =
                                                              start ??
                                                                  DateTime
                                                                      .now();
                                                        });
                                                      }
                                                      if (val == 'Week Days') {
                                                        return showModalBottomSheet(
                                                          context: context,
                                                          builder: (context) {
                                                            return MilkScreenWeekdaysShared(
                                                              weekDaysCallback:
                                                                  weekDaysCallback,
                                                              listOfDayClass: [
                                                                DayClass(
                                                                  day: 'Sunday',
                                                                  status: false,
                                                                ),
                                                                DayClass(
                                                                  day: 'Monday',
                                                                  status: false,
                                                                ),
                                                                DayClass(
                                                                  day:
                                                                      'Tuesday',
                                                                  status: false,
                                                                ),
                                                                DayClass(
                                                                  day:
                                                                      'Wednesday',
                                                                  status: false,
                                                                ),
                                                                DayClass(
                                                                  day:
                                                                      'Thursday',
                                                                  status: false,
                                                                ),
                                                                DayClass(
                                                                  day: 'Friday',
                                                                  status: false,
                                                                ),
                                                                DayClass(
                                                                  day:
                                                                      'Saturday',
                                                                  status: false,
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }
                                                      print(
                                                          'startingDateOfSubscription${startingDateOfSubscription}');
                                                    },
                                                    activeColor: Colors.green,
                                                    labels: [
                                                      'Daily',
                                                      'Alternate Days',
                                                      'Week Days'
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      showPaymentOptions
                                          ? Container(
                                              child: RadioButtonGroup(
                                                onSelected: (String val) async {
                                                  setState(() {
                                                    paymentPreference = val;
                                                  });
                                                },
                                                activeColor: Colors.green,
                                                labels: [
                                                  'Cash On Delivery',
                                                  'Pay Online'
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                              bottomNavigationBar: paymentPreference != null
                                  ? Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: TextButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.green)),
                                          child: Text(
                                            "Proceed",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () async {
                                            if (paymentPreference ==
                                                'Cash On Delivery') {
                                              await DatabaseServices()
                                                  .uploadingSubscriptionStatus(
                                                quantity,
                                                addressFromAddressScreen,
                                                (double.parse(
                                                            milkProductPrice!) *
                                                        quantity)
                                                    .toString(),
                                                subscriptionPlan!,
                                                selectedDays,
                                                paymentPreference!,
                                                user!.uid,
                                                user!.displayName!,
                                                startingDateOfSubscription
                                                    .toString(),
                                                milkProduct,
                                                DateTime.now().toString(),
                                                orderZone,
                                              );
                                              mapOfOrders = {
                                                'orderZone': orderZone,
                                                'isMilkSubs': true,
                                                'username': user?.displayName,
                                                'isDelivered': false,
                                                'quantity': quantity,
                                                'address':
                                                    addressFromAddressScreen,
                                                'totalPrice': (double.parse(
                                                            milkProductPrice!) *
                                                        quantity)
                                                    .toString(),
                                                'subscriptionPlan':
                                                    subscriptionPlan!,
                                                'selectedDays': selectedDays,
                                                'paymentPreference':
                                                    paymentPreference!,
                                                'uid': user?.uid,
                                                'startingDateOfSubscription':
                                                    startingDateOfSubscription
                                                        .toString(),
                                                'product': milkProduct,
                                                'orderTime':
                                                    DateTime.now().toString()
                                              };
                                              await DatabaseServices(
                                                      uid: user?.uid)
                                                  .addOrder(
                                                      mapOfOrders, orderZone);
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Column(
                                                    children: [
                                                      Image.asset(
                                                        'assets/checked.png',
                                                        height: 80,
                                                        width: 45,
                                                      ),
                                                      Container(
                                                        child: Text(
                                                            "Yay! You're subscribed"),
                                                      )
                                                    ],
                                                  ),
                                                  actions: <Widget>[
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Okay'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            } else {
                                              print(
                                                  'startingDateOfSubscription${startingDateOfSubscription}');
                                              mapOfOrders = {
                                                'orderZone': orderZone,
                                                'isMilkSubs': true,
                                                'username': user?.displayName,
                                                'isDelivered': false,
                                                'quantity': quantity,
                                                'address':
                                                    addressFromAddressScreen,
                                                'totalPrice': (double.parse(
                                                            milkProductPrice!) *
                                                        quantity)
                                                    .toString(),
                                                'subscriptionPlan':
                                                    subscriptionPlan!,
                                                'selectedDays': selectedDays,
                                                'paymentPreference':
                                                    paymentPreference!,
                                                'uid': user?.uid,
                                                'startingDateOfSubscription':
                                                    startingDateOfSubscription
                                                        .toString(),
                                                'product': milkProduct,
                                                'orderTime':
                                                    DateTime.now().toString()
                                              };

                                              await generate_ODID((double.parse(
                                                          milkProductPrice!) *
                                                      quantity)
                                                  .roundToDouble());
                                            }
                                            ;
                                          }),
                                    )
                                  : null,
                              floatingActionButtonLocation:
                                  FloatingActionButtonLocation.centerDocked,
                            );
                          });
                    });
              });
        });
  }

  void paymentDoneFunc() {
    setState(() {
      paymentDone = true;
    });
  }
}
