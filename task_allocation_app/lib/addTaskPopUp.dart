import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'task.dart';
import 'locationSearch.dart';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';

class PriorTask {
  final Task task;
  bool selected;
  PriorTask(this.task, this.selected);
}

class AddTaskPopUp extends StatefulWidget {
  final List<Task> tasks;

  AddTaskPopUp({required this.tasks});

  @override
  _AddTaskPopUpState createState() => _AddTaskPopUpState();
}

class _AddTaskPopUpState extends State<AddTaskPopUp> {
  final TextEditingController _nameFieldController =
      TextEditingController(text: '');

  int _selectedHours = 0;
  int _selectedMinutes = 0;

  final _hasLocationController = ValueNotifier<bool>(true);

  List<bool> isSelected = [true, false, false];

  int _priority = 0;
  var colors = [
    const Color.fromARGB(255, 174, 228, 158),
    const Color.fromARGB(255, 240, 221, 152),
    const Color.fromARGB(255, 235, 124, 109)
  ];

  int _categoryValue = 0;
  var categories = [
    'UNIVERSITY',
    'WORK',
    'HEALTH',
    'SOCIAL',
    'FAMILY',
    'HOBBIES',
    'MISCELLANEOUS',
  ];

  bool hasLocation = true;

  int getNewTaskID() {
    if (widget.tasks.isEmpty) {
      return 1;
    } else {
      List<int> taskIDs = widget.tasks.map((task) => task.taskID).toList();
      int maxTaskID =
          taskIDs.reduce((value, element) => value > element ? value : element);
      return maxTaskID + 1;
    }
  }

