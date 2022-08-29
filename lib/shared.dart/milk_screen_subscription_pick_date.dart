import 'package:flutter/material.dart';

class MilkScreenPickDate extends StatefulWidget {
  String subscriptionPlan;
  MilkScreenPickDate({required this.subscriptionPlan});
  @override
  _MilkScreenPickDateState createState() => _MilkScreenPickDateState();
}

class _MilkScreenPickDateState extends State<MilkScreenPickDate> {
 
  @override
  Widget build(BuildContext context) {
    // print(alternateDays);
    print(DateTime.now().add(
      const Duration(days: 1),
    ));
    return Scaffold(
      body: Container(
          child: TextButton(
        child: Text('something'),
        onPressed: () {
          
        },
      )),
    );
  }
}
