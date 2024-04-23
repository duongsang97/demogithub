import 'package:erp/src/screens/profile/pages/asset/assetDetail/assetDetail.Container.dart';
import 'package:erp/src/screens/profile/pages/asset/assetDetail/assetDetail.Controller.dart';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:erpcore/models/apps/userInfo.Model.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:erpcore/models/apps/asset/asset.Model.dart';
import 'package:erpcore/providers/erp/asset.Provider.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/components/boxs/models/paginationInfo.Model.dart';
import 'package:erpcore/components/modalSheet/modalSheet.Component.dart';

class AssetController extends GetxController {
  Rx<bool> isLoading = false.obs;
  RxList<AssetModel > listAsset = RxList.empty(growable: true);
  AssetProvider assetProvider = AssetProvider();
  Rx<PaginationInfoModel> assetPagingInfo = Rx<PaginationInfoModel>(PaginationInfoModel(pageSize: 25));
  var appController = Get.find<AppController>();
  UserInfoModel user = UserInfoModel();

  @override
  void onInit() {
    super.onInit();
    user = appController.userProfle.value;
  }
  
  @override
  void onReady() async {
    fetchData();
    super.onReady();
  }

  Future<void> fetchData({bool pageLoading = true,bool isPaging=false,int fromDate = 0, int toDate = 0}) async {
    try {
      if(pageLoading){
        isLoading.value = true;
      }
      else{
        LoadingComponent.show();
      }
      
      assetProvider.getAssetList(paginationInfoModel: assetPagingInfo.value).then((result){
        if (result.statusCode == 0) {
          if (result.data.isNotEmpty) {
            assetPagingInfo.value = result.paging??PaginationInfoModel(pageSize: 25);
          } else {
            assetPagingInfo.value = PaginationInfoModel(pageSize: 25, page: 0, totalPage: 0);
          }
          assetPagingInfo.refresh();
          List<AssetModel> assetList = List.empty(growable: true);
          if(isPaging){
            assetList.clear();
            for (var element in result.data) {
              assetList.add(element);
            }
            listAsset.addAll(assetList);
          }
          else{
            assetList.clear();
            for (var element in result.data) {
              assetList.add(element);
            }
            listAsset.value = assetList;
          }
        }
        if(pageLoading){
          isLoading.value = false;
        }
        else{
          LoadingComponent.dismiss();
        }
      });
    } catch (e) {
      isLoading.value = false;
      AppLogsUtils.instance.writeLogs(e, func: "fetchData AssetController");
    }
  }

   Future<void> onRouteDetailSignature(BuildContext context, {String sysCode = ""}) async {
    try {
      
      var assetDetailController = Get.put(AssetDetailController());
      assetDetailController.sysCode = sysCode;
      var result = await ModalSheetComponent.showBarModalBottomSheet(
        context: context,
        isDismissible: false,
        useSafeArea: true,
        title: "Chi tiết tài sản",
        expand: true,
        formSize: 1,  
        WillPopScope(
          onWillPop: () async {
            await fetchData();
            return true;
          },
          child: AssetDetailScreen()
        ), 
        onCancel: () {
          fetchData().then((value) {
            Get.back();
          });
        },
      );
      if (result != null) {
        await fetchData();
      }
      Get.delete<AssetDetailController>();
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "onRouteDetailSignature signatureSign.controller");
    }
  }
}