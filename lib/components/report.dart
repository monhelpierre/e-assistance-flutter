import 'package:flutter/material.dart';
import 'package:eassistance/models/user.dart';
import 'package:eassistance/constant/session.dart';
import 'package:eassistance/services/report.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  UserModel? session = null;
  final List<Map<String, String>> _reports = reportsList;
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

  void _addReport(String title, String description) {
    setState(() {
      _reports.add({"title": title, "description": description});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rapò'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rapò Resan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: _reports.length,
                itemBuilder: (context, index) {
                  Map<String, String> report = _reports[index];

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(
                        Icons.report,
                        color: Colors.blue,
                      ),
                      title: Text(report['title']!, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(report['description']!),
                      onTap: () {

                      },
                    ),
                  );
                },
              ),
            ),

            ElevatedButton(
              onPressed: () {
                _addReport("Rapò Mansyèl", "Rapò mansyel pou pèfòmans asistans.");
              },
              child: Text('Ajoute Yon Nouvo Rapò'),
            ),
            ElevatedButton(
              onPressed: () {
                _addReport("Angajman Itilizatè", "Rapò sou angajman itilizatè sou platfòm lan.");
              },
              child: Text('Ajoute Yon Nouvo Angajman Itilizatè'),
            ),
          ],
        ),
      ),
    );
  }
}