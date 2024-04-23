import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/datas/appData.dart';
import 'package:erpcore/utility/preferences.Utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/providers/erp/profile.Provider.dart';
import 'package:erpcore/screens/app.Controller.dart';

class ProfileController extends GetxController{
  RxBool isPageLoading = false.obs;
  RxBool isLoading = false.obs;
  late ScrollController controller;
  late ProfileProvider profileProvider;
  late AppController appController;
  RxBool isDevMode = false.obs;
  @override
  void onInit() {
    controller = ScrollController();
    profileProvider = ProfileProvider();
    appController = Get.find();
    super.onInit();
  }

  @override
  void onClose() {
    // appController = Get.find();
    super.onClose();
  }
  
  @override
  void onReady(){
    super.onReady();
    isDevMode.value = PreferenceUtility.getBool(AppKey.keyDevMode);
  }

  Future<void> requestDeleteAccount() async{
    try{
      isLoading.value = true;
      var questionResult = await Alert.showDialogConfirm("Thông báo", "Mọi dữ liệu liên quan tới tài khoản sẽ bị xoá, tiếp tục?");
      isLoading.value = false;
      if(questionResult){
        var response = await profileProvider.deleteAccount();
         AlertControl.push(response.msg??"", type: AlertType.ERROR);
        if(response.statusCode == 0){
          appController.logout();
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "requestDeleteAccount ProfileController");
    }
  }

  void onPressAvatar(){
    
  }


  
}