import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class EditPreferences extends StatefulWidget {
  const EditPreferences({super.key});

  @override
  State<EditPreferences> createState() => _EditPreferencesState();
}

class _EditPreferencesState extends State<EditPreferences> {
  int _universityDay = 0;
  int _universityWeek = 0;
  var universityColor = Color.fromARGB(255, 255, 232, 202);

  int _workDay = 0;
  int _workWeek = 0;
  var workColor = Color.fromARGB(255, 195, 225, 255);

  int _healthDay = 0;
  int _healthWeek = 0;
  var healthColor = Color.fromARGB(255, 237, 210, 255);

  int _socialDay = 0;
  int _socialWeek = 0;
  var socialColor = Color.fromARGB(255, 255, 214, 243);

  int _familyDay = 0;
  int _familyWeek = 0;
  var familyColor = Color.fromARGB(255, 255, 207, 207);

  int _hobbiesDay = 0;
  int _hobbiesWeek = 0;
  var hobbiesColor = Color.fromARGB(255, 204, 255, 214);

  int _miscellaneousDay = 0;
  int _miscellaneousWeek = 0;
  var miscellaneousColor = Color.fromARGB(255, 255, 251, 200);

  void setPreferences() {
    Map<String, dynamic> preferences = {
      'university': {
        'day': _universityDay,
        'week': _universityWeek,
      },
      'work': {
        'day': _workDay,
        'week': _workWeek,
      },
      'health': {
        'day': _healthDay,
        'week': _healthWeek,
      },
      'social': {
        'day': _socialDay,
        'week': _socialWeek,
      },
      'family': {
        'day': _familyDay,
        'week': _familyWeek,
      },
      'hobbies': {
        'day': _hobbiesDay,
        'week': _hobbiesWeek,
      },
      'miscellaneous': {
        'day': _miscellaneousDay,
        'week': _miscellaneousWeek,
      },
    };

    // Convert the structured map to a JSON string
    String jsonPreferences = jsonEncode(preferences);

    // Print the JSON string
    print(jsonPreferences);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.88,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
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
                "EDIT PREFERENCES",
                style: TextStyle(
                    fontSize: 30, color: Color.fromARGB(255, 80, 78, 78)),
              ),
            ),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.67,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(
                        255, 205, 205, 205), // Color of the border
                    width: 1.0, // Thickness of the border
                  ),
                  borderRadius:
                      BorderRadius.circular(4), // Optional: add a border radius
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView(
                    padding: EdgeInsets.only(right: 5.0),
                    children: [
                      Center(
                        child: Container(
                          // height: MediaQuery.of(context).size.height * 0.16,
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  "UNIVERSITY",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 80, 78, 78),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  children: [
                                    dayWidget(),
                                    Center(
                                      child:
                                          CupertinoSlidingSegmentedControl<int>(
                                        groupValue: _universityDay,
                                        backgroundColor: universityColor,
                                        thumbColor: Colors.white,
                                        children: {
                                          0: _startOptionWidget(),
                                          1: _endOptionWidget()
                                        },
                                        onValueChanged: (value) {
                                          setState(() {
                                            if (value != null) {
                                              _universityDay = value;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  children: [
                                    weekWidget(),
                                    Center(
                                      child:
                                          CupertinoSlidingSegmentedControl<int>(
                                        groupValue: _universityWeek,
                                        backgroundColor: universityColor,
                                        thumbColor: Colors.white,
                                        children: {
                                          0: _startOptionWidget(),
                                          1: _endOptionWidget()
                                        },
                                        onValueChanged: (value) {
                                          setState(() {
                                            if (value != null) {
                                              _universityWeek = value;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          // height: MediaQuery.of(context).size.height * 0.16,
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  "WORK",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 80, 78, 78),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  children: [
                                    dayWidget(),
                                    Center(
                                      child:
                                          CupertinoSlidingSegmentedControl<int>(
                                        groupValue: _workDay,
                                        backgroundColor: workColor,
                                        thumbColor: Colors.white,
                                        children: {
                                          0: _startOptionWidget(),
                                          1: _endOptionWidget()
                                        },
                                        onValueChanged: (value) {
                                          setState(() {
                                            if (value != null) {
                                              _workDay = value;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  children: [
                                    weekWidget(),
                                    Center(
                                      child:
                                          CupertinoSlidingSegmentedControl<int>(
                                        groupValue: _workWeek,
                                        backgroundColor: workColor,
                                        thumbColor: Colors.white,
                                        children: {
                                          0: _startOptionWidget(),
                                          1: _endOptionWidget()
                                        },
                                        onValueChanged: (value) {
                                          setState(() {
                                            if (value != null) {
                                              _workWeek = value;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          // height: MediaQuery.of(context).size.height * 0.16,
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  "HEALTH",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 80, 78, 78),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  children: [
                                    dayWidget(),
                                    Center(
                                      child:
                                          CupertinoSlidingSegmentedControl<int>(
                                        groupValue: _healthDay,
                                        backgroundColor: healthColor,
                                        thumbColor: Colors.white,
                                        children: {
                                          0: _startOptionWidget(),
                                          1: _endOptionWidget()
                                        },
                                        onValueChanged: (value) {
                                          setState(() {
                                            if (value != null) {
                                              _healthDay = value;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  children: [
                                    weekWidget(),
                                    Center(
                                      child:
                                          CupertinoSlidingSegmentedControl<int>(
                                        groupValue: _healthWeek,
                                        backgroundColor: healthColor,
                                        thumbColor: Colors.white,
                                        children: {
                                          0: _startOptionWidget(),
                                          1: _endOptionWidget()
                                        },
                                        onValueChanged: (value) {
                                          setState(() {
                                            if (value != null) {
                                              _healthWeek = value;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          // height: MediaQuery.of(context).size.height * 0.16,
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  "SOCIAL",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 80, 78, 78),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  children: [
                                    dayWidget(),
                                    Center(
                                      child:
                                          CupertinoSlidingSegmentedControl<int>(
                                        groupValue: _socialDay,
                                        backgroundColor: socialColor,
                                        thumbColor: Colors.white,
                                        children: {
                                          0: _startOptionWidget(),
                                          1: _endOptionWidget()
                                        },
                                        onValueChanged: (value) {
                                          setState(() {
                                            if (value != null) {
                                              _socialDay = value;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  children: [
                                    weekWidget(),
                                    Center(
                                      child:
                                          CupertinoSlidingSegmentedControl<int>(
                                        groupValue: _socialWeek,
                                        backgroundColor: socialColor,
                                        thumbColor: Colors.white,
                                        children: {
                                          0: _startOptionWidget(),
                                          1: _endOptionWidget()
                                        },
                                        onValueChanged: (value) {
                                          setState(() {
                                            if (value != null) {
                                              _socialWeek = value;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          // height: MediaQuery.of(context).size.height * 0.16,
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  "FAMILY",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 80, 78, 78),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  children: [
                                    dayWidget(),
                                    Center(
                                      child:
                                          CupertinoSlidingSegmentedControl<int>(
                                        groupValue: _familyDay,
                                        backgroundColor: familyColor,
                                        thumbColor: Colors.white,
                                        children: {
                                          0: _startOptionWidget(),
                                          1: _endOptionWidget()
                                        },
                                        onValueChanged: (value) {
                                          setState(() {
                                            if (value != null) {
                                              _familyDay = value;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  children: [
                                    weekWidget(),
                                    Center(
                                      child:
                                          CupertinoSlidingSegmentedControl<int>(
                                        groupValue: _familyWeek,
                                        backgroundColor: familyColor,
                                        thumbColor: Colors.white,
                                        children: {
                                          0: _startOptionWidget(),
                                          1: _endOptionWidget()
                                        },
                                        onValueChanged: (value) {
                                          setState(() {
                                            if (value != null) {
                                              _familyWeek = value;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          // height: MediaQuery.of(context).size.height * 0.16,
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  "HOBBIES",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 80, 78, 78),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  children: [
                                    dayWidget(),
                                    Center(
                                      child:
                                          CupertinoSlidingSegmentedControl<int>(
                                        groupValue: _hobbiesDay,
                                        backgroundColor: hobbiesColor,
                                        thumbColor: Colors.white,
                                        children: {
                                          0: _startOptionWidget(),
                                          1: _endOptionWidget()
                                        },
                                        onValueChanged: (value) {
                                          setState(() {
                                            if (value != null) {
                                              _hobbiesDay = value;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  children: [
                                    weekWidget(),
                                    Center(
                                      child:
                                          CupertinoSlidingSegmentedControl<int>(
                                        groupValue: _hobbiesWeek,
                                        backgroundColor: hobbiesColor,
                                        thumbColor: Colors.white,
                                        children: {
                                          0: _startOptionWidget(),
                                          1: _endOptionWidget()
                                        },
                                        onValueChanged: (value) {
                                          setState(() {
                                            if (value != null) {
                                              _hobbiesWeek = value;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          // height: MediaQuery.of(context).size.height * 0.16,
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  "MISCELLANEOUS",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 80, 78, 78),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  children: [
                                    dayWidget(),
                                    Center(
                                      child:
                                          CupertinoSlidingSegmentedControl<int>(
                                        groupValue: _miscellaneousDay,
                                        backgroundColor: miscellaneousColor,
                                        thumbColor: Colors.white,
                                        children: {
                                          0: _startOptionWidget(),
                                          1: _endOptionWidget()
                                        },
                                        onValueChanged: (value) {
                                          setState(() {
                                            if (value != null) {
                                              _miscellaneousDay = value;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 3),
                                child: Row(
                                  children: [
                                    weekWidget(),
                                    Center(
                                      child:
                                          CupertinoSlidingSegmentedControl<int>(
                                        groupValue: _miscellaneousWeek,
                                        backgroundColor: miscellaneousColor,
                                        thumbColor: Colors.white,
                                        children: {
                                          0: _startOptionWidget(),
                                          1: _endOptionWidget()
                                        },
                                        onValueChanged: (value) {
                                          setState(() {
                                            if (value != null) {
                                              _miscellaneousWeek = value;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
                    setPreferences();
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

  Widget dayWidget() {
    return Expanded(
        flex: 1,
        child: Center(
          child: Text(
            "DAY:",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ));
  }

  Widget weekWidget() {
    return Expanded(
        flex: 1,
        child: Center(
          child: Text(
            "WEEK:",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 80, 78, 78)),
          ),
        ));
  }

  Widget _startOptionWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 35, vertical: 0), // Specify your padding here
      child: Text(
        "START",
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 80, 78, 78)),
      ),
    );
  }

  Widget _endOptionWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 35, vertical: 0), // Specify your padding here
      child: Text(
        "END",
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 80, 78, 78)),
      ),
    );
  }
}
