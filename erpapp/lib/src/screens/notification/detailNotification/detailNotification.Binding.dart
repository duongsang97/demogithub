import 'package:erp/src/screens/notification/detailNotification/detailNotification.Controller.dart';
import 'package:get/get.dart';

class DetailNotificationBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => DetailNotificationController());
  }
}