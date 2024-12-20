import 'package:flutter/material.dart';
import 'package:eassistance/models/user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:eassistance/constant/loading.dart';
import 'package:eassistance/services/process.dart';
import 'package:eassistance/pages/assistance.dart';
import 'package:eassistance/constant/session.dart';

class ProcessPage extends StatefulWidget {
  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  UserModel? session = null;
  final SessionManager _sessionManager = SessionManager();
  final List<Map<String, dynamic>> processes = processesList;

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

  @override
  Widget build(BuildContext context) {
    return session != null? Scaffold(
      appBar: AppBar(
        title: Text('Pwosesis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: processes.length,
          itemBuilder: (context, index) {
            final process = processes[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              child: ListTile(
                title: Text(
                  process['title'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tip: ${process['type']}"),
                    Text(
                        "Peryòd: ${process['startDate']} to ${process['endDate']}"),
                    Text("Stati: ${process['status']}"),
                  ],
                ),
                trailing: Icon(Icons.info_outline),
                onTap: () {
                  // Navigate to process details page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProcessDetailsPage(
                        process: process
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    ) : LoadingPage();
  }
}

class ProcessDetailsPage extends StatelessWidget {
  final Map<String, dynamic> process;
  const ProcessDetailsPage({super.key, required this.process});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(process['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              process['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            Text(
              process['description'],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            Text(
              "Details:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Tip: ${process['type']}"),
            Text("Dat Kòmansman: ${process['startDate']}"),
            Text("Dat Finisman: ${process['endDate']}"),
            Text("Stati: ${process['status']}"),
            SizedBox(height: 20),

            Text(
              "Dokiman Egzije:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...process['documents'].map<Widget>((doc) {
              String docKey = doc.keys.first; // Get the key (document type)
              return ListTile(
                leading: Icon(Icons.document_scanner),
                title: Text(docKey), // Display the key
              );
            }).toList(),
            Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async{
                    final applyLink = process['applyLink'];
                    if (applyLink != null) {
                      await launchUrl(Uri.parse(applyLink), mode: LaunchMode.platformDefault);
                    } else if (applyLink == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Lyen an poko pa disponib.")),
                      );
                    }
                  },
                  icon: Icon(Icons.open_in_new),
                  label: Text("Plis Enfo & Aplike"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    if(process['applyLink'] == null){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Wap jwenn asistans lè lyen pou enskri an disponib.")),
                      );
                    }else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssistancePage(
                            requiredDocuments: process['documents'],
                          ),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.help_outline),
                  label: Text("Mande Asistans"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}