import 'package:eassistance/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:eassistance/models/user.dart';
import 'package:eassistance/services/session.dart';

class PaymentPage extends StatefulWidget {
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // Simulated list of payment data
  final List<Map<String, dynamic>> payments = [
    {
      'service': 'Asistans Imigrasyon',
      'amount': 200.00,
      'date': '01-12-2024',
      'status': 'Peye',
      'details': 'Pèman pou sèvis asistans dokiman imigrasyon.'
    },
    {
      'service': 'Applikasyon Viza',
      'amount': 150.00,
      'date': '25-11-2024',
      'status': 'An atant',
      'details': 'Pèman pou pwosesis frè aplikasyon viza.'
    },
    {
      'service': 'Konsiltasyon Etid Aletranje',
      'amount': 300.00,
      'date': '20-11-2024',
      'status': 'Echwe',
      'details': 'Pèman konsiltasyon akademik ak preparasyon dokiman.'
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
        title: Text('Lis Pèman'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: payments.length,
          itemBuilder: (context, index) {
            final payment = payments[index];
            return buildPaymentCard(payment);
          },
        ),
      ),
    ) : LoadingPage();
  }

  // Build individual payment card
  Widget buildPaymentCard(Map<String, dynamic> payment) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(
          Icons.payment,
          color: getStatusColor(payment['status']),
          size: 36,
        ),
        title: Text(payment['service']),
        subtitle: Text(
          "Montan: \$${payment['amount'].toStringAsFixed(2)}\n"
              "Dat: ${payment['date']}\n"
              "Stati: ${payment['status']}",
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          showPaymentDetails(payment);
        },
      ),
    );
  }

  // Show payment details in a dialog
  void showPaymentDetails(Map<String, dynamic> payment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(payment['service']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Montan: \$${payment['amount'].toStringAsFixed(2)}"),
              Text("Dat: ${payment['date']}"),
              Text("Stati: ${payment['status']}"),
              SizedBox(height: 10),
              Text(payment['details']),
            ],
          ),
          actions: [
            if (payment['status'] == 'Echwe') ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  retryPayment(payment);
                },
                child: Text("Reseye"),
              ),
            ],
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Fèmen"),
            ),
          ],
        );
      },
    );
  }

  // Retry payment function (simulated)
  void retryPayment(Map<String, dynamic> payment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Retrying payment for ${payment['service']}...",
        ),
      ),
    );

    // Simulate a retry process (replace with actual logic if needed)
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        payment['status'] = 'Paid'; // Update payment status
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Payment for ${payment['service']} was successful!"),
        ),
      );
    });
  }

  // Get color based on payment status
  Color getStatusColor(String status) {
    switch (status) {
      case 'Peye':
        return Colors.green;
      case 'An atant':
        return Colors.orange;
      case 'Echwe':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
