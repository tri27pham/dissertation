import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_allocation_app/taskWidget.dart';
import 'navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dailySchedule.dart';
import 'allocatedTask.dart';
import 'package:provider/provider.dart';
import 'dataModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = "";

  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    final nameStr = prefs.getString('name') ?? '';
    setState(() {
      name = nameStr;
    });
  }

  late List<AllocatedTask> tasks;
  bool _isDataModelInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadName(); // Continue to load the name as it doesn't depend on context
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure this block runs only once to avoid reinitialization
    if (!_isDataModelInitialized) {
      // Accessing the DataModel via Provider now that context is available
      final dataModel = Provider.of<DataModel>(context);
      tasks = dataModel.getTasksDay(1); // Example function call to get tasks
      _isDataModelInitialized = true; // Set the flag to true to avoid reruns
    }
  }

  Color getCategoryColor(int category) {
    switch (category) {
      case 1:
        return Color.fromARGB(255, 236, 186, 139);
      case 2:
        return Color.fromARGB(255, 154, 205, 221);
      case 3:
        return Color.fromARGB(255, 187, 176, 192);
      case 4:
        return Color.fromARGB(255, 211, 158, 180);
      case 5:
        return Color.fromARGB(255, 175, 228, 201);
      case 6:
        return Color.fromARGB(255, 240, 255, 200);
      case 7:
        return Color.fromARGB(255, 196, 203, 240);
      default:
        return Color.fromARGB(255, 100, 44, 44);
    }
  }

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
              'Hello $name',
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
                    child: SingleChildScrollView(
                      child: TodaysTask(),
                    ),
                    // child: ListView(
                    //   children: [
                    //     UnconstrainedBox(
                    //         child: Container(
                    //       height: MediaQuery.of(context).size.height * 0.18,
                    //       width: MediaQuery.of(context).size.width * 0.9,
                    //       decoration: BoxDecoration(
                    //         color: Color.fromARGB(255, 236, 186,
                    //             139), // Set the color of the container
                    //         borderRadius: BorderRadius.all(Radius.circular(20)),
                    //       ),
                    //     )),
                    //     SizedBox(
                    //       height: MediaQuery.of(context).size.height * 0.01,
                    //     ),
                    //     UnconstrainedBox(
                    //         child: Container(
                    //       height: MediaQuery.of(context).size.height * 0.18,
                    //       width: MediaQuery.of(context).size.width * 0.9,
                    //       decoration: BoxDecoration(
                    //         color: Color.fromARGB(255, 154, 205,
                    //             221), // Set the color of the container
                    //         borderRadius: BorderRadius.all(Radius.circular(20)),
                    //       ),
                    //     )),
                    //     SizedBox(
                    //       height: MediaQuery.of(context).size.height * 0.01,
                    //     ),
                    //     UnconstrainedBox(
                    //         child: Container(
                    //       height: MediaQuery.of(context).size.height * 0.18,
                    //       width: MediaQuery.of(context).size.width * 0.9,
                    //       decoration: BoxDecoration(
                    //         color: Color.fromARGB(255, 187, 176,
                    //             192), // Set the color of the container
                    //         borderRadius: BorderRadius.all(Radius.circular(20)),
                    //       ),
                    //     )),
                    //     SizedBox(
                    //       height: MediaQuery.of(context).size.height * 0.01,
                    //     ),
                    //     UnconstrainedBox(
                    //         child: Container(
                    //       height: MediaQuery.of(context).size.height * 0.18,
                    //       width: MediaQuery.of(context).size.width * 0.9,
                    //       decoration: BoxDecoration(
                    //         color: Color.fromARGB(255, 211, 158,
                    //             180), // Set the color of the container
                    //         borderRadius: BorderRadius.all(Radius.circular(20)),
                    //       ),
                    //     )),
                    //     SizedBox(
                    //       height: MediaQuery.of(context).size.height * 0.01,
                    //     ),
                    //   ],
                    // ),
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

  Widget TodaysTask() {
    List<Widget> taskWidgets = [];

    tasks.forEach((task) {
      taskWidgets.add(TaskWidget(task));
    });

    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: taskWidgets,
    ));
  }

  Widget TaskWidget(AllocatedTask task) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.17,
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
          decoration: BoxDecoration(
            color: getCategoryColor(task.category),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    task.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  child: Text(
                    task.locationName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          task.getStartTime(),
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        Text("START")
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height *
                          0.03, //use duration
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 83, 83, 83),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          '${task.getDurationStr()} hours',
                          style: TextStyle(
                            fontSize: 14,
                            color: getCategoryColor(task.category),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          task.getEndTime(),
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        Text("END")
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
