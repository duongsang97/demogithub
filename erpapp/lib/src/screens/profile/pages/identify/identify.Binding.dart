import 'package:get/instance_manager.dart';
import 'package:erp/src/screens/profile/pages/identify/identify.Controller.dart';

class IdentifyBinding implements Bindings{
  @override 
  void dependencies(){
    Get.lazyPut(() => IdentifyController());
  }
}