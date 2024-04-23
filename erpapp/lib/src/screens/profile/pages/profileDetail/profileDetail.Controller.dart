import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/datas/appData.dart';
import 'package:erpcore/models/apps/userInfo.Model.dart';
import 'package:erpcore/providers/erp/authen.Provider.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/utility/preferences.Utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileDetailController extends GetxController{
  Rx<UserInfoModel> userProfile = Rx<UserInfoModel>(UserInfoModel());
  RxBool isLoading = false.obs;
  AuthenProvider authenProvider = AuthenProvider();
  TextEditingController txtFullNameController = TextEditingController();
  TextEditingController txtbirthdayController = TextEditingController();
  TextEditingController txtAddressController = TextEditingController();
  TextEditingController txtPhoneController = TextEditingController();
  TextEditingController txtEmailController = TextEditingController();
  late AppController appController;
  RxInt countOnPressAvatar = 0.obs; // use for count press to Avatar, if count to 5 then dev mode is turn on
  RxBool isDevMode = false.obs;
  final int devModeTarget = 5;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    appController = Get.find();
    fetchEmpProfile();
    isDevMode.value = PreferenceUtility.getBool(AppKey.keyDevMode);
    if(isDevMode.value){
      countOnPressAvatar.value = devModeTarget;
    }
    super.onReady();
  }

  Future<void> fetchEmpProfile() async{
    try{
      LoadingComponent.show();
      var response = await authenProvider.getEmpProfile();
      LoadingComponent.dismiss();
      if(response.statusCode == 0){
        userProfile.value = response.data;
        txtFullNameController.text = userProfile.value.displayName??"";
        txtbirthdayController.text = userProfile.value.birthday??"";
        txtAddressController.text = userProfile.value.street??"";
        txtPhoneController.text = userProfile.value.phoneDefault;
        txtEmailController.text = userProfile.value.emailDetail;
        appController.userProfle.value.verified = userProfile.value.verified??false;
        appController.userProfle.value.urlAvatar = userProfile.value.urlAvatar??"";
        appController.userProfle.refresh();
      }
      else{
        AlertControl.push(response.msg??"", type: AlertType.ERROR);
        
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "fetchEmpProfile");
    }
  }

  void onPressAvatar(){
    if(countOnPressAvatar.value>=0 && countOnPressAvatar.value < devModeTarget && !isDevMode.value){
      countOnPressAvatar.value++;
      Future.delayed(const Duration(milliseconds: 1000),(){
        if(countOnPressAvatar.value >0 && countOnPressAvatar< devModeTarget){
          countOnPressAvatar.value --;
        }
      });
      if(countOnPressAvatar.value < devModeTarget){
        Alert.showSnackbar("DEVMOD", "Còn ${devModeTarget - countOnPressAvatar.value} lần để mở chế độ dev mode",snackPosition:SnackPosition.BOTTOM,duration: const Duration(milliseconds: 1000));
      }
    }
    if(countOnPressAvatar.value == devModeTarget && !isDevMode.value){
      PreferenceUtility.saveBool(AppKey.keyDevMode,true);
      isDevMode.value = PreferenceUtility.getBool(AppKey.keyDevMode);
      Alert.showSnackbar("DEVMOD", "Chế độ dev mode đã được mở",snackPosition:SnackPosition.BOTTOM,duration: const Duration(milliseconds: 1000));
    }
  }
}