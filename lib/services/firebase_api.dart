
// import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class FirebaseApi {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   void configureFirebaseMessaging() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("onMessage: $message");
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("onLaunch / onResume: $message");
//     });
//   }

//   Future<String?> getToken() async {
//     return await _firebaseMessaging.getToken();
//   }
// }

// class FirebaseNotificationPage extends StatelessWidget {
//   final FirebaseApi firebaseApi = FirebaseApi();

//   FirebaseNotificationPage() {
//     // Configure Firebase Messaging service
//     firebaseApi.configureFirebaseMessaging();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Firebase Messaging Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: NotificationPage(firebaseApi: firebaseApi),
//     );
//   }
// }

// class NotificationPage extends StatefulWidget {
//   final FirebaseApi firebaseApi;

//   NotificationPage({required this.firebaseApi});

//   @override
//   _NotificationPageState createState() => _NotificationPageState();
// }

// class _NotificationPageState extends State<NotificationPage> {
//   String? fcmToken;

//   @override
//   void initState() {
//     super.initState();
//     // Get FCM token when the widget is initialized
//     getToken();
//   }

//   // Method to get FCM token
//   void getToken() async {
//     String? token = await widget.firebaseApi.getToken();
//     print(token);
//     setState(() {
//       fcmToken = token;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter Firebase Messaging Demo'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text('Ready to receive notifications!'),
//             SizedBox(height: 20),
//             if (fcmToken != null) Text('FCM Token: $fcmToken'),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  void configureFirebaseMessaging() {
    // Request permission for receiving notifications
    _firebaseMessaging.requestPermission();

    // Handle incoming messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    // Handle messages when the app is in background or terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Here, you could navigate to a specific screen, for example
    });
  }
}