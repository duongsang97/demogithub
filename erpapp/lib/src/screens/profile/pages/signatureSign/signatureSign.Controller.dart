import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/loading/loading.component.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:erpcore/providers/erp/esignature.Provider.dart';
import 'package:flutter/material.dart';
import 'package:erpcore/components/boxs/boxFilter/models/filterInfo.Model.dart';
import 'package:erpcore/components/modalSheet/modalSheet.Component.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/components/boxs/models/paginationInfo.Model.dart';
import 'package:erpcore/screens/app.Controller.dart';
import 'package:erpcore/models/apps/userInfo.Model.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erp/src/screens/profile/pages/signatureSign/signatureDetail/signatureDetail.Controller.dart';
import 'package:erp/src/screens/profile/pages/signatureSign/signatureDetail/signatureDetail.Container.dart';
import 'package:erpcore/models/apps/signature/signatureAvailable.Model.dart';

class SignatureSignController extends GetxController{
  Rx<bool> isLoading = false.obs;
  Rx<PaginationInfoModel> signaturePagingInfo = Rx<PaginationInfoModel>(PaginationInfoModel(pageSize: 25));
  DocumentProvider documentProvider = DocumentProvider();
  RxList<SignatureAvailableModel> listSignature = RxList.empty(growable: true);
  Rx<FilterInfoModel> boxItemFilter = FilterInfoModel().obs;
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
      
      documentProvider.getSignatureList(paginationInfoModel: signaturePagingInfo.value).then((result){
        if (result.statusCode == 0) {
          if (result.data.isNotEmpty) {
            signaturePagingInfo.value = result.paging??PaginationInfoModel(pageSize: 25);
          } else {
            signaturePagingInfo.value = PaginationInfoModel(pageSize: 25, page: 0, totalPage: 0);
          }
          signaturePagingInfo.refresh();
          List<SignatureAvailableModel> signatureList = List.empty(growable: true);
          if(isPaging){
            signatureList.clear();
            for (var element in result.data) {
              if (user.sysCode != null && user.sysCode == element.username?.code) {
                signatureList.add(result.data);
              }
            }
            listSignature.addAll(signatureList);
          }
          else{
            signatureList.clear();
            for (var element in result.data) {
              if (user.sysCode != null && user.sysCode == element.username?.code) {
                signatureList.add(element);
              }
            }
            listSignature.value = signatureList;
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
      AppLogsUtils.instance.writeLogs(e, func: "fetchData_esignature SignatureSignController");
    }
  }

  Future<void> handleApplyFilter() async {
    try {
      LoadingComponent.show(msg: "Đang tải dữ liệu"); 
      int fromDate = 0;
      int toDate = 0;
      signaturePagingInfo.value = PaginationInfoModel(pageSize: 25);
      if (boxItemFilter.value.txtFromDateController != null && boxItemFilter.value.txtFromDateController!.text.isNotEmpty && boxItemFilter.value.txtToDateController != null && boxItemFilter.value.txtToDateController!.text.isNotEmpty) {
        fromDate = convertDateToTicks(DateTime.parse(boxItemFilter.value.txtFromDateController!.text));
        toDate = convertDateToTicks(DateTime.parse(boxItemFilter.value.txtToDateController!.text));
      } 
      fetchData(fromDate: fromDate, toDate: toDate);
      LoadingComponent.dismiss();
    } catch (e) {
      LoadingComponent.dismiss();
      AppLogsUtils.instance.writeLogs(e, func: "handleApplyFilter_esignature signatureSign.controller");
    }
  }

  Future<void> onRouteDetailSignature(BuildContext context, {String sysCode = ""}) async {
    try {
      int isAddSignature = 1;
      if (sysCode.isNotEmpty) {
        isAddSignature = 0;
      }
      Get.put(SignatureDetailController());
      var signatureDetailController = Get.find<SignatureDetailController>();
      signatureDetailController.type.value = isAddSignature; // 0 => update | 1 => add
      signatureDetailController.sysCode = sysCode;
      var result = await ModalSheetComponent.showBarModalBottomSheet(
        context: context,
        isDismissible: false,
        useSafeArea: true,
        title: isAddSignature == 1 ? "Thêm chữ ký" : "Chỉnh sửa chữ ký",
        expand: true,
        formSize: 1,  
        WillPopScope(
          onWillPop: () async {
            Get.back(result: true) ;
            await fetchData();
            return true;
          },
          child: const SignatureDetailScreen()
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
      Get.delete<SignatureDetailController>();
    } catch (e) {
      AppLogsUtils.instance.writeLogs(e, func: "onRouteDetailSignature signatureSign.controller");
    }
  }

  Future<void> onDeleteSignature(String sysCode, String name) async {
    int statusDelete = 3;
    try {
      var resultConfirm = await Alert.showDialogConfirm("Xóa chữ ký", "Bạn muốn xóa chữ ký $name không?");
      if (resultConfirm) {
        LoadingComponent.show(msg: "Đang xử lý dữ liệu...");
        var result = await documentProvider.updateStatusSignature(sysCode: sysCode, status: statusDelete);
        if (result.statusCode == 0) {
          await fetchData();
          AlertControl.push(result.msg ?? "", type: AlertType.SUCCESS);
        } else {
          AlertControl.push(result.msg ?? "", type: AlertType.ERROR);
        }
        LoadingComponent.dismiss();
      }
    } catch (e) {
      LoadingComponent.dismiss();
      AppLogsUtils.instance.writeLogs(e, func: "onDeleteSignature signatureSign.controller");
    }
  }
}