// import 'package:erp/src/configs/activation.Config.dart';
// import 'package:erp/src/configs/appStyle.Config.dart';
// import 'package:erp/src/routers/app.Router.dart';
// import 'package:erp/src/screens/app.Controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class DrawerActComponent extends StatefulWidget {
//   @override
//   _DrawerActComponentState createState() => _DrawerActComponentState();
// }

// class _DrawerActComponentState extends State<DrawerActComponent>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

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
//     Size size = MediaQuery.of(context).size;
//     return Container(
//       color: Colors.white,
//       height: size.height,
//       width: size.width * 0.8,
//       child: Column(
//         children: <Widget>[
//           Expanded(
//             child: ListView(
//               children: [
//                 DrawerHeader(
//                   child: Obx(
//                     () => Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             _buildSwithTypeApp(),
//                           ],
//                         ),
//                         Text(appController.userProfle.value.fullName?? "Tài khoản",
//                           style: TextStyle(fontSize: 20, color: Colors.white)
//                         ),
//                       ],
//                     )
//                   ),
//                   decoration: BoxDecoration(
//                       color: Colors.blue,
//                       image: DecorationImage(
//                           image: AssetImage(
//                               "assets/images/background/erp-blueprinting-banner.png"),
//                           fit: BoxFit.cover)),
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 _buildItemMenu(Icon(Icons.lock), "Đổi mật khẩu", () {
//                   Get.toNamed(AppRouter.actChangePassword);
//                 }),
//                 _buildItemMenu(Icon(Icons.support), "Hỗ trợ", () {
//                   //Get.toNamed(AppRouter.supportApp);
//                 }),
//                 Obx(() => Visibility(
//                   visible: appController.actRecordGlobal.value,
//                   child: _buildItemMenu(Icon(Icons.lock), "Quản lý File", () {
//                     Get.toNamed(AppRouter.actRecordFileMngt);
//                   }),
//                 ))
//               ],
//             ),
//           ),
//           Container(
//             child: Align(
//                 alignment: FractionalOffset.bottomCenter,
//                 // This container holds all the children that will be aligned
//                 // on the bottom and should not scroll with the above ListView
//                 child: Container(
//                     padding: EdgeInsets.all(16.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: <Widget>[
//                         // IconButton(
//                         //   icon: Icon(
//                         //     Icons.settings,
//                         //     color: Colors.black,
//                         //     size: 30,
//                         //   ),
//                         //   onPressed: () {
//                         //     Alert.dialogShow( "Thông báo","Chức năng đang tạm đóng");
//                         //   },
//                         // ),
//                         // IconButton(
//                         //   icon: Icon(
//                         //     Icons.help,
//                         //     color: Colors.black,
//                         //     size: 30,
//                         //   ),
//                         //   onPressed: () {
//                         //     Alert.dialogShow( "Thông báo",
//                         //         "Chức năng đang tạm đóng");
//                         //   },
//                         // ),
//                         IconButton(
//                           icon: Icon(
//                             Icons.logout,
//                             color: Colors.redAccent,
//                             size: 30,
//                           ),
//                           onPressed: () {
//                             Get.back();
//                             Future.delayed(Duration(milliseconds: 400),(){
//                               Get.back();
//                             });
//                           },
//                         )
//                       ],
//                     ))),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _buildItemMenu(Icon icon, String label, Function onPress) {
//     return GestureDetector(
//       onTap: () {
//         onPress();
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 2,
//               blurRadius: 10,
//               offset: Offset(0, 5), // changes position of shadow
//             ),
//           ],
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             icon,
//             SizedBox(
//               width: 10,
//             ),
//             Text(
//               label,
//               style: TextStyle(fontSize: 16),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSwithTypeApp(){
//     return Container(
//       child: Row(
//         children: [
//           Text( appController.isOnlineMode.value?"Chế độ Online":"Chế độ Offline",
//             style: TextStyle(color: appController.isOnlineMode.value?AppColor.whiteColor:AppColor.brightRed,fontSize: 16,fontWeight: FontWeight.bold),
//           ),
//           Switch(
//             activeColor: AppColor.jadeColor,
//             value: appController.isOnlineMode.value,
//             onChanged: (v){
//               appController.changeAppMode(!appController.isOnlineMode.value);
//             },
//           ),
//         ],
//       )
//     );
//   }
// }
