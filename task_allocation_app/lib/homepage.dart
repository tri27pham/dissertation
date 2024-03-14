import 'package:flutter/material.dart';
import 'addTasks.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedOption = 'MEDIUM';
  List<bool> inOutSelection = [true, false];

  @override
  Widget build(BuildContext context) {
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
        children: [
          Text(
            'Hello Tri',
            style: TextStyle(
              fontSize: 55, // Change the font size here
              color: Color.fromARGB(
                  255, 32, 32, 32), // Change the color of the text here
              fontWeight: FontWeight.w500, // Make the text bold
            ),
          ),
        ],
      ),
    );
  }
}
