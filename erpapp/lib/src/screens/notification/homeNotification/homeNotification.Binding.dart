import 'package:erp/src/screens/notification/homeNotification/homeNotification.Controller.dart';
import 'package:get/get.dart';

class HomeNotificationBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => HomeNotificationController());
  }
}