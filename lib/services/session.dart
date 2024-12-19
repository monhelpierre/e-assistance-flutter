import 'dart:convert';
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

  Future<void> deleteSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}

class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final String? phoneNumber;
  final bool isAnonymous;

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.phoneNumber,
    required this.isAnonymous,
  });

  // Convert the UserModel to a map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'isAnonymous': isAnonymous,
    };
  }

  // Create a UserModel from a map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      photoURL: map['photoURL'],
      phoneNumber: map['phoneNumber'],
      isAnonymous: map['isAnonymous'],
    );
  }
}
