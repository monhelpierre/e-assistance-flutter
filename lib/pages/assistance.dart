import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:eassistance/models/user.dart';
import 'package:eassistance/constant/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eassistance/constant/session.dart';
import 'package:eassistance/services/payment.dart';
import 'package:eassistance/constant/loading.dart';
import 'package:eassistance/services/assistance.dart';

class AssistancePage extends StatefulWidget {
  User? user;
  final List<Map<String, dynamic>> requiredDocuments;
  final List<Map<String, dynamic>> previousAssistance = previousAssistanceList;

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
              "Etap 1: Verifye Dokiman Egzije yo",
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

  Widget buildPreviousAssistanceCard(Map<String, dynamic> assistance) {
    String processTitle = assistance['processTitle'];
    List documents = assistance['documents'];

    bool isProcessComplete = documents.every((doc) => doc['isComplete']);
    Color processColor = isProcessComplete ? completeColor : incompleteColor;

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
                  Text(doc['isComplete'] ? 'Dokiman konplè' : 'Dokiman inkonplete'),
                  Text(doc['isFileUploaded'] ? 'Dokiman telechaje' : 'Dokiman pa telechaje'),
                  SizedBox(height: 8),
                  Text("Feedback: ${doc['feedback']}", style: TextStyle(color: userInfoEmailColor)),
                ],
              ),
            );
          }),
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