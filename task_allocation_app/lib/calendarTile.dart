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
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 38,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Transform.translate(
                                  offset: Offset(
                                      0, 15), // Adjust the offset as needed
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        MediaQuery.of(context).size.width *
                                            0.06,
                                        0,
                                        0,
                                        0),
                                    child: Text(
                                      widget.weekday,
                                      style: TextStyle(
                                        fontSize:
                                            15, // Change the font size here
                                        color: Color.fromARGB(255, 80, 78,
                                            78), // Change the color of the text here
                                        fontWeight: FontWeight
                                            .w400, // Make the text bold
                                        // letterSpacing: -3,
                                      ),
                                    ),
                                  ),
                                ),
                                Transform.translate(
                                  offset: Offset(
                                      0, 10), // Adjust the offset as needed
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        MediaQuery.of(context).size.width *
                                            0.06,
                                        0,
                                        0,
                                        0),
                                    child: Text(
                                      widget.day,
                                      style: TextStyle(
                                        fontSize:
                                            35, // Change the font size here
                                        color: Color.fromARGB(255, 80, 78,
                                            78), // Change the color of the text here
                                        fontWeight: FontWeight
                                            .w400, // Make the text bold
                                        // letterSpacing: -3,
                                      ),
                                    ),
                                  ),
                                ),
                                Transform.translate(
                                  offset: Offset(
                                      0, -8), // Adjust the offset as needed
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(
                                        MediaQuery.of(context).size.width *
                                            0.06,
                                        0,
                                        0,
                                        0),
                                    child: Text(
                                      widget.month,
                                      style: TextStyle(
                                        fontSize:
                                            35, // Change the font size here
                                        color: Color.fromARGB(255, 80, 78,
                                            78), // Change the color of the text here
                                        fontWeight: FontWeight
                                            .w400, // Make the text bold
                                        // letterSpacing: -3,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Expanded(flex: 65, child: DailyTimesWidget()),
                      ],
                    ),
                  ],
                ))),
      ],
    );
  }

  Widget DailyTimesWidget() {
    return Container(
        width: 40,
        height: MediaQuery.of(context).size.height * 0.18,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 5,
              child: Align(
                alignment: Alignment.center,
                child: VerticalDivider(
                  color: Colors.black,
                  thickness: 1,
                  indent: 5,
                  endIndent: 5,
                ),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.11,
                padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
                child: Column(
                  children: [
                    Text(
                      "9am",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    )
                  ],
                )),
            Container(
              width: 5,
              child: Align(
                alignment: Alignment.center,
                child: VerticalDivider(
                  color: Colors.black,
                  thickness: 1,
                  indent: 5,
                  endIndent: 5,
                ),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.11,
                padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
                child: Column(
                  children: [
                    Text(
                      "10am",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    )
                  ],
                )),
            Container(
              width: 5,
              child: Align(
                alignment: Alignment.center,
                child: VerticalDivider(
                  color: Colors.black,
                  thickness: 1,
                  indent: 5,
                  endIndent: 5,
                ),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.11,
                padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
                child: Column(
                  children: [
                    Text(
                      "11am",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    )
                  ],
                )),
            Container(
              width: 5,
              child: Align(
                alignment: Alignment.center,
                child: VerticalDivider(
                  color: Colors.black,
                  thickness: 1,
                  indent: 5,
                  endIndent: 5,
                ),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.11,
                padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
                child: Column(
                  children: [
                    Text(
                      "12pm",
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    )
                  ],
                )),
          ],
        ));
  }
}
