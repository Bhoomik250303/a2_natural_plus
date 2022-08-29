import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:a2_natural/constants/form_constants.dart';
import 'package:a2_natural/models/list_of_pincodes_model.dart';
import 'package:a2_natural/models/user_info_model.dart';
import 'package:a2_natural/screens/preview_order_details_screen.dart';
import 'package:a2_natural/services/database_services/database_service.dart';
import 'package:a2_natural/services/razorpay_services/razorpay_services.dart';
import 'package:provider/provider.dart';

class MapsPicker extends StatefulWidget {
  LocationData? pickedAddress;
  String id;
  Function addressCallback;
  MapsPicker(
      {this.pickedAddress, required this.id, required this.addressCallback});

  @override
  State<MapsPicker> createState() => _MapsPickerState();
}

class _MapsPickerState extends State<MapsPicker> {
  Location location = Location();

  @override
  dispose() {
    super.dispose();
    _googleMapController.dispose();
  }

  late GoogleMapController _googleMapController;
  Marker currentPositionMarker = Marker(
    markerId: MarkerId('Your Current Location'),
    position: LatLng(0, 0),
    visible: true,
  );
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: null,
      future: location.getLocation(),
      builder: (BuildContext context, AsyncSnapshot locationData) {
        if (!locationData.hasData) {
          return Scaffold(
            body:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                'Loading Map...',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ]),
          );
        } else {
          print('locationData${locationData}');
          LocationData locData = locationData.data;
          print(locData.longitude);
          return Scaffold(
            body: GoogleMap(
              zoomControlsEnabled: false,
              onMapCreated: (controller) {
                _googleMapController = controller;
                setState(() {
                  currentPositionMarker = Marker(
                    markerId: MarkerId('Your Current Location'),
                    position: LatLng(locationData.data.latitude,
                        locationData.data.longitude),
                  );
                });
              },
              onTap: (LatLng latLng) {
                setState(() {
                  currentPositionMarker = Marker(
                    markerId: MarkerId("Order Location"),
                    position: LatLng(latLng.latitude, latLng.longitude),
                    visible: true,
                  );
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddressScreen(
                        id: widget.id,
                        addressCallback: widget.addressCallback,
                        coordinates:
                            LatLng(locData.latitude!, locData.longitude!),
                      ),
                    ));
              },
              markers: {currentPositionMarker},
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    locationData.data.latitude, locationData.data.longitude),
                zoom: 16,
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () async {
                await _googleMapController.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                  target: LatLng(
                      locationData.data.latitude, locationData.data.longitude),
                  zoom: 16,
                )));
                setState(() {
                  currentPositionMarker = Marker(
                    markerId: MarkerId("Order Location"),
                    position: LatLng(locationData.data.latitude,
                        locationData.data.longitude),
                    visible: true,
                  );
                  ;
                });
              },
              child: Icon(
                Icons.gps_fixed,
                color: Colors.white,
              ),
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.green,
                      blurRadius: 1,
                      offset: Offset(15, 25)),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                color: Colors.white,
              ),
              child: Container(
                child: Text(
                  'Tap to select order address',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class AddressScreen extends StatefulWidget {
  LocationData? pickedAddress;
  String id;
  Function addressCallback;
  LatLng coordinates;
  AddressScreen(
      {this.pickedAddress,
      required this.id,
      required this.addressCallback,
      required this.coordinates});
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool isLocationAvailble = true;
  final formKey = GlobalKey<FormState>();
  Map address = {};
  bool saveForLater = false;
  Location location = Location();
  LocationData? locationData;
  List listOfActivePincodes = [];
  String phonenumber = '';
  String pincode = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // RazorpayServices(context: context).initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    // RazorpayServices(context: context).dispose();
    // googleMapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    var widthScreen = MediaQuery.of(context).size.width;
    // location.getLocation().then((val) {
    //   setState(() {
    //     locationData = val;
    //   });
    // });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Address',
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.green,
      ),
      body: StreamProvider<ListOfPincodes?>.value(
          initialData: null,
          value: DatabaseServices(uid: user!.uid).listOfPincodes,
          builder: (context, child) {
            ListOfPincodes? listOfAvailblePincode =
                Provider.of<ListOfPincodes?>(context);
            print(listOfAvailblePincode?.pincodes);
            return StreamProvider<UserInfoModel?>.value(
                value: DatabaseServices(uid: user.uid).cartDetailsStream,
                initialData: null,
                builder: (context, child) {
                  UserInfoModel? userInfoModel =
                      Provider.of<UserInfoModel?>(context);
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
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
                              'Enter Flat no.',
                              style: textStyleFrom,
                            ),
                            TextFormField(
                              onChanged: (val) {
                                setState(() {
                                  address['flat no'] = val;
                                });
                              },
                              validator: (val) {
                                return val!.isEmpty
                                    ? "Enter a valid detail"
                                    : null;
                              },
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                isDense: true,
                                enabled: true,
                                focusedBorder: inputBorderForm,
                                enabledBorder: inputBorderForm,
                              ),
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            Text(
                              'Enter Building Name',
                              style: textStyleFrom,
                            ),
                            TextFormField(
                              onChanged: (val) {
                                setState(() {
                                  address['building'] = val;
                                });
                              },
                              validator: (val) {
                                return val!.isEmpty
                                    ? "Enter a valid detail"
                                    : null;
                              },
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                isDense: true,
                                enabled: true,
                                focusedBorder: inputBorderForm,
                                enabledBorder: inputBorderForm,
                              ),
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            Text(
                              'Enter Locality',
                              style: textStyleFrom,
                            ),
                            TextFormField(
                              onChanged: (val) {
                                setState(() {
                                  address['locality'] = val;
                                });
                              },
                              validator: (val) {
                                return val!.isEmpty
                                    ? "Enter a valid detail"
                                    : null;
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
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                if (val.length == 6) {
                                  // if (!listOfActivePincodes.contains(val)) {

                                  // }
                                  if (listOfAvailblePincode!.pincodes
                                      .contains(val)) {
                                    isLocationAvailble = true;
                                    setState(() {
                                      pincode = val;
                                      address['pinCode'] = val;
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 1),
                                        content: Container(
                                          child: Text('Service available'),
                                        ),
                                      ),
                                    );
                                  } else {
                                    setState(() {
                                      isLocationAvailble = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 1),
                                        content: Text(
                                            'Service unavilable at this location'),
                                      ),
                                    );
                                  }
                                }
                              },
                              validator: (val) {
                                return val!.length != 6
                                    ? "Enter a valid detail"
                                    : null;
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
                            Text(
                              'Enter phone number',
                              style: textStyleFrom,
                            ),
                            TextFormField(
                              maxLength: 10,
                              keyboardType: TextInputType.number,
                              onChanged: (val) async {
                                if (val.length == 10) {
                                  setState(() {
                                    phonenumber = val;
                                    address['phoneNumber'] = phonenumber;
                                  });
                                }
                              },
                              validator: (val) {
                                return val!.length != 10
                                    ? "Enter a valid detail"
                                    : null;
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
                              onChanged: (val) {
                                setState(() {
                                  val != null
                                      ? address['landmark'] = val
                                      : address['landmark'] = '';
                                });
                              },
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
                            isLocationAvailble
                                ? Container(
                                    width: widthScreen,
                                    child: Center(
                                      child: TextButton(
                                        style: buttonStyle,
                                        onPressed: () async {
                                          setState(() {
                                            address['latitude'] = widget
                                                .coordinates.latitude
                                                .toString();

                                            address['longitude'] = widget
                                                .coordinates.longitude
                                                .toString();
                                          });
                                          if (formKey.currentState!
                                              .validate()) {
                                            if (widget.id == 'milkAddress') {
                                              widget.addressCallback(address);
                                              Navigator.pop(context);
                                            }
                                            if (saveForLater) {
                                              DatabaseServices(uid: user.uid)
                                                  .updateAddress(address);
                                            }
                                            if (widget.id == 'onlyAdd') {
                                              DatabaseServices(uid: user.uid)
                                                  .updateAddress(address);
                                            }
                                            if (widget.id == 'addAndProceed') {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PreviewScreen(
                                                            address: address),
                                                  ));
                                            } else {
                                              Navigator.pop(context);
                                            }
                                          }
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
                                  )
                                : Container(),
                            Container(
                              child: widget.id != 'onlyAdd'
                                  ? Row(
                                      children: [
                                        Checkbox(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8.0,
                                            ),
                                          ),
                                          fillColor: MaterialStateProperty.all(
                                              Colors.green),
                                          value: saveForLater,
                                          onChanged: (val) {
                                            setState(() {
                                              saveForLater = val!;
                                            });
                                          },
                                        ),
                                        Text(
                                          'Save address for future ease',
                                          style: TextStyle(
                                              color: Colors.grey[850]),
                                        ),
                                      ],
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
