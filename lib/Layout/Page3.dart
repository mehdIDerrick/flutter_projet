
// import 'package:calendar_timeline/calendar_timeline.dart';
// import 'package:flutter/material.dart';

// class Page3 extends StatefulWidget {
//   const Page3({Key? key}) : super(key: key);

//   @override
//   State<Page3> createState() => Page3State();
// }

// class Page3State extends State<Page3> {
//   late DateTime _selectedDate;

//   @override
//   void initState() {
//     super.initState();
//     _resetSelectedDate();
//   }

//   void _resetSelectedDate() {
//     _selectedDate = DateTime.now();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 255, 255, 255),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             CalendarTimeline(
//               showYears: true,
//               initialDate: _selectedDate,
//               firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)), // 5 years ago
//               lastDate: DateTime.now().add(const Duration(days: 365 * 4)),
//               onDateSelected: (date) => setState(() => _selectedDate = date),
//               leftMargin: 20,
//               monthColor: const Color.fromARGB(179, 0, 0, 0),
//               dayColor: const Color.fromARGB(179, 0, 0, 0),
//               dayNameColor: const Color.fromARGB(179, 0, 0, 0),
//               activeDayColor: const Color.fromARGB(179, 0, 0, 0),
//               activeBackgroundDayColor: Colors.redAccent[100],
//               dotsColor: const Color(0xFF333A47),
//               selectableDayPredicate: (date) {
//                 final fiveYearsAgo = DateTime.now().subtract(const Duration(days: 365 * 5));
//                 return date.isAfter(fiveYearsAgo) && date.day != 23;
//               },
//               locale: 'en',
//             ),
//             const SizedBox(height: 20),
//             Center(
//               child: Text(
//                 'Selected date is ${_formatDate(_selectedDate)}',
//                 style: const TextStyle(color: Colors.white),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     final now = DateTime.now();
//     if (date.year == now.year && date.month == now.month && date.day == now.day) {
//       return 'Today';
//     } else {
//       return '${_getDayName(date)}, ${date.day}';
//     }
//   }

//   String _getDayName(DateTime date) {
//     switch (date.weekday) {
//       case DateTime.monday:
//         return 'Monday';
//       case DateTime.tuesday:
//         return 'Tuesday';
//       case DateTime.wednesday:
//         return 'Wednesday';
//       case DateTime.thursday:
//         return 'Thursday';
//       case DateTime.friday:
//         return 'Friday';
//       case DateTime.saturday:
//         return 'Saturday';
//       case DateTime.sunday:
//         return 'Sunday';
//       default:
//         return '';
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_login_template/flutter_login_template.dart';

// class Page3 extends StatefulWidget {
//   @override
//   Page3State createState() => Page3State();
// }

// enum _State {
//   signIn,
//   signUp,
//   forgot,
//   confirm,
//   create,
// }

// class Page3State extends State<Page3> {
//   late LoginTemplateStyle style;
//   _State state = _State.signIn;

//   @override
//   void initState() {
//     style = LoginTemplateStyle.defaultTemplate;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var logo = Icon(
//       Icons.android_rounded,
//       size: 80,
//     );

//     var signInPage = LoginTemplateSignInPage(
//       logo: logo,
//       style: style,
//       onPressedSignIn: () {},
//       onPressedSignUp: () {
//         setState(() {
//           state = _State.signUp;
//         });
//       },
//       onPressedForgot: () {
//         setState(() {
//           state = _State.forgot;
//         });
//       },
//       term: LoginTemplateTerm(
//         style: style,
//         onPressedTermOfService: () {},
//         onPressedPrivacyPolicy: () {},
//       ),
//     );

//     var signUpPage = LoginTemplateSignUpPage(
//       logo: logo,
//       style: style,
//       onPressedSignIn: () {
//         setState(() {
//           state = _State.signIn;
//         });
//       },
//       onPressedSignUp: () {
//         setState(() {
//           state = _State.confirm;
//         });
//       },
//       term: LoginTemplateTerm(
//         style: style,
//         onPressedTermOfService: () {},
//         onPressedPrivacyPolicy: () {},
//       ),
//     );

//     var forgotPasswordPage = LoginTemplateForgotPasswordPage(
//         logo: logo,
//         style: style,
//         onPressedNext: () {
//           setState(() {
//             state = _State.confirm;
//           });
//         });

