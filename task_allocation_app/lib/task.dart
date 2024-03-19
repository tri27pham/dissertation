class Task {
  final int taskID;
  final String name;
  final int hours;
  final int minutes;
  final int priority;
  final List<int> priorTasks;
  final String locationName;
  final String locationLongitude;
  final String locationLatitude;
  final int category;
  final String categoryName;

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
      this.category,
      this.categoryName);

  void printValues() {
    print(taskID);
    print(name);
    print(hours);
    print(minutes);
    print(priority);
    print(priorTasks);
    print(locationName);
    print(locationLongitude);
    print(locationLatitude);
    print(category);
  }

  String getMinutes() {
    double minutesAsHours = (minutes / 60);
    String roundedHours = minutesAsHours.toStringAsFixed(1);
    return roundedHours.split('.').last;
  }
}
