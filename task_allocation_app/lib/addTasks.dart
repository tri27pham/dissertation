import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_allocation_app/viewTasks.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class AddTasksPage extends StatefulWidget {
  const AddTasksPage({super.key});

  @override
  State<AddTasksPage> createState() => _AddTasksPageState();
}

class _AddTasksPageState extends State<AddTasksPage> {
  String? selectedOption = 'MEDIUM';
  List<bool> inOutSelection = [true, false];

  String tokenForSession = '34512';

  var uuid = Uuid();

  List<dynamic> listForPlaces = [];

  final TextEditingController _controller = TextEditingController();

  void makeSuggestion(String input) async {
    String googlePlacesApiKey = 'AIzaSyBaLZBGSMsZppfhtF8lu0IGvJ7Wpfg5294';
    String groundURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$groundURL?input=$input&key=$googlePlacesApiKey&sessiontoken=$tokenForSession';

    var responseResult = await http.get(Uri.parse(request));

    var resultData = responseResult.body.toString();

    print('Result data: ' + resultData);

    if (responseResult.statusCode == 200) {
      setState(() {
        listForPlaces =
            jsonDecode(responseResult.body.toString())['predictions'];
      });
    } else {
      throw Exception('Showing data failed');
    }
  }

  void onModify() {
    if (tokenForSession == null) {
      setState(() {
        tokenForSession = uuid.v4();
      });
    }
    makeSuggestion(_controller.text);
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      onModify();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Add Tasks"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 0.07 * MediaQuery.of(context).size.height,
              width: 0.85 * MediaQuery.of(context).size.width,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Task Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 0.01 * MediaQuery.of(context).size.height),
            Container(
              height: 0.07 * MediaQuery.of(context).size.height,
              width: 0.85 * MediaQuery.of(context).size.width,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Duration',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 0.01 * MediaQuery.of(context).size.height),
            Container(
              height: 0.07 * MediaQuery.of(context).size.height,
              width: 0.85 * MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(2.0),
              ),
              child: Row(
                children: [
                  Text(
                    "Priority",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Spacer(),
                  DropdownButton<String>(
                    value: selectedOption,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedOption = newValue;
                      });
                    },
                    items: <String>[
                      'HIGH',
                      'MEDIUM',
                      'LOW',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 0.01 * MediaQuery.of(context).size.height),
            Container(
              height: 0.07 * MediaQuery.of(context).size.height,
              width: 0.85 * MediaQuery.of(context).size.width,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Tasks to be completed before',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 0.01 * MediaQuery.of(context).size.height),
            Container(
              height: 0.07 * MediaQuery.of(context).size.height,
              width: 0.85 * MediaQuery.of(context).size.width,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // Expanded(
            //   child: ListView.builder(
            //       itemCount: listForPlaces.length,
            //       itemBuilder: (context, index) {
            //         return ListTile(
            //           onTap: ()
            //           async {
            //             List
            //         });
            //       }),
            // ),
            SizedBox(height: 0.01 * MediaQuery.of(context).size.height),
            Container(
              height: 0.07 * MediaQuery.of(context).size.height,
              width: 0.85 * MediaQuery.of(context).size.width,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Task Category',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 0.01 * MediaQuery.of(context).size.height),
            Container(
              height: 0.07 * MediaQuery.of(context).size.height,
              width: 0.85 * MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(2.0),
              ),
              child: Row(
                children: [
                  Text(
                    "In / Out",
                    style: TextStyle(fontSize: 16.0), // Set font size
                  ),
                  Spacer(),
                  ToggleButtons(
                    isSelected: inOutSelection,
                    onPressed: (index) {
                      setState(() {
                        inOutSelection[index] = !inOutSelection[index];
                        inOutSelection[(index + 1) % 2] = false;
                        if (index == 0) {
                          print("Option 1 selected");
                        } else if (index == 1) {
                          print("Option 2 selected");
                        }
                      });
                    },
                    children: [
                      Container(
                        height: 0.05 * MediaQuery.of(context).size.height,
                        width: 0.25 * MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            "INDOOR",
                            style: TextStyle(fontSize: 14.0), // Set font size
                          ),
                        ),
                      ),
                      Container(
                        height: 0.05 * MediaQuery.of(context).size.height,
                        width: 0.25 * MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            "OUTDOOR",
                            style: TextStyle(fontSize: 14.0), // Set font size
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 0.02 * MediaQuery.of(context).size.height),
            Container(
              height: 0.07 * MediaQuery.of(context).size.height,
              width: 0.85 * MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  // add task to list
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewTasksPage()),
                  );
                },
                child: Text("ADD TASK"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
