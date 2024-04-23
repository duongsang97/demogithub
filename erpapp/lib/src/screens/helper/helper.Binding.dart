import 'package:erp/src/screens/helper/helper.Controller.dart';
import 'package:get/get.dart';

class HelperBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => HelperController());
  }
}