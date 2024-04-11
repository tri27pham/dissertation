import 'package:flutter/material.dart';
import 'navbar.dart';
import 'calendarTile.dart';
import 'package:intl/intl.dart';
import 'package:task_allocation_app/allocatedTask.dart';
import 'dataModel.dart';
import 'package:provider/provider.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});
  @override
  _Calendar createState() => _Calendar();
}

class _Calendar extends State<Calendar> {
  late List<AllocatedTask> tasks;
  late List<AllocatedTask> day1Tasks;
  late List<AllocatedTask> day2Tasks;
  late List<AllocatedTask> day3Tasks;
  late List<AllocatedTask> day4Tasks;
  late List<AllocatedTask> day5Tasks;
  late List<AllocatedTask> day6Tasks;
  late List<AllocatedTask> day7Tasks;
  bool _isDataModelInitialized = false;

  void assignTasksToDays(DataModel dataModel) {
    day1Tasks = dataModel.getTasksDay(1);
    day2Tasks = dataModel.getTasksDay(2);
    day3Tasks = dataModel.getTasksDay(3);
    day4Tasks = dataModel.getTasksDay(4);
    day5Tasks = dataModel.getTasksDay(5);
    day6Tasks = dataModel.getTasksDay(6);
    day7Tasks = dataModel.getTasksDay(7);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataModelInitialized) {
      final dataModel = Provider.of<DataModel>(context);
      assignTasksToDays(dataModel);
      _isDataModelInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // var dataModel = Provider.of<DataModel>(context);
    // tasks = dataModel.tasks;
    // assignTasksToDays(dataModel);

    DateTime now = DateTime.now();

    String getWeekday(int weekdayNumber) {
      switch (weekdayNumber) {
        case 1:
          return 'MONDAY';
        case 2:
          return 'TUESDAY';
        case 3:
          return 'WEDNESDAY';
        case 4:
          return 'THURSDAY';
        case 5:
          return 'FRIDAY';
        case 6:
          return 'SATURDAY';
        case 7:
          return 'SUNDAY';
        default:
          return '';
      }
    }

    int weekday1Int = (now.add(Duration(days: 0))).weekday;
    String weekday1 = getWeekday(weekday1Int);
    int weekday2Int = (now.add(Duration(days: 1))).weekday;
    String weekday2 = getWeekday(weekday2Int);
    int weekday3Int = (now.add(Duration(days: 2))).weekday;
    String weekday3 = getWeekday(weekday3Int);
    int weekday4Int = (now.add(Duration(days: 3))).weekday;
    String weekday4 = getWeekday(weekday4Int);
    int weekday5Int = (now.add(Duration(days: 4))).weekday;
    String weekday5 = getWeekday(weekday5Int);
    int weekday6Int = (now.add(Duration(days: 5))).weekday;
    String weekday6 = getWeekday(weekday6Int);
    int weekday7Int = (now.add(Duration(days: 6))).weekday;
    String weekday7 = getWeekday(weekday7Int);

    String day1 = (now.add(Duration(days: 0))).day.toString();
    String day2 = (now.add(Duration(days: 1))).day.toString();
    String day3 = (now.add(Duration(days: 2))).day.toString();
    String day4 = (now.add(Duration(days: 3))).day.toString();
    String day5 = (now.add(Duration(days: 4))).day.toString();
    String day6 = (now.add(Duration(days: 5))).day.toString();
    String day7 = (now.add(Duration(days: 6))).day.toString();

    // String monthAbbreviationFromNumber(int monthNumber) {
    //   switch (monthNumber) {
    //     case 1:
    //       return 'JAN';
    //     case 2:
    //       return 'FEB';
    //     case 3:
    //       return 'MAR';
    //     case 4:
    //       return 'APR';
    //     case 5:
    //       return 'MAY';
    //     case 6:
    //       return 'JUN';
    //     case 7:
    //       return 'JUL';
    //     case 8:
    //       return 'AUG';
    //     case 9:
    //       return 'SEP';
    //     case 10:
    //       return 'OCT';
    //     case 11:
    //       return 'NOV';
    //     case 12:
    //       return 'DEC';
    //     default:
    //       return '';
    //   }
    // }

    String month1Long = (now.add(Duration(days: 0))).month.toString();
    // String month1 = monthAbbreviationFromNumber(int.parse(month1Long));
    int month1 = int.parse(month1Long);
    String month2Long = (now.add(Duration(days: 1))).month.toString();
    int month2 = int.parse(month2Long);
    // String month2 = monthAbbreviationFromNumber(int.parse(month2Long));
    String month3Long = (now.add(Duration(days: 2))).month.toString();
    int month3 = int.parse(month3Long);
    // String month3 = monthAbbreviationFromNumber(int.parse(month3Long));
    String month4Long = (now.add(Duration(days: 3))).month.toString();
    int month4 = int.parse(month4Long);
    // String month4 = monthAbbreviationFromNumber(int.parse(month4Long));
    String month5Long = (now.add(Duration(days: 4))).month.toString();
    int month5 = int.parse(month5Long);
    // String month5 = monthAbbreviationFromNumber(int.parse(month5Long));
    String month6Long = (now.add(Duration(days: 5))).month.toString();
    int month6 = int.parse(month6Long);
    // String month6 = monthAbbreviationFromNumber(int.parse(month6Long));
    String month7Long = (now.add(Duration(days: 6))).month.toString();
    int month7 = int.parse(month7Long);
    // String month7 = monthAbbreviationFromNumber(int.parse(month7Long));

    var color1 = Color.fromARGB(255, 236, 186, 139);
    var color2 = Color.fromARGB(255, 154, 205, 221);
    var color3 = Color.fromARGB(255, 187, 176, 192);
    var color4 = Color.fromARGB(255, 211, 158, 180);
    var color5 = Color.fromARGB(255, 175, 228, 201);
    var color6 = Color.fromARGB(255, 240, 255, 200);
    var color7 = Color.fromARGB(255, 196, 203, 240);

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
                      CalendarTile(
                          weekday: weekday1,
                          day: day1,
                          month: month1,
                          color: color1,
                          tasks: day1Tasks),
                      CalendarTile(
                          weekday: weekday2,
                          day: day2,
                          month: month2,
                          color: color2,
                          tasks: day2Tasks),
                      CalendarTile(
                          weekday: weekday3,
                          day: day3,
                          month: month3,
                          color: color3,
                          tasks: day3Tasks),
                      CalendarTile(
                          weekday: weekday4,
                          day: day4,
                          month: month4,
                          color: color4,
                          tasks: day4Tasks),
                      CalendarTile(
                          weekday: weekday5,
                          day: day5,
                          month: month5,
                          color: color5,
                          tasks: day5Tasks),
                      CalendarTile(
                          weekday: weekday6,
                          day: day6,
                          month: month6,
                          color: color6,
                          tasks: day6Tasks),
                      CalendarTile(
                          weekday: weekday7,
                          day: day7,
                          month: month7,
                          color: color7,
                          tasks: day7Tasks),
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


// import 'package:flutter/material.dart';
// import 'navbar.dart';
// import 'calendarTile.dart';
// import 'package:intl/intl.dart';
// import 'package:task_allocation_app/allocatedTask.dart';
// import 'dataModel.dart';
// import 'package:provider/provider.dart';

// class Calendar extends StatefulWidget {
//   const Calendar({super.key});
//   @override
//   _Calendar createState() => _Calendar();
// }

// class _Calendar extends State<Calendar> {
//   late List<AllocatedTask> tasks;
//   late List<AllocatedTask> day1Tasks;
//   late List<AllocatedTask> day2Tasks;
//   late List<AllocatedTask> day3Tasks;
//   late List<AllocatedTask> day4Tasks;
//   late List<AllocatedTask> day5Tasks;
//   late List<AllocatedTask> day6Tasks;
//   late List<AllocatedTask> day7Tasks;

//   void assignTasksToDays(DataModel dataModel) {
//     day1Tasks = dataModel.getTasksDay(1);
//     day2Tasks = dataModel.getTasksDay(2);
//     day3Tasks = dataModel.getTasksDay(3);
//     day4Tasks = dataModel.getTasksDay(4);
//     day5Tasks = dataModel.getTasksDay(5);
//     day6Tasks = dataModel.getTasksDay(6);
//     day7Tasks = dataModel.getTasksDay(7);
//   }

//  @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!_isDataModelInitialized) {
//       final dataModel = Provider.of<DataModel>(context);
//       assignTasksToDays(dataModel);
//       _isDataModelInitialized = true;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // var dataModel = Provider.of<DataModel>(context);
//     // tasks = dataModel.tasks;
//     // assignTasksToDays(dataModel);

//     DateTime now = DateTime.now();

//     String getWeekday(int weekdayNumber) {
//       switch (weekdayNumber) {
//         case 1:
//           return 'MONDAY';
//         case 2:
//           return 'TUESDAY';
//         case 3:
//           return 'WEDNESDAY';
//         case 4:
//           return 'THURSDAY';
//         case 5:
//           return 'FRIDAY';
//         case 6:
//           return 'SATURDAY';
//         case 7:
//           return 'SUNDAY';
//         default:
//           return '';
//       }
//     }

//     int weekday1Int = (now.add(Duration(days: 0))).weekday;
//     String weekday1 = getWeekday(weekday1Int);
//     int weekday2Int = (now.add(Duration(days: 1))).weekday;
//     String weekday2 = getWeekday(weekday2Int);
//     int weekday3Int = (now.add(Duration(days: 2))).weekday;
//     String weekday3 = getWeekday(weekday3Int);
//     int weekday4Int = (now.add(Duration(days: 3))).weekday;
//     String weekday4 = getWeekday(weekday4Int);
//     int weekday5Int = (now.add(Duration(days: 4))).weekday;
//     String weekday5 = getWeekday(weekday5Int);
//     int weekday6Int = (now.add(Duration(days: 5))).weekday;
//     String weekday6 = getWeekday(weekday6Int);
//     int weekday7Int = (now.add(Duration(days: 6))).weekday;
//     String weekday7 = getWeekday(weekday7Int);

//     String day1 = (now.add(Duration(days: 0))).day.toString();
//     String day2 = (now.add(Duration(days: 1))).day.toString();
//     String day3 = (now.add(Duration(days: 2))).day.toString();
//     String day4 = (now.add(Duration(days: 3))).day.toString();
//     String day5 = (now.add(Duration(days: 4))).day.toString();
//     String day6 = (now.add(Duration(days: 5))).day.toString();
//     String day7 = (now.add(Duration(days: 6))).day.toString();

//     // String monthAbbreviationFromNumber(int monthNumber) {
//     //   switch (monthNumber) {
//     //     case 1:
//     //       return 'JAN';
//     //     case 2:
//     //       return 'FEB';
//     //     case 3:
//     //       return 'MAR';
//     //     case 4:
//     //       return 'APR';
//     //     case 5:
//     //       return 'MAY';
//     //     case 6:
//     //       return 'JUN';
//     //     case 7:
//     //       return 'JUL';
//     //     case 8:
//     //       return 'AUG';
//     //     case 9:
//     //       return 'SEP';
//     //     case 10:
//     //       return 'OCT';
//     //     case 11:
//     //       return 'NOV';
//     //     case 12:
//     //       return 'DEC';
//     //     default:
//     //       return '';
//     //   }
//     // }

//     String month1Long = (now.add(Duration(days: 0))).month.toString();
//     // String month1 = monthAbbreviationFromNumber(int.parse(month1Long));
//     int month1 = int.parse(month1Long);
//     String month2Long = (now.add(Duration(days: 1))).month.toString();
//     int month2 = int.parse(month2Long);
//     // String month2 = monthAbbreviationFromNumber(int.parse(month2Long));
//     String month3Long = (now.add(Duration(days: 2))).month.toString();
//     int month3 = int.parse(month3Long);
//     // String month3 = monthAbbreviationFromNumber(int.parse(month3Long));
//     String month4Long = (now.add(Duration(days: 3))).month.toString();
//     int month4 = int.parse(month4Long);
//     // String month4 = monthAbbreviationFromNumber(int.parse(month4Long));
//     String month5Long = (now.add(Duration(days: 4))).month.toString();
//     int month5 = int.parse(month5Long);
//     // String month5 = monthAbbreviationFromNumber(int.parse(month5Long));
//     String month6Long = (now.add(Duration(days: 5))).month.toString();
//     int month6 = int.parse(month6Long);
//     // String month6 = monthAbbreviationFromNumber(int.parse(month6Long));
//     String month7Long = (now.add(Duration(days: 6))).month.toString();
//     int month7 = int.parse(month7Long);
//     // String month7 = monthAbbreviationFromNumber(int.parse(month7Long));

//     var color1 = Color.fromARGB(255, 236, 186, 139);
//     var color2 = Color.fromARGB(255, 154, 205, 221);
//     var color3 = Color.fromARGB(255, 187, 176, 192);
//     var color4 = Color.fromARGB(255, 211, 158, 180);
//     var color5 = Color.fromARGB(255, 175, 228, 201);
//     var color6 = Color.fromARGB(255, 240, 255, 200);
//     var color7 = Color.fromARGB(255, 196, 203, 240);

//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: MediaQuery.of(context).size.height * 0.08,
//         backgroundColor: Colors.transparent,
//         leading: Padding(
//           padding: const EdgeInsets.all(8.0), // Add padding to the leading icon
//           child: Builder(
//             builder: (context) => IconButton(
//               icon: Icon(Icons.menu),
//               iconSize: 45,
//               onPressed: () {
//                 print("MENU PRESSED");
//                 Scaffold.of(context).openDrawer();
//               },
//             ),
//           ),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Spacer(),
//           Container(
//             height: 0.88 * MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//               color: Colors.white, // Set the color of the container
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(40.0), // Radius for top-left corner
//                 topRight: Radius.circular(40.0), // Radius for top-right corner
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.02,
//                 ),
//                 Padding(
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
//                   child: Text(
//                     "CALENDAR",
//                     style: TextStyle(fontSize: 30),
//                   ),
//                 ),
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.75,
//                   child: ListView(
//                     children: [
//                       CalendarTile(
//                           weekday: weekday1,
//                           day: day1,
//                           month: month1,
//                           color: color1,
//                           tasks: day1Tasks),
//                       CalendarTile(
//                           weekday: weekday2,
//                           day: day2,
//                           month: month2,
//                           color: color2,
//                           tasks: day2Tasks),
//                       CalendarTile(
//                           weekday: weekday3,
//                           day: day3,
//                           month: month3,
//                           color: color3,
//                           tasks: day3Tasks),
//                       CalendarTile(
//                           weekday: weekday4,
//                           day: day4,
//                           month: month4,
//                           color: color4,
//                           tasks: day4Tasks),
//                       CalendarTile(
//                           weekday: weekday5,
//                           day: day5,
//                           month: month5,
//                           color: color5,
//                           tasks: day5Tasks),
//                       CalendarTile(
//                           weekday: weekday6,
//                           day: day6,
//                           month: month6,
//                           color: color6,
//                           tasks: day6Tasks),
//                       CalendarTile(
//                           weekday: weekday7,
//                           day: day7,
//                           month: month7,
//                           color: color7,
//                           tasks: day7Tasks),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       drawer: NavBar(),
//     );
//   }
// }
