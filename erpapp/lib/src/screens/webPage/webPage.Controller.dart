import 'dart:io';

import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class WebPageController extends GetxController{
  RxString title ="WebView".obs;
  String currentURL = "";
  late InAppWebViewController webViewController;
  late PullToRefreshController pullToRefreshController = PullToRefreshController();
  late InAppWebViewGroupOptions options = InAppWebViewGroupOptions();
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
      pullToRefreshController = PullToRefreshController(
        options: PullToRefreshOptions(
          color: AppColor.aqua,
        ),
        onRefresh: () async {
          if (Platform.isAndroid) {
            webViewController.reload();
          } else if (Platform.isIOS) {
            webViewController.loadUrl(
                urlRequest: URLRequest(url: await webViewController.getUrl()));
          }
        },
      );
      options = InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
        ),
        android: AndroidInAppWebViewOptions(
          useHybridComposition: true,
        ),
        ios: IOSInAppWebViewOptions(
          allowsInlineMediaPlayback: true,
        )
      );
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex);
    }
  }
  @override
  void onReady() async{
    //await initDataWebPage();
    await initWebPage();
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

  // Future<void> initDataWebPage() async{
  //   if(train == null || (train != null && train == 0)){
  //     var token = await Reference.getString("access_token");
  //     currentURL+=token;
  //   }
  // }

  Future<void> initWebPage() async{
     
    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

      var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
          AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
      var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
          AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

      if (swAvailable && swInterceptAvailable) {
        AndroidServiceWorkerController serviceWorkerController =
            AndroidServiceWorkerController.instance();

        await serviceWorkerController.setServiceWorkerClient(AndroidServiceWorkerClient(
          shouldInterceptRequest: (request) async {
            return null;
          },
        ));
      }
    }
    
  }
}