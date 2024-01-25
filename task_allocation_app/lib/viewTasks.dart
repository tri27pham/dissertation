import 'package:flutter/material.dart';
import 'addTasks.dart';

class ViewTasksPage extends StatefulWidget {
  const ViewTasksPage({super.key});

  @override
  State<ViewTasksPage> createState() => _ViewTasksPageState();
}

class _ViewTasksPageState extends State<ViewTasksPage> {
  String? selectedOption = 'MEDIUM';
  List<bool> inOutSelection = [true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("View Tasks"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 0.85 * MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the second page when the button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddTasksPage()),
                  );
                },
                child: Text("Add Task"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
