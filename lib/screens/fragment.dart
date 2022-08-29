import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:a2_natural/models/milk_product_model.dart';
import 'package:a2_natural/models/user_info_model.dart';
import 'package:a2_natural/screens/home_screen.dart';
import 'package:a2_natural/screens/milk_screen.dart';
import 'package:a2_natural/screens/milk_screen_subscribed_screen.dart';
import 'package:a2_natural/screens/order_history_details_screen.dart';
import 'package:a2_natural/screens/order_history_screen.dart';
import 'package:a2_natural/screens/profile_screen.dart';
import 'package:a2_natural/screens/all_products_screen.dart';
import 'package:a2_natural/services/database_services/database_service.dart';
import 'package:provider/provider.dart';

class Tabs extends StatefulWidget {
  const Tabs({Key? key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin {
  late TabController _tabsController;

  MilkProductModel? listOfFuturesOfDocumentRef;
  UserInfoModel? userInfoModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabsController = TabController(length: 4, vsync: this);
    _tabsController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;
    listOfFuturesOfDocumentRef = Provider.of<MilkProductModel?>(context);

    User? user = Provider.of<User?>(context);
    // Fluttertoast.showToast(msg: '${user?.uid}');
    

    return StreamProvider.value(
        value: DatabaseServices(uid: user?.uid).cartDetailsStream,
        initialData: null,
        builder: (context, child) {
          userInfoModel = Provider.of<UserInfoModel?>(context);
          return WillPopScope(
            onWillPop: () async {
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
                  content: Text('Do you want to exit the App'),
                  actions: <Widget>[
                    TextButton(     
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        'No',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        'Yes',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ));
            },
            child: DefaultTabController(
              length: 4,
              child: Scaffold(
                body: TabBarView(
                  controller: _tabsController,
                  children: [
                    HomeScreen(
                      user: user,
                    ),
                    ALlProductsScreen(),
                    OrderHistoryScreen(),
                    ProfileScreen(),
                  ],
                ),
                bottomNavigationBar: Container(
                  height: 0.07 * heightScreen,
                  child: BottomAppBar(
                    shape: CircularNotchedRectangle(),
                    child: TabBar(
                      unselectedLabelColor: Colors.green,
                      indicatorColor: Colors.green,
                      labelColor: Colors.green,
                      controller: _tabsController,
                      tabs: [
                        Icon(
                          Icons.home,
                          color: _tabsController.index == 0
                              ? Colors.green
                              : Colors.grey,
                        ),
                        Icon(
                          Icons.shopping_bag,
                          color: _tabsController.index == 1
                              ? Colors.green
                              : Colors.grey,
                        ),
                        Icon(
                          Icons.update_sharp,
                          color: _tabsController.index == 2
                              ? Colors.green
                              : Colors.grey,
                        ),
                        Icon(
                          Icons.person,
                          color: _tabsController.index == 3
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  elevation: 0.0,
                  backgroundColor: Colors.green,
                  onPressed: () {
                    userInfoModel!.isSubscribed
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MilkScreenSubcribedScreen(
                                userInfoModel: userInfoModel,
                              ),
                            ),
                          )
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MilkScreen(orderDetails: {},price: ''),
                            ),
                          );
                  },
                  child: Text(
                    'Milk',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
              ),
            ),
          );
        });
  }
}
