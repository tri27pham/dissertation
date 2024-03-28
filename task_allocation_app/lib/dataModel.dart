import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:developer';

class DataModel with ChangeNotifier {
  String times = "";
  String preferences = "";
  List<dynamic> tasks = [];

  void updateTimes(String newTimes) {
    times = newTimes;
    notifyListeners();
  }

  void updatePreferences(String newPreferences) {
    preferences = newPreferences;
    notifyListeners();
  }

  void updateTasks(String newTasks) {
    List<dynamic> decodedTasks = jsonDecode(newTasks);
    List<Map<String, dynamic>> tasks =
        List<Map<String, dynamic>>.from(decodedTasks);

    notifyListeners();
  }
}
