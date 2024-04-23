import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/providers/erp/authen.Provider.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController{
  TextEditingController txtOldPassword =TextEditingController();
  TextEditingController txtNewPassword =TextEditingController();
  TextEditingController txtConfirmNewPassword =TextEditingController();
  RxBool isHideOldPassword = false.obs;
  RxBool isHideNewPassword = false.obs;
  RxBool isHideConfirmNewPassword = false.obs;
  late AuthenProvider authenProvider;
  late BuildContext context;

  @override
  void onInit() {
    authenProvider = AuthenProvider();
    super.onInit();
  }

  @override
  void onReady() {
    
    super.onReady();
  }
  bool validateInputData(){
    if(txtOldPassword.text.isEmpty){
      Alert.dialogShow("Thông báo","Mật khẩu cũ không được bỏ trống");
      return false;
    }
    if(txtNewPassword.text.isEmpty){
      Alert.dialogShow("Thông báo","Mật khẩu mới không được bỏ trống");
      return false;
    }
    if(txtConfirmNewPassword.text.isEmpty){
      Alert.dialogShow("Thông báo","Xác nhận mật khẩu mới không được bỏ trống");
      return false;
    }
    if(txtNewPassword.text != txtConfirmNewPassword.text){
      Alert.dialogShow("Thông báo","Mật khẩu mới và xác nhận mật khẩu không giống nhau");
      return false;
    }
    return true;
  }

  Future<void> onChangePassword() async{
    try {
      if(validateInputData()){
        LoadingComponent.show();
        var result = await authenProvider.changePassword(txtOldPassword.text, txtNewPassword.text);
        if (result.statusCode == 0) {
          Get.back();
          AlertControl.push(result.msg ?? "Mật khẩu đã được đổi", type: AlertType.ERROR);
        } else {
          AlertControl.push(result.msg ?? "Đổi mật khẩu thất bại", type: AlertType.ERROR);
        }
        LoadingComponent.dismiss();
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "onChangePassword ChangePassword.Controller");
      LoadingComponent.dismiss();
    }
  }

  void onChangeStatusHidePassword(int type) {
    try {
      // 0 old - 1 new - 2 confirm new
      if (type == 0) {
        isHideOldPassword.value = !isHideOldPassword.value;
      } else if (type == 1) {
        isHideNewPassword.value = !isHideNewPassword.value;
      } else if (type == 2) {
        isHideConfirmNewPassword.value = !isHideConfirmNewPassword.value;
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "onChangeStatusHidePassword ChangePassword.Controller");
    }
  }
}