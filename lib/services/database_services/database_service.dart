import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:a2_natural/models/cart_orders_product_list_model.dart';
import 'package:a2_natural/models/categorywise/product_catrgory_list_model.dart';
import 'package:a2_natural/models/list_of_pincodes_model.dart';
import 'package:a2_natural/models/milk_product_model.dart';
import 'package:a2_natural/models/milk_quantity_list_model.dart';
import 'package:a2_natural/models/product_display_details_model.dart';
import 'package:a2_natural/models/user_info_model.dart';
import 'package:a2_natural/models/zonewise_pincodes_model.dart';
import 'package:a2_natural/services/authentication_services/authentication_service.dart';

class DatabaseServices {
  final String? uid;
  final String? category;

  DatabaseServices({this.category, this.uid});

  final CollectionReference productCategoryList =
      FirebaseFirestore.instance.collection('productCategories');

  final CollectionReference usersList =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference listOfMilkQuantity =
      FirebaseFirestore.instance.collection('milkQuantityList');

  final CollectionReference milkProductList =
      FirebaseFirestore.instance.collection('milkProductList');

  final CollectionReference milkSubscriptionList =
      FirebaseFirestore.instance.collection('milkSubscriptionList');

  final CollectionReference availableLocations =
      FirebaseFirestore.instance.collection('availableLocations');

  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');

  final CollectionReference zonewisePincodes =
      FirebaseFirestore.instance.collection('deliveryPincodeZones');

  Future setUserData(LocationData location, String? email, String? phone,
      String? username) async {
    await usersList.doc(uid).set(
      {
        'uid': uid,
        'location': GeoPoint(location.latitude!, location.longitude!),
        'cart': [],
        'order': [],
        'email': email,
        'phonenumber': phone,
        'address': [],
        'profileImageUrl': '',
        'isSubscribed': false,
        'subscriptionData': {},
        'subscriptionPlan': {},
        'subscriptionPlanCancelDates': [],
        'username': username,
      },
    );
  }

  Future uploadUserProfileImage(String imageUrl) async {
    return await usersList.doc(FirebaseAuth.instance.currentUser?.uid).update(
      {
        'profileImageUrl': imageUrl,
      },
    );
  }

