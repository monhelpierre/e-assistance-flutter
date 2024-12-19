import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eassistance/components/analytic.dart';
import 'package:eassistance/components/calendar.dart';
import 'package:eassistance/components/message.dart';
import 'package:eassistance/components/notification.dart';
import 'package:eassistance/components/report.dart';
import 'package:eassistance/components/taks.dart';

class HomePage extends StatefulWidget {
  final User? user;
  final Function(int) updateIndex;

  const HomePage({super.key, required this.user, required this.updateIndex});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        backgroundImage: NetworkImage('${widget.user?.photoURL}'), // Example profile image
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.user?.displayName}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${widget.user?.email}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Dashboard Title
              Text(
                'Aksyon Rapid',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Dashboard Menu Items
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
                      Colors.blue, context, null
                  ),
                  _buildDashboardCard(
                      'Asistans',
                      Icons.support_agent,
                      Colors.orange, context, null
                  ),
                  _buildDashboardCard(
                      'Rapò',
                      Icons.bar_chart,
                      Colors.teal, context,
                      ReportPage()
                  ),
                  _buildDashboardCard(
                      'Notifikasyon',
                      Icons.notifications_active,
                      Colors.red, context,
                      NotificationsPage()
                  ),
                  _buildDashboardCard(
                      'Analitik',
                      Icons.analytics,
                      Colors.indigo, context,
                      AnalyticsPage()
                  ),
                  _buildDashboardCard(
                      'Kalandriye',
                      Icons.calendar_today,
                      Colors.deepOrange, context,
                      CalendarPage()
                  ),
                  _buildDashboardCard(
                      'Tach',
                      Icons.task_alt,
                      Colors.cyan, context,
                      TaskPage()
                  ),
                  _buildDashboardCard(
                      'Mesaj',
                      Icons.message,
                      Colors.pink, context,
                      MessagePage()
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create dashboard cards
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
