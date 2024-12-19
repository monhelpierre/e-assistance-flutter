import 'package:flutter/material.dart';
import 'package:eassistance/models/user.dart';
import 'package:eassistance/services/session.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  // Example state: counter for demonstration
  int _counter = 0;

  // Function to update the state
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  final SessionManager _sessionManager = SessionManager();
  UserModel? session = null;

  @override
  void initState() async{
    super.initState();

    UserModel? session = await _sessionManager.getSession();
    if(session == null){
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }else{
      this.session = session;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analitik'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header for analytics page
            Text(
              'Analytics Dashboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Display some dynamic content
            Text(
              'Total Views: $_counter',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),

            // Button to simulate a change in analytics data (counter)
            ElevatedButton(
              onPressed: _incrementCounter,
              child: Text('Increase Views'),
            ),
            SizedBox(height: 20),

            // Example Graph or Chart Placeholder
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[200],
              child: Center(
                child: Text(
                  'Graph/Chart Goes Here',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
