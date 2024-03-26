import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:provider/provider.dart';
import 'dataModel.dart';

void main() {
  runApp(
      ChangeNotifierProvider(create: (context) => DataModel(), child: MyApp()));
}

// void main() {
//   runApp(MyApp());
// }

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
