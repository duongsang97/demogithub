import 'package:erp/src/screens/attendants/attendantHistory/attendantHistory.Controller.dart';
import 'package:erp/src/screens/attendants/attendantHome/attendantHome.Controller.dart';
import 'package:get/instance_manager.dart';

import 'attendantMain.Controller.dart';

class AttendantMainBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => AttendantMainController());
    Get.lazyPut(() => AttendantHomeControler());
    Get.lazyPut(() => AttendantHistoryController());
  }
  
}