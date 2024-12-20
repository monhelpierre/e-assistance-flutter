import 'package:flutter/material.dart';
import 'package:eassistance/models/user.dart';
import 'package:eassistance/constant/colors.dart';
import 'package:eassistance/constant/loading.dart';
import 'package:eassistance/constant/session.dart';

class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String? name;
  String? email;
  String? phone;
  String defaultLang = "ht";
  String selectedLevel = "Lisans";
  String selectedProgram = "Imigrasyon";

  UserModel? session = null;
  bool? enableNotification = false;
  final SessionManager _sessionManager = SessionManager();

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
        this.enableNotification = session.enableNotification;
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
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

            SizedBox(height: 12),

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

            SizedBox(height: 12),

            buildSectionTitle("Lang Prensipal"),
            buildDropdown(
              "Lang",
              ["ht", "fr", "pt", "en"],
              defaultLang,
                  (value) {
                setState(() {
                  defaultLang = value!;
                });
              },
            ),
            SizedBox(height: 12),

            buildSectionTitle("Lòt Paramèt"),
            SwitchListTile(
              title: Text("Aktive Notifikasyon"),
              value: this.enableNotification as bool,
              onChanged: (value) {
                setState(() {
                  this.enableNotification = ! (this.enableNotification as bool);
                });
              },
            ),
            SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      saveSettings();
                    },
                    child: Text("Anrejistre Paramèt"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _signOut();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: errorColor,
                    ),
                    child: Text(
                      "Dekonekte",
                      style: TextStyle(color: bgColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ) : LoadingPage();
  }

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

  void saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Paramèt anrejistre ak siksè.",
        ),
      ),
    );
  }
}