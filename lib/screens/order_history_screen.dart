import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:a2_natural/models/user_info_model.dart';
import 'package:a2_natural/screens/order_history_details_screen.dart';
import 'package:a2_natural/services/database_services/database_service.dart';
import 'package:provider/provider.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0.0,
      ),
      body: StreamProvider<UserInfoModel?>.value(
        initialData: null,
        value: DatabaseServices(uid: user?.uid).cartDetailsStream,
        builder: (context, child) {
          UserInfoModel? userInfoModel = Provider.of<UserInfoModel?>(context);
          if (userInfoModel == null) {
            return Scaffold(
              body: Container(
                child: Center(
                  child: CircularProgressIndicator(color: Colors.green),
                ),
              ),
            );
          }

          return userInfoModel != null && userInfoModel.orders!.length != 0
              ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: userInfoModel.orders?.length ?? 0,
                  itemBuilder: (context, index) {
                    print(userInfoModel.orders);
                    return userInfoModel.orders![userInfoModel.orders!.length -
                            1 -
                            index]['isMilkSubs']
                        ? Card(
                            child: ListTile(
                              title: Text(
                                'Order Date: ${userInfoModel.orders?[userInfoModel.orders!.length - 1 - index]?['orderTime'].toString().split(' ')[0]}',
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Row(
                                    children: [
                                      Text('Product : '),
                                      Text(
                                        '${userInfoModel.orders?[userInfoModel.orders!.length - 1 - index]?['product']}',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Subscription Plan : '),
                                      Text(
                                        '${userInfoModel.orders?[userInfoModel.orders!.length - 1 - index]?['subscriptionPlan']}',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Total Price : '),
                                      Text(
                                        '\u{20B9}${userInfoModel.orders?[userInfoModel.orders!.length - 1 - index]?['totalPrice']}',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Card(
                            elevation: 2.0,
                            child: ListTile(
                              title: Text(
                                'Order Date: ${userInfoModel.orders?[userInfoModel.orders!.length - 1 - index]?['orderTime'].toString().split(' ')[0]}',
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  Row(
                                    children: [
                                      Text('Total Price : '),
                                      Text(
                                        '\u{20B9}${userInfoModel.orders?[userInfoModel.orders!.length - 1 - index]?['totalPrice'].round()}',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Row(
                                    children: [
                                      Text('Total Saved : '),
                                      Text(
                                        '\u{20B9}${userInfoModel.orders?[userInfoModel.orders!.length - 1 - index]['totalSaved'].round()}',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Text(
                                    'Order products: ${userInfoModel.orders?[userInfoModel.orders!.length - 1 - index]?['productList'][0]['product']} ...',
                                  ),
                                ],
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrderHistoryDetailsScreen(
                                          orderDetails: userInfoModel.orders?[
                                                  userInfoModel.orders!.length -
                                                      1 -
                                                      index] ??
                                              {},
                                        ),
                                      ));
                                },
                                child: Icon(
                                  Icons.arrow_right,
                                  color: Colors.green,
                                  size: 32,
                                ),
                              ),
                            ),
                          );
                  })
              : Container(
                  child: Center(
                    child: Text(
                      'No orders yet',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
