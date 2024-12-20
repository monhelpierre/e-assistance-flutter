import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:eassistance/models/user.dart';
import 'package:eassistance/constant/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eassistance/constant/session.dart';
import 'package:eassistance/services/payment.dart';
import 'package:eassistance/constant/loading.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:eassistance/services/assistance.dart';

class AssistancePage extends StatefulWidget {
  User? user;
  final List<Map<String, dynamic>> requiredDocuments;

  AssistancePage({super.key, required this.requiredDocuments});

  @override
  _AssistancePageState createState() => _AssistancePageState();
}

class _AssistancePageState extends State<AssistancePage> {
  UserModel? session = null;
  String? selectedPaymentMethod;
  Map<String, bool> documentUploaded = {};
  Map<String, String?> uploadedFiles = {};
  Map<String, bool> taskCompletionStatus = {};
  Map<String, List<String>> documentTasks = {};
  final List<Map<String, dynamic>> _tasks = tasksList;
  final SessionManager _sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    _checkSession();

    if (widget.requiredDocuments.isNotEmpty) {
      for (var doc in widget.requiredDocuments) {
        doc.forEach((docName, tasks) {
          documentTasks[docName] = tasks;
          taskCompletionStatus[docName] = false;
          documentUploaded[docName] = false;
          uploadedFiles[docName] = null;
        });
      }
    }
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
        _tasks[taskIndex]['document'][docKey] = File(result.files.single.path!);
      });
    }
  }

  void _removeDocument(int taskIndex, String docKey) {
    setState(() {
      _tasks[taskIndex]['document'][docKey] = null as dynamic;
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
            title: Text("Gadel"),
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
            title: Text("Gadel"),
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
    return session != null
        ? Scaffold(
      appBar: AppBar(
        title: Text(widget.requiredDocuments.isNotEmpty
            ? "Mande Asistans"
            : "Lis Asistans"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: widget.requiredDocuments.isNotEmpty
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Etap 1: Verifye Dokiman Egzije yo",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...widget.requiredDocuments
                .map((doc) => doc.entries.map((entry) {
              return buildDocumentCard(
                  entry.key, entry.value);
            }).toList())
                .expand((x) => x),
            SizedBox(height: 30),
            if (shouldShowPayment())
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Etap 2: Chwazi Metòd Pèman an",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ...paymentMethods.map(
                        (method) => RadioListTile(
                      title: Text(method),
                      value: method,
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: selectedPaymentMethod != null
                        ? () {
                      showPaymentConfirmation();
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text("Peye Kounya"),
                  ),
                ],
              ),
          ],
        )
            : Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(), // Prevent ListView from scrolling
            shrinkWrap: true, // Constrain ListView's height
            itemCount: _tasks.length,
            itemBuilder: (context, index) {
              Map task = _tasks[index];
              bool allDocumentsComplete = _tasks[index]['document']
                  .values
                  .every((dynamic isComplete) => isComplete != null);
              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ExpansionTile(
                  title: Text(
                    task['title'],
                    style: TextStyle(
                      color: allDocumentsComplete
                          ? completeColor
                          : incompleteColor,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 18),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text("Dat Limit: ${task['dueDate']}"),
                          SizedBox(height: 8),
                          Text(task['description']),
                          SizedBox(height: 8),
                          ...task['document'].entries.map((doc) {
                            return ListTile(
                              title: Text(doc.key),
                              subtitle: Text(doc.value != null
                                  ? 'Dokiman konplè'
                                  : 'Dokiman enkonplè'),
                              trailing: doc.value == null
                                  ? GestureDetector(
                                onTap: () => _pickDocument(index, doc.key),
                                child: Icon(Icons.add, color: completeColor),
                              )
                                  : Row(
                                mainAxisSize:
                                MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        _viewDocument(
                                            index, doc.key),
                                    child: Icon(Icons.remove_red_eye),
                                  ),
                                  SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () =>
                                        _removeDocument(
                                            index, doc.key),
                                    child: Icon(Icons.close, color: errorColor),
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
      ),
    )
        : LoadingPage();
  }

  Widget buildDocumentCard(String doc, List<String> tasks) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(doc),
        children: [
          ...tasks.map((task) {
            return CheckboxListTile(
              title: Text(task),
              value: taskCompletionStatus["$doc-$task"] ?? false,
              onChanged: (value) {
                setState(() {
                  taskCompletionStatus["$doc-$task"] = value!;
                  documentTasks[doc]!.every((t) =>
                  taskCompletionStatus["$doc-$t"] ?? false)
                      ? taskCompletionStatus[doc] = true
                      : taskCompletionStatus[doc] = false;
                });
              },
            );
          }),
          if (documentTasks[doc]!.every((task) => taskCompletionStatus["$doc-$task"] ?? false) && uploadedFiles[doc] == null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1),
                  ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                      );
                      if (result != null) {
                        setState(() {
                          uploadedFiles[doc] = result.files.single.name;
                          documentUploaded[doc] = true;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text("Chaje Dokiman an (pdf/jpg/jpeg/png)"),
                  ),
                ],
              ),
            ),
          if (uploadedFiles[doc] != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    uploadedFiles[doc]!.length > 25
                        ? "${uploadedFiles[doc]!.substring(0, 25)}...${uploadedFiles[doc]!.split('.').last}" // Truncate and add the extension
                        : uploadedFiles[doc]!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        uploadedFiles[doc] = null;
                        documentUploaded[doc] = false;
                      });
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  bool shouldShowPayment() {
    bool hasIncompleteTasksWithoutUpload = widget.requiredDocuments.any((doc) {
      return doc.keys.any((docKey) {
        bool tasksNotChecked = documentTasks[docKey]!.any((task) =>
        !(taskCompletionStatus["$docKey-$task"] ?? false));

        bool allTasksCheckedAndUploaded = documentTasks[docKey]!.every((task) =>
        taskCompletionStatus["$docKey-$task"] ?? false) &&
            documentUploaded[docKey] == true;

        return !tasksNotChecked && !documentUploaded[docKey]!;
      });
    });

    if (hasIncompleteTasksWithoutUpload) {
      return false;
    }

    bool allDocumentsCheckedAndUploaded = widget.requiredDocuments.every((doc) {
      return doc.keys.every((docKey) {
        return documentTasks[docKey]!.every((task) =>
        taskCompletionStatus["$docKey-$task"] ?? false) &&
            documentUploaded[docKey] == true;
      });
    });

    return !hasIncompleteTasksWithoutUpload || allDocumentsCheckedAndUploaded;
  }

  void showPaymentConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Konfimasyon Pèman"),
          content: Text(
              "Ou chwazi $selectedPaymentMethod kòm metòd pèman. Kontinye ak Pèman an?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Pèman an fèt ak siksè!")),
                );
                Navigator.pop(context);
              },
              child: Text("Peye"),
            ),
          ],
        );
      },
    );
  }
}