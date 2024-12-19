import 'package:flutter/material.dart';
import 'package:eassistance/models/user.dart';
import 'package:eassistance/services/session.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // List of notifications (simulating different types)
  final List<Map<String, String>> _notifications = [
    {"type": "New Process", "message": "A new process has been started."},
    {"type": "Payment Error", "message": "There was an error processing your payment."},
    {"type": "New Message", "message": "You have a new message from the admin."},
    {"type": "Assistance Feedback", "message": "Feedback has been received for your assistance request."},
  ];

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

  // Function to add a new notification
  void _addNotification(String type, String message) {
    setState(() {
      _notifications.add({"type": type, "message": message});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifikasyon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Recent Notifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Notifications list
            Expanded(
              child: ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  Map<String, String> notification = _notifications[index];

                  // Assign a color based on notification type
                  Color notificationColor;
                  switch (notification['type']) {
                    case "New Process":
                      notificationColor = Colors.blue;
                      break;
                    case "Payment Error":
                      notificationColor = Colors.red;
                      break;
                    case "New Message":
                      notificationColor = Colors.green;
                      break;
                    case "Assistance Feedback":
                      notificationColor = Colors.orange;
                      break;
                    default:
                      notificationColor = Colors.grey;
                  }

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: notificationColor,
                        child: Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(notification['type']!, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(notification['message']!),
                    ),
                  );
                },
              ),
            ),

            // Button to simulate a new notification
            ElevatedButton(
              onPressed: () {
                _addNotification("New Process", "A new process has been started.");
              },
              child: Text('Add New Process Notification'),
            ),
            ElevatedButton(
              onPressed: () {
                _addNotification("Payment Error", "There was an error processing your payment.");
              },
              child: Text('Add Payment Error Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
