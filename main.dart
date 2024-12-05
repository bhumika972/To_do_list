import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black), // Default text color
        ),
      ),
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<String> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Load tasks from SharedPreferences
  }

  // Load tasks from SharedPreferences
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tasks = prefs.getStringList('tasks') ?? [];
    });
    print("Tasks loaded: $_tasks");
  }

  // Save tasks to SharedPreferences
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tasks', _tasks);
    print("Tasks saved: $_tasks");
  }

  // Add a task
  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add(_taskController.text.trim());
        _taskController.clear();
      });
      _saveTasks();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Task added successfully!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a task.")));
    }
  }

  // Delete a task
  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks();
  }

  // Mark a task as completed
  void _toggleComplete(int index) {
    setState(() {
      _tasks[index] = _tasks[index].endsWith("(Completed)")
          ? _tasks[index].replaceAll(" (Completed)", "")
          : "${_tasks[index]} (Completed)";
    });
    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'To-Do App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Task Input Field
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: 'Enter task',
                labelStyle: TextStyle(color: Colors.blue),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.blueAccent),
            ),
            SizedBox(height: 10),
            // Add Task Button
            ElevatedButton(
              onPressed: _addTask,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: Text('Add Task'),
            ),
            SizedBox(height: 20),
            // List of Tasks
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _tasks[index],
                      style: TextStyle(
                        color: Colors.black,
                        decoration: _tasks[index].contains("(Completed)")
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    leading: IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () => _toggleComplete(index),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteTask(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
