import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'dataModel.dart';

class EditTimes extends StatefulWidget {
  const EditTimes({super.key});

  @override
  State<EditTimes> createState() => _EditTimesState();
}

class _EditTimesState extends State<EditTimes> {
  DateTime mondayStart = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 0, 0, 0); // Set to midnight
  DateTime mondayEnd = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 23, 45, 0); // Set to midnight

  DateTime tuesdayStart = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 0, 0, 0); // Set to midnight
  DateTime tuesdayEnd = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 23, 45, 0); // Set to midnight

  DateTime wednesdayStart = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 0, 0, 0); // Set to midnight
  DateTime wednesdayEnd = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 23, 45, 0); // Set to midnight

  DateTime thursdayStart = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 0, 0, 0); // Set to midnight
  DateTime thursdayEnd = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 23, 45, 0); // Set to midnight

  DateTime fridayStart = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 0, 0, 0); // Set to midnight
  DateTime fridayEnd = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 23, 45, 0); // Set to midnight

  DateTime saturdayStart = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 0, 0, 0); // Set to midnight
  DateTime saturdayEnd = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 23, 45, 0); // Set to midnight

  DateTime sundayStart = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 0, 0, 0); // Set to midnight
  DateTime sundayEnd = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 23, 45, 0); // Set to midnight

  var mondayColor = Color.fromARGB(255, 255, 232, 202);
  var tuesdayColor = Color.fromARGB(255, 195, 225, 255);
  var wednesdayColor = Color.fromARGB(255, 237, 210, 255);
  var thursdayColor = Color.fromARGB(255, 255, 214, 243);
  var fridayColor = Color.fromARGB(255, 255, 207, 207);
  var saturdayColor = Color.fromARGB(255, 176, 224, 186);
  var sundayColor = Color.fromARGB(255, 240, 236, 183);

  Future<void> _saveTimes() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('mondayStart', mondayStart.toIso8601String());
    await prefs.setString('mondayEnd', mondayEnd.toIso8601String());

    await prefs.setString('tuesdayStart', tuesdayStart.toIso8601String());
    await prefs.setString('tuesdayEnd', tuesdayEnd.toIso8601String());

    await prefs.setString('wednesdayStart', wednesdayStart.toIso8601String());
    await prefs.setString('wednesdayEnd', wednesdayEnd.toIso8601String());

    await prefs.setString('thursdayStart', thursdayStart.toIso8601String());
    await prefs.setString('thursdayEnd', thursdayEnd.toIso8601String());

    await prefs.setString('fridayStart', fridayStart.toIso8601String());
    await prefs.setString('fridayEnd', fridayEnd.toIso8601String());

    await prefs.setString('saturdayStart', saturdayStart.toIso8601String());
    await prefs.setString('saturdayEnd', saturdayEnd.toIso8601String());

    await prefs.setString('sundayStart', sundayStart.toIso8601String());
    await prefs.setString('sundayEnd', sundayEnd.toIso8601String());
  }

  Future<void> _loadTimes() async {
    final prefs = await SharedPreferences.getInstance();

    // Fetching Monday's values
    String? mondayStartStr = prefs.getString('mondayStart');
    String? mondayEndStr = prefs.getString('mondayEnd');

    // Fetching Tuesday's values
    String? tuesdayStartStr = prefs.getString('tuesdayStart');
    String? tuesdayEndStr = prefs.getString('tuesdayEnd');

    // Fetching Wednesday's values
    String? wednesdayStartStr = prefs.getString('wednesdayStart');
    String? wednesdayEndStr = prefs.getString('wednesdayEnd');

    // Fetching Thursday's values
    String? thursdayStartStr = prefs.getString('thursdayStart');
    String? thursdayEndStr = prefs.getString('thursdayEnd');

    // Fetching Friday's values
    String? fridayStartStr = prefs.getString('fridayStart');
    String? fridayEndStr = prefs.getString('fridayEnd');

    // Fetching Saturday's values
    String? saturdayStartStr = prefs.getString('saturdayStart');
    String? saturdayEndStr = prefs.getString('saturdayEnd');

    // Fetching Sunday's values
    String? sundayStartStr = prefs.getString('sundayStart');
    String? sundayEndStr = prefs.getString('sundayEnd');

    setState(() {
      // Setting values to variables or defaulting to midnight and 23:45
      mondayStart = mondayStartStr != null
          ? DateTime.parse(mondayStartStr)
          : DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 0, 0, 0);
      mondayEnd = mondayEndStr != null
          ? DateTime.parse(mondayEndStr)
          : DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 23, 45, 0);

      tuesdayStart = tuesdayStartStr != null
          ? DateTime.parse(tuesdayStartStr)
          : DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 0, 0, 0);
      tuesdayEnd = tuesdayEndStr != null
          ? DateTime.parse(tuesdayEndStr)
          : DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 23, 45, 0);

      wednesdayStart = wednesdayStartStr != null
          ? DateTime.parse(wednesdayStartStr)
          : DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 0, 0, 0);
      wednesdayEnd = wednesdayEndStr != null
          ? DateTime.parse(wednesdayEndStr)
          : DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 23, 45, 0);

      thursdayStart = thursdayStartStr != null
          ? DateTime.parse(thursdayStartStr)
          : DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 0, 0, 0);
      thursdayEnd = thursdayEndStr != null
          ? DateTime.parse(thursdayEndStr)
          : DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 23, 45, 0);

      fridayStart = fridayStartStr != null
          ? DateTime.parse(fridayStartStr)
          : DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 0, 0, 0);
      fridayEnd = fridayEndStr != null
          ? DateTime.parse(fridayEndStr)
          : DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 23, 45, 0);

      saturdayStart = saturdayStartStr != null
          ? DateTime.parse(saturdayStartStr)
          : DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 0, 0, 0);
      saturdayEnd = saturdayEndStr != null
          ? DateTime.parse(saturdayEndStr)
          : DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 23, 45, 0);

      sundayStart = sundayStartStr != null
          ? DateTime.parse(sundayStartStr)
          : DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 0, 0, 0);
      sundayEnd = sundayEndStr != null
          ? DateTime.parse(sundayEndStr)
          : DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 23, 45, 0);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTimes();
  }

  @override
  Widget build(BuildContext context) {
    var dataModel = Provider.of<DataModel>(context);

    String formatTime(DateTime dateTime) {
      return DateFormat('HH:mm').format(dateTime);
    }

    void displayInvalidTimesDialog(BuildContext context) {
      showCupertinoDialog<void>(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text("INVALID TIMES"),
                content: Text("Make sure all end times are after start times"),
                actions: [
                  CupertinoDialogAction(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ));
    }

    bool checkTimesValid() {
      if (mondayStart.isAfter(mondayEnd)) {
        return false;
      } else if (tuesdayStart.isAfter(tuesdayEnd)) {
        return false;
      } else if (wednesdayStart.isAfter(wednesdayEnd)) {
        return false;
      } else if (thursdayStart.isAfter(thursdayEnd)) {
        return false;
      } else if (fridayStart.isAfter(fridayEnd)) {
        return false;
      } else if (saturdayStart.isAfter(saturdayEnd)) {
        return false;
      } else if (sundayStart.isAfter(sundayEnd)) {
        return false;
      } else {
        return true;
      }
    }

    void setTimes() {
      Map<String, String> times = {
        'mondayStart': mondayStart.toIso8601String(),
        'mondayEnd': mondayEnd.toIso8601String(),
        'tuesdayStart': tuesdayStart.toIso8601String(),
        'tuesdayEnd': tuesdayEnd.toIso8601String(),
        'wednesdayStart': wednesdayStart.toIso8601String(),
        'wednesdayEnd': wednesdayEnd.toIso8601String(),
        'thursdayStart': thursdayStart.toIso8601String(),
        'thursdayEnd': thursdayEnd.toIso8601String(),
        'fridayStart': fridayStart.toIso8601String(),
        'fridayEnd': fridayEnd.toIso8601String(),
        'saturdayStart': saturdayStart.toIso8601String(),
        'saturdayEnd': saturdayEnd.toIso8601String(),
        'sundayStart': sundayStart.toIso8601String(),
        'sundayEnd': sundayEnd.toIso8601String(),
      };

      String jsonTimes = jsonEncode(times);

      dataModel.updateTimes(jsonTimes);
    }

    return GestureDetector(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.72,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 248, 248, 248),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(30, 30, 0, 10),
              child: Text(
                "EDIT TIMES",
                style: TextStyle(fontSize: 30),
              ),
            ),
            Center(
              child: FractionallySizedBox(
                widthFactor:
                    0.85, // Sets the width to 50% of the available width
                child: Divider(
                  color:
                      Color.fromARGB(255, 80, 78, 78), // Color of the divider
                  height:
                      1, // Space occupied by the divider, including the line and space above and below it
                  thickness: 0.5, // Thickness of the line
                ),
              ),
            ),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.95,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Center(
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  decoration: BoxDecoration(
                                    color: mondayColor,
                                    borderRadius: BorderRadius.circular(
                                        10), // Set the radius to 5
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.2,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      10), // Set the radius to 5
                                ),
                                child: Center(
                                  child: CupertinoButton(
                                    child: Text(
                                      formatTime(mondayStart),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext builder) {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .copyWith()
                                                      .size
                                                      .height /
                                                  3,
                                              color: Colors.white,
                                              child: CupertinoDatePicker(
                                                mode: CupertinoDatePickerMode
                                                    .time,
                                                initialDateTime: mondayStart,
                                                onDateTimeChanged:
                                                    (DateTime newTime) {
                                                  // Update the selectedTime variable when the user picks a new time
                                                  setState(() {
                                                    mondayStart = newTime;
                                                  });
                                                },
                                                use24hFormat:
                                                    true, // Optionally, set to true for 24-hour format
                                                minuteInterval: 15,
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 225, 165),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "MONDAY",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  decoration: BoxDecoration(
                                    color: mondayColor,
                                    borderRadius: BorderRadius.circular(
                                        10), // Set the radius to 5
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.2,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      10), // Set the radius to 5
                                ),
                                child: Center(
                                  child: CupertinoButton(
                                    child: Text(
                                      formatTime(mondayEnd),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext builder) {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .copyWith()
                                                      .size
                                                      .height /
                                                  3,
                                              color: Colors.white,
                                              child: CupertinoDatePicker(
                                                mode: CupertinoDatePickerMode
                                                    .time,
                                                initialDateTime: mondayEnd,
                                                onDateTimeChanged:
                                                    (DateTime newTime) {
                                                  // Update the selectedTime variable when the user picks a new time
                                                  setState(() {
                                                    mondayEnd = newTime;
                                                  });
                                                },
                                                use24hFormat:
                                                    true, // Optionally, set to true for 24-hour format
                                                minuteInterval: 15,
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: FractionallySizedBox(
                widthFactor:
                    0.85, // Sets the width to 50% of the available width
                child: Divider(
                  color:
                      Color.fromARGB(255, 80, 78, 78), // Color of the divider
                  height:
                      1, // Space occupied by the divider, including the line and space above and below it
                  thickness: 0.5, // Thickness of the line
                ),
              ),
            ),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.95,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Center(
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  decoration: BoxDecoration(
                                    color: tuesdayColor,
                                    borderRadius: BorderRadius.circular(
                                        10), // Set the radius to 5
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.2,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      10), // Set the radius to 5
                                ),
                                child: Center(
                                  child: CupertinoButton(
                                    child: Text(
                                      formatTime(tuesdayStart),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext builder) {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .copyWith()
                                                      .size
                                                      .height /
                                                  3,
                                              color: Colors.white,
                                              child: CupertinoDatePicker(
                                                mode: CupertinoDatePickerMode
                                                    .time,
                                                initialDateTime: tuesdayStart,
                                                onDateTimeChanged:
                                                    (DateTime newTime) {
                                                  // Update the selectedTime variable when the user picks a new time
                                                  setState(() {
                                                    tuesdayStart = newTime;
                                                  });
                                                },
                                                use24hFormat:
                                                    true, // Optionally, set to true for 24-hour format
                                                minuteInterval: 15,
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                          color: tuesdayColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "TUESDAY",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  decoration: BoxDecoration(
                                    color: tuesdayColor,
                                    borderRadius: BorderRadius.circular(
                                        10), // Set the radius to 5
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.2,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      10), // Set the radius to 5
                                ),
                                child: Center(
                                  child: CupertinoButton(
                                    child: Text(
                                      formatTime(tuesdayEnd),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext builder) {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .copyWith()
                                                      .size
                                                      .height /
                                                  3,
                                              color: Colors.white,
                                              child: CupertinoDatePicker(
                                                mode: CupertinoDatePickerMode
                                                    .time,
                                                initialDateTime: tuesdayEnd,
                                                onDateTimeChanged:
                                                    (DateTime newTime) {
                                                  // Update the selectedTime variable when the user picks a new time
                                                  setState(() {
                                                    tuesdayEnd = newTime;
                                                  });
                                                },
                                                use24hFormat:
                                                    true, // Optionally, set to true for 24-hour format
                                                minuteInterval: 15,
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: FractionallySizedBox(
                widthFactor:
                    0.85, // Sets the width to 50% of the available width
                child: Divider(
                  color:
                      Color.fromARGB(255, 80, 78, 78), // Color of the divider
                  height:
                      1, // Space occupied by the divider, including the line and space above and below it
                  thickness: 0.5, // Thickness of the line
                ),
              ),
            ),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.95,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Center(
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  decoration: BoxDecoration(
                                    color: wednesdayColor,
                                    borderRadius: BorderRadius.circular(
                                        10), // Set the radius to 5
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.2,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      10), // Set the radius to 5
                                ),
                                child: Center(
                                  child: CupertinoButton(
                                    child: Text(
                                      formatTime(wednesdayStart),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext builder) {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .copyWith()
                                                      .size
                                                      .height /
                                                  3,
                                              color: Colors.white,
                                              child: CupertinoDatePicker(
                                                mode: CupertinoDatePickerMode
                                                    .time,
                                                initialDateTime: wednesdayStart,
                                                onDateTimeChanged:
                                                    (DateTime newTime) {
                                                  // Update the selectedTime variable when the user picks a new time
                                                  setState(() {
                                                    wednesdayStart = newTime;
                                                  });
                                                },
                                                use24hFormat:
                                                    true, // Optionally, set to true for 24-hour format
                                                minuteInterval: 15,
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                          color: wednesdayColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "WEDNESDAY",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  decoration: BoxDecoration(
                                    color: wednesdayColor,
                                    borderRadius: BorderRadius.circular(
                                        10), // Set the radius to 5
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.2,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      10), // Set the radius to 5
                                ),
                                child: Center(
                                  child: CupertinoButton(
                                    child: Text(
                                      formatTime(wednesdayEnd),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext builder) {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .copyWith()
                                                      .size
                                                      .height /
                                                  3,
                                              color: Colors.white,
                                              child: CupertinoDatePicker(
                                                mode: CupertinoDatePickerMode
                                                    .time,
                                                initialDateTime: wednesdayEnd,
                                                onDateTimeChanged:
                                                    (DateTime newTime) {
                                                  // Update the selectedTime variable when the user picks a new time
                                                  setState(() {
                                                    wednesdayEnd = newTime;
                                                  });
                                                },
                                                use24hFormat:
                                                    true, // Optionally, set to true for 24-hour format
                                                minuteInterval: 15,
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: FractionallySizedBox(
                widthFactor:
                    0.85, // Sets the width to 50% of the available width
                child: Divider(
                  color:
                      Color.fromARGB(255, 80, 78, 78), // Color of the divider
                  height:
                      1, // Space occupied by the divider, including the line and space above and below it
                  thickness: 0.5, // Thickness of the line
                ),
              ),
            ),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.95,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Center(
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  decoration: BoxDecoration(
                                    color: thursdayColor,
                                    borderRadius: BorderRadius.circular(
                                        10), // Set the radius to 5
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.2,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      10), // Set the radius to 5
                                ),
                                child: Center(
                                  child: CupertinoButton(
                                    child: Text(
                                      formatTime(thursdayStart),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext builder) {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .copyWith()
                                                      .size
                                                      .height /
                                                  3,
                                              color: Colors.white,
                                              child: CupertinoDatePicker(
                                                mode: CupertinoDatePickerMode
                                                    .time,
                                                initialDateTime: thursdayStart,
                                                onDateTimeChanged:
                                                    (DateTime newTime) {
                                                  // Update the selectedTime variable when the user picks a new time
                                                  setState(() {
                                                    thursdayStart = newTime;
                                                  });
                                                },
                                                use24hFormat:
                                                    true, // Optionally, set to true for 24-hour format
                                                minuteInterval: 15,
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                          color: thursdayColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "THURSDAY",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  decoration: BoxDecoration(
                                    color: thursdayColor,
                                    borderRadius: BorderRadius.circular(
                                        10), // Set the radius to 5
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.2,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      10), // Set the radius to 5
                                ),
                                child: Center(
                                  child: CupertinoButton(
                                    child: Text(
                                      formatTime(thursdayEnd),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext builder) {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .copyWith()
                                                      .size
                                                      .height /
                                                  3,
                                              color: Colors.white,
                                              child: CupertinoDatePicker(
                                                mode: CupertinoDatePickerMode
                                                    .time,
                                                initialDateTime: thursdayEnd,
                                                onDateTimeChanged:
                                                    (DateTime newTime) {
                                                  // Update the selectedTime variable when the user picks a new time
                                                  setState(() {
                                                    thursdayEnd = newTime;
                                                  });
                                                },
                                                use24hFormat:
                                                    true, // Optionally, set to true for 24-hour format
                                                minuteInterval: 15,
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: FractionallySizedBox(
                widthFactor:
                    0.85, // Sets the width to 50% of the available width
                child: Divider(
                  color:
                      Color.fromARGB(255, 80, 78, 78), // Color of the divider
                  height:
                      1, // Space occupied by the divider, including the line and space above and below it
                  thickness: 0.5, // Thickness of the line
                ),
              ),
            ),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.95,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Center(
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  decoration: BoxDecoration(
                                    color: fridayColor,
                                    borderRadius: BorderRadius.circular(
                                        10), // Set the radius to 5
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.2,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      10), // Set the radius to 5
                                ),
                                child: Center(
                                  child: CupertinoButton(
                                    child: Text(
                                      formatTime(fridayStart),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext builder) {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .copyWith()
                                                      .size
                                                      .height /
                                                  3,
                                              color: Colors.white,
                                              child: CupertinoDatePicker(
                                                mode: CupertinoDatePickerMode
                                                    .time,
                                                initialDateTime: fridayStart,
                                                onDateTimeChanged:
                                                    (DateTime newTime) {
                                                  // Update the selectedTime variable when the user picks a new time
                                                  setState(() {
                                                    fridayStart = newTime;
                                                  });
                                                },
                                                use24hFormat:
                                                    true, // Optionally, set to true for 24-hour format
                                                minuteInterval: 15,
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                          color: fridayColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "FRIDAY",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  decoration: BoxDecoration(
                                    color: fridayColor,
                                    borderRadius: BorderRadius.circular(
                                        10), // Set the radius to 5
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.2,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      10), // Set the radius to 5
                                ),
                                child: Center(
                                  child: CupertinoButton(
                                    child: Text(
                                      formatTime(fridayEnd),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext builder) {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .copyWith()
                                                      .size
                                                      .height /
                                                  3,
                                              color: Colors.white,
                                              child: CupertinoDatePicker(
                                                mode: CupertinoDatePickerMode
                                                    .time,
                                                initialDateTime: fridayEnd,
                                                onDateTimeChanged:
                                                    (DateTime newTime) {
                                                  // Update the selectedTime variable when the user picks a new time
                                                  setState(() {
                                                    fridayEnd = newTime;
                                                  });
                                                },
                                                use24hFormat:
                                                    true, // Optionally, set to true for 24-hour format
                                                minuteInterval: 15,
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: FractionallySizedBox(
                widthFactor:
                    0.85, // Sets the width to 50% of the available width
                child: Divider(
                  color:
                      Color.fromARGB(255, 80, 78, 78), // Color of the divider
                  height:
                      1, // Space occupied by the divider, including the line and space above and below it
                  thickness: 0.5, // Thickness of the line
                ),
              ),
            ),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.95,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Center(
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  decoration: BoxDecoration(
                                    color: saturdayColor,
                                    borderRadius: BorderRadius.circular(
                                        10), // Set the radius to 5
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.2,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      10), // Set the radius to 5
                                ),
                                child: Center(
                                  child: CupertinoButton(
                                    child: Text(
                                      formatTime(saturdayStart),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext builder) {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .copyWith()
                                                      .size
                                                      .height /
                                                  3,
                                              color: Colors.white,
                                              child: CupertinoDatePicker(
                                                mode: CupertinoDatePickerMode
                                                    .time,
                                                initialDateTime: saturdayStart,
                                                onDateTimeChanged:
                                                    (DateTime newTime) {
                                                  // Update the selectedTime variable when the user picks a new time
                                                  setState(() {
                                                    saturdayStart = newTime;
                                                  });
                                                },
                                                use24hFormat:
                                                    true, // Optionally, set to true for 24-hour format
                                                minuteInterval: 15,
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                          color: saturdayColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "SATURDAY",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  decoration: BoxDecoration(
                                    color: saturdayColor,
                                    borderRadius: BorderRadius.circular(
                                        10), // Set the radius to 5
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.2,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      10), // Set the radius to 5
                                ),
                                child: Center(
                                  child: CupertinoButton(
                                    child: Text(
                                      formatTime(saturdayEnd),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext builder) {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .copyWith()
                                                      .size
                                                      .height /
                                                  3,
                                              color: Colors.white,
                                              child: CupertinoDatePicker(
                                                mode: CupertinoDatePickerMode
                                                    .time,
                                                initialDateTime: saturdayEnd,
                                                onDateTimeChanged:
                                                    (DateTime newTime) {
                                                  // Update the selectedTime variable when the user picks a new time
                                                  setState(() {
                                                    saturdayEnd = newTime;
                                                  });
                                                },
                                                use24hFormat:
                                                    true, // Optionally, set to true for 24-hour format
                                                minuteInterval: 15,
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: FractionallySizedBox(
                widthFactor:
                    0.85, // Sets the width to 50% of the available width
                child: Divider(
                  color:
                      Color.fromARGB(255, 80, 78, 78), // Color of the divider
                  height:
                      1, // Space occupied by the divider, including the line and space above and below it
                  thickness: 0.5, // Thickness of the line
                ),
              ),
            ),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.95,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Center(
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  decoration: BoxDecoration(
                                    color: sundayColor,
                                    borderRadius: BorderRadius.circular(
                                        10), // Set the radius to 5
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.2,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      10), // Set the radius to 5
                                ),
                                child: Center(
                                  child: CupertinoButton(
                                    child: Text(
                                      formatTime(sundayStart),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext builder) {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .copyWith()
                                                      .size
                                                      .height /
                                                  3,
                                              color: Colors.white,
                                              child: CupertinoDatePicker(
                                                mode: CupertinoDatePickerMode
                                                    .time,
                                                initialDateTime: sundayStart,
                                                onDateTimeChanged:
                                                    (DateTime newTime) {
                                                  // Update the selectedTime variable when the user picks a new time
                                                  setState(() {
                                                    sundayStart = newTime;
                                                  });
                                                },
                                                use24hFormat:
                                                    true, // Optionally, set to true for 24-hour format
                                                minuteInterval: 15,
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                          color: sundayColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "SUNDAY",
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Center(
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  decoration: BoxDecoration(
                                    color: sundayColor,
                                    borderRadius: BorderRadius.circular(
                                        10), // Set the radius to 5
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.2,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      10), // Set the radius to 5
                                ),
                                child: Center(
                                  child: CupertinoButton(
                                    child: Text(
                                      formatTime(sundayEnd),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext builder) {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .copyWith()
                                                      .size
                                                      .height /
                                                  3,
                                              color: Colors.white,
                                              child: CupertinoDatePicker(
                                                mode: CupertinoDatePickerMode
                                                    .time,
                                                initialDateTime: sundayEnd,
                                                onDateTimeChanged:
                                                    (DateTime newTime) {
                                                  // Update the selectedTime variable when the user picks a new time
                                                  setState(() {
                                                    sundayEnd = newTime;
                                                  });
                                                },
                                                use24hFormat:
                                                    true, // Optionally, set to true for 24-hour format
                                                minuteInterval: 15,
                                              ),
                                            );
                                          });
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: FractionallySizedBox(
                widthFactor:
                    0.85, // Sets the width to 50% of the available width
                child: Divider(
                  color:
                      Color.fromARGB(255, 80, 78, 78), // Color of the divider
                  height:
                      1, // Space occupied by the divider, including the line and space above and below it
                  thickness: 0.5, // Thickness of the line
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  onPressed: () {
                    if (checkTimesValid() == true) {
                      setTimes();
                      _saveTimes();
                      Navigator.of(context).pop();
                    } else {
                      displayInvalidTimesDialog(context);
                    }
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // No rounding
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.amber.shade200),
                  ),
                  child: Text(
                    "SET TIMES",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
