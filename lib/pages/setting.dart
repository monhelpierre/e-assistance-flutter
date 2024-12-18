import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // User information fields
  String name = "Faniel Frenat";
  String email = "faniel.frenat@gmail.com";
  String phone = "+55 27 98808-1642";

  // Selected options
  String selectedProgram = "Imigrasyon";
  String selectedLevel = "Lisans";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramèt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Section: User Info
            buildSectionTitle("Enfòmasyon Itilizatè"),
            buildTextField("Non", name, (value) {
              setState(() {
                name = value;
              });
            }),
            SizedBox(height: 12),
            buildTextField("Imel", email, (value) {
              setState(() {
                email = value;
              });
            }),
            SizedBox(height: 12),
            buildTextField("Telefòn", phone, (value) {
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
          ],
        ),
      ),
    );
  }

  // Build a section title
  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Build a text field for user info
  Widget buildTextField(
      String label, String initialValue, Function(String) onChanged) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      controller: TextEditingController(text: initialValue)
        ..selection = TextSelection.fromPosition(
            TextPosition(offset: initialValue.length)),
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
