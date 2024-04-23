import 'package:erp/src/screens/profile/pages/profileDetail/profileDetail.Controller.dart';
import 'package:get/get.dart';

class ProfileDetailBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileDetailController());
  }

}