import 'package:get/get.dart';
import 'appUpgrade.Controller.dart';

class AppUpgradeBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => AppUpgradeController());
  }
  
}