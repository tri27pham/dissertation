import 'package:flutter/material.dart';
import 'navbar.dart';
import 'addTaskPopUp.dart';
import 'task.dart';
import 'taskWidget.dart';
import 'dart:convert';
import 'calendar.dart';
import 'package:flutter/cupertino.dart';

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
  Task task1 = Task(1, "Dissertation", 4, 0, 2, [], "NO LOCATION", "0", "0", 0);
  Task task2 = Task(2, "gym - push day", 1, 30, 1, ["1"],
      "PureGym Waterloo, Brad Street, London, UK", "-0.109303", "51.504159", 2);
  Task task3 = Task(3, "gym pull day", 2, 30, 2, ["2"],
      "PureGym Waterloo, Brad Street, London, UK", "-0.109303", "51.504159", 2);
  Task task4 = Task(4, "clean room", 2, 30, 0, [],
      "Colwyn House, Hercules Road, London, UK", "-0.113041", "51.496862", 6);
  Task task5 =
      Task(5, "sign contract", 4, 0, 1, [], "NO LOCATION", "0", "0", 1);
  Task task6 = Task(6, "plan party", 1, 0, 1, [], "NO LOCATION", "0", "0", 2);
  Task task7 = Task(7, "NSE coursework", 2, 0, 2, ["5"],
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

  bool isLoading = false;

  void populateTasks() {
    setState(() {
      tasks.add(task1);
      tasks.add(task2);
      tasks.add(task3);
      tasks.add(task4);
      tasks.add(task5);
      tasks.add(task6);
      tasks.add(task7);
      tasks.add(task8);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void showMissingTasksDialog() {
      showCupertinoDialog<void>(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text("NO TASKS"),
                content: Text("Add some tasks!"),
                actions: [
                  CupertinoDialogAction(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ));
    }

    void showMissingTimesPreferencesDialog() {
      showCupertinoDialog<void>(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: Text("MISSING TIMES / PREFERENCES"),
                content: Text("Set your times and preferences in settings"),
                actions: [
                  CupertinoDialogAction(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ));
    }

    var dataModel = Provider.of<DataModel>(context);

    var url = Uri.parse('http://10.0.2.2:5000/data_endpoint');

    Future<void> sendDataToAPI() async {
      setState(() {
        isLoading = true; // Set loading state to true
      });

      Map<String, dynamic> requestData = {
        "tasks": getTaskAsJson(),
        "times": dataModel.times,
        "preferences": dataModel.preferences
      };
      String jsonRequestData = jsonEncode(requestData);
      log(jsonRequestData);
      try {
        var response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonRequestData,
        );

        if (response.statusCode == 200) {
          var responseData = jsonDecode(response.body);
          // log(responseData);
          dataModel.updateAllocatedTasks(responseData);
        } else {
          print('Error: ${response.statusCode}');
          print(response.body);
        }
      } catch (e) {
        print('Error: $e');
      } finally {
        setState(() {
          isLoading =
              false; // Set loading state to false after response is received
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Calendar()),
          );
        });
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
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "TASKS",
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.07,
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: ElevatedButton(
                                onPressed: () {
                                  populateTasks();
                                },
                                child: Text(
                                  "EXAMPLE \n TASKS",
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              )),
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
                            ),
                          ),
                        ],
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
                            if (tasks.length == 0) {
                              showMissingTasksDialog();
                            } else if (dataModel.times == "" ||
                                dataModel.preferences == "") {
                              showMissingTimesPreferencesDialog();
                            } else {
                              sendDataToAPI();
                            }
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