//     var confirmCodePage = LoginTemplateConfirmCodePage(
//       logo: logo,
//       style: style,
//       onPressedNext: () {
//         setState(() {
//           state = _State.create;
//         });
//       },
//       onPressedResend: () {},
//     );

//     var createPassword = LoginTemplateCreatePasswordPage(
//       logo: logo,
//       style: style,
//       errorTextPassword:
//           'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source.',
//       onPressedNext: () {
//         setState(() {
//           state = _State.signIn;
//         });
//       },
//     );

//     Widget body;
//     switch (state) {
//       case _State.signUp:
//         body = signUpPage;
//         break;
//       case _State.forgot:
//         body = forgotPasswordPage;
//         break;
//       case _State.confirm:
//         body = confirmCodePage;
//         break;
//       case _State.create:
//         body = createPassword;
//         break;
//       case _State.signIn:
//       default:
//         body = signInPage;
//         break;
//     }

//     return MaterialApp(
//       title: 'Example',
//       theme: ThemeData(
//         // Set the background color to white
//         scaffoldBackgroundColor: Colors.white,
//         colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
//             .copyWith(secondary: Colors.orangeAccent),
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text(''),
//         ),
//         body: SingleChildScrollView(
//           child: body,
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:my_dash/services/firebase_api.dart';
// import 'package:firebase_core/firebase_core.dart';

// class Page3 extends StatefulWidget {
//   @override
//   _Page3State createState() => _Page3State();
// }

// class _Page3State extends State<Page3> {
//   final FirebaseMessagingService firebaseMessagingService =
//       FirebaseMessagingService();

//   String? fcmToken;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize Firebase when the widget is initialized
//     initializeFirebase();
//   }

//   // Method to initialize Firebase
//   void initializeFirebase() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp(
//       options: const FirebaseOptions(
//         apiKey: "AIzaSyA4dvarN22kDoM7zHlfqR8HNGmByfrHkKY",
//         appId: "1:256849183307:android:b94803a557072c2b8103ce",
//         messagingSenderId: "256849183307",
//         projectId: "my-dash-a67f9",
//       ),
//     );
//     // Configure Firebase Messaging service
//     firebaseMessagingService.configureFirebaseMessaging();
//     // Get FCM token
//     getToken();
//   }

//   // Method to get FCM token
//   void getToken() async {
//     String? token = await firebaseMessagingService.getToken();
//     print('FCM Token: $token'); // Print token in the terminal
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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  String? fcmToken;
final _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    initializeFirebase();
    getToken();
  }

  void initializeFirebase() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyA4dvarN22kDoM7zHlfqR8HNGmByfrHkKY",
        appId: "1:256849183307:android:b94803a557072c2b8103ce",
        messagingSenderId: "256849183307",
        projectId: "my-dash-a67f9",
      ),
    );
  }

 void getToken() async {

    String? token = await FirebaseMessaging.instance.getToken();

    setState(() {

      fcmToken = token;

    });

  }
  void sendTokenToServer(String phone, String? token) async {

    print("Sending Phone: $phone with Token: $token");

    try {

      final response = await http.post(

        Uri.parse('https://notificationfirebase.onrender.com/register-token/'),

       headers: <String, String>{

          'Content-Type': 'application/json; charset=UTF-8',

        },

        body: jsonEncode(<String, String>{

          'phone': phone,

          'token': token!,

        }),

      );

 

      if (response.statusCode == 200) {

        print("Data sent successfully");

      } else {

        print("Failed to send data. Error: ${response.body}");

      }

    } catch (e) {

      print("Error sending data: $e");

    }

  }



  void handleSubmit() {

    if (_formKey.currentState!.validate()) {

      if (fcmToken != null) {

        sendTokenToServer(_phoneController.text, fcmToken);

      } else {

        print("FCM token not available yet.");

      }

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text('Flutter Firebase Messaging Demo'),

      ),

      body: Center(

        child: Form(

          key: _formKey,

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[

              TextFormField(

                controller: _phoneController,

                decoration: InputDecoration(labelText: 'Enter your phone number'),

                validator: (value) {

                  if (value == null || value.isEmpty) {

                    return 'Please enter your phone number';

                  }

                  return null;

                },

              ),

              SizedBox(height: 20),

              ElevatedButton(

                onPressed: handleSubmit,

                child: Text('Register Phone and Send Token'),

              ),

            ],

          ),

        ),

      ),

    );

  }

}
