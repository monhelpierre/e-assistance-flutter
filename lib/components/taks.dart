import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:eassistance/models/user.dart';
import 'package:eassistance/services/task.dart';
import 'package:eassistance/constant/session.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:eassistance/constant/colors.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  UserModel? session = null;
  final List<Map<String, dynamic>> _tasks = tasksList;
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

  Future<void> _pickDocument(int taskIndex, String docKey) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpeg', 'jpg', 'png'],
    );

    if (result != null) {
      setState(() {
        _tasks[taskIndex]['document'][docKey] = File(result.files.single.path!);  // Assign the picked file to the task
      });
    }
  }

  void _removeDocument(int taskIndex, String docKey) {
    setState(() {
      _tasks[taskIndex]['document'][docKey] = null;
    });
  }

  void _viewDocument(int taskIndex, String docKey) {
    if (_tasks[taskIndex]['document'][docKey] != false) {
      final file = _tasks[taskIndex]['document'][docKey];
      final fileExtension = file.path.split('.').last.toLowerCase();

      if (fileExtension == 'pdf') {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Gade Dokiman"),
            content: Container(
              height: 400,
              child: PDFView(
                filePath: file.path,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Fèmen"),
              ),
            ],
          ),
        );
      } else if (['jpeg', 'jpg', 'png'].contains(fileExtension)) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Gade Dokiman"),
            content: Image.file(file),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Fèmen"),
              ),
            ],
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pa Gen Fichye")),
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
            Map task = _tasks[index];
            bool allDocumentsComplete = _tasks[index]['document'].values.every((dynamic isComplete) => isComplete != null);
            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ExpansionTile(
                title: Text(
                  task['title'],
                  style: TextStyle(color: allDocumentsComplete ? completeColor : incompleteColor),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Dat Limit: ${task['dueDate']}"),
                        SizedBox(height: 8),
                        Text(task['description']),
                        SizedBox(height: 8),
                        ...task['document'].entries.map((doc) {
                          return ListTile(
                            title: Text(doc.key),
                            subtitle: Text(doc.value != null ? 'Dokiman konplè' : 'Dokiman enkonplè'),
                            trailing: doc.value == null ? ElevatedButton(
                                  onPressed: () => _pickDocument(index, doc.key),
                                  child: Text('Metel')
                            ) : Row(
                              mainAxisSize: MainAxisSize.min,
                                children: [
                                    ElevatedButton(
                                      onPressed: () => _viewDocument(index, doc.key),
                                      child: Text('Gadel'),
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                        onPressed: () => _removeDocument(index, doc.key),
                                        child: Text('Retirel') ,
                                      ),
                                ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}