  bool checkInputs() {
    if (_nameFieldController.text.isEmpty) {
      showCupertinoDialog<void>(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text("BLANK NAME"),
                content: Text("Give your task a name!"),
                actions: [
                  CupertinoDialogAction(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ));
      return false;
    }
    if (_selectedHours == 0 && _selectedMinutes == 0) {
      showCupertinoDialog<void>(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text("NO DURATION"),
                content: Text("How long will your task take?"),
                actions: [
                  CupertinoDialogAction(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ));
      return false;
    }
    if (_hasLocationController.value && _locationController.text.isEmpty) {
      showCupertinoDialog<void>(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text("NO LOCATION"),
                content: Text(
                    "Give your task a location! (or select no location option)"),
                actions: [
                  CupertinoDialogAction(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ));
      return false;
    }
    return true;
  }

  Task createNewTask() {
    List<String> priorTasksIDs = [];
    for (var priorTask in selectedPriorTasks) {
      if (priorTask.selected) {
        priorTasksIDs.add(priorTask.task.taskID.toString());
      }
    }
    String locationName = "";
    if (!_hasLocationController.value) {
      longitude = "0";
      latitude = "0";
      locationName = "NO LOCATION";
    } else {
      locationName = _locationController.text;
    }

    Task newTask = Task(
        getNewTaskID(),
        _nameFieldController.text,
        _selectedHours,
        _selectedMinutes,
        _priority,
        priorTasksIDs,
        locationName,
        longitude,
        latitude,
        _categoryValue,
        categories[_categoryValue]);
    newTask.printValues();
    return newTask;
  }

  final TextEditingController _locationController = TextEditingController();

  String latitude = "";
  String longitude = "";

  String sessionToken = '89025';

  var uuid = Uuid();

  List<dynamic> places = [];

  bool _viewPriorTasks = false;

  void makeSuggestion(String input) async {
    String apiKey = 'AIzaSyBaLZBGSMsZppfhtF8lu0IGvJ7Wpfg5294';
    String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$url?input=$input&key=$apiKey&sessiontoken=$sessionToken';

    var response = await http.get(Uri.parse(request));

    var responseData = response.body.toString();

    // print(responseData);

    if (response.statusCode == 200) {
      setState(() {
        places = jsonDecode(responseData)['predictions'];
      });
    } else {
      throw Exception('FAILED');
    }
  }

  void onModify() {
    if (_locationController.text.isEmpty) {
      setState(() {
        places.clear(); // Empty the places list
      });
      return; // Exit the method early if the controller is empty
    }
    if (sessionToken == null) {
      setState(() {
        sessionToken = uuid.v4();
      });
    }
    makeSuggestion(_locationController.text);
  }

  void updateSelectedPriorTasks() {
    selectedPriorTasks.clear();
    for (var priorTask in priorTasks) {
      if (priorTask.selected) {
        selectedPriorTasks.add(priorTask);
      }
    }
  }

  late List<PriorTask> priorTasks;
  late List<PriorTask> selectedPriorTasks;

  @override
  void initState() {
    super.initState();

    if (widget.tasks.isNotEmpty) {
      List<PriorTask> tasks = [];
      for (var task in widget.tasks) {
        tasks.add(PriorTask(task, false));
      }
      priorTasks = tasks;
    } else {
      priorTasks = [];
    }
    selectedPriorTasks = [];

    _locationController.addListener(() {
      onModify();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Remove focus from any text fields
        setState(() {
          places.clear();
          _viewPriorTasks = false;
        });
        // HiddenButtonContainerState().toggleButtonVisibility();
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.77,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 248, 248, 248),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                "ADD TASK",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Text(
                      "NAME",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Center(
                    child: Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.045,
                        width: MediaQuery.of(context).size.width * 0.75,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius:
                              BorderRadius.circular(5), // Set the radius to 5
                        ),
                        child: Transform.translate(
                          offset: Offset(
                              0, -2), // Adjust the vertical offset as needed
                          child: TextField(
                            controller: _nameFieldController,
                            decoration: InputDecoration(
                              hintText: "enter task name",
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: const Color.fromARGB(255, 196, 196, 196),
                                fontWeight: FontWeight.w300,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Text(
                      "DURATION",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.2,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius:
                              BorderRadius.circular(5), // Set the radius to 5
                        ),
                        child: CupertinoButton(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '$_selectedHours',
                                style: TextStyle(
                                  fontSize: 18, // Set your desired font size
                                  fontWeight: FontWeight.w400,
                                  color: Colors
                                      .black, // Set your desired text color
                                ),
                              ),
                            ),
                            onPressed: () => showCupertinoModalPopup(
                                context: context,
                                builder: (_) => SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: CupertinoPicker(
                                      backgroundColor: Colors.white,
                                      itemExtent: 30,
                                      scrollController:
                                          FixedExtentScrollController(
                                        initialItem: 0,
                                      ),
                                      children: const [
                                        Text('0'),
                                        Text('1'),
                                        Text('2'),
                                        Text('3'),
                                        Text('4'),
                                        Text('5'),
                                        Text('6'),
                                        Text('7'),
                                        Text('8'),
                                        Text('9'),
                                        Text('10'),
                                        Text('11'),
                                        Text('12'),
                                        Text('13'),
                                        Text('14'),
                                        Text('15'),
                                        Text('16'),
                                        Text('17'),
                                        Text('18'),
                                        Text('19'),
                                        Text('20'),
                                        Text('21'),
                                        Text('22'),
                                        Text('23'),
                                      ],
                                      onSelectedItemChanged: (int value) {
                                        setState(() {
                                          _selectedHours = value;
                                        });
                                      },
                                    )))),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius:
                              BorderRadius.circular(5), // Set the radius to 5
                        ),
                        child: Center(
                          child: Text(
                            "h",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Text(
                        ':',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.2,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius:
                              BorderRadius.circular(5), // Set the radius to 5
                        ),
                        child: CupertinoButton(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '$_selectedMinutes',
                                style: TextStyle(
                                  fontSize: 18, // Set your desired font size
                                  fontWeight: FontWeight.w400,
                                  color: Colors
                                      .black, // Set your desired text color
                                ),
                              ),
                            ),
                            onPressed: () => showCupertinoModalPopup(
                                context: context,
                                builder: (_) => SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: CupertinoPicker(
                                      backgroundColor: Colors.white,
                                      itemExtent: 30,
                                      scrollController:
                                          FixedExtentScrollController(
                                        initialItem: 0,
                                      ),
                                      children: const [
                                        Text('0'),
                                        Text('5'),
                                        Text('10'),
                                        Text('15'),
                                        Text('20'),
                                        Text('25'),
                                        Text('30'),
                                        Text('35'),
                                        Text('40'),
                                        Text('45'),
                                        Text('50'),
                                        Text('55'),
                                      ],
                                      onSelectedItemChanged: (int value) {
                                        setState(() {
                                          _selectedMinutes = value * 5;
                                        });
                                      },
                                    )))),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius:
                              BorderRadius.circular(5), // Set the radius to 5
                        ),
                        child: Center(
                          child: Text(
                            "m",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                    ],
                  )),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Text(
                      "PRIORITY",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Center(
                    child: CupertinoSlidingSegmentedControl<int>(
                      groupValue: _priority,
                      thumbColor: colors[_priority],
                      children: {
                        0: priorityOption("LOW"),
                        1: priorityOption("MEDIUM"),
                        2: priorityOption("HIGH"),
                      },
                      onValueChanged: (value) {
                        setState(() {
                          if (value != null) {
                            _priority = value;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Text(
                      "PRIOR TASKS",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Center(
                      child: Container(
                    height: MediaQuery.of(context).size.height * 0.045,
                    width: MediaQuery.of(context).size.width * 0.75,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 240, 240, 240),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 85,
                          child: Row(
                            children: [
                              Expanded(
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: selectedPriorTasks.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(5, 0, 0, 0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03,
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Text(
                                                    selectedPriorTasks[index]
                                                        .task
                                                        .name,
                                                  ),
                                                ),
                                              ],
                                            ));
                                      }))
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 15,
                          child: IconButton(
                            icon: Icon(
                              CupertinoIcons.add_circled_solid,
                              size: 20,
                              color: priorTasks.isNotEmpty
                                  ? Color.fromARGB(255, 44, 44, 44)
                                  : Color.fromARGB(255, 173, 173, 173),
                            ),
                            onPressed: () {
                              if (priorTasks.isNotEmpty) {
                                setState(() {
                                  _viewPriorTasks = !_viewPriorTasks;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Stack(
              children: [
                if (_viewPriorTasks)
                  Center(
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.115,
                        width: MediaQuery.of(context).size.width * 0.75,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 240, 240, 240),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Scrollbar(
                          child: ListView.builder(
                            itemCount: priorTasks.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                child: CheckboxListTile(
                                  title: Text(priorTasks[index].task.name),
                                  value: priorTasks[index].selected,
                                  onChanged: (newValue) {
                                    setState(() {
                                      priorTasks[index].selected = newValue!;
                                      updateSelectedPriorTasks();
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        )),
                  )
                else
                  Container(
                    // color: Color.fromARGB(255, 240, 240, 240),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "ADDRESS",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Spacer(),
                              Text("LOCATION"),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.01,
                              ),
                              AdvancedSwitch(
                                controller: _hasLocationController,
                                initialValue: _hasLocationController.value,
                                activeColor: Color.fromARGB(255, 174, 228, 158),
                                inactiveColor:
                                    Color.fromARGB(255, 235, 124, 109),
                                activeChild: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/home_icon.png'),
                                  ),
                                ),
                                inactiveChild: Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.055,
                                  width:
                                      MediaQuery.of(context).size.width * 0.055,
                                  child: Image(
                                    image: AssetImage(
                                        'assets/images/no_home_icon.png'),
                                  ),
                                ),
                                borderRadius:
                                    BorderRadius.all(const Radius.circular(15)),
                                width: 55.0,
                                height: 25.0,
                                // enabled: true,
                                disabledOpacity: 0.5,
                                onChanged: (newValue) {
                                  setState(() {
                                    _hasLocationController.value = newValue;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        LocationSearchBar(),
                      ],
                    ),
                  ),
              ],
            ),
            Stack(
              children: [
                if (places.length == 0)
                  Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                child: Text(
                                  "CATEGORY",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 240, 240, 240),
                                    borderRadius: BorderRadius.circular(
                                        5), // Set the radius to 5
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      DropdownButton<int>(
                                        value: _categoryValue,
                                        items: categories
                                            .asMap()
                                            .entries
                                            .map((MapEntry<int, String> entry) {
                                          return DropdownMenuItem<int>(
                                            value: entry.key,
                                            child: Text(entry.value),
                                          );
                                        }).toList(),
                                        onChanged: (int? newValue) {
                                          setState(() {
                                            if (newValue != null) {
                                              _categoryValue = newValue;
                                            }
                                          });
                                        },
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        borderRadius: BorderRadius.circular(10),
                                        underline: Container(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: ElevatedButton(
                              onPressed: () {
                                if (checkInputs()) {
                                  Task newTask = createNewTask();
                                  Navigator.pop(context, newTask);
                                } else {
                                  // prompt user that they need to fill in fields
                                }
                              },
                              style: ButtonStyle(
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // No rounding
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.amber.shade200),
                              ),
                              child: Text(
                                "ADD TASK",
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
                LocationSearchResults(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget priorityOption(String text) => Container(
        child: Text(text),
      );

  Widget LocationSearchBar() => Material(
      color: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.width * 0.9,
        // color: Color.fromARGB(0, 199, 88, 88),
        child: Center(
            child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 240, 240, 240),
                  borderRadius:
                      BorderRadius.circular(5), // Adjust the radius as needed
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 85,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Transform.translate(
                          offset: Offset(0, 4),
                          child: TextFormField(
                            controller: _locationController,
                            enabled: _hasLocationController.value,
                            decoration: InputDecoration(
                              hintText: _hasLocationController.value
                                  ? "enter location"
                                  : "no location",
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 207, 207, 207),
                                  fontWeight: FontWeight.w300),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 15,
                        child: _hasLocationController.value
                            ? Icon(
                                CupertinoIcons.location_fill,
                                size: 20,
                              )
                            : Container()),
                  ],
                ))),
      ));

  Widget LocationSearchResults() {
    if (places.isEmpty) {
      return Container();
    } else {
      return Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width * 0.75,
          child: ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height *
                      0.05, // Specify the desired height
                  width: MediaQuery.of(context).size.width, // Use full width
                  child: ListTile(
                    onTap: () async {
                      List<Location> locations = await locationFromAddress(
                          places[index]['description']);
                      latitude = locations.last.latitude.toString();
                      longitude = locations.last.longitude.toString();
                      setState(() {
                        _locationController.text = places[index]['description'];
                      });
                      setState(() {
                        places.clear(); // Clear the places list
                      });
                      print(places.length);
                    },
                    title: Text(places[index]['description']),
                  ),
                );
              }),
        ),
      );
    }
  }
}
