import 'package:flutter/material.dart';
import 'package:eassistance/models/user.dart';
import 'package:eassistance/constant/colors.dart';
import 'package:eassistance/constant/session.dart';
import 'package:eassistance/constant/loading.dart';
import 'package:eassistance/components/report.dart';
import 'package:eassistance/components/message.dart';
import 'package:eassistance/components/calendar.dart';
import 'package:eassistance/components/notification.dart';

class HomePage extends StatefulWidget {
  final Function(int) updateIndex;
  const HomePage({super.key, required this.updateIndex});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel? session = null;
  final SessionManager _sessionManager = SessionManager();
  final int notificationCount = 5; // Example notification count
  final int messageCount = 2; // Example message count

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    UserModel? session = await _sessionManager.getSession();
    if(session == null){
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }else{
      setState(() {
        this.session = session;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return this.session != null? Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info Card
                Card(
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage('${session?.photoURL}'), // Example profile image
                    ),
                    SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${session!.displayName!.length > 13
                              ? "${session?.displayName!.split(' ').first}"
                              : session?.displayName}',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${session!.email!.length > 22
                              ? "${session?.email!.substring(0, 9)}...@${session?.email!.split('@').last}"
                              : session?.email}',
                          style: TextStyle(fontSize: 10, color: userInfoEmailColor),
                        ),
                      ],
                    ),
                    SizedBox(width: 35),
                    // Notifications and Messages
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: Icon(Icons.notifications_active),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => NotificationsPage()),
                            );
                          },
                        ),
                        if (notificationCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.red,
                              child: Text(
                                '$notificationCount',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(width: 5),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: Icon(Icons.message),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MessagePage()),
                            );
                          },
                        ),
                        if (messageCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.red,
                              child: Text(
                                '$messageCount',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
              SizedBox(height: 20),

              Text(
                'Aksyon Rapid',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              GridView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 2,
                ),
                children: [
                  _buildDashboardCard(
                      'Pwosesis',
                      Icons.work_outline,
                      processMenuColor, context, null
                  ),
                  _buildDashboardCard(
                      'Asistans',
                      Icons.support_agent,
                      assistanceMenuColor, context, null
                  ),
                  _buildDashboardCard(
                      'Rapò',
                      Icons.bar_chart,
                      reportMenuColor, context,
                      ReportPage()
                  ),
                  _buildDashboardCard(
                      'Kalandriye',
                      Icons.calendar_today,
                      calendarMenuColor, context,
                      CalendarPage()
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ) : LoadingPage();
  }

  Widget _buildDashboardCard(String title, IconData icon, Color color, BuildContext context, Widget? page) {
    return GestureDetector(
      onTap: () {
        if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }else{
          widget.updateIndex(title.contains("Pwosesis")? 0 : 1);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color.withOpacity(0.1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}