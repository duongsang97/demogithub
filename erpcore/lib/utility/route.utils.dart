import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/utility/preferences.Utility.dart';
import 'package:get/get.dart';
import '../components/alerts/elements/login.Element.dart';
import '../components/modalSheet/modalSheet.Component.dart';
import '../configs/appStyle.Config.dart';
import '../datas/appData.dart';
import '../routers/app.Router.dart';
import 'localStorage/permission.dbLocal.dart';

class RouteUtils{
  static final List<String> withOutPopup = ["/welcome",];
  static final List<String> withOutNavi = ["/authen/signin","/authen/signup"];
  void handleAuthen() async{
    try{
      PreferenceUtility.removeByKey(AppKey.keyERPToken);
      PermissionDBLocal permissionDBLocal = PermissionDBLocal();
      permissionDBLocal.removeAllPermission(null);
      var authenStatus = PreferenceUtility.getBool(AppKey.authenOpenStatus);
      String msg = "Phiên đăng nhập hết hạn, vui lòng đăng nhập lại!";
      if(!withOutPopup.contains(Get.currentRoute) && !withOutNavi.contains(Get.currentRoute) && !authenStatus){
        await PreferenceUtility.saveBool(AppKey.authenOpenStatus,true);
        await ModalSheetComponent.showBarModalBottomSheet(
          context: Get.context,
          title: "Đăng nhập",
          onCancel: () async{
            Get.back();
            await PreferenceUtility.saveBool(AppKey.authenOpenStatus,false);
          },
          isDismissible: false,
          expand: true,
          enableDrag: false,
          formSize: .7,
          const SignInAlert()
        ).whenComplete(() {
          PreferenceUtility.saveBool(AppKey.authenOpenStatus,false);
        });
        PreferenceUtility.saveBool(AppKey.authenOpenStatus,false);
      }
      else if(!withOutNavi.contains(Get.currentRoute) && !authenStatus){
        await PreferenceUtility.saveBool(AppKey.authenOpenStatus,true);
        AlertControl.push(msg,type: AlertType.ERROR);
        Get.offAllNamed(AppRouter.signIn);
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "handleAuthen");
    }
  }
}