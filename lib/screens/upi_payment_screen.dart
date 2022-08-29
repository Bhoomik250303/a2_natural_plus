// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:a2_natural/constants/form_constants.dart';

// class UpiPaymentScreen extends StatefulWidget {
//   const UpiPaymentScreen({Key? key}) : super(key: key);

//   @override
//   _UpiPaymentScreenState createState() => _UpiPaymentScreenState();
// }

// class _UpiPaymentScreenState extends State<UpiPaymentScreen> {
//   // Future<UpiResponse?>? _transaction;
//   // UpiIndia _upiIndia = UpiIndia();
//   // List<UpiApp>? apps;

//   TextStyle header = TextStyle(
//     fontSize: 18,
//     fontWeight: FontWeight.bold,
//   );

//   TextStyle value = TextStyle(
//     fontWeight: FontWeight.w400,
//     fontSize: 14,
//   );

//   @override
//   void initState() {
//     // _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
//     //   setState(() {
//     //     apps = value;
//     //   });
//     // }).catchError((e) {
//     //   apps = [];
//     // });
//     super.initState();
//   }

//   // Future<UpiResponse> initiateTransaction(UpiApp app) async {
//   //   return _upiIndia.startTransaction(
//   //     app: app,
//   //     receiverUpiId: "9699491103@paytm",
//   //     receiverName: 'Company name',
//   //     transactionRefId: 'TestingUpiIndiaPlugin',
//   //     transactionNote: 'Not actual. Just an example.',
//   //     amount: 1.00,
//   //   );
//   // }

//   Widget displayUpiApps(double heightScreen, double widthScreen) {
//     if (apps == null)
//       return Center(child: CircularProgressIndicator());
//     else if (apps!.length == 0)
//       return Center(
//         child: Text(
//           "No apps found to handle transaction.",
//           style: header,
//         ),
//       );
//     else
//       return ListView.builder(
//         itemCount: apps!.length + 2,
//         itemBuilder: (context, index) {
//           if (index == apps!.length + 1) {
//             return Container(
//               child: Column(
//                 children: [
//                   Text(
//                     "OR",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Card(
//                     child: ListTile(
//                       leading: Icon(Icons.money),
//                       title: Text(
//                         'Cash on delivery',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       trailing: Icon(
//                         Icons.arrow_forward_ios_rounded,
//                         color: Colors.black,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             );
//           }

//           if (index == apps!.length) {
//             return FutureBuilder<UpiResponse?>(
//               future: _transaction,
//               builder:
//                   (BuildContext context, AsyncSnapshot<UpiResponse?> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   if (snapshot.hasError) {
//                     return Container(
//                       color: Colors.white,
//                       child: Center(
//                         child: Text(
//                           _upiErrorHandler(snapshot.error.runtimeType),
//                           style: header,
//                         ), // Print's text message on screen
//                       ),
//                     );
//                   }

//                   // If we have data then definitely we will have UpiResponse.
//                   // It cannot be null
//                   UpiResponse? _upiResponse = snapshot.data!;

//                   // Data in UpiResponse can be null. Check before printing
//                   String txnId = _upiResponse.transactionId ?? 'N/A';
//                   String resCode = _upiResponse.responseCode ?? 'N/A';
//                   String txnRef = _upiResponse.transactionRefId ?? 'N/A';
//                   String status = _upiResponse.status ?? 'N/A';
//                   String approvalRef = _upiResponse.approvalRefNo ?? 'N/A';
//                   _checkTxnStatus(status);

//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       color: Colors.white,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           displayTransactionData('Transaction Id', txnId),
//                           displayTransactionData('Response Code', resCode),
//                           displayTransactionData('Reference Id', txnRef),
//                           displayTransactionData(
//                               'Status', status.toUpperCase()),
//                           displayTransactionData('Approval No', approvalRef),
//                         ],  
//                       ),
//                     ),
//                   );
//                 } else
//                   return Center(
//                     child: Text(''),
//                   );
//               },
//             );
//           }

//           return GestureDetector(
//             onTap: () {
//               initiateTransaction(apps![index]);
//             },
//             child: Card(
//               elevation: 0.0,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Container(
//                     height: 0.1 * heightScreen,
//                     child: Card(
//                       child: ListTile(
//                         leading: Image.memory(
//                           apps![index].icon,
//                           height: 60,
//                           width: 60,
//                         ),
//                         title: Text(
//                           'Continue with ${apps![index].name}',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                         trailing: Icon(
//                           Icons.arrow_forward_ios_rounded,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//   }

//   String _upiErrorHandler(error) {
//     switch (error) {
//       case UpiIndiaAppNotInstalledException:
//         return 'Requested app not installed on device';
//       case UpiIndiaUserCancelledException:
//         return 'You cancelled the transaction';
//       case UpiIndiaNullResponseException:
//         return 'Requested app didn\'t return any response';
//       case UpiIndiaInvalidParametersException:
//         return 'Requested app cannot handle the transaction';
//       default:
//         return 'An Unknown error has occurred';
//     }
//   }

//   void _checkTxnStatus(String status) {
//     switch (status) {
//       case UpiPaymentStatus.SUCCESS:
//         Fluttertoast.showToast(msg: 'Transaction Successful');
//         print('Transaction Successful');
//         break;
//       case UpiPaymentStatus.SUBMITTED:
//         print('Transaction Submitted');
//         break;
//       case UpiPaymentStatus.FAILURE:
//         Fluttertoast.showToast(msg: 'Transaction Failed');
//         print('Transaction Failed');
//         break;
//       default:
//         print('Received an Unknown transaction status');
//     }
//   }

//   Widget displayTransactionData(title, body) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text("$title: ", style: header),
//           Flexible(
//               child: Text(
//             body,
//             style: value,
//           )),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     double heightScreen = MediaQuery.of(context).size.height;
//     double widthScreen = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select Payment Method '),
//         backgroundColor: Colors.green,
//         centerTitle: true,
//         elevation: 0.0,
//       ),
//       body: Container(
//         height: heightScreen,
//         color: Colors.white,
//         child: displayUpiApps(heightScreen, widthScreen),
//       ),
//     );
//   }
// }
