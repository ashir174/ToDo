import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'task.dart';
import 'AddItem.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();

  List<Task> pendingTasks = [];
  List<Task> completedTasks = [];
  List<Task> filteredTasks = [];

  @override
  void initState() {
    super.initState();
    filteredTasks = pendingTasks; // Initially, show all pending tasks
  }

  // Function to format date and time to include AM/PM
  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return "No date";
    final DateFormat dateFormatter =
        DateFormat('dd-MM-yyyy hh:mm a'); // Format with AM/PM
    return dateFormatter.format(dateTime);
  }

  void _addTask(String title, DateTime dateTime) {
    setState(() {
      pendingTasks.add(Task(title: title, dateTime: dateTime));
      filteredTasks = pendingTasks; // Update filtered list
    });
  }

  void _editTask(Task task) {
    final TextEditingController editController =
        TextEditingController(text: task.title);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: editController,
                decoration: const InputDecoration(
                  hintText: "Enter new task title",
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: task.dateTime != null
                    ? "${task.dateTime?.day}-${task.dateTime?.month}-${task.dateTime?.year}"
                    : "",
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: task.dateTime ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null) {
                    setState(() {
                      task.dateTime = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          task.dateTime?.hour ?? 0,
                          task.dateTime?.minute ?? 0);
                    });
                  }
                },
                decoration: const InputDecoration(
                  hintText: "Tap to change date",
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: task.dateTime != null
                    ? "Time: ${task.dateTime?.hour}:${task.dateTime?.minute}"
                    : "Time: Not Set",
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(task.dateTime ?? DateTime.now()),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      task.dateTime = DateTime(
                        task.dateTime?.year ?? 0,
                        task.dateTime?.month ?? 0,
                        task.dateTime?.day ?? 0,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                },
                decoration: const InputDecoration(
                  hintText: "Tap to change time",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  task.title = editController.text;
                });
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(Task task, bool isCompleted) {
    setState(() {
      if (isCompleted) {
        completedTasks.remove(task);
      } else {
        pendingTasks.remove(task);
        filteredTasks = pendingTasks; // Update filtered list
      }
    });
  }

  void _toggleCompleted(Task task) {
    setState(() {
      if (task.isCompleted) {
        // Restore to pending
        completedTasks.remove(task);
        task.isCompleted = false;
        pendingTasks.add(task);
        filteredTasks = pendingTasks; // Update filtered list
      } else {
        // Move to completed
        task.isCompleted = true;
        pendingTasks.remove(task);
        completedTasks.add(task);
        filteredTasks = pendingTasks; // Update filtered list
      }
    });
  }

  void _filterTasks(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTasks = pendingTasks;
      } else {
        filteredTasks = pendingTasks
            .where((task) =>
                task.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filterTasks('');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor:
              const Color.fromARGB(255, 225, 225, 225), // Warm beige background
          bottom: const TabBar(
            labelColor: Color.fromARGB(255, 185, 117, 97),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color.fromARGB(255, 185, 117, 97),
            tabs: [
              Tab(icon: Icon(Icons.home), text: "Pending Tasks"),
              Tab(icon: Icon(Icons.check), text: "Completed Tasks"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Pending Tasks with Checkbox, Edit, Delete
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterTasks,
                    decoration: InputDecoration(
                      hintText: 'Search tasks...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: _clearSearch,
                            )
                          : null,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        color: const Color.fromARGB(
                            255, 249, 249, 249), // Light task background color
                        child: ListTile(
                          title: Text(task.title),
                          subtitle: Text(
                            'Due: ${task.dateTime != null ? formatDateTime(task.dateTime) : "No date"}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          leading: Checkbox(
                            value: task.isCompleted,
                            onChanged: (value) {
                              _toggleCompleted(task);
                            },
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.brown),
                                onPressed: () {
                                  _editTask(task);
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteTask(task, false);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            // Completed Tasks with Edit and Restore
            ListView.builder(
              itemCount: completedTasks.length,
              itemBuilder: (context, index) {
                final task = completedTasks[index];
                return Card(
                  color: const Color.fromARGB(
                      255, 240, 240, 240), // Light grey background
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    subtitle: Text(
                      'Completed on: ${task.dateTime != null ? formatDateTime(task.dateTime) : "No date"}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.undo, color: Colors.green),
                      onPressed: () {
                        _toggleCompleted(task);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AddItem(
                  onAdd: _addTask,
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
