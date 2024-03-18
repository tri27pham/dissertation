import 'package:flutter/material.dart';

class TaskWidget extends StatefulWidget {
  @override
  _TaskWidget createState() => _TaskWidget();
}

class _TaskWidget extends State<TaskWidget> {
  bool deleteOption = true;

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
                                  "DISSERATION",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(0.0,
                                    0), // Adjust the X and Y offsets to move the text horizontally and vertically
                                child: Text(
                                  "BUSH HOUSE (S) 6.01",
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(0.0,
                                    -2), // Adjust the X and Y offsets to move the text horizontally and vertically
                                child: Text(
                                  "UNIVERSITY",
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
                              "2 HOURS",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Transform.translate(
                            offset: Offset(0, -3),
                            child: Text(
                              "HIGH",
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
