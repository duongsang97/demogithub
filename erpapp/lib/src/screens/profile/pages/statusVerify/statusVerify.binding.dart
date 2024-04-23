import 'package:get/get.dart';

import 'statusVerify.controller.dart';
class StatusVerifyBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => StatusVerifyController());
  }

}