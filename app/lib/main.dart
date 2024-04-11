import 'package:flutter/material.dart';
import 'package:task_allocation_app/allocatedTask.dart';
import 'homepage.dart';
import 'package:provider/provider.dart';
import 'dataModel.dart';
import 'database.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(LoadingScreen());

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String name = prefs.getString('name') ?? '';

  List<AllocatedTask> dbTasks = await DatabaseHelper.instance.getTasks();

  // Once name is retrieved, run the app with the retrieved name
  runApp(ChangeNotifierProvider(
      create: (context) => DataModel(initialTasks: dbTasks, name: name),
      child: MyApp()));
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

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loading',
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
