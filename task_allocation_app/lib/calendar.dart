import 'package:flutter/material.dart';
import 'navbar.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

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
                topRight: Radius.circular(40.0), // Radius for top-right corner
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  child: Text(
                    "CALENDAR",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: ListView(
                    children: [
                      UnconstrainedBox(
                          child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 236, 186,
                              139), // Set the color of the container
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      UnconstrainedBox(
                          child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 154, 205,
                              221), // Set the color of the container
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      UnconstrainedBox(
                          child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 187, 176,
                              192), // Set the color of the container
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      UnconstrainedBox(
                          child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 211, 158,
                              180), // Set the color of the container
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      UnconstrainedBox(
                          child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 175, 228,
                              201), // Set the color of the container
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      UnconstrainedBox(
                          child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 240, 255,
                              200), // Set the color of the container
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      UnconstrainedBox(
                          child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 196, 203,
                              240), // Set the color of the container
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      )),
                    ],
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
