import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/asset/asset.Model.dart';
import 'package:erpcore/providers/erp/asset.Provider.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AssetDetailController extends GetxController {
  RxBool isLoading = true.obs;
  late AppController appController;
  Rx<AssetModel> asset = AssetModel().obs;
  AssetProvider assetProvider = AssetProvider();
  String sysCode = "";
  TextEditingController colorTextController = TextEditingController();
  TextEditingController configTextController = TextEditingController();
  TextEditingController accessoryTextController = TextEditingController();
  TextEditingController codeTextController = TextEditingController();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController supplierTextController = TextEditingController();
  TextEditingController assetSrcTextController = TextEditingController();
  TextEditingController assetTypeTextController = TextEditingController();
  TextEditingController TextController = TextEditingController();
  TextEditingController orderPurchaseTextController = TextEditingController();
  TextEditingController locationTextController = TextEditingController();
  TextEditingController departmentTextController = TextEditingController();
  TextEditingController assetCostTextController = TextEditingController();
  TextEditingController transTextController = TextEditingController();
  TextEditingController statusTextController = TextEditingController();
  TextEditingController transactionStatusTextController = TextEditingController();
  
  @override
  void onReady() {
    fetchData();
    appController = Get.find();
    super.onReady();
  }

  Future<void> fetchData() async {
    try {
      LoadingComponent.show(msg: "Đang tải dữ liệu...");
      isLoading.value = true;
        var result = await assetProvider.getOneAsset(sysCode: sysCode);
        if (result.statusCode == 0) {
          asset.value = result.data;
          colorTextController.text = (asset.value.attributes?.where((element) => element.kind?.code == "ATT01").first)?.kind?.name ?? "";
          configTextController.text = (asset.value.attributes?.where((element) => element.kind?.code == "ATT02").first)?.kind?.name ?? "";
          accessoryTextController.text = (asset.value.attributes?.where((element) => element.kind?.code == "ATT03").first)?.kind?.name ?? "";
          codeTextController.text = asset.value.code ?? "";
          nameTextController.text = asset.value.name ?? "";
          supplierTextController.text = asset.value.supplier?.name ?? "";
          assetSrcTextController.text = asset.value.assetsrc?.name ?? "";
          assetTypeTextController.text = asset.value.assettype?.name ?? "";
          orderPurchaseTextController.text = asset.value.orderPurchase?.name ?? "";
          locationTextController.text = asset.value.location?.name ?? "";
          departmentTextController.text = asset.value.department?.name ?? "";
          assetCostTextController.text = asset.value.assetCost.toString();
          transTextController.text = asset.value.transDate?.sD ?? "";
          statusTextController.text = asset.value.status?.name ?? "";
          transactionStatusTextController.text = asset.value.transactionStatus?.codeDisplay ?? "";
          isLoading.value = false;
        } else {
          AlertControl.push(result.msg ?? "", type: AlertType.ERROR);
          isLoading.value = false;
        }
      LoadingComponent.dismiss();
    } catch (e) {
      isLoading.value = false;
      LoadingComponent.dismiss();
      AppLogsUtils.instance.writeLogs(e,func: "fetchData SignatureDetail.Component");
    }
  }
}