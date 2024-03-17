import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

class AddTaskPopUp extends StatefulWidget {
  const AddTaskPopUp({super.key});

  @override
  _AddTaskPopUpState createState() => _AddTaskPopUpState();
}

class _AddTaskPopUpState extends State<AddTaskPopUp> {
  final TextEditingController _nameFieldController =
      TextEditingController(text: '');

  int _selectedHours = 0;
  int _selectedMinutes = 0;

  final TextEditingController _addressLine1FieldController =
      TextEditingController(text: '');

  final TextEditingController _cityFieldController =
      TextEditingController(text: '');

  final TextEditingController _countyFieldController =
      TextEditingController(text: '');

  final TextEditingController _areaCodeFieldController =
      TextEditingController(text: '');

  final _hasLocationController = ValueNotifier<bool>(true);

  List<bool> isSelected = [true, false, false];

  int priority = 0;
  var colors = [
    const Color.fromARGB(255, 174, 228, 158),
    const Color.fromARGB(255, 240, 221, 152),
    const Color.fromARGB(255, 235, 124, 109)
  ];

  String _categoryValue = 'UNIVERSITY';
  var categories = [
    'UNIVERSITY',
    'WORK',
    'HEALTH',
    'SOCIAL',
    'FAMILY',
    'HOBBIES',
    'MISCELLANEOUS',
  ];

  String _priorTaskValue = '1';
  var priorTasks = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
  ];

  String _timeValue = 'AM';
  var timeValues = ['AM', 'PM'];

  bool hasLocation = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.89,
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
                                color:
                                    Colors.black, // Set your desired text color
                              ),
                            ),
                          ),
                          onPressed: () => showCupertinoModalPopup(
                              context: context,
                              builder: (_) => SizedBox(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
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
                                color:
                                    Colors.black, // Set your desired text color
                              ),
                            ),
                          ),
                          onPressed: () => showCupertinoModalPopup(
                              context: context,
                              builder: (_) => SizedBox(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
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
                    // Container(
                    //   height: MediaQuery.of(context).size.height * 0.045,
                    //   width: MediaQuery.of(context).size.width * 0.2,
                    //   decoration: BoxDecoration(
                    //     color: Color.fromARGB(255, 240, 240, 240),
                    //     borderRadius:
                    //         BorderRadius.circular(5), // Set the radius to 5
                    //   ),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       DropdownButton(
                    //         value: _timeValue,
                    //         items: timeValues.map((String item) {
                    //           return DropdownMenuItem(
                    //               value: item, child: Text(item));
                    //         }).toList(),
                    //         onChanged: (String? newValue) {
                    //           setState(() {
                    //             _timeValue = newValue!;
                    //           });
                    //         },
                    //         style: TextStyle(
                    //           fontSize: 15,
                    //           fontWeight: FontWeight.w400,
                    //           color: Colors.black,
                    //         ),
                    //         icon: const Icon(Icons.keyboard_arrow_down),
                    //         borderRadius: BorderRadius.circular(10),
                    //         underline: Container(),
                    //       ),
                    //     ],
                    //   ),
                    // ),
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
                    groupValue: priority,
                    thumbColor: colors[priority],
                    children: {
                      0: lowOption(),
                      1: mediumOption(),
                      2: highOption(),
                    },
                    onValueChanged: (value) {
                      setState(() {
                        if (value != null) {
                          priority = value;
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
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.045,
                      width: MediaQuery.of(context).size.width * 0.37,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 240, 240),
                        borderRadius: BorderRadius.circular(5),
                        // Adjust the radius as needed
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.045,
                      width: MediaQuery.of(context).size.width * 0.37,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.grey, // Border color
                          width: 1.5, // Border width
                        ), // Adjust the radius as needed
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DropdownButton(
                            value: _priorTaskValue,
                            items: priorTasks.map((String category) {
                              return DropdownMenuItem(
                                  value: category, child: Text(category));
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _priorTaskValue = newValue!;
                              });
                            },
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            borderRadius: BorderRadius.circular(10),
                            underline: Container(),
                          ),
                        ],
                      ),
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
                        inactiveColor: Color.fromARGB(255, 235, 124, 109),
                        activeChild: Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.05,
                          child: Image(
                            image: AssetImage('assets/images/home_icon.png'),
                          ),
                        ),
                        inactiveChild: Container(
                          height: MediaQuery.of(context).size.height * 0.055,
                          width: MediaQuery.of(context).size.width * 0.055,
                          child: Image(
                            image: AssetImage('assets/images/no_home_icon.png'),
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
                Center(
                    child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.045,
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 240, 240),
                        borderRadius: BorderRadius.circular(
                            5), // Adjust the radius as needed
                      ),
                      child: Transform.translate(
                        offset: Offset(
                            0, -2), // Adjust the vertical offset as needed
                        child: TextField(
                          controller: _addressLine1FieldController,
                          readOnly: !_hasLocationController.value,
                          decoration: InputDecoration(
                            hintText: "address line 1",
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.045,
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 240, 240),
                        borderRadius: BorderRadius.circular(
                            5), // Adjust the radius as needed
                      ),
                      child: Transform.translate(
                        offset: Offset(
                            0, -2), // Adjust the vertical offset as needed
                        child: TextField(
                          controller: _cityFieldController,
                          readOnly: !_hasLocationController.value,
                          decoration: InputDecoration(
                            hintText: "city",
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.045,
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 240, 240),
                        borderRadius: BorderRadius.circular(
                            5), // Adjust the radius as needed
                      ),
                      child: Transform.translate(
                        offset: Offset(
                            0, -2), // Adjust the vertical offset as needed
                        child: TextField(
                          controller: _countyFieldController,
                          readOnly: !_hasLocationController.value,
                          decoration: InputDecoration(
                            hintText: "county/state",
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.045,
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 240, 240, 240),
                        borderRadius: BorderRadius.circular(
                            5), // Adjust the radius as needed
                      ),
                      child: Transform.translate(
                        offset: Offset(
                            0, -2), // Adjust the vertical offset as needed
                        child: TextField(
                          controller: _areaCodeFieldController,
                          readOnly: !_hasLocationController.value,
                          decoration: InputDecoration(
                            hintText: "postcode/zipcode",
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
                    "CATEGORY",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.75,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 240, 240, 240),
                      borderRadius:
                          BorderRadius.circular(5), // Set the radius to 5
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DropdownButton(
                          value: _categoryValue,
                          items: categories.map((String category) {
                            return DropdownMenuItem(
                                value: category, child: Text(category));
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _categoryValue = newValue!;
                            });
                          },
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          borderRadius: BorderRadius.circular(10),
                          underline: Container(),
                        ),
                        // Spacer(),
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
    );
  }

  Widget lowOption() => Container(
        child: Text("LOW"),
      );
  Widget mediumOption() => Container(
        // color: Color.fromARGB(255, 226, 203, 126),
        child: Text("MEDIUM"),
      );
  Widget highOption() => Container(
        // color: const Color.fromARGB(255, 192, 124, 119),
        child: Text("HIGH"),
      );
}
