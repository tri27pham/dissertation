class Task {
  final String name;
  final int hours;
  final int minutes;
  final int priority;
  final List<int> priorTasks;
  final String location;
  // final String city;
  // final String areaName;
  // final String areaCode;
  final int category;
  final String categoryName;

  Task(
      this.name,
      this.hours,
      this.minutes,
      this.priority,
      this.priorTasks,
      this.location,
      // this.city,
      // this.areaName,
      // this.areaCode,
      this.category,
      this.categoryName);

  void printValues() {
    print(name);
    print(hours);
    print(minutes);
    print(priority);
    print(priorTasks);
    print(location);
    // print(city);
    // print(areaName);
    // print(areaCode);
    print(category);
  }

  String getMinutes() {
    double minutesAsHours = (minutes / 60);
    return minutesAsHours.toString().split('.').last;
  }
}
