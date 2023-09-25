// import 'package:car_app/screens/shift_selection%20screen.dart';
// import 'package:flutter/material.dart';
//
// import '../helpers/theme_helper.dart';
//
// class AccidentQuestion extends StatelessWidget {
//   final String selectedCarNumber;
//   final String selectedPrivateNumber;
//   final String carId;
//
//   const AccidentQuestion({Key? key, required this.selectedCarNumber,
//     required this.selectedPrivateNumber, required this.carId}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned(
//             child: Image.asset('assets/bil.png',width: 100,height: 100,),
//             top: 10,
//             left: 10,
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 'Have you had any accidents today?',
//                 style: TextStyle(fontSize: 24),
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         PageRouteBuilder(
//                           pageBuilder: (context, animation, secondaryAnimation) {
//                             return ShiftChoiceScreen(
//                                 selectedCarNumber: selectedCarNumber,
//                                 selectedPrivateNumber: selectedPrivateNumber,
//                                 carId:carId,
//                               accidents:1
//                             );
//                           },
//                           transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                             return FadeTransition(
//                               opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
//                                 CurvedAnimation(
//                                   parent: animation,
//                                   curve: Curves.easeInOut,
//                                 ),
//                               ),
//                               child: child,
//                             );
//                           },
//                           transitionDuration: Duration(seconds: 1),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       primary: Colors.green,
//                       textStyle: TextStyle(
//                           fontSize: 20
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                     ),
//                     child: Text('Yes'),
//                   ),
//                   SizedBox(width: 20),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       primary: Colors.red,
//                       textStyle: TextStyle(
//                           fontSize: 20
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         PageRouteBuilder(
//                           pageBuilder: (context, animation, secondaryAnimation) {
//                             return ShiftChoiceScreen(
//                                 selectedCarNumber: selectedCarNumber,
//                                 selectedPrivateNumber: selectedPrivateNumber,
//                                 carId:carId,
//                                 accidents: 0
//                             );
//                           },
//                           transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                             return FadeTransition(
//                               opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
//                                 CurvedAnimation(
//                                   parent: animation,
//                                   curve: Curves.easeInOut,
//                                 ),
//                               ),
//                               child: child,
//                             );
//                           },
//                           transitionDuration: Duration(seconds: 1),
//                         ),
//                       );
//                     },
//                     child: Text('No'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
