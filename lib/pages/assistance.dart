//import 'package:file_picker/file_picker.dart';
import 'package:eassistance/components/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eassistance/models/user.dart';
import 'package:eassistance/services/session.dart';

class AssistancePage extends StatefulWidget {
  User? user;

  final List<Map<String, dynamic>> requiredDocuments;
  final List<Map<String, dynamic>> previousAssistance = [
    {
      'processTitle': 'Process 1',
      'documents': [
        {
          'documentName': 'Dokiman 1',
          'isComplete': true,
          'isFileUploaded': true,
          'feedback': 'Good job, everything is in order.',
        },
        {
          'documentName': 'Dokiman 2',
          'isComplete': false,
          'isFileUploaded': false,
          'feedback': 'File is missing, please upload it.',
        },
      ],
    },
    {
      'processTitle': 'Process 2',
      'documents': [
        {
          'documentName': 'Dokiman 3',
          'isComplete': true,
          'isFileUploaded': false,
          'feedback': 'File needs to be uploaded.',
        },
      ],
    },
  ];

  AssistancePage({super.key, required this.requiredDocuments});

  @override
  _AssistancePageState createState() => _AssistancePageState();
}

class _AssistancePageState extends State<AssistancePage> {
  UserModel? session = null;
  String? selectedPaymentMethod;
  Map<String, List<String>> documentTasks = {};
  Map<String, bool> taskCompletionStatus = {};
  Map<String, bool> documentUploaded = {};
  Map<String, String?> uploadedFiles = {};
  final SessionManager _sessionManager = SessionManager();
  List<String> paymentMethods = ["Kat Kredi", "PayPal", "Transfè Labank", "Moncash", "Pix"];

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
          uploadedFiles[docName] = null; // Initialize as no file uploaded
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

  @override
  Widget build(BuildContext context) {
    return session != null? Scaffold(
      appBar: AppBar(
        title: Text(widget.requiredDocuments.isNotEmpty ? "Mande Asistans" : "Lis Asistans"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: widget.requiredDocuments.isNotEmpty
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Etap 1: Verifye Dokiman Obligatwa yo",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...widget.requiredDocuments.map((doc) {
              return doc.entries.map((entry) {
                return buildDocumentCard(entry.key, entry.value);
              }).toList();
            }).expand((x) => x),
            SizedBox(height: 30),
            if (shouldShowPayment())
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Etap 2: Chwazi Metòd Pèman an",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ...paymentMethods.map((method) => RadioListTile(
                    title: Text(method),
                    value: method,
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value;
                      });
                    },
                  )),
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
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...widget.previousAssistance.map((assistance) {
              return buildPreviousAssistanceCard(assistance);
            }),
          ],
        ),
      ),
    ) : LoadingPage();
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
                  Text("Telechaje Dokiman:", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      //FilePickerResult? result = await FilePicker.platform.pickFiles();
                      //if (result != null) {
                        //setState(() {
                          //uploadedFiles[doc] = result.files.single.name;
                          //documentUploaded[doc] = true;
                        //});
                      //}
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text("Telechaje Dokiman"),
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
                  Text(uploadedFiles[doc]!, style: TextStyle(fontWeight: FontWeight.bold)),
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

  Widget buildPreviousAssistanceCard(Map<String, dynamic> assistance) {
    String processTitle = assistance['processTitle'];
    List documents = assistance['documents'];

    bool isProcessComplete = documents.every((doc) => doc['isComplete']);
    Color processColor = isProcessComplete ? Colors.green : Colors.orange;

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(processTitle, style: TextStyle(color: processColor)),
        children: [
          ...documents.map((doc) {
            return ListTile(
              title: Text(doc['documentName']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doc['isComplete'] ? 'Dokiman konplete' : 'Dokiman inonplete'),
                  Text(doc['isFileUploaded'] ? 'Dokiman telechaje' : 'Dokiman pa telechaje'),
                  SizedBox(height: 8),
                  Text("Feedback: ${doc['feedback']}", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  bool shouldShowPayment() {
    return widget.requiredDocuments.any((doc) {
      return doc.keys.any((docKey) {
        bool tasksNotChecked = documentTasks[docKey]!.any((task) =>
        !(taskCompletionStatus["$docKey-$task"] ?? false));
        bool allTasksCheckedAndUploaded = documentTasks[docKey]!
            .every((task) => taskCompletionStatus["$docKey-$task"] ?? false) &&
            documentUploaded[docKey] == true;

        return tasksNotChecked || allTasksCheckedAndUploaded;
      });
    });
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
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Pèman an fèt ak siksè!")),
                );
              },
              child: Text("Peye"),
            ),
          ],
        );
      },
    );
  }
}