import 'package:erp/src/screens/main/main.Controller.dart';
import 'package:get/instance_manager.dart';

class MainBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
  }
  
}