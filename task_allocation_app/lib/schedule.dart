import 'package:flutter/material.dart';
import 'navbar.dart';
import 'addTaskPopUp.dart';
import 'task.dart';
import 'taskWidget.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';
import 'dataModel.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'dart:developer';

class ScheduleTasks extends StatefulWidget {
  ScheduleTasks({super.key});

  @override
  _ScheduleTasksState createState() => _ScheduleTasksState();
}

class _ScheduleTasksState extends State<ScheduleTasks> {
  Task task1 = Task(1, "Dissertation", 2, 0, 2, [], "NO LOCATION", "0", "0", 0);
  Task task2 = Task(2, "gym - push day", 1, 30, 1, ["1"],
      "PureGym Waterloo, Brad Street, London, UK", "-0.109303", "51.504159", 2);
  Task task3 = Task(3, "gym pull day", 1, 30, 2, ["2"],
      "PureGym Waterloo, Brad Street, London, UK", "-0.109303", "51.504159", 2);
  Task task4 = Task(4, "clean room", 1, 0, 0, [],
      "Colwyn House, Hercules Road, London, UK", "-0.113041", "51.496862", 6);
  Task task5 =
      Task(5, "sign contract", 1, 0, 1, [], "NO LOCATION", "0", "0", 1);
  Task task6 = Task(6, "plan party", 1, 0, 1, [], "NO LOCATION", "0", "0", 2);
  Task task7 = Task(7, "NSE coursework", 2, 0, 2, [],
      "Bush House, Aldwych, London, UK", "-0.117351", "51.513056", 0);
  Task task8 = Task(8, "piano practice", 1, 0, 0, [],
      "Colwyn House, Hercules Road, London, UK", "-0.113041", "51.496862", 5);

  List<Task> tasks = [];

  List<Map<String, dynamic>> getTaskAsJson() {
    List<Map<String, dynamic>> taskJsonList =
        tasks.map((task) => task.toJson()).toList();

    return taskJsonList;
  }

  void displayAddTaskPopUp(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return AddTaskPopUp(tasks: tasks);
      },
    ).then((newTask) {
      if (newTask != null) {
        setState(() {
          tasks.add(newTask);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    tasks.add(task1);
    tasks.add(task2);
    tasks.add(task3);
    tasks.add(task4);
    tasks.add(task5);
    tasks.add(task6);
    tasks.add(task7);
    tasks.add(task8);
  }

  @override
  Widget build(BuildContext context) {
    var dataModel = Provider.of<DataModel>(context);

    var url = Uri.parse('http://10.0.2.2:5000/data_endpoint');

    Future<void> sendDataToAPI() async {
      Map<String, dynamic> requestData = {
        "tasks": getTaskAsJson(),
        "times": dataModel.times,
        "preferences": dataModel.preferences
      };
      String jsonRequestData = jsonEncode(requestData);
      // log(jsonRequestData);
      try {
        var response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonRequestData,
        );

        if (response.statusCode == 200) {
          // If the server returns a 200 OK response
          var responseData =
              jsonDecode(response.body); // Convert response body to JSON
          // Process responseData as needed
          log(responseData);
          print('Data sent successfully!');
        } else {
          // If the server returns an error response
          print('Error: ${response.statusCode}');
          print(response.body); // Print error message received from the server
        }
      } catch (e) {
        // If an error occurs during the HTTP request
        print('Error: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0), // Add padding to the leading icon
          child: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              iconSize: 45,
              onPressed: () {
                print("MENU PRESSED");
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Spacer(),
          Container(
            height: 0.88 * MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white, // Set the color of the container
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0), // Radius for top-left corner
                topRight: Radius.circular(40.0), // Radius for top-right corner
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "TASKS",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ElevatedButton(
                    onPressed: () {
                      // print("length of tasks: " + tasks.length.toString());
                      displayAddTaskPopUp(context);
                    },
                    child: Text(
                      "ADD TASK",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10), // No rounding
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.amber.shade200),
                    ),
                  ),
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                      border: Border.all(
                        color: Colors.grey.shade300, // Border color
                        width: 2, // Border width
                      ),
                    ),
                    child: Scrollbar(
                      child: ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (content, index) {
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: 3),
                              child: TaskWidget(task: tasks[index]),
                            );
                          }),

                      // child: ListView(
                      //   children: [
                      //     TaskWidget(),
                      //   ],
                      // ),
                    )),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: ElevatedButton(
                    onPressed: () {
                      sendDataToAPI();
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15), // No rounding
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.amber.shade200),
                    ),
                    child: Text(
                      "CREATE SCHEDULE",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: NavBar(),
    );
  }
}
