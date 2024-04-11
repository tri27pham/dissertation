import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'navbar.dart';
import 'editNamePopUp.dart';
import 'editTimesPopUp.dart';
import 'editPreferencesPopUp.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  void displayEditNamePopUp(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return EditName();
      },
    );
  }

  void displayEditTimesPopUp(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return EditTimes();
      },
    );
  }

  void displayEditPreferencesPopUp(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        return EditPreferences();
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacer(),
          Container(
              height: 0.88 * MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white, // Set the color of the container
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0), // Radius for top-left corner
                  topRight:
                      Radius.circular(40.0), // Radius for top-right corner
                ),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: Text(
                        "SETTINGS",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    Center(
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextButton(
                              onPressed: () {
                                displayEditNamePopUp(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, // Space out the row elements
                                mainAxisSize: MainAxisSize
                                    .min, // Minimize the row size to wrap its content
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Icon(CupertinoIcons.profile_circled,
                                        size: 30,
                                        color: Color.fromARGB(255, 80, 78,
                                            78)), // Icon on the far left
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Text('Name',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 80, 78, 78),
                                          fontSize: 20,
                                        )),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Icon(Icons.arrow_forward,
                                        color: Color.fromARGB(255, 80, 78,
                                            78)), // Icon on the far right)
                                  )
                                  // Text in the middle
                                ],
                              ),
                            ))),
                    Center(
                      child: FractionallySizedBox(
                        widthFactor:
                            0.85, // Sets the width to 50% of the available width
                        child: Divider(
                          color: Color.fromARGB(
                              255, 80, 78, 78), // Color of the divider
                          height:
                              15, // Space occupied by the divider, including the line and space above and below it
                          thickness: 0.5, // Thickness of the line
                        ),
                      ),
                    ),
                    Center(
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextButton(
                              onPressed: () {
                                displayEditTimesPopUp(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, // Space out the row elements
                                mainAxisSize: MainAxisSize
                                    .min, // Minimize the row size to wrap its content
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Icon(CupertinoIcons.clock_solid,
                                        size: 30,
                                        color: Color.fromARGB(255, 80, 78,
                                            78)), // Icon on the far left
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Text('Times',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 80, 78, 78),
                                          fontSize: 20,
                                        )),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Icon(Icons.arrow_forward,
                                        color: Color.fromARGB(255, 80, 78,
                                            78)), // Icon on the far right)
                                  )
                                  // Text in the middle
                                ],
                              ),
                            ))),
                    Center(
                      child: FractionallySizedBox(
                        widthFactor:
                            0.85, // Sets the width to 50% of the available width
                        child: Divider(
                          color: Color.fromARGB(
                              255, 80, 78, 78), // Color of the divider
                          height:
                              15, // Space occupied by the divider, including the line and space above and below it
                          thickness: 0.5, // Thickness of the line
                        ),
                      ),
                    ),
                    Center(
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: TextButton(
                              onPressed: () {
                                displayEditPreferencesPopUp(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, // Space out the row elements
                                mainAxisSize: MainAxisSize
                                    .min, // Minimize the row size to wrap its content
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Icon(CupertinoIcons.suit_heart_fill,
                                        size: 30,
                                        color: Color.fromARGB(255, 80, 78,
                                            78)), // Icon on the far left
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Text('Preferences',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 80, 78, 78),
                                          fontSize: 20,
                                        )),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Icon(Icons.arrow_forward,
                                        color: Color.fromARGB(255, 80, 78,
                                            78)), // Icon on the far right)
                                  )
                                  // Text in the middle
                                ],
                              ),
                            ))),
                    Center(
                      child: FractionallySizedBox(
                        widthFactor:
                            0.85, // Sets the width to 50% of the available width
                        child: Divider(
                          color: Color.fromARGB(
                              255, 80, 78, 78), // Color of the divider
                          height:
                              15, // Space occupied by the divider, including the line and space above and below it
                          thickness: 0.5, // Thickness of the line
                        ),
                      ),
                    ),
                  ]))
        ],
      ),
      drawer: NavBar(),
    );
  }
}
