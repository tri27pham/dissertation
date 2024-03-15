import 'package:flutter/material.dart';
// import 'addTasks.dart';
import 'package:intl/intl.dart';

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
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Color.fromARGB(255, 70, 70, 70),
          ),
          iconSize: 45,
          onPressed: () {
            // Add your search action here
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hello {name} message
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.02),
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
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: Offset(0, -20), // Adjust the offset as needed
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.06,
                        ),
                        child: Text(
                          date,
                          style: TextStyle(
                            fontSize: 85, // Change the font size here
                            color: Color.fromARGB(255, 80, 78,
                                78), // Change the color of the text here
                            fontWeight: FontWeight.w400, // Make the text bold
                            letterSpacing: -5,
                          ),
                        ),
                      ),
                    ),
                    // month
                    Transform.translate(
                      offset: Offset(0, -65), // Adjust the offset as needed
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.06,
                        ),
                        child: Text(
                          month,
                          style: TextStyle(
                            fontSize: 90, // Change the font size here
                            color: Color.fromARGB(255, 80, 78,
                                78), // Change the color of the text here
                            fontWeight: FontWeight.w400, // Make the text bold
                            letterSpacing: -5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
          // date
        ],
      ),
    );
  }
}
