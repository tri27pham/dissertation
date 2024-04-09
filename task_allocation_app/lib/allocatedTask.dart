import 'dart:convert';
import 'package:intl/intl.dart';

class AllocatedTask {
  final String taskID;
  final String name;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final int priority;
  final String locationName;
  final int category;
  final DateFormat formatter = DateFormat('HH:mm');

  AllocatedTask(this.taskID, this.name, this.startDateTime, this.endDateTime,
      this.priority, this.locationName, this.category);

  String getDurationStr() {
    Duration timeDiff = endDateTime.difference(startDateTime);

    double hoursDiff = (timeDiff.inSeconds / 3600).roundToDouble();

    return "${hoursDiff.toStringAsFixed(1)}";
  }

  double getDurationFloat() {
    Duration timeDiff = endDateTime.difference(startDateTime);

    double hoursDiff = timeDiff.inSeconds / 3600;

    return hoursDiff;
  }

  String getStartTime() {
    return formatter.format(startDateTime);
  }

  String getEndTime() {
    return formatter.format(endDateTime);
  }

  // Method to convert AllocatedTask object to a map
  Map<String, dynamic> toMap() {
    return {
      'taskID': taskID,
      'name': name,
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String(),
      'priority': priority,
      'locationName': locationName,
      'category': category,
    };
  }

  // Constructor to create AllocatedTask object from a map
  factory AllocatedTask.fromMap(Map<String, dynamic> map) {
    return AllocatedTask(
      map['taskID'].toString(),
      map['name'],
      DateTime.parse(map['startDateTime']),
      DateTime.parse(map['endDateTime']),
      map['priority'],
      map['locationName'],
      map['category'],
    );
  }
}
