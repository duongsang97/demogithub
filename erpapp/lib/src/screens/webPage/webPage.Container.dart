import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/components/webView/webView.component.dart';
import 'package:erpcore/configs/app.Config.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erp/src/screens/webPage/webPage.Controller.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebPageScreen extends GetWidget<WebPageController>{
  final WebPageController webPageController = Get.find();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation:0.0,
        backgroundColor: AppConfig.appColor,
        automaticallyImplyLeading:false,
        title: Row(
          children: [
            Obx(() => Visibility(
              visible: webPageController.isBack.value,
              child: IconButton(icon: const Icon(Icons.arrow_back_ios,color: AppColor.whiteColor,size: 25,),
                onPressed: () async{
                  webPageController.webViewController.goBack();
                }
              ),
            ),),
            Expanded(
              child: Obx(()=>Text(webPageController.title.value,maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.center,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: AppColor.whiteColor))),
            )
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.home,color: AppColor.whiteColor,size: 28,),
            onPressed: () async{
              Get.back();
            }
          ),
        ],
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
          url: Uri.parse(webPageController.currentURL),
          controller: webPageController.webViewController,
          onWebViewCreated: (controller){
            webPageController.webViewController = controller;
          },
        )
      ),
    );
  }

}