import 'package:get/get.dart';

import 'cameraView.Controller.dart';

class CameraViewBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => CameraViewController());
  }

}