import 'package:erp/src/screens/systemInfo/systemInfo.Controller.dart';
import 'package:get/get.dart';

class SystemInfoBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SystemInfoController());
  }
}