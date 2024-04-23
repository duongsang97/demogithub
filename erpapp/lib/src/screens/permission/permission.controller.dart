import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
class PermissionController extends GetxController{
  RxList<PrCodeName> permission = RxList<PrCodeName>.empty(growable: true);
  PageController pageController = PageController();
  RxBool isLoading = false.obs;
  int pageIndex = 0;
  @override
  void onInit() {
    if(Get.arguments != null){
      permission.value = Get.arguments;
    }
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  Future<void> requestPermission(PrCodeName data) async{
    int count = 0;
    for(Permission per in data.value){
      isLoading.value = true;
      var vlStatus = await per.status;
      if(vlStatus.isDenied){
        PermissionStatus result = await per.request().timeout(const Duration(seconds: 10),onTimeout: () async{
          AlertControl.push("Yêu cầu quyền thất bại, vui lòng thử lại", type: AlertType.ERROR);
          return PermissionStatus.denied;
        }).catchError((e) async{
          isLoading.value = false;
          return PermissionStatus.denied;
        });
        isLoading.value = false;
        if(result.isDenied){
          count++;
        }
      }
      else if(vlStatus.isPermanentlyDenied){
        AlertControl.push("Quyền truy cập đã bị từ chối vĩnh viễn, Vui lòng thay đổi trong Cài đặt", type: AlertType.ERROR);
      }
      isLoading.value = false;
    }
    if(data.value2 != null){
      // kiểm tra các quyền phụ, không cần thiết
      for(Permission per in data.value2){
        isLoading.value = true;
        var vl2Status = await per.status;
        if(vl2Status.isDenied){
          await per.request().timeout(const Duration(seconds: 5),onTimeout: (){return PermissionStatus.denied;}).catchError((e) async{
          isLoading.value = false;
          return PermissionStatus.denied;
        });
          isLoading.value = false;
        }
        isLoading.value = false;
      }
    }
    isLoading.value = false;
    if(count ==0){
      if(pageIndex ==  (permission.length -1)){
        Get.back(result: true);
      }
      else{
        pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.bounceInOut);
      }
      
    }
  }
}