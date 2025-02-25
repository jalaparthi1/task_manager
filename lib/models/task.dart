class Task {
  String name;
  bool isCompleted;
  String priority; // "Low", "Medium", "High"

  Task(
      {required this.name, this.isCompleted = false, this.priority = "Medium"});
}