  addToCartFunction(String selectedPackaging, String price, String name,
      int quantity, String imageUrl, String discountPercentage) async {
    await DatabaseServices(uid: FirebaseAuth.instance.currentUser?.uid)
        .usersList
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      'cart': FieldValue.arrayRemove(
        ['No items in cart'],
      ),
    });

    await DatabaseServices(uid: FirebaseAuth.instance.currentUser?.uid)
        .usersList
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update(
      {
        'cart': FieldValue.arrayUnion(
          [
            {
              'packaging': selectedPackaging.toString(),
              'price': price,
              'product': name,
              'quantity': quantity,
              'imageUrl': imageUrl,
              'discountPercentage': discountPercentage,
            },
          ],
        ),
      },
    );
  }

  Future removeFromCart(String val) {
    return usersList.doc(FirebaseAuth.instance.currentUser?.uid).update({
      'cart': FieldValue.arrayRemove([val])
    });
  }

  Future updateAddress(Map address) {
    return usersList.doc(FirebaseAuth.instance.currentUser?.uid).update(
      {
        'address': FieldValue.arrayUnion([address])
      },
    );
  }

  Future addOrder(Map orderDetails, String zone) async {
    await usersList.doc(FirebaseAuth.instance.currentUser?.uid).update(
      {
        'order': FieldValue.arrayUnion([orderDetails]),
      },
    );
    orders.doc(zone).update({
      'order': FieldValue.arrayUnion([orderDetails]),
    });
    return usersList.doc(FirebaseAuth.instance.currentUser?.uid).update(
      {
        'cart': [],
      },
    );
  }

  List<ProductDairyCategoryListModel> _productCategoryDatabaseToModel(
      QuerySnapshot snap) {
    return snap.docs.map((e) {
      return ProductDairyCategoryListModel(
          imageUrl: e['imageUrl'],
          name: e['name'],
          displayName: e['displayName']);
    }).toList();
  }

  Stream<List<ProductDairyCategoryListModel>> get ProductCategoryListStream {
    return productCategoryList.snapshots().map(_productCategoryDatabaseToModel);
  }

  List<ProductDisplayDetailsModel> _databaseCategorywiseDetailedProductToModel(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      return ProductDisplayDetailsModel(
        imageUrl: e['imageUrl'],
        name: e['name'],
        currentPrice: e['price'].toList(),
        packaging: e['packaging'].toList(),
        discountPercentage: e['discountPercentage'].toString(),
        productDescription: e['description'].toList(),
        isMilk: e['milk'],
      );
    }).toList();
  }

  Stream<List<ProductDisplayDetailsModel>>
      get productCategoryDetailedListMilkProducts {
    return productCategoryList
        .doc(category)
        .collection('items')
        .snapshots()
        .map(_databaseCategorywiseDetailedProductToModel);
  }

  UserInfoModel databaseToUserInfoModel(DocumentSnapshot snapshot) {
    return UserInfoModel(
      cart: snapshot['cart'],
      location: snapshot['location'].toString(),
      orders: snapshot['order'],
      address: snapshot['address'],
      email: snapshot['email'],
      phonenumber: snapshot['phonenumber'],
      profileImageUrl: snapshot['profileImageUrl'],
      isSubscribed: snapshot['isSubscribed'],
      subscriptionData: snapshot['subscriptionData'],
      username: snapshot['username'],
    );
  }

  Stream<UserInfoModel?> get cartDetailsStream {
    // Fluttertoast.showToast(
    //     msg: 'uid fire${FirebaseAuth.instance.currentUser?.uid}');
    // Fluttertoast.showToast(msg: 'uid ${uid}');
    return usersList.doc(uid).snapshots().map(
          (databaseToUserInfoModel),
        );
  }

  MilkQuantityListModel _listOfMilkQuantity(DocumentSnapshot snap) {
    return MilkQuantityListModel(listOfQuantity: snap['quantity']);
  }

  Stream<MilkQuantityListModel?> get listOfMilkQuantityStream {
    return listOfMilkQuantity.doc('List').snapshots().map(_listOfMilkQuantity);
  }

  List<MilkProductModel> _listOfMilkProductToModel(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      return MilkProductModel(
        imageUrl: e['imageUrl'],
        name: e['name'],
        currentPrice: e['price'].toList(),
        packaging: e['packaging'].toList(),
        discountPercentage: e['discountPercentage'].toString(),
        productDescription: e['description'].toList(),
      );
    }).toList();
  }

  Stream<List<MilkProductModel>?> get milkProductStream {
    return milkProductList.snapshots().map(_listOfMilkProductToModel);
  }

  Future uploadingSubscriptionStatus(
    double quantity,
    Map address,
    String price,
    String subscriptionPlan,
    List weekDays,
    String paymentMethod,
    String uid,
    String username,
    String startingDate,
    String product,
    String orderTime,
    String orderZone,
  ) async {
    await milkSubscriptionList.doc(subscriptionPlan).update({
      'address': FieldValue.arrayUnion([
        {
          'subscriptionPlan': subscriptionPlan,
          'quantity': quantity,
          'address': address,
          'paymentMethod': paymentMethod,
          'user': uid,
          'username': username,
          'startingDate': startingDate.toString(),
          'weekDaysSelections': weekDays,
          'price': price,
          'product': product,
          'orderZone': orderZone,
        }
      ])
    });
    await usersList.doc(uid).update(
      {
        'isSubscribed': true,
        'subscriptionData': {
          'orderZone': orderZone,
          'subscriptionPlan': subscriptionPlan,
          'quantity': quantity,
          'address': address,
          'paymentMethod': paymentMethod,
          'user': uid,
          'username': username,
          'startingDate': startingDate,
          'weekDaysSelections': weekDays,
          'price': price,
          'product': product,
        }
      },
    );
  }

  Future updatingSubscriptionPlan(
      String newSubscriptionPlan,
      String currentSubscriptionPlan,
      String startingDate,
      double quantity,
      Map address,
      String paymentMethod) async {
    await milkSubscriptionList
        .doc(currentSubscriptionPlan)
        .update({'address': FieldValue.delete()});

    await milkSubscriptionList.doc(newSubscriptionPlan).update({
      'address': FieldValue.arrayUnion([
        {
          'quantity': quantity,
          'address': address,
          'paymentMethod': paymentMethod,
          'user': uid,
          'startingDate': startingDate,
        }
      ])
    });

    usersList.doc(uid).update(
      {
        'isSubscribed': true,
        'subscriptionData': {
          'subscriptionPlan': newSubscriptionPlan,
          'quantity': quantity,
          'address': address,
          'paymentMethod': paymentMethod,
          'user': uid,
          'startingDate': startingDate,
        }
      },
    );
  }

  Future updatingSubscriptionQuantity(
      String subscriptionPlan,
      String startingDate,
      double newQuantity,
      Map address,
      String paymentMethod) async {
    await milkSubscriptionList.doc(subscriptionPlan).get().then(
      (value) {
        value['address'].map(
          (val) {
            if (val['user'] == uid) {
              milkSubscriptionList.doc(subscriptionPlan).update(
                {
                  'address': FieldValue.arrayUnion(
                    [
                      {
                        'quantity': newQuantity,
                        'address': address,
                        'paymentMethod': paymentMethod,
                        'user': uid,
                        'startingDate': startingDate,
                      }
                    ],
                  )
                },
              );
            }
          },
        );
      },
    );

    // update({
    //   'address': FieldValue.arrayUnion([
    //     {
    //       'quantity': newQuantity,
    //       'address': address,
    //       'paymentMethod': paymentMethod,
    //       'user': uid,
    //       'startingDate' : startingDate,
    //     }
    //   ])
    // });

    usersList.doc(uid).update(
      {
        'isSubscribed': true,
        'subscriptionData': {
          'subscriptionPlan': subscriptionPlan,
          'quantity': newQuantity,
          'address': address,
          'paymentMethod': paymentMethod,
          'user': uid,
          'startingDate': startingDate,
        }
      },
    );
  }

  Future updatingSubscriptionAddress(
      String subscriptionPlan,
      String startingDate,
      double quantity,
      Map newAddress,
      String paymentMethod) async {
    await milkSubscriptionList.doc(subscriptionPlan).get().then(
      (value) {
        value['address'].map(
          (val) {
            if (val['user'] == uid) {
              milkSubscriptionList.doc(subscriptionPlan).update(
                {
                  'address': FieldValue.arrayUnion(
                    [
                      {
                        'quantity': quantity,
                        'address': newAddress,
                        'paymentMethod': paymentMethod,
                        'user': uid,
                        'startingDate': startingDate,
                      }
                    ],
                  )
                },
              );
            }
          },
        );
      },
    );

    // update({
    //   'address': FieldValue.arrayUnion([
    //     {
    //       'quantity': newQuantity,
    //       'address': address,
    //       'paymentMethod': paymentMethod,
    //       'user': uid,
    //       'startingDate' : startingDate,
    //     }
    //   ])
    // });

    usersList.doc(uid).update(
      {
        'isSubscribed': true,
        'subscriptionData': {
          'subscriptionPlan': subscriptionPlan,
          'quantity': quantity,
          'address': newAddress,
          'paymentMethod': paymentMethod,
          'user': uid,
          'startingDate': startingDate,
        }
      },
    );
  }

  unSubscribingFromMilk(
    String uid,
  ) async {
    return await usersList.doc(uid).update(
      {
        'isSubscribed': false,
        'subscriptionPlan': {},
      },
    );
  }

  Future skippingMilk(var date) async {
    await usersList.doc(uid).update(
      {
        'subscriptionPlanCancelDates': FieldValue.arrayUnion([date]),
      },
    );
    // await milkSubscriptionList.doc(subscriptionPlan).update(
    //   {

    //   }
    // );
  }

  ListOfPincodes gettingListOfPincodes(DocumentSnapshot snapshot) {
    return ListOfPincodes(pincodes: snapshot['pincodes']);
  }

  Stream<ListOfPincodes?> get listOfPincodes {
    return availableLocations
        .doc('pincodes')
        .snapshots()
        .map((gettingListOfPincodes));
  }

  ZonewisePincodesModel _zonewisePincodeDbToModel(QuerySnapshot snapshot) {
    List listOfDocs = snapshot.docs.map((e) {
      return e;
    }).toList();
    return ZonewisePincodesModel(
      zone1: listOfDocs[0],
      zone2: listOfDocs[1],
      zone3: listOfDocs[2],
      zone4: listOfDocs[3],
      zone5: listOfDocs[4],
      zone6: listOfDocs[5],
    );
  }

  Stream<ZonewisePincodesModel?> get zonewisePincodeStream {
    return zonewisePincodes.snapshots().map(_zonewisePincodeDbToModel);
  }
}
