import 'package:eassistance/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:eassistance/pages/assistance.dart';
import 'package:eassistance/models/user.dart';
import 'package:eassistance/services/session.dart';

class ProcessPage extends StatefulWidget {
  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {

  final List<Map<String, dynamic>> processes = [
    {
      "title": "Bous Lisans - Kanada",
      "type": "Opòtinite Etid",
      "startDate": "15-01-2024",
      "endDate": "30-04-2024",
      "status": "Ankou",
      "description":
      "Yon pwogram bous pou etidyan entènasyonal kap chèche genyen yon lisans Kanada. Frè enskripsyon, kote pouw rete e yon montan chak mwa enkli.",
      "documents": [
        {"Paspò": ["Valid"]},
        {"Relvedenòt Nivo Klasik": ["Legalize"]},
        {"Tès Metriz Lang (IELTS/TOEFL)": ["Disponib"]},
        {"Lèt Rekòmandayon": ["Disponib"]},
        {"Pwopozisyon Pwojèt Etid": ["Disponib"]}
      ],
    },
    {
      "title": "Rechèch Doktora - Etazini",
      "type": "Opòtinite Etid",
      "startDate": "01-03-2024",
      "endDate": "30-06-2024",
      "status": "Fèmen",
      "description":
      "Yon pwogram rechèch doktora ak bous konplè nan Entelijans Atifisyèl ke yon gwo inivèsite Etazini ofri.",
      "documents": [
        {"Paspò":["Valid"]},
        {"Relvedenòt Metriz":["Legalize"]},
        {"CV":["Disponib"]},
        {"Avan Pwojè":["Disponib"]},
        {"Lèt Rekòmandasyon":["Disponib"]},
      ],
    },
    {
      "title": "Viza Travay - Almay",
      "type": "Pwojè Imigrasyon",
      "startDate": "01-02-2024",
      "endDate": "31-12-2024",
      "status": "Ankou",
      "description":
      "Yon pwogram imigrasyon pou travayè ki gen talan kap chèche opòtinite travay an Almay. Sponnsò viza enkli ak èd pou ede chanje peyi.",
      "documents": [
        {"Paspò" : ["Valid"]},
        {"Sètifika Lisans": ["Legalize", "Notarye"]},
        {"Kontra Travay": ["Disponib"]},
        {"Pwèv Mwayen Finansman": ["Disponib"]},
        {"Sètifika Lang (Alman/Anglè)" : ["Disponib"]},
      ],
    },
    {
      "title": "Echanj Etidyan - Lafrans",
      "type": "Opòtinite Vwayaj",
      "startDate": "01-09-2024",
      "endDate": "30-06-2025",
      "status": "Ankou",
      "description":
      "Yon pwogram kiltirèl e akademik pou etidyan pou eksperimante edikasyon ak kilti lafrans pou yon dire yon lane akademik.",
      "documents": [
        {"Paspò" : ["Valid"]},
        {"Sètifika Enskripsyon": ["Disponib"]},
        {"Tès Metriz Lang (Fransè/Anglè)": ["Disponib"]},
        {"Lèt Motivasyon": ["Disponib"]},
        {"Lèt Rekòmandasyon": ["Disponib"]},
      ],
    },
  ];

  UserModel? session = null;
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return session != null? Scaffold(
      appBar: AppBar(
        title: Text('Pwosesis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: processes.length,
          itemBuilder: (context, index) {
            final process = processes[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              child: ListTile(
                title: Text(
                  process['title'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tip: ${process['type']}"),
                    Text(
                        "Peryòd: ${process['startDate']} to ${process['endDate']}"),
                    Text("Stati: ${process['status']}"),
                  ],
                ),
                trailing: Icon(Icons.info_outline),
                onTap: () {
                  // Navigate to process details page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProcessDetailsPage(
                        process: process
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    ) : LoadingPage();
  }
}

class ProcessDetailsPage extends StatelessWidget {
  final Map<String, dynamic> process;
  const ProcessDetailsPage({super.key, required this.process});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(process['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title of the Process
            Text(
              process['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Description
            Text(
              process['description'],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Details Section
            Text(
              "Details:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text("Tip: ${process['type']}"),
            Text("Dat Kòmansman: ${process['startDate']}"),
            Text("Dat Finisman: ${process['endDate']}"),
            Text("Stati: ${process['status']}"),
            SizedBox(height: 20),

            // Required Documents Section
            Text(
              "Dokiman Egzije:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...process['documents'].map<Widget>((doc) {
              String docKey = doc.keys.first; // Get the key (document type)
              return ListTile(
                leading: Icon(Icons.document_scanner),
                title: Text(docKey), // Display the key
              );
            }).toList(),
            Spacer(),
            // Buttons: Apply and Ask Assistance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Apply Button
                ElevatedButton.icon(
                  onPressed: () {
                    // Check if the process has an apply link
                    final applyLink = process['applyLink'];
                    if (applyLink != null) {
                      // Open the apply link
                      launchURL(applyLink);
                    } else {
                      // Show a message if no link is available
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Pa gen lyen pou enskri.")),
                      );
                    }
                  },
                  icon: Icon(Icons.open_in_new),
                  label: Text("Aplike"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                // Ask Assistance Button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssistancePage(
                          requiredDocuments: process['documents'],
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.help_outline),
                  label: Text("Mande Asistans"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to launch external URLs
  void launchURL(String url) async {

  }
}
