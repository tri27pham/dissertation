import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    String formatTime(DateTime dateTime) {
      return DateFormat('HH:mm').format(dateTime);
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
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          // color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius:
                              BorderRadius.circular(10), // Set the radius to 5
                        ),
                        child: Center(
                          child: CupertinoButton(
                            child: Text(
                              formatTime(mondayStart),
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 80, 78, 78),
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
                                        mode: CupertinoDatePickerMode.time,
                                        initialDateTime: mondayStart,
                                        onDateTimeChanged: (DateTime newTime) {
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
                    Spacer(),
                    Text(
                      "MONDAY",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Spacer(),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          // color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius:
                              BorderRadius.circular(10), // Set the radius to 5
                        ),
                        child: Center(
                          child: CupertinoButton(
                            child: Text(
                              formatTime(mondayEnd),
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 80, 78, 78),
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
                                        mode: CupertinoDatePickerMode.time,
                                        initialDateTime: mondayEnd,
                                        onDateTimeChanged: (DateTime newTime) {
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
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          // color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius:
                              BorderRadius.circular(10), // Set the radius to 5
                        ),
                        child: Center(
                          child: CupertinoButton(
                            child: Text(
                              formatTime(tuesdayStart),
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 80, 78, 78),
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
                                        mode: CupertinoDatePickerMode.time,
                                        initialDateTime: tuesdayStart,
                                        onDateTimeChanged: (DateTime newTime) {
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
                    Spacer(),
                    Text(
                      "TUESDAY",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Spacer(),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          // color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius:
                              BorderRadius.circular(10), // Set the radius to 5
                        ),
                        child: Center(
                          child: CupertinoButton(
                            child: Text(
                              formatTime(tuesdayEnd),
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 80, 78, 78),
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
                                        mode: CupertinoDatePickerMode.time,
                                        initialDateTime: tuesdayEnd,
                                        onDateTimeChanged: (DateTime newTime) {
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
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          // color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius:
                              BorderRadius.circular(10), // Set the radius to 5
                        ),
                        child: Center(
                          child: CupertinoButton(
                            child: Text(
                              formatTime(wednesdayStart),
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 80, 78, 78),
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
                                        mode: CupertinoDatePickerMode.time,
                                        initialDateTime: wednesdayStart,
                                        onDateTimeChanged: (DateTime newTime) {
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
                    Spacer(),
                    Text(
                      "WEDNESDAY",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Spacer(),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          // color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius:
                              BorderRadius.circular(10), // Set the radius to 5
                        ),
                        child: Center(
                          child: CupertinoButton(
                            child: Text(
                              formatTime(wednesdayEnd),
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 80, 78, 78),
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
                                        mode: CupertinoDatePickerMode.time,
                                        initialDateTime: wednesdayEnd,
                                        onDateTimeChanged: (DateTime newTime) {
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
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          // color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius:
                              BorderRadius.circular(10), // Set the radius to 5
                        ),
                        child: Center(
                          child: CupertinoButton(
                            child: Text(
                              formatTime(thursdayStart),
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 80, 78, 78),
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
                                        mode: CupertinoDatePickerMode.time,
                                        initialDateTime: thursdayStart,
                                        onDateTimeChanged: (DateTime newTime) {
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
                    Spacer(),
                    Text(
                      "THURSDAY",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Spacer(),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          // color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius:
                              BorderRadius.circular(10), // Set the radius to 5
                        ),
                        child: Center(
                          child: CupertinoButton(
                            child: Text(
                              formatTime(thursdayEnd),
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 80, 78, 78),
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
                                        mode: CupertinoDatePickerMode.time,
                                        initialDateTime: thursdayEnd,
                                        onDateTimeChanged: (DateTime newTime) {
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
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          // color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius:
                              BorderRadius.circular(10), // Set the radius to 5
                        ),
                        child: Center(
                          child: CupertinoButton(
                            child: Text(
                              formatTime(fridayStart),
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 80, 78, 78),
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
                                        mode: CupertinoDatePickerMode.time,
                                        initialDateTime: fridayStart,
                                        onDateTimeChanged: (DateTime newTime) {
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
                    Spacer(),
                    Text(
                      "FRIDAY",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Spacer(),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          // color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius:
                              BorderRadius.circular(10), // Set the radius to 5
                        ),
                        child: Center(
                          child: CupertinoButton(
                            child: Text(
                              formatTime(fridayEnd),
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 80, 78, 78),
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
                                        mode: CupertinoDatePickerMode.time,
                                        initialDateTime: fridayEnd,
                                        onDateTimeChanged: (DateTime newTime) {
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
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          // color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius:
                              BorderRadius.circular(10), // Set the radius to 5
                        ),
                        child: Center(
                          child: CupertinoButton(
                            child: Text(
                              formatTime(saturdayStart),
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 80, 78, 78),
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
                                        mode: CupertinoDatePickerMode.time,
                                        initialDateTime: saturdayStart,
                                        onDateTimeChanged: (DateTime newTime) {
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
                    Spacer(),
                    Text(
                      "SATURDAY",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Spacer(),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          // color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius:
                              BorderRadius.circular(10), // Set the radius to 5
                        ),
                        child: Center(
                          child: CupertinoButton(
                            child: Text(
                              formatTime(saturdayEnd),
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 80, 78, 78),
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
                                        mode: CupertinoDatePickerMode.time,
                                        initialDateTime: saturdayEnd,
                                        onDateTimeChanged: (DateTime newTime) {
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
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          // color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius:
                              BorderRadius.circular(10), // Set the radius to 5
                        ),
                        child: Center(
                          child: CupertinoButton(
                            child: Text(
                              formatTime(sundayStart),
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 80, 78, 78),
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
                                        mode: CupertinoDatePickerMode.time,
                                        initialDateTime: sundayStart,
                                        onDateTimeChanged: (DateTime newTime) {
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
                    Spacer(),
                    Text(
                      "SUNDAY",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    Spacer(),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          // color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius:
                              BorderRadius.circular(10), // Set the radius to 5
                        ),
                        child: Center(
                          child: CupertinoButton(
                            child: Text(
                              formatTime(sundayEnd),
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 80, 78, 78),
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
                                        mode: CupertinoDatePickerMode.time,
                                        initialDateTime: sundayEnd,
                                        onDateTimeChanged: (DateTime newTime) {
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
                  onPressed: () {},
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
