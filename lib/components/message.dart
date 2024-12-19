import 'package:flutter/material.dart';
import 'package:eassistance/models/user.dart';
import 'package:eassistance/services/session.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  // Controller to manage input field for typing messages
  final TextEditingController _messageController = TextEditingController();

  // List to simulate messages (user and admin)
  final List<Map<String, String>> _messages = [
    {"sender": "admin", "message": "Hello! How can I assist you today?"},
    {"sender": "user", "message": "I need help with my account."},
  ];

  final SessionManager _sessionManager = SessionManager();
  UserModel? session = null;

  @override
  void initState() async{
    super.initState();

    UserModel? session = await _sessionManager.getSession();
    if(session == null){
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }else{
      this.session = session;
    }
  }

  // Function to send a new message
  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add({"sender": "user", "message": _messageController.text});
        _messageController.clear();
      });
      // Simulate admin reply after a short delay
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _messages.add({"sender": "admin", "message": "Can you provide more details?"});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mesaj'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Chat messages list
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  Map<String, String> message = _messages[index];
                  bool isUser = message['sender'] == 'user';

                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      margin: EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue[200] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        message['message']!,
                        style: TextStyle(color: isUser ? Colors.white : Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Input field and send button
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
