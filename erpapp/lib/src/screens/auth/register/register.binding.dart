import 'package:erp/src/screens/auth/register/register.controller.dart';
import 'package:get/get.dart';
class RegisterBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterController());
  }

}