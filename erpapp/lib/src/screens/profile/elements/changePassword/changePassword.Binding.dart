import 'package:erp/src/screens/profile/elements/changePassword/changePassword.Controller.dart';
import 'package:get/instance_manager.dart';

class ChangePasswordBingding implements Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => ChangePasswordController());
  }
}