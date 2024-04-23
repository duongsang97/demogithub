import 'package:erp/src/screens/profile/pages/identify/pages/authencity/authencity.Controller.dart';
import 'package:get/instance_manager.dart';

class AuthenticityBinding implements Bindings{
  @override 
  void dependencies(){
    Get.lazyPut(() => AuthenticityController());
  }
}