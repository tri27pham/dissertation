import 'package:flutter/material.dart';
import 'navbar.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

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
                print("MENU PRESSED");
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
      ),
      body: Column(
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
          ),
        ],
      ),
      drawer: NavBar(),
    );
  }
}
