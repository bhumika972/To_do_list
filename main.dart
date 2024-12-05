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
  TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();  // Load tasks when the app starts
  }

  // Load tasks from SharedPreferences
  _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tasks = prefs.getStringList('tasks') ?? [];
    });
    print("Tasks loaded: $_tasks");  // Debugging line to verify loaded tasks
  }

  // Save tasks to SharedPreferences
  _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('tasks', _tasks);
    print("Tasks saved: $_tasks");  // Debugging line to verify saved tasks
  }

  // Add a task
  _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add(_taskController.text);
        _taskController.clear();
      });
      _saveTasks();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Task added successfully!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a task.")));
    }
  }

  // Delete a task
  _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks();
  }

  // Mark task as completed
  _toggleComplete(int index) {
    setState(() {
      _tasks[index] = _tasks[index] + " (Completed)";
    });
    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'To-Do App',
          style: TextStyle(color: Colors.white), // Text color for AppBar
        ),
        backgroundColor: Colors.blueAccent,  // AppBar background color
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
                labelStyle: TextStyle(color: Colors.blue), // Label color
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.blueAccent),  // Text color for input
            ),
            SizedBox(height: 10),
            // Add Task Button
            ElevatedButton(
              onPressed: _addTask,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),  // Button color
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
                      style: TextStyle(color: Colors.black),  // Text color for task list
                    ),
                    leading: IconButton(
                      icon: Icon(Icons.check, color: Colors.green),  // Check icon color
                      onPressed: () => _toggleComplete(index),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),  // Delete icon color
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
