import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Opaque background
          Container(
            color: Colors.grey[200],
            width: double.infinity,
            height: double.infinity,
          ),
          // Centered Spinner
          Center(
            child: SpinKitFoldingCube(
              color: Colors.blue,
              size: 50.0,
            ),
          ),
        ],
      ),
    );
  }
}
