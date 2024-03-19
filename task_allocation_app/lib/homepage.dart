import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'navbar.dart';
// import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Get the current date
    DateTime now = DateTime.now();

    // Get the weekday as an integer (where Monday is 1 and Sunday is 7)
    int weekday = now.weekday;

    // Convert the integer representation of the weekday to a string
    String weekdayString = '';

    switch (weekday) {
      case 1:
        weekdayString = 'MONDAY';
        break;
      case 2:
        weekdayString = 'TUESDAY';
        break;
      case 3:
        weekdayString = 'WEDNESDAY';
        break;
      case 4:
        weekdayString = 'THURSDAY';
        break;
      case 5:
        weekdayString = 'FRIDAY';
        break;
      case 6:
        weekdayString = 'SATURDAY';
        break;
      case 7:
        weekdayString = 'SUNDAY';
        break;
    }

    String date = DateFormat('dd.MM').format(now);
    String month = DateFormat.MMM().format(now).toUpperCase();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.12,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0), // Add padding to the leading icon
          child: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu,
                color: Color.fromARGB(255, 80, 78, 78),
              ),
              iconSize: 45,
              onPressed: () {
                print("MENU PRESSED");
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.all(8.0), // Add padding to the actions icon
            child: IconButton(
              icon: Icon(
                Icons.account_circle_rounded,
                color: Color.fromARGB(255, 70, 70, 70),
              ),
              iconSize: 70,
              onPressed: () {
                // Add your profile action here
                print('Hello, world!');
              },
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hello {name} message
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05),
            child: Text(
              'Hello Tri',
              style: TextStyle(
                fontSize: 55, // Change the font size here
                color: Color.fromARGB(
                    255, 77, 75, 75), // Change the color of the text here
                fontWeight: FontWeight.w400, // Make the text bold
              ),
            ),
          ),
          // weekday
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.06,
                vertical: 0),
            child: Text(
              weekdayString,
              style: TextStyle(
                fontSize: 20, // Change the font size here
                color: Color.fromARGB(
                    255, 80, 78, 78), // Change the color of the text here
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Transform.translate(
                          offset: Offset(0, 15), // Adjust the offset as needed
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.06,
                            ),
                            child: Text(
                              date,
                              style: TextStyle(
                                fontSize: 80, // Change the font size here
                                color: Color.fromARGB(255, 80, 78,
                                    78), // Change the color of the text here
                                fontWeight:
                                    FontWeight.w400, // Make the text bold
                                letterSpacing: -3,
                              ),
                            ),
                          ),
                        ),
                        // month
                        Transform.translate(
                          offset: Offset(0, -20), // Adjust the offset as needed
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.06,
                            ),
                            child: Text(
                              month,
                              style: TextStyle(
                                fontSize: 80, // Change the font size here
                                color: Color.fromARGB(255, 80, 78,
                                    78), // Change the color of the text here
                                fontWeight:
                                    FontWeight.w400, // Make the text bold
                                letterSpacing: -3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: VerticalDivider(
                    thickness: 1, // Set the thickness of the line
                    width: 1, // Set the width of the line
                    color: Colors.black, // Set the color of the line
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(top: 15),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                      40.0), // Adjust the top left corner radius
                  topRight: Radius.circular(
                      40.0), // Adjust the top right corner radius
                ),
              ),
              elevation: 10,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(25.0, 30.0, 25.0, 5.0),
                    child: Text(
                      "TODAY'S TASKS",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20, // Change the font size here
                        color: Color.fromARGB(255, 80, 78,
                            78), // Change the color of the text here
                        fontWeight: FontWeight.w500, // Make the text bold
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.37,
                    child: ListView(
                      children: [
                        UnconstrainedBox(
                            child: Container(
                          height: MediaQuery.of(context).size.height * 0.18,
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
                          height: MediaQuery.of(context).size.height * 0.18,
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
                          height: MediaQuery.of(context).size.height * 0.18,
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
                          height: MediaQuery.of(context).size.height * 0.18,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
      drawer: NavBar(),
    );
  }
}
