import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddItem extends StatefulWidget {
  final Function(String, DateTime) onAdd;

  const AddItem({super.key, required this.onAdd});

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
      ),
      body: GestureDetector(
        onTap: _dismissKeyboard, // Dismiss the keyboard on tap outside
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                focusNode: _textFieldFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 124, 124, 124),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Date: ${DateFormat('dd-MM-yyyy').format(_selectedDate)}',
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? selected = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (selected != null && selected != _selectedDate) {
                        setState(() {
                          _selectedDate = selected;
                        });
                      }
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Time: ${_selectedTime.format(context)}'),
                  IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () async {
                      TimeOfDay? selected = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (selected != null && selected != _selectedTime) {
                        setState(() {
                          _selectedTime = selected;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  DateTime finalDateTime = DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                    _selectedTime.hour,
                    _selectedTime.minute,
                  );
                  widget.onAdd(_titleController.text, finalDateTime);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 185, 117, 97),
                ),
                child: const Text("Add Task"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
