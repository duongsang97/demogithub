import 'package:erp/src/screens/home/home.Controller.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}