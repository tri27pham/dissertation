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
}
