import 'package:erp/src/screens/auth/signIn/signIn.Controller.dart';
import 'package:get/get.dart';

class SignInBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController());
  }

}