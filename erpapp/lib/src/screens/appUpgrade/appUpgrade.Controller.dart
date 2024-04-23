import 'dart:io';

import 'package:erpcore/models/apps/appVersion.Model.dart';
import 'package:erpcore/providers/erp/app.Provider.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:erpcore/configs/app.Config.dart';

class AppUpgradeController extends GetxController with GetSingleTickerProviderStateMixin{
  RxBool isLoading = false.obs;
  Rx<AppVersionModel> appVersionInfo = Rx<AppVersionModel>(AppVersionModel());
 
  late AnimationController controller;
  @override
  void onInit() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {});
    controller.repeat(reverse: true);
    getAppVersionData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  void getAppVersionData(){
    try{
      appVersionInfo.value = Get.arguments;
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getAppVersionData appUpgrade.Controller");
    }
  }

  Future<void> updateHandle() async{
    try {
      if(Platform.isIOS){
        launchUrl(Uri.parse(appVersionInfo.value.linkIOS??"",),mode: LaunchMode.externalApplication);
      }
      else{
        // if ((appVersionInfo.value.linkAndroid != null && appVersionInfo.value.linkAndroid!.endsWith(".apk")) ) {
        //   isLoading.value=true;
          
        //   // OtaUpdate().execute(appVersionInfo.value.linkAndroid??"",
        //   //     destinationFilename: appVersionInfo.value.name,
        //   //   ).listen(
        //   //     (OtaEvent event) {
        //   //     otaStatus.value = event;
        //   //     controller.value = double.parse(event.value!)/100;
        //   //     },
        //   //   ).onDone(() {
        //   //     isLoading.value=false;
        //   //   });
        // } else {
        //   launchUrl(Uri.parse(appVersionInfo.value.linkAndroid ?? "",),mode: LaunchMode.externalApplication);
        // }
        launchUrl(Uri.parse(appVersionInfo.value.linkAndroid ?? "",),mode: LaunchMode.externalApplication);
      }
    } catch (ex) {
      isLoading.value=false;
      print('Failed to make OTA update. Details: $ex');
      AppLogsUtils.instance.writeLogs(ex,func: "updateHandle appUpgrade.Controller");
    }
    
  }
}