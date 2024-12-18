import 'package:flutter/material.dart';
import 'package:eassistance/auth/login.dart';
import 'package:eassistance/auth/forget.dart';
import 'package:eassistance/auth/signup.dart';
import 'package:eassistance/app.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

  runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/': (context) => MyApp(),
      '/forgot': (context) => ForgetPage(),
      '/signup': (context) => SignupPage(),
      '/login': (context) => LoginPage(),
    },
  ));
}