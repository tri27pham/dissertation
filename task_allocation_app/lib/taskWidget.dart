import 'package:flutter/material.dart';
import 'task.dart';

class TaskWidget extends StatefulWidget {
  final Task task;

  TaskWidget({required this.task});

  @override
  _TaskWidget createState() => _TaskWidget();
}

class _TaskWidget extends State<TaskWidget> {
  bool deleteOption = false;

  List<String> priorities = ["LOW", "MEDIUM", "HIGH"];

  String trim(String input) {
    if (input.length <= 50) {
      return input;
    } else {
      return input.substring(0, 50);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle the visibility of the button
          deleteOption = !deleteOption;
        });
      },
      child: Stack(
        children: [
          if (!deleteOption)
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.grey.shade100, // Set color to blue
                borderRadius: BorderRadius.circular(15), // Set rounded corners
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Transform.translate(
                                offset: Offset(0.0,
                                    3.0), // Adjust the X and Y offsets to move the text horizontally and vertically
                                child: Text(
                                  widget.task.name,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(0.0,
                                    0), // Adjust the X and Y offsets to move the text horizontally and vertically
                                child: Text(
                                  widget.task.locationName,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(0.0,
                                    -2), // Adjust the X and Y offsets to move the text horizontally and vertically
                                child: Text(
                                  widget.task.categoryName,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          Color.fromARGB(255, 146, 211, 162)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Transform.translate(
                            offset: Offset(0, 3),
                            child: Text(
                              "${widget.task.hours}.${widget.task.getMinutes()} HOURS",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Transform.translate(
                            offset: Offset(0, -3),
                            child: Text(
                              priorities[widget.task.priority],
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 212, 106, 106),
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (deleteOption)
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                    255, 221, 123, 123), // Set color to blue
                borderRadius: BorderRadius.circular(15), // Set rounded corners
              ),
              child: Icon(
                Icons.delete_forever,
                size: 40,
                color: Colors.white,
              ),
            )
        ],
      ),
    );
  }
}
