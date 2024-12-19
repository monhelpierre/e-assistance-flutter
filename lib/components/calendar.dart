import 'package:flutter/material.dart';
import 'package:eassistance/models/user.dart';
import 'package:eassistance/services/session.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // Example state: Current month displayed
  int _currentMonth = DateTime.now().month;
  int _currentYear = DateTime.now().year;

  // Example list of events for demonstration
  final Map<int, List<String>> _events = {
    1: ['New Year\'s Day', 'Winter Break'],
    5: ['Labor Day'],
    12: ['Christmas'],
  };

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

  // Function to change month
  void _changeMonth(int change) {
    setState(() {
      _currentMonth += change;
      if (_currentMonth > 12) {
        _currentMonth = 1;
        _currentYear++;
      } else if (_currentMonth < 1) {
        _currentMonth = 12;
        _currentYear--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalandriye'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar Header (Month and Year)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_left),
                  onPressed: () => _changeMonth(-1),
                ),
                Text(
                  '$_currentMonth/$_currentYear',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed: () => _changeMonth(1),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Calendar (Placeholder)
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // Days of the Week (Mon, Tue, etc.)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (var day in ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'])
                        Text(day, style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  // Dummy Calendar Dates (You can customize this further)
                  Wrap(
                    spacing: 8,
                    children: List.generate(30, (index) {
                      return Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueAccent.withOpacity(0.2),
                        ),
                        child: Text('${index + 1}'),
                      );
                    }),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Events for the Month
            Text(
              'Events for $_currentMonth/$_currentYear:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...(_events[_currentMonth] ?? [])
                .map((event) => ListTile(
              leading: Icon(Icons.event),
              title: Text(event),
            ))
                ,
          ],
        ),
      ),
    );
  }
}
