import 'dart:convert';

class Task {
  final int taskID;
  final String name;
  final int hours;
  final int minutes;
  final int priority;
  final List<String> priorTasks;
  final String locationName;
  final String locationLongitude;
  final String locationLatitude;
  final int category;

  Task(
      this.taskID,
      this.name,
      this.hours,
      this.minutes,
      this.priority,
      this.priorTasks,
      this.locationName,
      this.locationLongitude,
      this.locationLatitude,
      this.category);

  Map<String, dynamic> toJson() {
    return {
      'taskID': taskID,
      'name': name,
      'hours': hours,
      'minutes': minutes,
      'priority': priority,
      'priorTasks': priorTasks,
      'locationName': locationName,
      'locationLongitude': locationLongitude,
      'locationLatitude': locationLatitude,
      'category': category,
    };
  }

  void printValues() {
    print("ID: $taskID");
    print("Name: $name");
    print("Hours: $hours, Minutes: $minutes}");
    print("Priority: $priority");
    print("Prior tasks: $priorTasks");
    print("Location name: $locationName");
    print("Location: ($locationLongitude,$locationLatitude)");
    print("Category: $category");
  }

  String getMinutes() {
    double minutesAsHours = (minutes / 60);
    String roundedHours = minutesAsHours.toStringAsFixed(1);
    return roundedHours.split('.').last;
  }
}
