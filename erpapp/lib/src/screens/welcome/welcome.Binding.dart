import 'package:erp/src/screens/welcome/welcome.Controller.dart';
import 'package:get/get.dart';

class WelcomeBingding extends Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => WelcomeController());
  }
}