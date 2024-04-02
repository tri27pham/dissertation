import 'dart:convert';

class AllocatedTask {
  final String taskID;
  final String name;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final int priority;
  final String locationName;
  final int category;

  AllocatedTask(this.taskID, this.name, this.startDateTime, this.endDateTime,
      this.priority, this.locationName, this.category);
}
