class Task {
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
    return minutesAsHours.toString().split('.').last;
  }
}
