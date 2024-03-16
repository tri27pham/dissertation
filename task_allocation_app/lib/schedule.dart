import 'package:flutter/material.dart';
import 'navbar.dart';
import 'addTaskPopUp.dart';

class ScheduleTasks extends StatelessWidget {
  const ScheduleTasks({super.key});

  void displayAddTaskPopUp(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return AddTaskPopUp();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      displayAddTaskPopUp(context);
                    },
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
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                    border: Border.all(
                      color: Colors.grey.shade300, // Border color
                      width: 2, // Border width
                    ),
                  ),
                  child: ListView(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        // width: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100, // Set color to blue
                          borderRadius:
                              BorderRadius.circular(15), // Set rounded corners
                        ),
                        child: Center(
                          child: Text(
                            'R',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black, // Set text color to white
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        // width: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100, // Set color to blue
                          borderRadius:
                              BorderRadius.circular(15), // Set rounded corners
                        ),
                        child: Center(
                          child: Text(
                            'R',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black, // Set text color to white
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: ElevatedButton(
                    onPressed: () {},
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

  // void addTaskPopUp(context) {
  //   showAddTaskPopUp(context, build_context) {
  //     return Container(
  //       height: MediaQuery.of(context).size.height * 0.6,
  //       width: MediaQuery.of(context).size.width,
  //       child: Text("test"),
  //     );
  //   }
  // }
}
