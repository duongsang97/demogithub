import 'package:erp/src/screens/webPage/webPage.Controller.dart';
import 'package:get/get.dart';

class WebPageBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => WebPageController());
  }
}