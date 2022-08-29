import 'package:flutter/material.dart';
import 'package:a2_natural/constants/form_constants.dart';

class MilkScreenWeekdaysShared extends StatefulWidget {
  Function weekDaysCallback;
  List listOfDayClass;

  MilkScreenWeekdaysShared(
      {required this.weekDaysCallback, required this.listOfDayClass});

  @override
  _MilkScreenWeekdaysSharedState createState() =>
      _MilkScreenWeekdaysSharedState();
}

class _MilkScreenWeekdaysSharedState extends State<MilkScreenWeekdaysShared> {
  List selectedWeekDays = [];

  @override
  Widget build(BuildContext context) {
    return widget.listOfDayClass == null
        ? Scaffold(
            body: Container(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            ),
          )
        : Scaffold(
            body: ListView.builder(
              itemCount: widget.listOfDayClass.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text(
                    widget.listOfDayClass[index].day,
                  ),
                  trailing: Checkbox(
                    onChanged: (value) {
                      setState(() {
                        widget.listOfDayClass[index].status = value!;
                      });
                      if (!widget.listOfDayClass[index].status) {
                        selectedWeekDays
                            .remove(widget.listOfDayClass[index].day);
                      }

                      print('before$selectedWeekDays');
                      if (!selectedWeekDays
                          .contains(widget.listOfDayClass[index].day)) {
                        widget.listOfDayClass[index].status
                            ? selectedWeekDays
                                .add(widget.listOfDayClass[index].day)
                            : selectedWeekDays
                                .remove(widget.listOfDayClass[index].day);
                      }
                      print('after$selectedWeekDays');
                    },
                    value: widget.listOfDayClass[index].status,
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                  ),
                );
              },
            ),
            bottomNavigationBar: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: TextButton(
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  widget.weekDaysCallback(selectedWeekDays);
                  Navigator.pop(context);
                },
                style: buttonStyle,
              ),
            ),
          );
  }
}

class DayClass {
  String day;
  bool status;
  DayClass({required this.day, required this.status});
}
