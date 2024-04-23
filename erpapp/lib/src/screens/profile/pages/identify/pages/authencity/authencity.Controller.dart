import 'dart:convert';
import 'dart:typed_data';
import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/datas/appData.dart';
import 'package:erpcore/models/activations/ItemSelectDataAct.Model.dart';
import 'package:erpcore/models/apps/identification.Model.dart';
import 'package:erpcore/providers/erp/identification.Provider.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/utility/preferences.Utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class AuthenticityController extends GetxController{
  RxBool authValue = false.obs; // giá trị tắt bật 2 bước 
  RxList<ItemSelectDataActModel> listAuth = RxList.empty(growable: true);
  Rx<ItemSelectDataActModel> authMethod =  ItemSelectDataActModel().obs;
  TextEditingController verifyCodeController =TextEditingController();
  Rx<IdentificationModel> data = IdentificationModel().obs;
  Rx<Uint8List> googleAuthQR = Uint8List(0).obs;
  late IdentificationProvider provider;
  RxBool isLoading = false.obs;
  RxBool isAuth = false.obs; // đang xác thực 2 bước
  RxInt statusCheck = 0.obs; // trạng thái check mã 0 - chưa check, 1 - thành công, 2 thất bại, 3 đang check

  @override
  void onInit() {
    provider = IdentificationProvider();
    initData();
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  Future<void> initData({bool isFirst = true}) async {
    try {
      if (isFirst == true) {
        await getInfoTypeAuth();
      }
      listAuth.clear();
      String genAuthCode = PreferenceUtility.getString(AppKey.authTypeKey);
      if (genAuthCode.isNotEmpty) {
        authValue.value = true;
        isAuth.value = true;
      }
      if (isAuth.value) {
        if (genAuthCode == "GoogleAuth") {
          listAuth.add(ItemSelectDataActModel(code: "GoogleAuth", name:"Google authenticator", linkFile: "assets/images/icons/google.png"));  
        } else if (genAuthCode == "MicrosoftAuth") {
          listAuth.add(ItemSelectDataActModel(code: "MicrosoftAuth", name:"Microsoft authenticator", linkFile: "assets/images/icons/microsoft.png"));  
        }
      } else {
        listAuth.add(ItemSelectDataActModel(code: "GoogleAuth", name:"Google authenticator", linkFile: "assets/images/icons/google.png"));  
        listAuth.add(ItemSelectDataActModel(code: "MicrosoftAuth", name:"Microsoft authenticator", linkFile: "assets/images/icons/microsoft.png"));  
        // listAuth.add(ItemSelectDataActModel(code: "SMSAuth", name:"SMS OTP", linkFile: "assets/images/icons/chat.png"));  
      }
      authMethod.value = listAuth.first;
      listAuth.refresh();
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "initData AuthenticityController");
    }
  }

  void onChangedStatusAuth(bool val) async {
    try {
      if (val == false) {
        bool cancel = await onCancelAuth2Step();
        if (cancel == true) {
          authValue.value = val;
        }
      } else {
        authValue.value = val;
        await initData(isFirst: false);
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "onChangedStatusAuth AuthenticityController");
    }
  }

  void onChangedSelectMethod(ItemSelectDataActModel? value) async {
    try {
      if (value != null) {
        authMethod.value = value;
        await getInfoTypeAuth(type: authMethod.value.code ?? "");
        listAuth.refresh();
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "onChangedSelectMethod AuthenticityController");
    }
  }

  Future<void> getInfoTypeAuth({String type = "GoogleAuth"}) async {
    try {
      isLoading.value = true;
      LoadingComponent.show(msg: "Đang xử lý dữ liệu...");
      var result = await provider.getInfoTypeAuth(authType: type, type: 0);
      LoadingComponent.dismiss();
      if (result.statusCode == 0) {
        data.value = result.data;
        if (data.value.qrCodeBase64 != null && data.value.qrCodeBase64!.isNotEmpty) {
          String base64 = data.value.qrCodeBase64!;
          String temp = base64.substring(base64.indexOf(',') + 1);
          googleAuthQR.value = base64Decode(temp);  
        }
        isLoading.value = false;
      }
    } catch (e) {
      LoadingComponent.dismiss();
      isLoading.value = false;
      AppLogsUtils.instance.writeLogs(e, func: "getInfoTypeAuth AuthenticityController");
    }
  }

  bool validateCode() {
    bool result = false;
    try {
      if (verifyCodeController.text.isNotEmpty) {
        result = true;
      }
      if (!result) {
        AlertControl.push("Chưa nhập mã xác thực", type: AlertType.ERROR);
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "validateCode AuthenticityController");
    }
    return result;
  }

  Future<void> onCheckAuthCode({String type = "GoogleAuth"}) async {
    try {
      if (validateCode()) {
        isLoading.value = true;
        statusCheck.value = 3;
        LoadingComponent.show(msg: "Đang kiếm tra...");
        var result = await provider.onCheckAuthCode(authType: type, type: 1, authCode: verifyCodeController.text);
        LoadingComponent.dismiss();
        if (result.statusCode == 0) {
          isLoading.value = false;
          statusCheck.value = 1;
          AlertControl.push(result.msg ?? "", type: AlertType.SUCCESS);
        } else {
          statusCheck.value = 2;
          isLoading.value = false;
          AlertControl.push(result.msg ?? "", type: AlertType.ERROR);
        }
      }
    } catch (e) {
      LoadingComponent.dismiss();
      isLoading.value = false;
      statusCheck.value = 0;
      AppLogsUtils.instance.writeLogs(e, func: "onCheckAuthCode AuthenticityController");
    }
  }

  String getTitleAuth() {
    String result = "";
    try {
      if (authMethod.value.code == "GoogleAuth") {
        result = "Goole";
      } else if (authMethod.value.code == "MicrosoftAuth") {
        result = "Microsoft";
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "getTitleAuth AuthenticityController");
    }
    return result;
  }

  Color getColorStatusCheck() {
    Color result = AppColor.cottonSeed;
    if (statusCheck.value == 1) {
      result = AppColor.greenMonth;
    } else if (statusCheck.value == 2) {
      result = AppColor.brightRed;
    } else if (statusCheck.value == 3) {
      result = AppColor.marsDeer;
    }
    return result;
  }

  Future<void> onSetAuthCode({String type = "GoogleAuth"}) async {
    try {
      if (validateCode()) {
        isLoading.value = true;
        LoadingComponent.show(msg: "Đang thiết lập...");
        var result = await provider.onCheckAuthCode(authType: type, type: 2, authCode: verifyCodeController.text);
        LoadingComponent.dismiss();
        if (result.statusCode == 0) {
          isLoading.value = false;
          isAuth.value = true;
          await PreferenceUtility.saveString(AppKey.authTypeKey, type);
          await initData();
          AlertControl.push(result.msg ?? "", type: AlertType.SUCCESS);
        } else {
          isLoading.value = false;
          AlertControl.push(result.msg ?? "", type: AlertType.ERROR);
        }
      }
    } catch (e) {
      LoadingComponent.dismiss();
      isLoading.value = false;
      AppLogsUtils.instance.writeLogs(e, func: "onSetAuthCode AuthenticityController");
    }
  }

  void onOpenOptionImage() async {
    try {
      await Clipboard.setData(ClipboardData(text: data.value.entrySetupCode ?? ""));
      AlertControl.push("Đã sao chép vào bộ nhớ tạm", type: AlertType.SUCCESS);
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "onOpenOptionImage AuthenticityController");
    }
  }

  Future<bool> onCancelAuth2Step() async {
    bool cancel = false;
    try {
      var result = await Alert.showDialogConfirm("Thông báo", "Bạn có chắc muốn tắt xác thực 2 bước không");
      if (result) {
        LoadingComponent.show(msg: "Đang xử lý...");
        var cancelResult = await provider.onCancelAuth2Step(type: 3);
        LoadingComponent.dismiss();
        if (cancelResult.statusCode == 0) {
          cancel = true;
          isAuth.value= false;
          await PreferenceUtility.removeByKey(AppKey.authTypeKey);
          AlertControl.push(cancelResult.msg ?? "", type: AlertType.SUCCESS);
        } else {
          AlertControl.push(cancelResult.msg ?? "", type: AlertType.ERROR);
        }
      }
    } catch (e) {
      LoadingComponent.dismiss();
      AppLogsUtils.instance.writeLogs(e, func: "onCancelAuth2Step AuthenticityController");
    }
    return cancel;
  }


}