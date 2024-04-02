import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:task_allocation_app/allocatedTask.dart';

class DataModel with ChangeNotifier {
  String times = "";
  String preferences = "";
  List<AllocatedTask> tasks = [];

  void updateTimes(String newTimes) {
    times = newTimes;
    notifyListeners();
  }

  void updatePreferences(String newPreferences) {
    preferences = newPreferences;
    notifyListeners();
  }

  void updateTasks(String newTasks) {
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
    notifyListeners();
  }

  List<AllocatedTask> getTasksDay(int day) {
    DateTime currentDate = DateTime.now();

    DateTime dayDate = currentDate.add(Duration(days: day - 1));

    List<AllocatedTask> tasksOnSelectedDate = tasks.where((task) {
      return task.startDateTime.year == dayDate.year &&
          task.startDateTime.month == dayDate.month &&
          task.startDateTime.day == dayDate.day;
    }).toList();

    return tasksOnSelectedDate;
  }
}
