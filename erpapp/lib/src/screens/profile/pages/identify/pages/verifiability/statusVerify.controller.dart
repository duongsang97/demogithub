import 'package:erp/src/routers/app.Router.dart';
import 'package:erp/src/screens/auth/identityChecking/identityChecking.Controller.dart';
import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/datas/appData.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
// import 'package:erpcore/models/apps/verify.Model.dart';
import 'package:erpcore/providers/erp/authen.Provider.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/utility/preferences.Utility.dart';
import 'package:get/get.dart';
import 'package:erpcore/models/apps/verify.Model.dart';

class StatusVerifyController extends GetxController{
  RxBool isLoading = false.obs;
  RxList<PrCodeName> datas = RxList.empty(growable: true);
  AuthenProvider authenProvider = AuthenProvider();
  VerifyModel verifyModel = VerifyModel();
  AppController appController = AppController();
  @override
  void onInit() {
    datas.addAll([
      PrCodeName(code: "khuonmat",name: "Khuôn mặt",codeDisplay: "assets/images/face-recognition.png",value: false),
      PrCodeName(code: "vantay",name: "Vân tay",codeDisplay: "assets/images/fingerprint.png",value: false),
      PrCodeName(code: "cmnd",name: "eKYC",codeDisplay: "assets/images/id-card.png",value: false),
    ]);
    super.onInit();
  }

  @override
  void onReady() {
    fetchStatusVerify();
    super.onReady();
  }

  Future<void> fetchStatusVerify() async{
    try {
      var result = await authenProvider.getListStatusVerify();
      if (result.statusCode == 0) {
        verifyModel = result.data;
        // kiểm tra faceId
        datas[0].value = verifyModel.isFace;
        // kiểm tra xác minh vân tay
        datas[1].value = verifyModel.isFingerprint;
        // cmnd
        datas[2].value = verifyModel.isIDNumber;
        datas.refresh();
      } else {
        AlertControl.push(result.msg ?? "", type: AlertType.ERROR);
      }
    } catch (ex) {
      AppLogsUtils.instance.writeLogs(ex,func: "fetchStatusVerify");
    }
  }

  void onSelectedStatusItem(PrCodeName codeName, bool value) async{
    try {
      int index = datas.indexWhere((element) => element.code == codeName.code);
      if (index > -1) {
        if(codeName.code == "khuonmat"){
          identityChecking();
        } else if (codeName.code == "vantay") {
          if (value == true) {
            bool result = await appController.questionBiometrics();
            if (result) {
              datas[index].value = value;
            }
          } else { 
            await PreferenceUtility.removeByKey(AppKey.keybiometricstoken);
            datas[index].value = value;
          }
        }
        datas.refresh();
      }
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "onSelectedStatusItem StatusVerifyController");
    }
  }

  Future<void> identityChecking() async{
    try{
      await Get.toNamed(AppRouter.identityChecking);
      try{
        bool isRegistered = Get.isRegistered<IdentityCheckingController>();
        if(isRegistered){
          Get.delete<IdentityCheckingController>();
        }
      }
      catch(ex){
        AppLogsUtils.instance.writeLogs(ex,func: "_buildHeader ProfileDetailScreen");
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "");
    }
  }
}