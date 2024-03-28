import 'dart:convert';

class AllocatedTask {
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

  AllocatedTask(
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
}
