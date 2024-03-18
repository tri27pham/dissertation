class TaskToAllocate {
  final String name;
  final int hours;
  final int minutes;
  final int priority;
  final List<int> priorTasks;
  final String addressLine1;
  final String city;
  final String areaName;
  final String areaCode;
  final int category;

  TaskToAllocate(
      this.name,
      this.hours,
      this.minutes,
      this.priority,
      this.priorTasks,
      this.addressLine1,
      this.city,
      this.areaName,
      this.areaCode,
      this.category);

  void printValues() {
    print(name);
    print(hours);
    print(minutes);
    print(priority);
    print(priorTasks);
    print(addressLine1);
    print(city);
    print(areaName);
    print(areaCode);
    print(category);
  }
}
