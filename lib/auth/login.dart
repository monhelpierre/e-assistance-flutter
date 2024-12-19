import 'package:eassistance/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:eassistance/services/session.dart';
import 'package:eassistance/models/user.dart';

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

  Future<User?> signInWithEmailPassword(BuildContext context) async {
    try {

      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user =  userCredential.user;
      Navigator.pop(context, '/');

    } catch (e) {
      print("Error during sign-in: $e");
    }
  }

  Future<User?> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  Future<void> signInWithGoogle() async {
    try {
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

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {

    return notCheckingSession ? Scaffold(
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 210),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              // Circle image icon
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/assist.png'), // Replace with your image asset
                backgroundColor: Colors.grey[200],
              ),
              SizedBox(height: 30),
              // Login form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Imel',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Modpas',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Forgot password link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/forgot');
                        },
                        child: Text(
                          'Bliye modpas? Reyinisyalize!',
                          style: TextStyle(color: Colors.red[800]),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Login button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
                            signInWithEmailPassword(context);
                          }else{
                            print("Password and Email should not be empty");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5), // Adjust this value for squareness
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text('Konekte'),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Google login button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          signInWithGoogle();
                        },
                        icon: Image.asset(
                          'assets/google.png', // Add a Google logo asset
                          height: 40,
                        ),
                        label: Text('Konekte ak Google'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          side: BorderSide(color: Colors.grey),

                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ) : LoadingPage();
  }
}