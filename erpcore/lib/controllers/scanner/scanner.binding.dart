import 'package:erpcore/controllers/scanner/scanner.controller.dart';
import 'package:get/get.dart';

class ScannerBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ScannerController());
  }
}