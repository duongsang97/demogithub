import 'package:erp/src/screens/profile/pages/asset/asset.Controller.dart';
import 'package:get/instance_manager.dart';

class AssetBindings implements Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => AssetController());
  }
}