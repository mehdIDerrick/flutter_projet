import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_dash/Layout/PageChartDetailedPerf.dart';
import 'package:my_dash/services/activation_client_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import '../Naviguation menu/PageMenu.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signInWithPhoneNumber(BuildContext context) async {
    String phoneNumber = _phoneNumberController.text.trim();
    String password = _passwordController.text.trim();

    // Save login credentials temporarily for the API call
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('msisdn', phoneNumber);
    await prefs.setString('password', password);

    ApiService apiService = ApiService();

    try {
      // Attempt to fetch data to verify authentication
      Map<String, dynamic> fetchedUser = await apiService.fetchUser();
      // Simulate token generation
      Map<String, dynamic> user = fetchedUser["msisdn"];
      String token = _generateAuthToken(phoneNumber);
      // Convert the map to a JSON string
      String userJson = jsonEncode(user);

// Store the JSON string in SharedPreferences
      await prefs.setString('userinfo', userJson);
      // Save login status and token
      await _saveLoggedInStatus(phoneNumber, token, password);

      if (user['entity_type_name'] == 'all' ||
          user['entity_name'].contains('all')) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PageA(title: '')),
        );
      } else {
        String entityName = user['entity_name']
            [0]; // Assuming entity_name is a list and we take the first element
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PageChartDetailedPerf(entityName: entityName)),
        );
      }
    } catch (e) {
      // Display error message and remain on the same page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to sign in: $e")),
      );
    }
  }

  String _generateAuthToken(String phoneNumber) {
    // Dummy token generation logic
    var rand = Random();
    return List.generate(20, (index) => rand.nextInt(100).toString()).join();
  }

  Future<void> _saveLoggedInStatus(
      String phoneNumber, String token, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('authToken', token);
    await prefs.setString('msisdn', phoneNumber);
    await prefs.setString('password', password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hello MY DASH',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/Orange_small_logo.png',
              height: 100,
              width: 100,
            ),
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _signInWithPhoneNumber(context),
              child: Text('Sign In', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
