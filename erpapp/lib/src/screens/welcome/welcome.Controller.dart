import 'dart:convert';
import 'dart:io';
import 'package:activation/datas/activation.data.dart';
import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/configs/app.Config.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/datas/appData.dart';
import 'package:erpcore/models/apps/userInfo.Model.dart';
import 'package:erpcore/providers/erp/app.Provider.dart';
import 'package:erpcore/providers/erp/authen.Provider.dart';
import 'package:erp/src/routers/app.Router.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/utility/preferences.Utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;
import 'package:erpcore/utility/localStorage/systemConfig.utils.dart';
import 'package:erpcore/utility/localNotification.utils.dart';
import 'package:erpcore/utility/permission.utils.dart';


class WelcomeController extends GetxController{
  Rx<PackageInfo> packageInfo = PackageInfo(appName: 'Unknown',packageName: 'Unknown',version: 'Unknown',buildNumber: 'Unknown',).obs;
  late AppProvider appProvider;
  late AppController appController;
  late AuthenProvider authenProvider;
  late BuildContext context;
  Rx<String> msgProcess = "Đang khởi tạo dữ liệu".obs;
  RxBool isLoading = true.obs;
  Rx<String> logoWelcome = "".obs;
  Rx<String> colorWelcome = "".obs;



  @override
  void onInit() {
    appProvider = AppProvider();
    authenProvider = AuthenProvider();
    appController = Get.find();
    super.onInit();
  }

  @override
  void onReady() async{
    await initPackageInfo();
    await fetchDBAppConfig();
    await checkAppVersion();
    await PreferenceUtility.saveBool(AppKey.authenOpenStatus,false);
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
  
  Widget? get subLogoByPackage{
    Widget? result;
    if(AppConfig.appPackageName == PackageName.acacyPackage){
      result = Image.asset("assets/images/logos/acacy_backgroud_bottom_right.png",width: Get.width*.5,);
    }
    return result;
  }

  Color? get colorByPackage{
    Color? result = AppColor.whiteColor;
    if(AppConfig.appPackageName == PackageName.acacyPackage){
      //result = AppColor.bluePen;
    }
    else{
      result = AppColor.whiteColor;
    }
    return result;
  }

  Future<void> initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    packageInfo.value = info;
  }

  int getNumberVersion (String string) {
    int serverVersion = 0;
    try {
      var stringServerV = string.replaceAll(".","");
      if (stringServerV.isNotEmpty) {
        serverVersion = int.parse(stringServerV);
      }
    } catch (ex) {
      serverVersion = -1;
      AppLogsUtils.instance.writeLogs(ex,func: "getNumberVersion");
    }
    return serverVersion;
  }

  Future<bool> permissionDevice() async{
    bool result = false;
    var device = await getDeviceDetails();
    var list= AppDatas.permissionRequired(device);
    var temp = await PermisstionUtils.checkDevicePermissionAllow(list);
    if(temp.isEmpty){
      result = true;
    }
    else{
      var resultToName = await Get.toNamed(AppRouter.permissionReview,arguments: temp)??false;
      if(resultToName != null && resultToName is bool){
        result = resultToName;
      }
    }
    return result;
  }

  Future<void> checkAppVersion() async{
    var permissionStatus = await permissionDevice();
    if(permissionStatus){
      msgProcess.value ="Đang kiểm tra cập nhật";
      var result = await appProvider.getVersionInfo(AppConfig.appPackageName);
      msgProcess.value ="Đang kiểm thông tin tài khoản";
      SystemConfigUtils.initialization();
      if(result.statusCode == 0){
        var appData = result.data;
        int appVersion = getNumberVersion(packageInfo.value.version);
        int serverVersion = getNumberVersion(appData.version);
        if((appData == -1 || appVersion == -1) || (appData!= null && serverVersion <= appVersion)){
          var temp = await checkTokenAvailability();
          if(temp){
            appController.loginNavigation(callback: (){
              Get.offAndToNamed(AppRouter.signIn);
            });
          }
          else{
            Get.offAndToNamed(AppRouter.signIn);
          }
        }
        else{
          await Get.toNamed(AppRouter.appUpgrade,arguments: result.data);
          msgProcess.value ="Vui lòng cập nhật để tiếp tục sử dụng ứng dụng";
        }
      }
      else{
        if(result.statusCode == 1){
          AlertControl.push(result.msg??"", type: AlertType.ERROR);
        }
        var temp = await checkTokenAvailability();
        if(temp){
          appController.loginNavigation(callback: (){
            Get.offAndToNamed(AppRouter.signIn);
          });
        }
        else{
          Get.offAndToNamed(AppRouter.signIn);
        }
        // lỗi server trả về
      }
    }
    else{
      msgProcess.value ="Một số quyền cần thiết đã không được cho phép, vui lòng thử lại";
    }
  }

  Future<bool> checkTokenAvailability() async{
    bool result = false;
    try{
      var token = PreferenceUtility.getString(AppKey.keyERPToken);
      if(token.isNotEmpty){
        var userData = PreferenceUtility.getString(AppKey.userData);
        if(userData.isEmpty){
          var responses = await authenProvider.getUserPermission();
          if(responses.statusCode == 0){
            appController.isAuthentication.value= true;
            appController.userProfle.value = responses.data;
            await PreferenceUtility.saveString(AppKey.userData,jsonEncode(appController.userProfle.value.toJson()));
            result = true;
          }
        }
        else{
          appController.isAuthentication.value= true;
          appController.userProfle.value = UserInfoModel.fromJson(jsonDecode(userData));
          result = true;
        }
      }
    }
    catch(ex){
      result = true;
      AppLogsUtils.instance.writeLogs(ex,func: "checkTokenAvailability");
    }
    return result;
  }

  Future fetchDBAppConfig() async {
    try {
      await SystemConfigUtils.handleExistConfigChecking(AppDatas.sysKeyAppConfig);
    } catch (ex) {
      AppLogsUtils.instance.writeLogs(ex,func: "fetchDBAppConfig welcome.Controller");
    }
    String tempLogo = await SystemConfigUtils.getConfigByKey(ActivationData.logoWelcome);
    if(File(tempLogo).existsSync() && checkFileOrImage(p.extension(tempLogo)) == "image"){
      logoWelcome.value = tempLogo;
    }
    colorWelcome.value = await SystemConfigUtils.getConfigByKey(AppDatas.colorWelcome);
    refresh();
  }
}
