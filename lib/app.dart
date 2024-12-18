import 'package:flutter/material.dart';
import 'package:eassistance/pages/home.dart';
import 'package:eassistance/pages/assistance.dart';
import 'package:eassistance/pages/payment.dart';
import 'package:eassistance/pages/process.dart';
import 'package:eassistance/pages/setting.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 2; // Initial index for Home
  late List<Widget> _pages; // Declare _pages without initializing it

  @override
  void initState() {
    super.initState();

    _pages = [
      ProcessPage(),
      AssistancePage(requiredDocuments: []),
      HomePage(updateIndex: (int index) {
        setState(() {
          _currentIndex = index;
        });
      }),
      PaymentPage(),
      SettingPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {

    //final index = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('EASISTANS'),
        backgroundColor: Colors.grey[600],
      ),
      body: _pages[_currentIndex], // Display selected page
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[60],
        type: BottomNavigationBarType.fixed, // Keeps all icons visible
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update selected index
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline), // Process icon
            label: 'Pwosesis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent), // Assistance icon
            label: 'Asistans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30), // Home icon (center, larger)
            label: 'Akèy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment), // Payment icon
            label: 'Pèman',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings), // User icon
            label: 'Paramèt',
          ),
        ],
        selectedItemColor: Colors.blue, // Color of the selected icon
        unselectedItemColor: Colors.grey, // Color of unselected icons
        showSelectedLabels: true, // Show labels for selected items
        showUnselectedLabels: true, // Show labels for unselected items
      ),
    );
  }
}