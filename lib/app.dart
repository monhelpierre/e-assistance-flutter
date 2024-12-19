import 'package:firebase_auth/firebase_auth.dart';
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
  int _currentIndex = 2;
  User? user;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      ProcessPage(user:user),
      AssistancePage(user:user, requiredDocuments: []),
      HomePage(user:user, updateIndex: (int index) {
        setState(() {
          _currentIndex = index;
        });
      }),
      PaymentPage(user:user),
      SettingPage(user:user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)?.settings.arguments;

    if(user is User){
      setState(() {
        _pages = [
          ProcessPage(user:user),
          AssistancePage(user:user, requiredDocuments: []),
          HomePage(user:user, updateIndex: (int index) {
            setState(() {
              _currentIndex = index;
            });
          }),
          PaymentPage(user:user),
          SettingPage(user:user),
        ];
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('eassistance'),
        backgroundColor: Colors.grey[600],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[60],
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
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}