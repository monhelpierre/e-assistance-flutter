import 'package:eassistance/app.dart';
import 'package:flutter/material.dart';
import 'package:eassistance/auth/login.dart';
import 'package:eassistance/auth/forget.dart';
import 'package:eassistance/auth/signup.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(); // Initialize Firebase

  /*
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('auth_token');

  if (token != null) {
    print(token);
  } else {
    print("Token not found !");
  }*/

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