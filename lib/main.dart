import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_dash/Authentification/Authentification.dart';
import 'package:my_dash/Layout/PageChartDetailedPerf.dart';
import 'package:my_dash/Naviguation%20menu/PageMenu.dart';
import 'package:provider/provider.dart';
import 'package:my_dash/services/firebase_api.dart'; // Import your Firebase API file here
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // Import for controlling screen orientation
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:my_dash/class/connectivity_mixin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:
          "AIzaSyA4dvarN22kDoM7zHlfqR8HNGmByfrHkKY", // paste your api key here
      appId:
          "1:256849183307:android:b94803a557072c2b8103ce", //paste your app id here
      messagingSenderId: "256849183307", //paste your messagingSenderId here
      projectId: "my-dash-a67f9", //paste your project id here
    ),
  );

  // Retrieve the FCM token
  String? fcmToken = await FirebaseMessagingService().getToken();
  print('FCM Token: $fcmToken');

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'My Dash',
      home: MyHomePage(),
    );
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Widget build1(BuildContext context) {
    return MaterialApp(
      title: 'My Dash',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        hintColor: Colors.orange,
        indicatorColor: Colors.blueGrey,
      ),
      darkTheme: ThemeData.dark(),
      home: const PageA(title: 'My Dash'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with ConnectivityMixin {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
    // Set the preferred orientations to portrait only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // Reset the preferred orientations to allow all orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  Future<void> _checkAuthStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? authToken = prefs.getString('authToken');
    String? userJson = prefs.getString('userinfo');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PageA(title: 'My Dash')),
    );
    // if (isLoggedIn && authToken != null && userJson != null) {
    //   Map<String, dynamic> user = jsonDecode(userJson);

    //   if (user['entity_type_name'] == 'all' ||
    //       (user['entity_name'] is List &&
    //           user['entity_name'].contains('all'))) {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => PageA(title: '')),
    //     );
    //   } else if (user['entity_name'] is List &&
    //       user['entity_name'].isNotEmpty) {
    //     String entityName = user['entity_name']
    //         [0]; // Assuming entity_name is a list and we take the first element
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) =>
    //               PageChartDetailedPerf(entityName: entityName)),
    //     );
    //   } else {
    //     // Handle the case where entity_name is not a list or is empty
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => PageA(title: 'My Dash')),
    //     );
    //   }
    // } else {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => SignInPage()),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class AnotherPage extends StatefulWidget {
  @override
  _AnotherPageState createState() => _AnotherPageState();
}

class _AnotherPageState extends State<AnotherPage> with ConnectivityMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Another Page'),
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: Center(
        child: Text('Another Page Content'),
      ),
    );
  }
}
