import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/providers/erp/identification.Provider.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class VerificationController extends GetxController{
  TextEditingController verifyController = TextEditingController();
  late IdentificationProvider provider;

  @override
  void onInit() {
    provider = IdentificationProvider();
    super.onInit();
  }

  Future<void> onVerifyAuthCode () async {
    try {
      var result = await provider.onVerifyAuthCode(authCode: verifyController.text, type: 4);
      if (result.statusCode == 0) {
        Get.back(result: true);
        AlertControl.push(result.msg ?? "",type: AlertType.SUCCESS);
      } else {
        AlertControl.push(result.msg ?? "",type: AlertType.ERROR);
      }
    } catch (ex) {
      AppLogsUtils.instance.writeLogs(ex,func: "verifyAuthCode");
    }
  }
}