import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:eassistance/models/user.dart';
import 'package:eassistance/services/session.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final List<Map<String, dynamic>> _tasks = [
    {
      "title": "Task 1",
      "description": "Complete the financial report.",
      "dueDate": "2024-12-25",
      "document": null,
    },
    {
      "title": "Task 2",
      "description": "Review the marketing proposal.",
      "dueDate": "2024-12-30",
      "document": null,
    },
    // Add more tasks as needed
  ];

  UserModel? session = null;
  final SessionManager _sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    UserModel? session = await _sessionManager.getSession();
    if (session == null) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } else {
      setState(() {
        this.session = session;
      });
    }
  }

  // Function to pick a document (image or file)
  Future<void> _pickDocument(int taskIndex) async {
    //final picker = ImagePicker();
    //final pickedFile = await picker.pickImage(source: ImageSource.gallery);  // You can use pickFile for documents

    //if (pickedFile != null) {
      //setState(() {
        //_tasks[taskIndex]['document'] = File(pickedFile.path);  // Assign the picked file to the task
      //});
    //}
  }

  // Function to view the document
  void _viewDocument(int taskIndex) {
    if (_tasks[taskIndex]['document'] != null) {
      // Handle document viewing (e.g., open the file, show preview)
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("View Document"),
          content: Image.file(_tasks[taskIndex]['document']),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Close"),
            ),
          ],
        ),
      );
    } else {
      // If no document is uploaded, show a message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No document uploaded for this task")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tach'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> task = _tasks[index];

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.task, color: Colors.blue),
                title: Text(task['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Due Date: ${task['dueDate']}"),
                    SizedBox(height: 8),
                    Text(task['description']),
                    SizedBox(height: 8),
                    task['document'] == null
                        ? ElevatedButton(
                      onPressed: () => _pickDocument(index),
                      child: Text('Upload Document'),
                    )
                        : ElevatedButton(
                      onPressed: () => _viewDocument(index),
                      child: Text('View Document'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
