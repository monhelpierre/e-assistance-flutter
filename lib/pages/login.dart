import 'package:flutter/material.dart';
import 'package:eassistance/models/user.dart';
import 'package:eassistance/constant/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eassistance/constant/loading.dart';
import 'package:eassistance/constant/session.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final SessionManager _sessionManager = SessionManager();
  bool notCheckingSession = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    UserModel? session = await _sessionManager.getSession();

    if (session != null) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }else{
      setState(() {
        notCheckingSession = true;
      });
    }
  }

  Future<void> signInWithGoogle() async {
    try {

      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Erè koneksyon.",
            ),
          ),
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        _sessionManager.saveSession(user);
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false, arguments: user);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Erè koneksyon.",
            ),
          ),
        );
      }
    } catch (error) {
      print('Error during Google Sign-In: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return notCheckingSession ? Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo or icon
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/logo.png'),
                  backgroundColor: logoBgColor,
                ),
                SizedBox(height: 30),
                // App title
                Text(
                  'Byenvini Nan Aplikasyon an',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: loginWelcomeTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                // Subtitle
                Text(
                  'Konekte ak kont Google ou pou kontinye',
                  style: TextStyle(
                    fontSize: 16,
                    color: connectToContinueColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                // Google login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: signInWithGoogle,
                    icon: Image.asset(
                      'assets/google.png',
                      height: 24,
                    ),
                    label: Text(
                      'Konekte ak Google',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: buttonBorderColor),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Footer text
                Text(
                  'Siw konekte, ou dakò ak Tèm & Kondisyon e Politik Privasite nou yo.',
                  style: TextStyle(
                    fontSize: 12,
                    color: connectToContinueColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    ) : LoadingPage();
  }
}