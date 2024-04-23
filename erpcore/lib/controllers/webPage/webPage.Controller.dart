import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class WebPageController extends GetxController{
  RxString title ="WebView".obs;
  String currentURL = "";
  InAppWebViewController? webViewController;
  late AppController appController;
  RxBool isBack = false.obs;
  int train = 0;
  CookieManager cookieManager = CookieManager.instance();

  @override
  Future<void> onInit() async {
    LoadingComponent.show();
    initData();
    super.onInit();
    try{
      appController = Get.find();
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "OnInit WebPageController");
    }
  }
  @override
  void onReady() async{
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    LoadingComponent.dismiss();
  }

  void initData(){
    try{
      if(Get.parameters["url"] != null){
        currentURL = Get.parameters["url"]??"";
        title.value = Get.parameters["pageName"]??"";
      }
      else if(Get.arguments["url"] != null){
        currentURL = Get.arguments["url"]??"";
        title.value = Get.arguments["pageName"]??"";
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "initData");
    }
  }
}