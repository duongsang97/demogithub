import 'dart:io';

import 'package:activation/datas/activation.data.dart';
import 'package:erp/src/routers/app.Router.dart';
import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/datas/appData.dart';
import 'package:erpcore/models/activations/ItemSelectDataAct.Model.dart';
import 'package:erpcore/models/apps/responses.Model.dart';
import 'package:erpcore/providers/erp/authen.Provider.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/localStorage/permission.dbLocal.dart';
import 'package:erpcore/utility/localStorage/systemConfig.utils.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/utility/permission.utils.dart';
import 'package:erpcore/utility/preferences.Utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
class SignInController extends GetxController{
  Rx<bool> isLoading = false.obs;
  TextEditingController userNameTextController = TextEditingController();
  TextEditingController passWordTextController = TextEditingController();
  TextEditingController rePassWordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController codeTextController = TextEditingController();
  AuthenProvider authenProvider = AuthenProvider();
  late AppController appController;
  final LocalAuthentication auth = LocalAuthentication();
  RxList<BiometricType> biometricList = RxList<BiometricType>.empty(growable: true);
  late PermissionDBLocal permissionDBLocal;
  Rx<ResponsesModel> recoveryPass = ResponsesModel().obs;
  RxInt stepRecovery = 0.obs;
  RxString logoPath = "".obs;
  RxInt wrongLogin = 0.obs;
  Rx<ItemSelectDataActModel> rememberMe = ItemSelectDataActModel(code: generateKeyCode(),name: "Ghi nhớ đăng nhập",selectType: true).obs;
  @override
  void onInit() {
    appController = Get.find();
    permissionDBLocal = PermissionDBLocal();
    super.onInit();
    try{
      LoadingComponent.dismiss();
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "onInit signIn.Controller");
    }
  }

  @override
  void onReady() async{
    logoHandle();
    super.onReady();
    checkLocalAuthen();
    permissionDBLocal.removeAllPermission(null);
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onChangeRememberMe(){
    if(rememberMe.value.isChoose != true && PermisstionUtils.loginInfoExits){
      PermisstionUtils.emptyLoginInfo();
    }
  }

  Widget get appLogo {
    if(logoPath.isNotEmpty){
      return Image.file(File(logoPath.value),height: Get.height * .35,);
    }
    else{
      return Image.asset("assets/images/vector/signIn_vector.jpg",height: Get.height * .35,);
    }
  }

  Future<void> logoHandle() async{
    String tempLogo = await SystemConfigUtils.getConfigByKey(ActivationData.logoWelcome);
    if(tempLogo.isNotEmpty && File(Uri.parse(tempLogo).path).existsSync() && File(Uri.parse(tempLogo).path).lengthSync() >0){
      logoPath.value =tempLogo;
    }
  }

  

  Future<void> checkLocalAuthen() async{
    biometricList.clear();
    var result = await auth.getAvailableBiometrics();
    if(result.isNotEmpty && result.indexWhere((element) => element == BiometricType.fingerprint || element == BiometricType.strong) >=0){
      biometricList.add(BiometricType.fingerprint);
      await PreferenceUtility.saveBool(AppKey.keyFingerprintStatus,true);
    }
    biometricList.add(BiometricType.face);
  }

  bool validateInputData() {
    if (userNameTextController.text == "") {
      AlertControl.push("Tài khoản không được bỏ trống",type: AlertType.ERROR);
      return false;
    }
    if (passWordTextController.text == "") {
      AlertControl.push("Mật khẩu không được bỏ trống",type: AlertType.ERROR);
      return false;
    }
    return true;
  }

  Future<void> logout() async {
    try {
      PreferenceUtility.removeByKey(AppKey.keyERPToken);
      PreferenceUtility.removeByKey(AppKey.usernameLogin);
      PreferenceUtility.removeByKey(AppKey.userData);
      PreferenceUtility.removeByKey(AppKey.authTypeKey);
      PermissionDBLocal permissionDBLocal = PermissionDBLocal();
      await permissionDBLocal.removeAllPermission(null);
    } catch (ex) {
      AppLogsUtils.instance.writeLogs(ex,func: "logout");
    }
  }

  Future<void> loginOnpress() async {
    if (validateInputData()) {
      isLoading.value = true;
        var result = await authenProvider.doLogin(username: userNameTextController.text,password: passWordTextController.text);
        if (result.statusCode == 0) {
          if(rememberMe.value.isChoose == true){
            await PermisstionUtils.encryptLoginInfo(userNameTextController.text, passWordTextController.text);
          }
          String genAuthCode = PreferenceUtility.getString(AppKey.authTypeKey);
          if (genAuthCode.isNotEmpty) {
            var result = await Get.toNamed(AppRouter.verification);
            if (result == true) {
              var resultUser = await authenProvider.getUserPermission();
              isLoading.value = false;
              if (resultUser.statusCode == 0) {
                wrongLogin.value  =0;
                appController.isAuthentication.value = true;
                appController.userProfle.value = resultUser.data;
                await PreferenceUtility.saveString(AppKey.usernameLogin, appController.userProfle.value.userName ?? "");
                appController.loginNavigation();
              } else {
                AlertControl.push(resultUser.msg??"",type: AlertType.ERROR);
              }
            } else {
              await logout();
              isLoading.value = false;
            }
          } else {
            var resultUser = await authenProvider.getUserPermission();
            isLoading.value = false;
            if (resultUser.statusCode == 0) {
              wrongLogin.value  =0;
              appController.isAuthentication.value = true;
              appController.userProfle.value = resultUser.data;
              await PreferenceUtility.saveString(AppKey.usernameLogin, appController.userProfle.value.userName ?? "");
              appController.loginNavigation();
            } else {
              AlertControl.push(resultUser.msg??"",type: AlertType.ERROR);
            }
          }
        } else {
          isLoading.value = false;
          wrongLogin.value++;
          AlertControl.push(result.msg??"",type: AlertType.ERROR);
        }
      }
  }

  String getImageAuthenLocalByType(BiometricType type){
    String result = "assets/images/icons/fingerprint.png";
    if(type == BiometricType.face){
      result= "assets/images/icons/face-recognition.png";
    }
    return result;
  }

  Future<void> onPressLoginWithFaceId() async{
    LoadingComponent.show();
    var result = await authenProvider.registerWithFingerprintID();
    LoadingComponent.dismiss();
  }

  Future<void> onPressLoginWithFingerprint(BiometricType type) async{
    try{
      String fingerprintID = PreferenceUtility.getString(AppKey.keybiometricstoken);
      if(fingerprintID.isNotEmpty){
        bool authenticated = await auth.authenticate(
        localizedReason: 'Vui lòng xác thực để tiếp tục',
          options: const AuthenticationOptions(
            biometricOnly: false,
          ),
        );
        if(authenticated){
          passWordTextController.text = "123456";
          Future.delayed(const Duration(milliseconds: 300));
          isLoading.value = true;
          var result = await authenProvider.doLogin(fingerprintToken: fingerprintID);
          isLoading.value = false;
            if (result.statusCode == 0) {
            var resultUser = await authenProvider.getUserPermission();
            isLoading.value = false;
            if (resultUser.statusCode == 0) {
              appController.isAuthentication.value = true;
              appController.userProfle.value = resultUser.data;
              appController.loginNavigation();
            } else {
              AlertControl.push(result.msg??"",type: AlertType.ERROR);
            }
          } else {
            isLoading.value = false;
            AlertControl.push(result.msg??"",type: AlertType.ERROR);
          }
        }
        else{
          AlertControl.push("Không thể xác minh danh tính!",type: AlertType.ERROR);
        }
      }
      else{
        AlertControl.push("Vân tay chưa được đăng ký với hệ thống",type: AlertType.ERROR);
      }
    }on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        AlertControl.push("Sinh trắc học không khả dụng trên thiết bị của bạn!",type: AlertType.ERROR);
      } else if (e.code == auth_error.notEnrolled) {
        AlertControl.push("Sinh trắc học chưa được đăng ký trên thiết bị của bạn!",type: AlertType.ERROR);
      }
      else {
        AlertControl.push("Có lỗi xảy ra, vui lòng thử lại!",type: AlertType.ERROR);
      }
    }
  }

  Future<void> passwordRecovery() async{
    try{
      recoveryPass.value = ResponsesModel.create();
      if(userNameTextController.text.isEmpty){
        AlertControl.push("Username không được bỏ trống",type: AlertType.ERROR);
      }
      else{
        isLoading.value = true;
        recoveryPass.value = await authenProvider.updatePasswordByUser(username: userNameTextController.text,email: emailTextController.text);
        isLoading.value= false;
        if(recoveryPass.value.statusCode == 0){
          stepRecovery.value =1;
          passWordTextController.clear();
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "passwordRecovery");
    }
  }

  Future<void> passwordSet() async{
    try{
      recoveryPass.value = ResponsesModel.create();
      if(userNameTextController.text.isEmpty){
        AlertControl.push("Username không được bỏ trống",type: AlertType.ERROR);
      }
      else{
        isLoading.value = true;
        recoveryPass.value = await authenProvider.setPasswordByUser(
          newPassword: passWordTextController.text,
          confirmNewPassword: rePassWordTextController.text,
          verifyCode: codeTextController.text,
          userName: userNameTextController.text,
          email: emailTextController.text
        );
        isLoading.value= false;
        if(recoveryPass.value.statusCode == 0){
          AlertControl.push(recoveryPass.value.msg??"",type: AlertType.SUCCESS);
          Get.back();
        }
        else{
          AlertControl.push(recoveryPass.value.msg??"",type: AlertType.ERROR);
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "passwordRecovery");
    }
  }
}