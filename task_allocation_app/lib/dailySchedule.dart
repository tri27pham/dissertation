import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'navbar.dart';
import 'calendarTile.dart';
import 'package:intl/intl.dart';
import 'package:task_allocation_app/allocatedTask.dart';

class DailySchedule extends StatefulWidget {
  final String weekday;
  final String day;
  final int month;
  final List<AllocatedTask> tasks;

  DailySchedule(
      {required this.weekday,
      required this.day,
      required this.month,
      required this.tasks});

  @override
  _DailyScheduleState createState() => _DailyScheduleState();
}

class _DailyScheduleState extends State<DailySchedule> {
  String monthFromNum(int monthNumber) {
    switch (monthNumber) {
      case 1:
        return 'JANUARY';
      case 2:
        return 'FEBRUARY';
      case 3:
        return 'MARCH';
      case 4:
        return 'APRIL';
      case 5:
        return 'MAY';
      case 6:
        return 'JUNE';
      case 7:
        return 'JULY';
      case 8:
        return 'AUGUST';
      case 9:
        return 'SEPTEMBER';
      case 10:
        return 'OCTOBER';
      case 11:
        return 'NOVEMBER';
      case 12:
        return 'DECEMBER';
      default:
        return '';
    }
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
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Transform.translate(
                  offset: Offset(0, -10), // Adjust the offset as needed
                  child: IconButton(
                    icon: Icon(
                      CupertinoIcons.arrow_left_circle_fill,
                      size: 45,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -10), // Adjust the offset as needed
                  child: IconButton(
                    icon: Icon(
                      CupertinoIcons.arrow_left_circle_fill,
                      size: 45,
                    ),
                    onPressed: () {
                      widget.tasks.forEach((element) {
                        print(element.name);
                      });
                    },
                  ),
                ),
                Spacer(),
                Transform.translate(
                  offset: Offset(10, -15), // Adjust the offset as needed
                  child: Text(
                    widget.weekday,
                    style: TextStyle(
                      fontSize: 50, // Change the font size here
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
            // height: MediaQuery.of(context).size.height * 0.02,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Transform.translate(
                  offset: Offset(0, -30), // Adjust the offset as needed
                  child: Text(
                    "${widget.day} ${monthFromNum(widget.month)}",
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
          Stack(
            children: [
              ListOfTimesWidget(),
              ListOfTasksWidget(),
            ],
          )
        ],
      ),
      drawer: NavBar(),
    );
  }

  Widget ListOfTasksWidget() {
    return Column(
      children: [
        Container(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.25, 25, 0, 0),
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * 0.95,
            child: ListView.builder(
              itemCount: 10, // Number of containers in the list
              itemBuilder: (context, index) {
                return Padding(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        'Container $index',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ));
              },
            )),
      ],
    );
  }

  Widget ListOfTimesWidget() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.73,
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 24, // 24 hours * 4 quarters per hour
              itemBuilder: (context, index) {
                return CustomTimeStamp(
                  timestamp: _generateTimeStamp(index),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  String _generateTimeStamp(int index) {
    // Generate timestamps for every hour
    DateTime now = DateTime.now();
    DateTime timestamp = DateTime(now.year, now.month, now.day, index);
    String formattedTime =
        '${timestamp.hour % 12 == 0 ? 12 : timestamp.hour % 12} ${timestamp.hour < 12 ? 'AM' : 'PM'}';
    return formattedTime;
  }
}

class CustomTimeStamp extends StatelessWidget {
  final String timestamp;

  const CustomTimeStamp({Key? key, required this.timestamp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
          width: MediaQuery.of(context).size.width * 0.15,
          child: Text(
            timestamp, // Your timestamp text
            style: TextStyle(fontSize: 16.0, letterSpacing: -1),
          ),
        ),
        Stack(
          children: [
            Container(
              width: 4, // Width of the vertical bar
              height: 70, // Height of the vertical bar
              color:
                  Color.fromARGB(255, 80, 78, 78), // Color of the vertical bar
              margin: EdgeInsets.symmetric(horizontal: 16.0),
            ),
            Positioned(
              top:
                  28, // Adjust this value to position the dot in the middle of the line
              left:
                  12, // Adjust this value to position the dot at the desired distance from the line
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 80, 78, 78),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
