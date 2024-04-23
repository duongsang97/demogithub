import 'package:erp/src/screens/auth/identityChecking/identityChecking.Controller.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:get/get.dart';

import '../../../../routers/app.Router.dart';
class StatusVerifyController extends GetxController{
  RxBool isLoading = false.obs;
  RxList<PrCodeName> datas = RxList.empty(growable: true);
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
    // kiểm tra faceId
    datas[0].value = true;
    // kiểm tra xác minh vân tay
    datas[1].value = true;
    // cmnd
    datas[2].value = false;

    datas.refresh();
  }

  void onSelectedStatusItem(PrCodeName codeName) async{
    if(codeName.code == "khuonmat"){
      identityChecking();
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