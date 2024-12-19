import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  // List of reports (simulating different report types)
  final List<Map<String, String>> _reports = [
    {"title": "Monthly Sales", "description": "Report for monthly sales performance."},
    {"title": "Payment Overview", "description": "Overview of all payments made during the last month."},
    {"title": "User Engagement", "description": "Report on user engagement across the platform."},
    {"title": "System Performance", "description": "Overview of system performance metrics."},
  ];

  // Function to simulate adding a new report
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
            // Title
            Text(
              'Recent Reports',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Reports list
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
                        // Handle tapping on a report (e.g., navigate to report details)
                      },
                    ),
                  );
                },
              ),
            ),

            // Button to simulate adding a new report
            ElevatedButton(
              onPressed: () {
                _addReport("Monthly Sales", "Report for monthly sales performance.");
              },
              child: Text('Add Monthly Sales Report'),
            ),
            ElevatedButton(
              onPressed: () {
                _addReport("User Engagement", "Report on user engagement across the platform.");
              },
              child: Text('Add User Engagement Report'),
            ),
          ],
        ),
      ),
    );
  }
}
