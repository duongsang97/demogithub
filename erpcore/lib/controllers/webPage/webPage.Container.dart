import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/components/appbars/appBarTab.component.dart';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/components/webView/webView.component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/controllers/webPage/webPage.Controller.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebPageScreen extends GetWidget<WebPageController>{
  final WebPageController webPageController = Get.find();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBarTabComponent(
        height: 60,
        title: Obx(()=>Text(webPageController.title.value,maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: AppColor.bluePen))),
        onBack: (){
          if(webPageController.isBack.value){
            webPageController.webViewController?.goBack();
          }
        },
        actionWidget: IconButton(icon: const Icon(Icons.home,color: AppColor.bluePen,size: 28,),
          onPressed: () async{
            Get.back();
          }
        ),
      ),
      body: WillPopScope(
        onWillPop: () async{
          bool result = true;
          try{
            if(!webPageController.isBack.value){
              var temp = await Alert.showDialogConfirm("Thông báo","Bạn muốn thoát khỏi ${controller.title}?");
              result = temp;
            }
          }
          catch(ex){
            AppLogsUtils.instance.writeLogs(ex,func: "willpopscope onWillpop");
          }
          return result;
        },
        child: WebViewComponent(
          url: Uri.parse(controller.currentURL),
          controller: controller.webViewController,
          onLoadStop: (controller, uri) =>  LoadingComponent.dismiss(),
          onWebViewCreated: (v){
            controller.webViewController = v;
          },
        )
      ),
    );
  }

}