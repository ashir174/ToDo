import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  void _addTask(String title, DateTime dateTime) {
    setState(() {
      pendingTasks.add(Task(title: title, dateTime: dateTime));
      filteredTasks = pendingTasks; // Update filtered list
    });
  }

  void _editTask(Task task) {
    final TextEditingController editController =
        TextEditingController(text: task.title);
    DateTime tempDate = task.dateTime;
    TimeOfDay tempTime = TimeOfDay.fromDateTime(task.dateTime);

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
              Row(
                children: [
                  Text('Date: ${DateFormat('dd-MM-yyyy').format(tempDate)}'),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? selected = await showDatePicker(
                        context: context,
                        initialDate: tempDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (selected != null && selected != tempDate) {
                        setState(() {
                          tempDate = selected;
                        });
                      }
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Time: ${tempTime.format(context)}'),
                  IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () async {
                      TimeOfDay? selected = await showTimePicker(
                        context: context,
                        initialTime: tempTime,
                      );
                      if (selected != null && selected != tempTime) {
                        setState(() {
                          tempTime = selected;
                        });
                      }
                    },
                  ),
                ],
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
                  task.dateTime = DateTime(
                    tempDate.year,
                    tempDate.month,
                    tempDate.day,
                    tempTime.hour,
                    tempTime.minute,
                  );
                  if (!task.isCompleted) {
                    filteredTasks = pendingTasks; // Update filtered list
                  }
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
          bottom: const TabBar(
            labelColor: Color.fromARGB(255, 205, 141, 77),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color.fromARGB(255, 205, 141, 77),
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
                      return ListTile(
                        title: Text(task.title),
                        subtitle: Text(
                          'Due: ${DateFormat('dd-MM-yyyy').format(task.dateTime)} at ${DateFormat('hh:mm a').format(task.dateTime)}',
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
                              icon: const Icon(Icons.edit, color: Colors.brown),
                              onPressed: () {
                                _editTask(task);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteTask(task, false);
                              },
                            ),
                          ],
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
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(
                    'Completed on: ${DateFormat('dd-MM-yyyy').format(task.dateTime)} at ${DateFormat('hh:mm a').format(task.dateTime)}',
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
                        icon: const Icon(Icons.edit, color: Colors.brown),
                        onPressed: () {
                          _editTask(task);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteTask(task, true);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddItem(onAdd: (title, dateTime) {
                  _addTask(title, dateTime);
                }),
              ),
            );
          },
          child: const Icon(Icons.add),
          backgroundColor:
              const Color.fromARGB(255, 205, 141, 77), // Custom color
        ),
      ),
    );
  }
}
