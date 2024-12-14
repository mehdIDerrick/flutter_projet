// import 'package:flutter/material.dart';

// class InAppNotification extends StatelessWidget {
//   final VoidCallback onClose;

//   const InAppNotification({Key? key, required this.onClose}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: GestureDetector(
//           onTap: onClose,
//           child: Container(
//             width: 300,
//             height: 200,
//             decoration: BoxDecoration(
//               color: Colors.blue,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'New notification!',
//                   style: TextStyle(color: Colors.white, fontSize: 20),
//                 ),
//                 SizedBox(height: 16),
//                 IconButton(
//                   onPressed: onClose,
//                   icon: Icon(Icons.close, color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';

// class InAppNotification extends StatelessWidget {
//   final VoidCallback onClose;

//   const InAppNotification({Key? key, required this.onClose}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Container(
//           width: 300,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 10,
//                 offset: Offset(0, 5),
//               ),
//             ],
//           ),
//           child: Stack(
//             children: [
//               Positioned(
//                 right: 0.0,
//                 child: GestureDetector(
//                   onTap: onClose,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Icon(Icons.close, color: Colors.black),
//                   ),
//                 ),
//               ),
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SizedBox(height: 20),
//                   Text(
//                     'Nouveauté',
//                     style: TextStyle(
//                       color: Colors.red,
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   // SizedBox(height: 10),
//                   // Text(
//                   //   'Faites tourner la Roue et Gagnez',
//                   //   style: TextStyle(
//                   //     color: Colors.black,
//                   //     fontSize: 16,
//                   //   ),
//                   //   textAlign: TextAlign.center,
//                   // ),
//                   SizedBox(height: 20),
//                   Image.asset(
//                     'assets/Orange_small_logo.png',
//                     height: 100,
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Add your functionality for spinning the wheel here
//                     },
//                     style: ElevatedButton.styleFrom(
//                       primary: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     child: Text(
//                       'Tourner',
//                       style: const TextStyle(
//                         color: Colors.black, fontSize: 18),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';

// class InAppNotification extends StatelessWidget {
//   final VoidCallback onClose;

//   const InAppNotification({Key? key, required this.onClose}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Container(
//           width: 350,
//           height: 500,  // Adjust the height to match the proportions
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 10,
//                 offset: Offset(0, 5),
//               ),
//             ],
//           ),
//           child: Stack(
//             children: [
//               Positioned(
//                 right: 0.0,
//                 child: GestureDetector(
//                   onTap: onClose,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Icon(Icons.close, color: Colors.black),
//                   ),
//                 ),
//               ),
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(height: 20),
//                   Center(
//                     child: Text(
//                       'Nouveautés',
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Center(
//                     child: Text(
//                       'Le KPI le plus remarquable du jour',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 16,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Center(
//                     child: Image.asset(
//                       'assets/KPInotif.png',
//                       height: 200,  // Adjust the image height
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Center(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Add your functionality for spinning the wheel here
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color.fromARGB(223, 255, 115, 34),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: Text(
//                         'Charger',
//                         style: TextStyle(fontSize: 18, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class InAppNotification extends StatefulWidget {
  final VoidCallback onClose;

  const InAppNotification({Key? key, required this.onClose}) : super(key: key);

  @override
  _InAppNotificationState createState() => _InAppNotificationState();
}

class _InAppNotificationState extends State<InAppNotification> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showKpiValue = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChargerPressed() {
    _controller.forward().then((_) {
      setState(() {
        _showKpiValue = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: 350,
          height: 500, // Adjust the height to match the proportions
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0.0,
                child: GestureDetector(
                  onTap: widget.onClose,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.close, color: Colors.black),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Nouveautés',
                      style: TextStyle(
                        color: const Color.fromARGB(223, 255, 115, 34),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Le KPI le plus remarquable du jour',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ScaleTransition(
                      scale: _animation,
                      child: Image.asset(
                        'assets/KPInotif.png',
                        height: 200, // Adjust the image height
                      ),
                    ),
                  ),
                  if (_showKpiValue) ...[
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        'KPI Value: 75%', // Example KPI value
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _onChargerPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(223, 255, 115, 34),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Charger',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
