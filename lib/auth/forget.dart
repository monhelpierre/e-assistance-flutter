import 'package:flutter/material.dart';

class ForgetPage extends StatefulWidget {
  const ForgetPage({super.key});

  @override
  State<ForgetPage> createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  final TextEditingController emailController = TextEditingController();

  void loginUser() {
    String email = emailController.text.trim();
    Navigator.pushNamed(context, '/'); // Navigate to home page
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
                    SizedBox(height: 10),
                    // Forgot password link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        child: Text(
                          'Gen kont deja? Konekte!',
                          style: TextStyle(color: Colors.blue[800]),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Login button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle login logic
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5), // Adjust this value for squareness
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text('Reyinisyalize'),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}