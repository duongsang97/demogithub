import 'package:erpcore/screens/app.Controller.dart';
import 'package:get/instance_manager.dart';

class AppBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => AppController());
  }
}