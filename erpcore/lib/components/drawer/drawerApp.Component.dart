// import 'package:erp/src/screens/app.Controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class DrawerAppComponent extends StatefulWidget {
//   @override
//   _DrawerAppComponentState createState() => _DrawerAppComponentState();
// }

// class _DrawerAppComponentState extends State<DrawerAppComponent>
//     with SingleTickerProviderStateMixin {
//    late AnimationController _controller;
//   final AppController appController = Get.find();

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     final TextStyle androidStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white);
//     final TextStyle iosStyle = const TextStyle(color: Colors.white);

//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Theme.of(context).primaryColor,
//               Colors.indigo,
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Spacer(),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 24.0, left: 24.0, right: 24.0),
//                 child: Container(
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 36.0, left: 24.0, right: 24.0),
//                 child: Text(
//                   "Menu 1",
//                   style: TextStyle(
//                     fontSize: 22,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w900,
//                   ),
//                 ),
//               ),
              
//               Spacer(),
//               Padding(
//                 padding: const EdgeInsets.only(left: 24.0, right: 24.0),
//                 child: OutlinedButton(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       "Đăng xuất",
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   ),
//                   style: OutlinedButton.styleFrom(
//                     side: BorderSide(color: Colors.white, width: 2.0),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
//                     textStyle: TextStyle(color: Colors.white),
//                   ),
//                   onPressed: () => appController.logout(),
//                 ),
//               ),
//               Spacer(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }