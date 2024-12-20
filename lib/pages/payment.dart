import 'package:flutter/material.dart';
import 'package:eassistance/models/user.dart';
import 'package:eassistance/constant/colors.dart';
import 'package:eassistance/constant/session.dart';
import 'package:eassistance/services/payment.dart';
import 'package:eassistance/constant/loading.dart';

class PaymentPage extends StatefulWidget {
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  UserModel? session = null;
  final List<Map<String, dynamic>> payments = paymentsList;
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

  void retryPayment(Map<String, dynamic> payment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Reseye pèman pou ${payment['service']}...",
        ),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        payment['status'] = 'Peye'; // Update payment status
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Pèman pou ${payment['service']} fèt ak siksè!"),
        ),
      );
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Peye':
        return completeColor;
      case 'An atant':
        return incompleteColor;
      case 'Echwe':
        return errorColor;
      default:
        return defaultColor;
    }
  }
}