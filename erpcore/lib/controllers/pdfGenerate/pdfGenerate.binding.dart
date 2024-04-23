import 'package:erpcore/controllers/pdfGenerate/pdfGenerate.controller.dart';
import 'package:get/get.dart';

class PdfGenerateBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => PdfGenerateController());
  }

}