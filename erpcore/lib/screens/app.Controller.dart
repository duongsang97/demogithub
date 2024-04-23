import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:connectivity/connectivity.dart';
import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/routers/app.Router.dart';
import 'package:erpcore/utility/localNotification.utils.dart';
import 'package:erpcore/utility/localStorage/systemConfig.utils.dart';
import 'package:erpcore/utility/permission.utils.dart';
import 'package:erpcore/utility/schedule/schedule.utils.dart';
import 'package:erpcore/configs/app.Config.dart';
import 'package:erpcore/datas/appData.dart';
import 'package:erpcore/models/apps/notification/notificationInfo.Model.dart';
import 'package:erpcore/models/apps/userInfo.Model.dart';
import 'package:erpcore/providers/erp/authen.Provider.dart';
import 'package:erpcore/providers/erp/notify.Provider.dart';
import 'package:erpcore/utility/localStorage/permission.dbLocal.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/utility/preferences.Utility.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:shorebird_code_push/shorebird_code_push.dart';

class AppController extends GetxController {
  RxBool isLoading = true.obs;
  RxBool isAuthentication = false.obs;
  RxBool isOnlineMode = true.obs;
  Rx<UserInfoModel> userProfle = UserInfoModel().obs;
  RxInt connectionType = 0.obs;
  RxList<NotificationInfoModel> notifys = RxList.empty(growable: true);
  late NotifyProvider notifyProvider;
  final Connectivity connectivity = Connectivity();
  //Stream to keep listening to network change state
  late StreamSubscription streamSubscription;
  final LocalAuthentication auth = LocalAuthentication();
  final AuthenProvider authenProvider = AuthenProvider();
  final PermissionDBLocal permissionDBLocal = PermissionDBLocal();
  RxBool actRecordGlobal = false.obs;
  RxBool actIsShowWorkResul = false.obs;
  List<PrCodeName> listFnData = List<PrCodeName>.empty(growable: true);
  late LocalNotificationUtils localNotification;
  late AppLinks appLinks;
  StreamSubscription<Uri>? linkSubscription;
  String colorTextColor = "";

  @override
  void onClose() {
    streamSubscription.cancel();
    super.onClose();
  }

