import 'package:flutter/material.dart';

void main() {
  runApp(TaskManagerApp());
}

class Task {
  String name;
  bool isCompleted;
  String priority;

  Task(
      {required this.name, this.isCompleted = false, this.priority = "Medium"});
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();
  String _selectedPriority = 'Medium';
  List<Task> _tasks = [];
  bool _isButtonEnabled = false;

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks
            .add(Task(name: _taskController.text, priority: _selectedPriority));
        _taskController.clear();
        _isButtonEnabled = false;
      });
    }
    Navigator.pop(context); // Close dialog after adding task
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    _tasks.sort((a, b) =>
        _priorityValue(b.priority).compareTo(_priorityValue(a.priority)));

    return Scaffold(
      appBar: AppBar(
        title:
            Text("Task Manager", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: _tasks.isEmpty
          ? Center(
              child: Text(
                "No tasks added yet!",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: Checkbox(
                      value: _tasks[index].isCompleted,
                      activeColor: Colors.green,
                      onChanged: (bool? value) {
                        _toggleTaskCompletion(index);
                      },
                    ),
                    title: Text(
                      _tasks[index].name,
                      style: TextStyle(
                        decoration: _tasks[index].isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        _priorityIcon(_tasks[index].priority),
                        SizedBox(width: 5),
                        Text("Priority: ${_tasks[index].priority}"),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeTask(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: Icon(Icons.add, size: 30, color: Colors.white),
        onPressed: () => _showAddTaskDialog(),
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text("Add New Task", textAlign: TextAlign.center),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _taskController,
                  decoration: InputDecoration(
                    labelText: "Task Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: (text) {
                    setDialogState(() {
                      _isButtonEnabled = text.trim().isNotEmpty;
                    });
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedPriority,
                  decoration: InputDecoration(
                    labelText: "Priority",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: (String? newValue) {
                    setDialogState(() {
                      _selectedPriority = newValue!;
                    });
                  },
                  items: ['Low', 'Medium', 'High'].map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(priority),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: Text("Cancel",
                          style:
                              TextStyle(color: Colors.redAccent, fontSize: 16)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      child: Text(
                        "Add",
                        style: TextStyle(
                            fontSize: 16,
                            color: _isButtonEnabled
                                ? Colors.white
                                : Colors.black54),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isButtonEnabled ? Colors.indigo : Colors.grey[400],
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _isButtonEnabled ? _addTask : null,
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  int _priorityValue(String priority) {
    switch (priority) {
      case "High":
        return 3;
      case "Medium":
        return 2;
      case "Low":
        return 1;
      default:
        return 2;
    }
  }

  Widget _priorityIcon(String priority) {
    IconData icon;
    Color color;
    switch (priority) {
      case "High":
        icon = Icons.priority_high;
        color = Colors.red;
        break;
      case "Medium":
        icon = Icons.trending_up;
        color = Colors.orange;
        break;
      case "Low":
        icon = Icons.low_priority;
        color = Colors.green;
        break;
      default:
        icon = Icons.circle;
        color = Colors.grey;
    }
    return Icon(icon, color: color, size: 20);
  }
}
