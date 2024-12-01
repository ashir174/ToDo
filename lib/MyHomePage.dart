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
  List<Task> pendingTasks = [];
  List<Task> completedTasks = [];

  void _addTask(String title) {
    setState(() {
      pendingTasks.add(Task(title: title));
    });
  }

  void _markAsCompleted(Task task) {
    setState(() {
      task.isCompleted = true;
      pendingTasks.remove(task);
      completedTasks.add(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: const TabBar(
            labelColor: Color.fromARGB(255, 211, 159, 108),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color.fromARGB(255, 211, 159, 108),
            tabs: [
              Tab(icon: Icon(Icons.home), text: "Pending Tasks"),
              Tab(icon: Icon(Icons.check), text: "Completed Tasks"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Pending Tasks
            ListView.builder(
              itemCount: pendingTasks.length,
              itemBuilder: (context, index) {
                final task = pendingTasks[index];
                return ListTile(
                  title: Text(task.title),
                  trailing: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      _markAsCompleted(task);
                    },
                  ),
                );
              },
            ),
            // Completed Tasks
            ListView.builder(
              itemCount: completedTasks.length,
              itemBuilder: (context, index) {
                final task = completedTasks[index];
                return ListTile(
                  title: Text(
                    task.title,
                    style:
                        const TextStyle(decoration: TextDecoration.lineThrough),
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
              child: const Text(
                "+",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
