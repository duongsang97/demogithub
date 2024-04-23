import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/notification/notificationInfo.Model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:get/get.dart';

class DetailNotificationController extends GetxController {
  RxBool isLoading = true.obs;
  Rx<NotificationInfoModel> notify = Rx<NotificationInfoModel>(NotificationInfoModel());
  Rx<PrCodeName> tagSelected = PrCodeName().obs;
  
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    if (Get.arguments != null && Get.arguments["NOTIFY"] != null) {
      notify.value = Get.arguments["NOTIFY"];
    }
    if (Get.arguments != null && Get.arguments["TAG"] != null) {
      tagSelected.value = Get.arguments["TAG"];
    }
    isLoading.value = false;
  }

  double getTitleSize(){
    double result = 19;
    try{
      if(notify.value.title != null && notify.value.title!.length > 30){
        result = 14;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "getTitleSize detailNotification.Controller");
    }
    return result;
  }

  void onDirection() {
    try {
      if (!PrCodeName.isEmpty(notify.value.nextFunction) && notify.value.nextFunction?.code == "201") {
        Get.toNamed("/esignature", arguments: {
          "NOTIFYPAYLOAD": notify.value.refCode,
        });
      }
    } catch (ex) {
      AppLogsUtils.instance.writeLogs(ex,func: "onDirection detailNotification.Controller");
    }
  }
}
