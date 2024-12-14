import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:my_dash/Authentification/Authentification.dart';

mixin ConnectivityMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _showDisconnectedMessage();
    }
  }

  void _showDisconnectedMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Disconnected'),
          content: Text('You are disconnected. Please check your internet connection.'),
          actions: <Widget>[
            TextButton(
              child: Text('Retry'),
              onPressed: () {
                Navigator.of(context).pop();
                _checkConnection();
              },
            ),
            TextButton(
              child: Text('Sign In'),
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToSignInPage();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToSignInPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
  }
}
