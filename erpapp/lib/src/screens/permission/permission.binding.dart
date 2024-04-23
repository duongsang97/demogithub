import 'package:erp/src/screens/permission/permission.controller.dart';
import 'package:get/get.dart';

class PermissionBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => PermissionController());
  }
}