
import 'package:get/get.dart';
import 'package:erp/src/screens/profile/pages/signatureSign/signatureSign.Controller.dart';
class SignatureSignBinding implements Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => SignatureSignController());
  }
  
}