import 'package:flutter/material.dart';
import 'addTasks.dart';
import 'viewTasks.dart';
import 'homepage.dart';
import 'locationSearch.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 219, 219, 219)),
      home: HomePage(),
    );
  }
}
