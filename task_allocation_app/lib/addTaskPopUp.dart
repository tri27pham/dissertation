import 'package:flutter/material.dart';

class AddTaskPopUp extends StatelessWidget {
  const AddTaskPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Text(
            "ADD TASK",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "NAME",
                  textAlign: TextAlign.left,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: Color.fromARGB(255, 233, 227, 227),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "DURATION",
                  textAlign: TextAlign.left,
                ),
                Row(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.2,
                      color: Color.fromARGB(255, 233, 227, 227),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.2,
                      color: Color.fromARGB(255, 233, 227, 227),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.2,
                      color: Color.fromARGB(255, 233, 227, 227),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
