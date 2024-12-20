import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:eassistance/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _sessionKey = 'session_token';

  Future<void> saveSession(User? user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, jsonEncode({
      'uid': user?.uid,
      'email': user?.email,
      'displayName': user?.displayName,
      'photoURL': user?.photoURL,
      'phoneNumber': user?.phoneNumber,
      'isAnonymous': user?.isAnonymous,
    }));
  }

  Future<UserModel?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString(_sessionKey);

    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      return UserModel.fromMap(userMap);
    }
    return null;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  Future<UserModel?> getSessionFromLogin(BuildContext context) async {
    UserModel? session = await getSession();
    if(session == null){
      User? user = FirebaseAuth.instance.currentUser;
      if(user != null){
        await saveSession(user);
        return UserModel.fromFirebaseUser(user);
      }
      return null;
    }else {
      return session;
    }
  }
}
