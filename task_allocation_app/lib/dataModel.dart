import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:developer';
import 'database.dart';
import 'package:task_allocation_app/allocatedTask.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataModel with ChangeNotifier {
  String name = "";
  String times = "";
  String preferences = "";
  List<AllocatedTask> tasks = [];

  DataModel({List<AllocatedTask>? initialTasks, String? name, String? times}) {
    if (initialTasks != null) {
      tasks = initialTasks;
    }
    if (name != null) {
      this.name = name;
    }
    if (times != null) {
      this.times = times;
    }
  }

  // static Future<DataModel> init() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String name = prefs.getString('name') ?? '';
  //   Map<String, String> prefTimes = {
  //     'mondayStart':
  //         prefs.getString('mondayStart') ?? "2024-03-26T09:00:00.000",
  //     'mondayEnd': prefs.getString('mondayEnd') ?? "2024-03-26T09:00:00.000",
  //     'tuesdayStart':
  //         prefs.getString('tuesdayStart') ?? "2024-03-26T09:00:00.000",
  //     'tuesdayEnd': prefs.getString('tuesdayEnd') ?? "2024-03-26T09:00:00.000",
  //     'wednesdayStart':
  //         prefs.getString('wednesdayStart') ?? "2024-03-26T09:00:00.000",
  //     'wednesdayEnd':
  //         prefs.getString('wednesdayEnd') ?? "2024-03-26T09:00:00.000",
  //     'thursdayStart':
  //         prefs.getString('thursdayStart') ?? "2024-03-26T09:00:00.000",
  //     'thursdayEnd':
  //         prefs.getString('thursdayEnd') ?? "2024-03-26T09:00:00.000",
  //     'fridayStart':
  //         prefs.getString('fridayStart') ?? "2024-03-26T09:00:00.000",
  //     'fridayEnd': prefs.getString('fridayEnd') ?? "2024-03-26T09:00:00.000",
  //     'saturdayStart':
  //         prefs.getString('saturdayStart') ?? "2024-03-26T09:00:00.000",
  //     'saturdayEnd':
  //         prefs.getString('saturdayEnd') ?? "2024-03-26T09:00:00.000",
  //     'sundayStart':
  //         prefs.getString('sundayStart') ?? "2024-03-26T09:00:00.000",
  //     'sundayEnd': prefs.getString('sundayEnd') ?? "2024-03-26T09:00:00.000",
  //   };
  //   String times = jsonEncode(prefTimes);
  //    Map<String, dynamic> preferences = {
  //       'university': {
  //         'morning': prefs.getInt('universityDay') ?? 0,
  //         'evening': universityEvening,
  //         'startOfWeek': universityStartOfWeek,
  //         'endOfWeek': universityEndOfWeek,
  //       },
  //       'work': {
  //         'morning': workMorning,
  //         'evening': workEvening,
  //         'startOfWeek': workStartOfWeek,
  //         'endOfWeek': workEndOfWeek,
  //       },
  //       'health': {
  //         'morning': healthMorning,
  //         'evening': healthEvening,
  //         'startOfWeek': healthStartOfWeek,
  //         'endOfWeek': healthEndOfWeek,
  //       },
  //       'social': {
  //         'morning': socialMorning,
  //         'evening': socialEvening,
  //         'startOfWeek': socialStartOfWeek,
  //         'endOfWeek': socialEndOfWeek,
  //       },
  //       'family': {
  //         'morning': familyMorning,
  //         'evening': familyEvening,
  //         'startOfWeek': familyStartOfWeek,
  //         'endOfWeek': familyEndOfWeek,
  //       },
  //       'hobbies': {
  //         'morning': hobbiesMorning,
  //         'evening': hobbiesEvening,
  //         'startOfWeek': hobbiesStartOfWeek,
  //         'endOfWeek': hobbiesEndOfWeek,
  //       },
  //       'miscellaneous': {
  //         'morning': miscellaneousMorning,
  //         'evening': miscellaneousEvening,
  //         'startOfWeek': miscellaneousStartOfWeek,
  //         'endOfWeek': miscellaneousEndOfWeek,
  //       },
  //     };

  //     // Convert the structured map to a JSON string
  //     String jsonPreferences = jsonEncode(preferences);
  //   List<AllocatedTask> dbTasks = await DatabaseHelper.instance.getTasks();
  //   return DataModel(initialTasks: dbTasks, name: name, times: times);
  // }

  void updateTimes(String newTimes) {
    times = newTimes;
    notifyListeners();
  }

  void updatePreferences(String newPreferences) {
    preferences = newPreferences;
    notifyListeners();
  }

  void updateAllocatedTasks(String newTasks) {
    tasks.clear();
    List<dynamic> decodedTasks = jsonDecode(newTasks);
    List<Map<String, dynamic>> task_data =
        List<Map<String, dynamic>>.from(decodedTasks);

    task_data.forEach((task) {
      DateTime startDateTime = DateTime.parse(task['start_datetime']);
      DateTime endDateTime = DateTime.parse(task['end_datetime']);
      AllocatedTask newTask = AllocatedTask(
          task['taskID'],
          task['name'],
          startDateTime,
          endDateTime,
          task['priority'],
          task['location_name'],
          task['category']);
      tasks.add(newTask);
    });
    // for (int i = 0; i < tasks.length; i++) {
    //   print(tasks[i].name);
    // }
    notifyListeners();
    saveTasksToDb();
  }

  Future<void> saveTasksToDb() async {
    try {
      // First, delete all existing tasks in the database
      await DatabaseHelper.instance.deleteAllTasks();

      // Once deletion is complete, insert the new tasks
      await DatabaseHelper.instance.insertTasks(tasks);
    } catch (e) {
      // Handle any errors that occur during deletion or insertion
      print("Error refreshing tasks: $e");
    }
  }

  List<AllocatedTask> getTasksDay(int day) {
    DateTime currentDate = DateTime.now();

    DateTime dayDate = currentDate.add(Duration(days: day - 1));

    List<AllocatedTask> tasksOnSelectedDate = tasks.where((task) {
      return task.startDateTime.year == dayDate.year &&
          task.startDateTime.month == dayDate.month &&
          task.startDateTime.day == dayDate.day;
    }).toList();

    tasksOnSelectedDate
        .sort((a, b) => a.startDateTime.compareTo(b.startDateTime));

    return tasksOnSelectedDate;
  }
}
