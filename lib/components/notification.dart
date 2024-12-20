import 'package:flutter/material.dart';
import 'package:eassistance/models/user.dart';
import 'package:eassistance/constant/session.dart';
import 'package:eassistance/services/notification.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  UserModel? session = null;
  final SessionManager _sessionManager = SessionManager();
  final List<Map<String, String>> _notifications = notificationsList;

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
              'Notifikasyon Resan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  Map<String, String> notification = _notifications[index];

                  Color notificationColor;
                  switch (notification['type']) {
                    case "Nouvo Pwosesis":
                      notificationColor = Colors.blue;
                      break;
                    case "Erè Pèman":
                      notificationColor = Colors.red;
                      break;
                    case "Nouvo Mesaj":
                      notificationColor = Colors.green;
                      break;
                    case "Fidbak Asistans":
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

            ElevatedButton(
              onPressed: () {
                _addNotification("Nouvo Pwosesis", "Yon nouvo pwosesis ajoute.");
              },
              child: Text('Ajoute Yon Nouvo Notifikasyon pou Pwosesis'),
            ),
            ElevatedButton(
              onPressed: () {
                _addNotification("Erè Pèman", "Genyen yon pwoblèm nan jere pèman an.");
              },
              child: Text('Ajoute Yon Nouvo Notifikasyon pou Erè Pèman'),
            ),
          ],
        ),
      ),
    );
  }
}