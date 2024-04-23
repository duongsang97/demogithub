import 'package:get/get.dart';
import 'package:erp/src/screens/auth/signIn/pages/verification.Controller.dart';

class VerificationBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => VerificationController());
  }

}