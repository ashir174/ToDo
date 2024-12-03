import 'package:flutter/material.dart';

class AddItem extends StatefulWidget {
  final Function(String) onAdd;

  const AddItem({super.key, required this.onAdd});

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  String _itemTitle = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Enter Item Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    _itemTitle = text;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_itemTitle.isNotEmpty) {
                    widget.onAdd(_itemTitle); // Call onAdd callback
                  }
                },
                child: const Text('Add Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
