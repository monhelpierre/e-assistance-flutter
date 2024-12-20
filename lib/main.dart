import 'package:flutter/material.dart';
import 'package:eassistance/pages/home.dart';
import 'package:eassistance/pages/login.dart';
import 'package:eassistance/pages/payment.dart';
import 'package:eassistance/pages/process.dart';
import 'package:eassistance/pages/setting.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eassistance/constant/colors.dart';
import 'package:eassistance/pages/assistance.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/': (context) => MyApp(),
      '/login': (context) => LoginPage(),
    },
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _currentIndex = 2;
  User? user;

  late final List<Widget> _pages = [
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('eassistance'),
        backgroundColor: bgColor,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: bottomNavBgColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'Pwosesis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: 'Asistans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Akèy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Pèman',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Paramèt',
          ),
        ],
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unselectedItemColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}