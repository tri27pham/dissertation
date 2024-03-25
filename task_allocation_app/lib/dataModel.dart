import 'package:flutter/material.dart';

class DataModel with ChangeNotifier {
  String times = "";
  String preferences = "";

  void updateTimes(String newTimes) {
    times = newTimes;
    notifyListeners();
  }

  void updatePreferences(String newPreferences) {
    preferences = newPreferences;
    notifyListeners();
  }
}
