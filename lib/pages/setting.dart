import 'package:eassistance/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:eassistance/models/user.dart';
import 'package:eassistance/services/session.dart';

class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String? name;
  String? email;
  String? phone;

  String selectedProgram = "Imigrasyon";
  String selectedLevel = "Lisans";

  final SessionManager _sessionManager = SessionManager();
  UserModel? session = null;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    UserModel? session = await _sessionManager.getSession();
    if (session == null) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } else {
      setState(() {
        this.session = session;
      });
    }
  }

  Future<void> _signOut() async {
    await _sessionManager.clearSession();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return session != null? Scaffold(
      appBar: AppBar(
        title: Text('Paramèt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Section: User Info
            buildSectionTitle("Enfòmasyon Itilizatè"),
            buildTextField("Non", session?.displayName, (value) {
              setState(() {
                name = value;
              });
            }),
            SizedBox(height: 12),
            buildTextField("Imel", session?.email, (value) {
              setState(() {
                email = value;
              });
            }),
            SizedBox(height: 12),
            buildTextField("Telefòn", session?.phoneNumber, (value) {
              setState(() {
                phone = value;
              });
            }),

            SizedBox(height: 20),

            // Section: Program Selection
            buildSectionTitle("Seleksyon Pwogram"),
            buildDropdown(
              "Tip Pwogram",
              ["Imigrasyon", "Pwogram Etid"],
              selectedProgram,
                  (value) {
                setState(() {
                  selectedProgram = value!;
                });
              },
            ),
            SizedBox(height: 12),
            if (selectedProgram == "Pwogram Etid")
              buildDropdown(
                "Study Level",
                ["Lisans", "Metriz", "Doktora"],
                selectedLevel,
                    (value) {
                  setState(() {
                    selectedLevel = value!;
                  });
                },
              ),

            SizedBox(height: 20),

            // Section: Other Settings
            buildSectionTitle("Lòt Paramèt"),
            SwitchListTile(
              title: Text("Aktive Notifikasyon"),
              value: true,
              onChanged: (value) {
                // Handle notification toggle
              },
            ),

            SizedBox(height: 20),

            // Save Button
            ElevatedButton(
              onPressed: () {
                saveSettings();
              },
              child: Text("Anrejistre Paramèt"),
            ),

            SizedBox(height: 20),

            // Sign Out Button
            ElevatedButton(
              onPressed: () {
                _signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Button color
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                "Dekonekte",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ) : LoadingPage();
  }

  // Build a section title
  Widget buildSectionTitle(String? title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title as String,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Build a text field for user info
  Widget buildTextField(
      String label, String? initialValue, Function(String) onChanged) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      controller: TextEditingController(text: initialValue)
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: initialValue != null ? initialValue.length : 0)),
      onChanged: onChanged,
    );
  }

  // Build a dropdown for program selection
  Widget buildDropdown(String label, List<String> options, String value,
      Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      value: value,
      items: options
          .map((option) => DropdownMenuItem<String>(
        value: option,
        child: Text(option),
      ))
          .toList(),
      onChanged: onChanged,
    );
  }

  // Save settings function
  void saveSettings() {
    // Simulate saving the settings
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Paramèt anrejistre ak siksè.",
        ),
      ),
    );
  }
}

