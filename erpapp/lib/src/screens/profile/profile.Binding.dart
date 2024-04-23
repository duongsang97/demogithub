import 'package:erp/src/screens/profile/profile.Controller.dart';
import 'package:get/get.dart';

class ProfileBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());
  }
}