import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'dataModel.dart';

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

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('universityDay', _universityDay);
    await prefs.setInt('universityWeek', _universityWeek);

    await prefs.setInt('workDay', _workDay);
    await prefs.setInt('workWeek', _workWeek);

    await prefs.setInt('healthDay', _healthDay);
    await prefs.setInt('healthWeek', _healthWeek);

    await prefs.setInt('socialDay', _socialDay);
    await prefs.setInt('socialWeek', _socialWeek);

    await prefs.setInt('familyDay', _familyDay);
    await prefs.setInt('familyWeek', _familyWeek);

    await prefs.setInt('hobbiesDay', _hobbiesDay);
    await prefs.setInt('hobbiesWeek', _hobbiesWeek);

    await prefs.setInt('miscellaneousDay', _miscellaneousDay);
    await prefs.setInt('miscellaneousWeek', _miscellaneousWeek);
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _universityDay = prefs.getInt('universityDay') ?? 0;
      _universityWeek = prefs.getInt('universityWeek') ?? 0;

      _workDay = prefs.getInt('workDay') ?? 0;
      _workWeek = prefs.getInt('workWeek') ?? 0;

      _healthDay = prefs.getInt('healthDay') ?? 0;
      _healthWeek = prefs.getInt('healthWeek') ?? 0;

      _socialDay = prefs.getInt('socialDay') ?? 0;
      _socialWeek = prefs.getInt('socialWeek') ?? 0;

      _familyDay = prefs.getInt('familyDay') ?? 0;
      _familyWeek = prefs.getInt('familyWeek') ?? 0;

      _hobbiesDay = prefs.getInt('hobbiesDay') ?? 0;
      _hobbiesWeek = prefs.getInt('hobbiesWeek') ?? 0;

      _miscellaneousDay = prefs.getInt('miscellaneousDay') ?? 0;
      _miscellaneousWeek = prefs.getInt('miscellaneousWeek') ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    var dataModel = Provider.of<DataModel>(context);

    void setPreferences() {
      bool universityMorning = false;
      bool universityEvening = false;
      bool universityStartOfWeek = false;
      bool universityEndOfWeek = false;

      bool workMorning = false;
      bool workEvening = false;
      bool workStartOfWeek = false;
      bool workEndOfWeek = false;

      bool healthMorning = false;
      bool healthEvening = false;
      bool healthStartOfWeek = false;
      bool healthEndOfWeek = false;

      bool socialMorning = false;
      bool socialEvening = false;
      bool socialStartOfWeek = false;
      bool socialEndOfWeek = false;

      bool familyMorning = false;
      bool familyEvening = false;
      bool familyStartOfWeek = false;
      bool familyEndOfWeek = false;

      bool hobbiesMorning = false;
      bool hobbiesEvening = false;
      bool hobbiesStartOfWeek = false;
      bool hobbiesEndOfWeek = false;

      bool miscellaneousMorning = false;
      bool miscellaneousEvening = false;
      bool miscellaneousStartOfWeek = false;
      bool miscellaneousEndOfWeek = false;

      if (_universityDay == 0) {
        universityMorning = true;
      } else {
        universityEvening = true;
      }
      if (_universityWeek == 0) {
        universityStartOfWeek = true;
      } else {
        universityEndOfWeek = true;
      }

      if (_workDay == 0) {
        workMorning = true;
      } else {
        workEvening = true;
      }
      if (_workWeek == 0) {
        workStartOfWeek = true;
      } else {
        workEndOfWeek = true;
      }

      if (_healthDay == 0) {
        healthMorning = true;
      } else {
        healthEvening = true;
      }
      if (_healthWeek == 0) {
        healthStartOfWeek = true;
      } else {
        healthEndOfWeek = true;
      }

      if (_socialDay == 0) {
        socialMorning = true;
      } else {
        socialEvening = true;
      }
      if (_socialWeek == 0) {
        socialStartOfWeek = true;
      } else {
        socialEndOfWeek = true;
      }

      if (_familyDay == 0) {
        familyMorning = true;
      } else {
        familyEvening = true;
      }
      if (_familyWeek == 0) {
        familyStartOfWeek = true;
      } else {
        familyEndOfWeek = true;
      }

      if (_hobbiesDay == 0) {
        hobbiesMorning = true;
      } else {
        hobbiesEvening = true;
      }
      if (_hobbiesWeek == 0) {
        hobbiesStartOfWeek = true;
      } else {
        hobbiesEndOfWeek = true;
      }

      if (_miscellaneousDay == 0) {
        miscellaneousMorning = true;
      } else {
        miscellaneousEvening = true;
      }
      if (_miscellaneousWeek == 0) {
        miscellaneousStartOfWeek = true;
      } else {
        miscellaneousEndOfWeek = true;
      }

      if (_universityDay == 0) {}
      Map<String, dynamic> preferences = {
        'university': {
          'morning': universityMorning,
          'evening': universityEvening,
          'startOfWeek': universityStartOfWeek,
          'endOfWeek': universityEndOfWeek,
        },
        'work': {
          'morning': workMorning,
          'evening': workEvening,
          'startOfWeek': workStartOfWeek,
          'endOfWeek': workEndOfWeek,
        },
        'health': {
          'morning': healthMorning,
          'evening': healthEvening,
          'startOfWeek': healthStartOfWeek,
          'endOfWeek': healthEndOfWeek,
        },
        'social': {
          'morning': socialMorning,
          'evening': socialEvening,
          'startOfWeek': socialStartOfWeek,
          'endOfWeek': socialEndOfWeek,
        },
        'family': {
          'morning': familyMorning,
          'evening': familyEvening,
          'startOfWeek': familyStartOfWeek,
          'endOfWeek': familyEndOfWeek,
        },
        'hobbies': {
          'morning': hobbiesMorning,
          'evening': hobbiesEvening,
          'startOfWeek': hobbiesStartOfWeek,
          'endOfWeek': hobbiesEndOfWeek,
        },
        'miscellaneous': {
          'morning': miscellaneousMorning,
          'evening': miscellaneousEvening,
          'startOfWeek': miscellaneousStartOfWeek,
          'endOfWeek': miscellaneousEndOfWeek,
        },
      };

      // Convert the structured map to a JSON string
      String jsonPreferences = jsonEncode(preferences);

      dataModel.updatePreferences(jsonPreferences);

      // Print the JSON string
      // print(jsonPreferences);
    }

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
                    _savePreferences();
                    Navigator.pop(context);
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
