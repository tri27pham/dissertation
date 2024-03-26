import 'package:flutter/material.dart';

class DataModel with ChangeNotifier {
  String times = "";
  String preferences = "";
  List<dynamic> taskOrder = [];

  void updateTimes(String newTimes) {
    times = newTimes;
    notifyListeners();
  }

  void updatePreferences(String newPreferences) {
    preferences = newPreferences;
    notifyListeners();
  }
}
