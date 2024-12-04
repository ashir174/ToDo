import 'package:flutter/material.dart';
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

  void _addTask(String title) {
    setState(() {
      pendingTasks.add(Task(title: title));
      filteredTasks = pendingTasks; // Update filtered list
    });
  }

  void _editTask(Task task) {
    final TextEditingController _editController =
        TextEditingController(text: task.title);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Task"),
          content: TextField(
            controller: _editController,
            decoration: const InputDecoration(
              hintText: "Enter new task title",
            ),
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
                  task.title = _editController.text;
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
                      return Container(
                        color: const Color.fromARGB(
                            255, 240, 240, 240), // Light grey background
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          title: Text(task.title),
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
                return Container(
                  color: Colors.grey[200], // Light grey background
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    title: Text(task.title), // Removed strikethrough
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
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddItem(onAdd: (title) {
                      _addTask(title);
                      Navigator.pop(context); // Go back after adding the item
                    }),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}
