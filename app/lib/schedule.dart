import 'package:flutter/material.dart';
import 'navbar.dart';
import 'addTaskPopUp.dart';
import 'task.dart';
import 'taskWidget.dart';
import 'dart:convert';
import 'calendar.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

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
  // Task task1 = Task(1, "Attend Lecture on Quantum Physics", 2, 0, 2, [],
  //     "Lecture Hall", "51.503162", "-0.086852", 0);
  // Task task2 = Task(2, "gym - push day", 1, 30, 1, ["1"],
  //     "PureGym Waterloo, Brad Street, London, UK", "51.504159", "-0.109303", 2);
  // Task task3 = Task(3, "gym pull day", 2, 30, 2, ["2"],
  //     "PureGym Waterloo, Brad Street, London, UK", "51.504159", "-0.109303", 2);
  // Task task4 = Task(4, "clean room", 2, 30, 0, [],
  //     "Colwyn House, Hercules Road, London, UK", "51.496862", "-0.113041", 6);
  // Task task5 = Task(5, "sign contract", 4, 0, 1, [], "NO LOCATION", "51.503162",
  //     "-0.086852", 1);
  // Task task6 = Task(
  //     6, "plan party", 1, 0, 1, [], "NO LOCATION", "51.503162", "-0.086852", 2);
  // Task task7 = Task(7, "NSE coursework", 2, 0, 2, ["5"],
  //     "Bush House, Aldwych, London, UK", "51.513056", "-0.117351", 0);
  // Task task8 = Task(8, "piano practice", 1, 0, 0, [],
  //     "Colwyn House, Hercules Road, London, UK", "51.496862", "-0.113041", 5);
  // Task task12 = Task(12, "Morning Yoga", 1, 0, 2, [], "Local Park", "51.505501",
  //     "-0.075313", 3);
  // Task task13 = Task(
  //     13, "Team Meeting", 1, 30, 1, [], "Office", "51.514463", "-0.142571", 1);
  // Task task14 = Task(14, "Lunch with Colleagues", 1, 0, 0, [],
  //     "Italian Restaurant", "51.513569", "-0.137596", 4);
  // Task task15 = Task(15, "Client Presentation", 2, 0, 2, [], "Office",
  //     "51.514463", "-0.142571", 1);
  // Task task16 = Task(16, "Software Update", 1, 30, 1, ["13"], "Home Office",
  //     "51.502991", "-0.091623", 5);
  // Task task17 = Task(
  //     17, "Study Session", 3, 0, 0, [], "Library", "51.529999", "-0.127742", 5);
  // Task task18 = Task(18, "Video Editing", 4, 0, 1, [], "Home Studio",
  //     "51.506520", "-0.106450", 6);
  // Task task19 = Task(19, "Dinner Preparation", 1, 0, 0, [], "Home Kitchen",
  //     "51.507878", "-0.087732", 3);
  // Task task20 = Task(20, "Evening Walk", 1, 0, 2, [], "Riverside Path",
  //     "51.507350", "-0.081328", 4);
  // Task task21 = Task(21, "Journaling", 0, 30, 1, [], "Home Study", "51.509865",
  //     "-0.118092", 3);
  // Task task22 = Task(22, "Meditation", 0, 30, 0, [], "Quiet Room", "51.508530",
  //     "-0.076132", 2);
  // Task task23 = Task(23, "Write Blog Post", 2, 0, 1, [], "Cozy Cafe",
  //     "51.512281", "-0.123761", 4);
  // Task task24 = Task(24, "Prepare Presentation", 3, 0, 2, ["22"], "Office",
  //     "51.515617", "-0.141947", 1);
  // Task task25 = Task(25, "Yoga Class", 1, 30, 1, [], "Yoga Studio", "51.514447",
  //     "-0.075689", 3);
  // Task task26 = Task(26, "Read Research Papers", 2, 0, 0, [],
  //     "University Library", "51.523438", "-0.134699", 5);

  Task task1 = Task(1, "Attend Lecture on Quantum Physics", 2, 0, 2, [],
      "Lecture Hall", "51.503162", "-0.086852", 0);
  Task task2 = Task(2, "Prepare Sales Report", 3, 0, 2, [], "Office",
      "51.513056", "-0.117352", 1);
  Task task3 =
      Task(3, "Morning Jog", 1, 0, 2, [], "Local Park", "51.505", "-0.1205", 2);
  Task task4 = Task(4, "Meetup with Friends for Dinner", 4, 0, 1, [],
      "Restaurant", "51.51", "-0.11", 3);
  Task task5 = Task(
      5, "Family Picnic", 5, 0, 1, [], "Picnic Spot", "51.5035", "-0.086", 4);
  Task task6 = Task(
      6, "Painting Class", 2, 0, 1, ["5"], "Art Studio", "51.512", "-0.117", 5);
  Task task7 = Task(7, "Grocery Shopping", 1, 30, 1, [], "Supermarket",
      "51.509", "-0.114", 6);
  Task task8 = Task(8, "Study Group Session", 3, 0, 2, ["1"], "Library",
      "51.503162", "-0.086852", 0);
  Task task9 = Task(9, "Project Presentation", 2, 30, 1, ["2"],
      "Conference Room", "51.51", "-0.11", 1);
  Task task10 = Task(10, "Yoga Class", 1, 30, 1, ["5"], "Yoga Studio",
      "51.513056", "-0.117352", 2);
  Task task11 = Task(11, "Volunteer at Local Shelter", 3, 0, 2, [], "Shelter",
      "51.503162", "-0.086852", 3);
  Task task12 = Task(
      12, "Family Movie Night", 2, 0, 1, ["7"], "Home", "51.51", "-0.11", 4);
  Task task13 = Task(13, "Photography Walk", 2, 0, 1, ["8"], "City Park",
      "51.5035", "-0.086", 5);
  Task task14 = Task(14, "Home Renovation Project", 4, 0, 1, ["1"], "Home",
      "51.512", "-0.117", 5);
  Task task15 = Task(15, "Study for Final Exams", 4, 0, 2, ["1"], "Library",
      "51.51", "-0.11", 0);

  // self.task1 = Task("1", "Attend Lecture on Quantum Physics", timedelta(hours=2), 3, (), "Lecture Hall", (51.503162, -0.086852), 0)
  // self.task2 = Task("2", "Prepare Sales Report", timedelta(hours=3), 3, (), "Office", (51.513056, -0.117352), 1)
  // self.task3 = Task("3", "Morning Jog", timedelta(hours=1), 3, (), "Local Park", (51.505, -0.1205), 2)
  // self.task4 = Task("4", "Meetup with Friends for Dinner", timedelta(hours=4), 2, (), "Restaurant", (51.51, -0.11), 3)
  // self.task5 = Task("5", "Family Picnic", timedelta(hours=5), 2, (), "Picnic Spot", (51.5035, -0.086), 4)
  // self.task6 = Task("6", "Painting Class", timedelta(hours=2), 2, ("5",), "Art Studio", (51.512, -0.117),5)
  // self.task7 = Task("7", "Grocery Shopping", timedelta(hours=1.5), 2, (), "Supermarket", (51.509, -0.114), 6)
  // self.task8 = Task("8", "Study Group Session", timedelta(hours=3), 2, ("1",), "Library", (51.503162, -0.086852), 0)
  // self.task9 = Task("9", "Project Presentation", timedelta(hours=2.5), 1, ("2",), "Conference Room", (51.51, -0.11), 1)
  // self.task10 = Task("10", "Yoga Class", timedelta(hours=1.5), 1, ("5",), "Yoga Studio", (51.513056, -0.117352), 2)
  // self.task11 = Task("11", "Volunteer at Local Shelter", timedelta(hours=3), 2, (), "Shelter", (51.503162, -0.086852), 3)
  // self.task12 = Task("12", "Family Movie Night", timedelta(hours=2), 1, ("7",), "Home", (51.51, -0.11), 4)
  // self.task13 = Task("13", "Photography Walk", timedelta(hours=2), 1, ("8",), "City Park", (51.5035, -0.086), 5)
  // self.task14 = Task("14", "Home Renovation Project", timedelta(hours=4), 1, ("1",), "Home", (51.512, -0.117), 5)
  // self.task15 = Task("15", "Study for Final Exams", timedelta(hours=4), 2, ("1",), "Library", (51.51, -0.11), 0)

  List<Task> tasks = [];

  List<Map<String, dynamic>> getTaskAsJson() {
    List<Map<String, dynamic>> taskJsonList =
        tasks.map((task) => task.toJson()).toList();

    return taskJsonList;
  }

  void showServerUnresponsiveDialog(BuildContext context) {
    showCupertinoDialog<void>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text("Server Unresponsive"),
              content:
                  Text("The server is not responding. Please try again later."),
              actions: [
                CupertinoDialogAction(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ));
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

  toggleTasks() {
    setState(() {
      if (tasks.length != 0) {
        tasks.clear();
      } else {
        tasks.add(task1);
        tasks.add(task2);
        tasks.add(task3);
        tasks.add(task4);
        tasks.add(task5);
        tasks.add(task6);
        tasks.add(task7);
        tasks.add(task8);
        tasks.add(task12);
        tasks.add(task13);
        tasks.add(task14);
        tasks.add(task15);
      }
    });
  }

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
      tasks.add(task12);
      tasks.add(task13);
      tasks.add(task14);
      tasks.add(task15);
      // tasks.add(task16);
      // tasks.add(task17);
      // tasks.add(task18);
      // tasks.add(task19);
      // tasks.add(task20);
      // tasks.add(task21);
      // tasks.add(task22);
      // tasks.add(task23);
      // tasks.add(task24);
      // tasks.add(task25);
      // tasks.add(task26);
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

      for (var task in tasks) {
        print(task.name);
      }

      Map<String, dynamic> requestData = {
        "tasks": getTaskAsJson(),
        "times": dataModel.times,
        "preferences": dataModel.preferences
      };
      String jsonRequestData = jsonEncode(requestData);
      log(jsonRequestData);
      try {
        var response = await http
            .post(
              url,
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonRequestData,
            )
            .timeout(Duration(seconds: 45));

        if (response.statusCode == 200) {
          var responseData = jsonDecode(response.body);
          dataModel.updateAllocatedTasks(responseData);
          setState(() {
            isLoading = false;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Calendar()),
            );
          });
        } else {
          showServerUnresponsiveDialog(context);
          print('Error: ${response.statusCode}');
        }
      } on TimeoutException catch (_) {
        print("Timeout occurred");
        showServerUnresponsiveDialog(context);
        setState(() {
          isLoading = false;
        });
      } catch (e) {
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
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.24,
                            child: ElevatedButton(
                              onPressed: () {
                                toggleTasks();
                                // populateTasks();
                              },
                              child: Center(
                                child: Text(
                                  "EXAMPLE TASKS",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
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
                                        Color.fromARGB(255, 130, 216, 202)),
                              ),
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
