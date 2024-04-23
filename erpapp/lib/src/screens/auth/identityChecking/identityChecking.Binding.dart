import 'package:erp/src/screens/auth/identityChecking/identityChecking.Controller.dart';
import 'package:get/get.dart';

class IdentityCheckingBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => IdentityCheckingController());
  }

}