  @override
  void onInit() async {
    notifyProvider = NotifyProvider();
    super.onInit();
    localNotification = LocalNotificationUtils.instance;
    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      if(message.data["type"] =="background"){
        handleBackgroundAction(message.data);
      }
      else{
        localNotification.showFlutterNotification(message);
        fetchNotifyData();
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      try {
        var notification = PrCodeName.fromJson(message.data);
        localNotification.onDirectionRoutes(notification);
      } catch (e) {
        Get.toNamed(AppRouter.homeNotification);
        AppLogsUtils.instance.writeLogs(e, func: "${message.data} onMessageOpenedApp");
      }
    });
    initDeepLinks();
  }
  

  @override
  void onReady() async{
    //GetConnectionType();
    streamSubscription = connectivity.onConnectivityChanged.listen(updateInternetConnectionState);
    ScheduleUtils.init();
    super.onReady();
  }

  Future<void> initDeepLinks() async {
    appLinks = AppLinks();

    // Check initial link if app was in cold state (terminated)
    final appLink = await appLinks.getInitialAppLink();
    if (appLink != null) {
      openAppLink(appLink);
    }

    // Handle link when app is in warm state (front or background)
    linkSubscription = appLinks.uriLinkStream.listen((uri) {
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    //_navigatorKey.currentState?.pushNamed(uri.fragment);
  }

  // a method to get which connection result, if you we connected to internet or no if yes then which network
  Future<void> getConnectionType() async {
    ConnectivityResult? connectivityResult;
    try {
      connectivityResult = await (connectivity.checkConnectivity());
    } on PlatformException catch (ex) {
      AppLogsUtils.instance.writeLogs(ex,func: "GetConnectionType app.Controller");
    }
    if(connectivityResult != null){
      await updateInternetConnectionState(connectivityResult);
    }
  }

  updateInternetConnectionState(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        Get.snackbar('Thông báo', 'Có kết nối internet (WIFI)');
        AppLogsUtils.instance.writeLogs("Có kết nối internet (WIFI)",func: "updateInternetConnectionState");
        connectionType.value = 1;
        break;
      case ConnectivityResult.mobile:
        Get.snackbar('Thông báo', 'Có kết nối internet (Mobile)');
        AppLogsUtils.instance.writeLogs("Có kết nối internet (Mobile)",func: "updateInternetConnectionState");
        connectionType.value = 2;
        break;
      case ConnectivityResult.none:
        connectionType.value = 0;
        AppLogsUtils.instance.writeLogs("Mất kết nối internet",func: "updateInternetConnectionState");
        Get.snackbar('Thông báo', 'Mất kết nối internet');
        break;
      default:
        AppLogsUtils.instance.writeLogs("Failed to get Network Status",func: "updateInternetConnectionState");
        Get.snackbar('Network Error', 'Failed to get Network Status');
        break;
    }
  }

  Future<void> handleBackgroundAction(dynamic jsonMsg) async{
    try{
      if(jsonMsg["cmd"] == "checkupdate"){
        final shorebirdCodePush = ShorebirdCodePush();
        // Check whether a patch is available to install.
        final isUpdateAvailable = await shorebirdCodePush.isNewPatchAvailableForDownload();
        if (isUpdateAvailable) {
          // Download the new patch if it's available.
          await shorebirdCodePush.downloadUpdateIfAvailable();
        }
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "handleBackgroundAction");
    }
  }

  Future<void> changeAppMode(bool flag) async{
    isOnlineMode.value = flag;
    PreferenceUtility.saveBool(AppKey.keyAppMode, flag);
  }

  Future<void> loginNavigation({VoidCallback? callback}) async {
    var listPermistion = await permissionDBLocal.findAllPermission();
    if (listPermistion.isNotEmpty) {
      Get.offAndToNamed(AppRouter.main);
      return;
    } else {
      AlertControl.push("Tài khoản của bạn không có quyền truy cập!", type: AlertType.ERROR);
      if (callback != null) {
        callback();
      }
      return;
    }

    //Get.offAndToNamed(AppRouter.main);
  }

  Future<void> loginAlertNavigation() async {
    var listPermistion = await permissionDBLocal.findAllPermission();
    if (listPermistion.isNotEmpty) {
      var username = PreferenceUtility.getString(AppKey.usernameLogin);
      if (username == userProfle.value.userName) {
        Get.back();
      } else {
        Get.offAllNamed(AppRouter.main);
      }
      return;
    } else {
      AlertControl.push("Tài khoản của bạn không có quyền truy cập!", type: AlertType.ERROR);
      return;
    }
  }

  void logout() async{
    PreferenceUtility.removeByKey(AppKey.keyERPToken);
    PreferenceUtility.removeByKey(AppKey.usernameLogin);
    PreferenceUtility.removeByKey(AppKey.userData);
    PreferenceUtility.removeByKey(AppKey.authTypeKey);
    isAuthentication.value = false;
    PermissionDBLocal permissionDBLocal = PermissionDBLocal();
    await permissionDBLocal.removeAllPermission(null);
    //Get.offAndToNamed(AppRouter.signIn);
    await PermisstionUtils.emptyLoginInfo();
    Get.offAllNamed(AppRouter.signIn);
  }

  String getLogoByPackageName(){
    String result = "";
    switch(AppConfig.appPackageName){
      case "spiral.com.vn.erpspi":
        result = AppConfig.logoSpiral;
      break;
      case "com.acacy.abbott":
        result = AppConfig.logoAbbott;
      break;
      case "acacy.com.vn.abbott":
        result = AppConfig.logoAbbott;
      break;
      case "acacy.com.vn.anlene":
        result = AppConfig.logoAnlene;
      break;
      case "acacy.com.vn.heineken":
        result = AppConfig.logoHeineken;
      break;
      case "acacy.com.vn.heinekenaudit":
        result = AppConfig.logoHeineken;
      break;
      case "acacy.com.vn.pepsi":
        result = AppConfig.logoPepsi;
      break;
      case "acacy.com.vn.mars":
        result = AppConfig.logoMars;
      break;
      default:
        result = AppConfig.logoERP;
      break;
    }
    return result;
  }

  String getUserName(){
    String result ="Tài khoản";
    try{
      if(userProfle.value.userName != null){
        result = userProfle.value.userName??"";
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getUserName app.Controller");
    }
    return result;
  }

  Future<bool> questionBiometrics() async{
    bool value = false;
    try {
      var isFingerprint = PreferenceUtility.getBool(AppKey.keyFingerprintStatus);
      if(isFingerprint){
        // Alert.showDialogConfirmCustom("Thông báo","Bật tính năng bảo mật bằng vân tay để tăng độ bảo mật và tiện dụng",child: [
        //   ButtonDefaultComponent(title: "Từ chối", onPress: () async{
        //     await PreferenceUtility.saveNumber(AppKey.keybiometricsStatus, 0);
        //     Get.back();
        //   },backgroundColor: type: AlertType.ERROR,),
        //   const SizedBox(width: 10,),
        //   ButtonDefaultComponent(title: "Đồng ý", onPress: () async{
            
        //   },backgroundColor: AppColor.greenMonth,)
        // ]);
        try{
            bool authenticated = await auth.authenticate(
            localizedReason: 'Đăng ký vân tay',
              options: const AuthenticationOptions(
                biometricOnly: false,
              ),
            );
            if(authenticated){
              LoadingComponent.show(msg: "Đang đăng ký vân tay");
              var result = await authenProvider.registerWithFingerprintID();
              LoadingComponent.dismiss();
              if(result.statusCode == 0){
                value = true;
                await PreferenceUtility.saveNumber(AppKey.keybiometricsStatus,1);
                await PreferenceUtility.saveString(AppKey.keybiometricstoken, result.data ?? "");
                AlertControl.push("Đăng ký thành công", type: AlertType.SUCCESS);
              }
              else{
                AlertControl.push(result.msg??"Đăng ký không thành công, vui lòng thử lại!", type: AlertType.ERROR);
              } 
            }
            else{
              AlertControl.push("Không thể xác minh, vui lòng thử lại", type: AlertType.ERROR);
            }
          }
          on PlatformException catch (ex) {
            if (ex.code == auth_error.notAvailable) {
              AlertControl.push("Sinh trắc học không khả dụng trên thiết bị của bạn!", type: AlertType.ERROR);
            } else if (ex.code == auth_error.notEnrolled) {
              AlertControl.push("Sinh trắc học chưa được đăng ký trên thiết bị của bạn!", type: AlertType.ERROR);
            }
            else {
              AlertControl.push("Có lỗi xảy ra, vui lòng thử lại!", type: AlertType.ERROR);
            }
            AppLogsUtils.instance.writeLogs(ex,func: "Sinh trắc học app.Controller");
          }
      } else if (!isFingerprint) {
        AlertControl.push("Vân tay thiết bị không khả dụng", type: AlertType.ERROR);
      }
    } catch (e) {
      AlertControl.push(e.toString(), type: AlertType.ERROR);
      AppLogsUtils.instance.writeLogs(e, func: "questionBiometrics AppController");
    }
    return value;
  }

  Future<void> fetchNotifyData() async{
    isLoading.value = true;
    var result = await notifyProvider.getListNotify(tagCodeList: "0");
    isLoading.value = false;
    if(result.statusCode == 0){
      notifys.value = result.data;
    }
    else{
      AlertControl.push(result.msg??"",type: AlertType.ERROR);
    }
  }

  Future<bool> fetchDBActConfig() async {
    bool result = false;
    try {
      //LoadingComponent.show();
      var listPermistion = await permissionDBLocal.findAllPermission();
      if (listPermistion.isNotEmpty && listPermistion.contains("PrFormActivation_AppActivation")) {
        await SystemConfigUtils.handleExistConfigChecking(AppDatas.sysKeyActConfig);
        result= true;
      }
      colorTextColor = await SystemConfigUtils.getConfigByKey(AppDatas.colorTextAppBar);
      if (colorTextColor.isEmpty) {
        colorTextColor = "#000F55";
      }
    } catch (ex) {
      result = false;
      AppLogsUtils.instance.writeLogs(ex, func: "fetchDBActConfig home.Controller");
    }
    return result;
  }
}
