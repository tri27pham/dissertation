import 'package:flutter/material.dart';
import 'navbar.dart';
import 'calendarTile.dart';
import 'package:intl/intl.dart';

class DailySchedule extends StatefulWidget {
  const DailySchedule({super.key});
  @override
  _DailyScheduleState createState() => _DailyScheduleState();
}

class _DailyScheduleState extends State<DailySchedule> {
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
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Transform.translate(
                  offset: Offset(10, -15), // Adjust the offset as needed
                  child: Text(
                    "TUESDAY",
                    style: TextStyle(
                      fontSize: 60, // Change the font size here
                      color: Color.fromARGB(
                          255, 80, 78, 78), // Change the color of the text here
                      fontWeight: FontWeight.w400, // Make the text bold
                      letterSpacing: -2,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Transform.translate(
                  offset: Offset(0, -30), // Adjust the offset as needed
                  child: Text(
                    "27 NOVEMBER",
                    style: TextStyle(
                      fontSize: 20, // Change the font size here
                      color: Color.fromARGB(
                          255, 80, 78, 78), // Change the color of the text here
                      fontWeight: FontWeight.w500, // Make the text bold
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      drawer: NavBar(),
    );
  }
}
