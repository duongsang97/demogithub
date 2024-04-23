
import 'package:get/get.dart';
import 'package:erp/src/screens/profile/pages/signatureSign/signatureDetail/signatureDetail.Controller.dart';
class SignatureDetailBinding implements Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => SignatureDetailController());
  }
  
}