import 'dart:convert';
import 'dart:io';

import 'package:erpcore/models/apps/notification/notificationInfo.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/routers/app.Router.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/src/flutter_local_notifications_plugin.dart';
import 'package:flutter_local_notifications/src/notification_details.dart';
import 'package:flutter_local_notifications/src/platform_specifics/android/notification_details.dart';
import 'package:flutter_local_notifications/src/platform_specifics/android/notification_channel.dart';
import 'package:flutter_local_notifications/src/platform_specifics/android/enums.dart';
import 'package:get/get.dart';
class LocalNotificationUtils{
  static final LocalNotificationUtils _singleton = LocalNotificationUtils._();
  static LocalNotificationUtils get instance => _singleton;
  LocalNotificationUtils._(){
    setupFlutterNotifications();
  }

  late AndroidNotificationChannel channel;
  static FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  bool isFlutterLocalNotificationsInitialized = false;
  
  LocalNotificationUtils();

  static Future<bool> requestPermission() async{
    bool? result = false;
    if(Platform.isIOS){
      result = await flutterLocalNotificationsPlugin?.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    else if(Platform.isAndroid){
      result = await flutterLocalNotificationsPlugin?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
    }
    return result??false;
  }
  Future<void> setupFlutterNotifications() async {
    try {
      if (isFlutterLocalNotificationsInitialized) {
        return;
      }
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.', // description
        importance: Importance.high,
      );
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      var initializationSettingsAndroid = const AndroidInitializationSettings('mipmap/ic_launcher'); // <- default icon name is @mipmap/ic_launcher
      var initializationSettingsIOS = DarwinInitializationSettings(requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
      },);
      var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
      flutterLocalNotificationsPlugin?.initialize(initializationSettings, onDidReceiveNotificationResponse: (NotificationResponse notificationResponse){
        if(notificationResponse.payload != null && notificationResponse.payload!.isNotEmpty) {
          PrCodeName? message;
          try {
            print("jsondata: ${message}");
            var jsonMsg= jsonDecode(notificationResponse.payload!);
            message = PrCodeName.fromJson(jsonMsg);
            onDirectionRoutes(message);
          } catch (e) {
            Get.toNamed(AppRouter.homeNotification);
            AppLogsUtils.instance.writeLogs(e, func: "setupFlutterNotifications");
          }
        } else {
          Get.toNamed(AppRouter.homeNotification);
        }
      },
      //onDidReceiveBackgroundNotificationResponse:notificationTapBackground
      );

      await flutterLocalNotificationsPlugin?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      isFlutterLocalNotificationsInitialized = true;
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "setupFlutterNotifications appController");
    }
  }

  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse) {
    // handle action
  }
  void showNotificationCodeName(PrCodeName msg,{AndroidNotificationPriority? priority = AndroidNotificationPriority.defaultPriority}){
    RemoteMessage message = RemoteMessage(
      notification: RemoteNotification(
        title: msg.name??"",
        body: msg.codeDisplay??"",
        android: AndroidNotification(
          channelId:"showNotificationCodeName",
          priority: priority??AndroidNotificationPriority.highPriority,
        ),
      )
    );

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      int id = msg.value2??notification.hashCode;
      flutterLocalNotificationsPlugin?.show(id,notification.title,notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            actions: [
            ],
            priority: Priority.high,
            importance: Importance.max,
            enableVibration: true,
            ongoing: true,
            autoCancel: false,
            playSound: true,
          ),
        ),
      );
    }
  }

  Future<void> notificationCancel(int id) async{
    flutterLocalNotificationsPlugin?.cancel(id);
  }

  void showFlutterNotification(RemoteMessage message){
    try {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      dynamic noti;
      if (message.data['content'] != null) {
        noti = NotificationInfoModel.fromJson(message.data);
      } else {
        noti = PrCodeName.fromJson(message.data);
      }
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin?.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              actions: [
              ],
              enableVibration: true,
              //ongoing: true,
              playSound: true,
            ),
          ),
          payload: noti != null ? jsonEncode(noti).trim() : null
        );
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "showFlutterNotification appController");
    }
  }

  // codeDisplay: đường dẫn truy cập,name : syscode ,code: loại
  void onDirectionRoutes(PrCodeName  message) {
    try {
      if (message.codeDisplay != null && message.codeDisplay!.isNotEmpty) {
        Get.toNamed(message.codeDisplay!, arguments: {
          "NOTIFYPAYLOAD": message.name,
          "TYPE": message.code,
        })?.catchError((ex) {
          Get.toNamed(AppRouter.homeNotification);
        });
      } else {
        Get.toNamed(AppRouter.homeNotification);
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "onDirectionRoutes appController");
    }
  }
}