import 'package:booking/booking.dart';
import 'package:complain/complain.dart';
import 'package:erp/src/routers/pages.Router.dart';
import 'package:erp/src/screens/app.dart';
import 'package:erpcore/datas/appData.dart';
import 'package:erpcore/utility/localNotification.utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:esignature/esignature.dart';
import 'package:attendancemng/attendancemng.dart';
import 'package:empscanner/empscanner.dart';
import 'package:labourtracking/labourtracking.dart';
import 'package:md5s/md5s.dart';
import 'package:payslip/payslip.dart';
import 'package:powerbi/powerbi.dart';
import 'package:projectcoststatistical/projectcoststatistical.dart';
import 'package:taskmng/taskmng.dart';
import 'package:themedia/themedia.dart';
import 'firebase_options.dart';
import 'package:erpcore/erpCore.dart';
import 'package:activation/activation.dart';
import 'package:warehouse/warehouse.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  LocalNotificationUtils.instance.setupFlutterNotifications();
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await ErpCore.program();
  Activation.program();
  Warehouse.program();
  Labourtracking.program();
  Md5s.program();
  Projectcoststatistical.program();
  Empscanner.program();
  Payslip.program();
  Esignature.program();
  AttendanceMng.program();
  TaskMng.program();
  PowerBI.program();
  Complain.program();
  TheMedia.program();
  Booking.program();
  ErpCore.routerInclude(AppPages.list);
  ErpCore.dbInclude(AppDatas.dbs);

  runApp(const App());
}