import 'package:flutter/material.dart';

class CalendarTile extends StatefulWidget {
  final String weekday;
  final String day;
  final String month;
  final Color color;

  CalendarTile(
      {required this.weekday,
      required this.day,
      required this.month,
      required this.color});

  @override
  _CalendarTileState createState() => _CalendarTileState();
}

class _CalendarTileState extends State<CalendarTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 3),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.22,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: widget.color, // Set the color of the container
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Transform.translate(
                            offset:
                                Offset(0, 20), // Adjust the offset as needed
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.06,
                              ),
                              child: Text(
                                widget.weekday,
                                style: TextStyle(
                                  fontSize: 20, // Change the font size here
                                  color: Color.fromARGB(255, 80, 78,
                                      78), // Change the color of the text here
                                  fontWeight:
                                      FontWeight.w400, // Make the text bold
                                  // letterSpacing: -3,
                                ),
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset:
                                Offset(0, 10), // Adjust the offset as needed
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.06,
                              ),
                              child: Text(
                                widget.day,
                                style: TextStyle(
                                  fontSize: 40, // Change the font size here
                                  color: Color.fromARGB(255, 80, 78,
                                      78), // Change the color of the text here
                                  fontWeight:
                                      FontWeight.w400, // Make the text bold
                                  // letterSpacing: -3,
                                ),
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset:
                                Offset(0, -8), // Adjust the offset as needed
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.06,
                              ),
                              child: Text(
                                widget.month,
                                style: TextStyle(
                                  fontSize: 40, // Change the font size here
                                  color: Color.fromARGB(255, 80, 78,
                                      78), // Change the color of the text here
                                  fontWeight:
                                      FontWeight.w400, // Make the text bold
                                  // letterSpacing: -3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  Expanded(flex: 6, child: Container())
                ],
              ),
            )),
      ],
    );
  }
}
