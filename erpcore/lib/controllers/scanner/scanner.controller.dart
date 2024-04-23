import 'dart:async';
import 'dart:ui';
import 'package:erpcore/components/alertControl/alertControl.component.dart';
import 'package:erpcore/components/alertControl/data/alertType.data.dart';
import 'package:erpcore/components/alerts/alert.dart';
import 'package:erpcore/components/alerts/data/alertType.Data.dart';
import 'package:erpcore/configs/appStyle.Config.dart';
import 'package:erpcore/controllers/scanner/model/scannerConfig.model.dart';
import 'package:erpcore/controllers/scanner/model/scannerOutput.model.dart';
import 'package:erpcore/models/apps/prCodeName.Model.dart';
import 'package:erpcore/models/apps/responses.Model.dart';
import 'package:erpcore/providers/erp/app.Provider.dart';
import 'package:erpcore/utility/app.Utility.dart';
import 'package:erpcore/utility/logs/appLogs.Utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerController extends GetxController  with GetSingleTickerProviderStateMixin{
  late Barcode result;
  late MobileScannerController cameraController;
  RxBool flashFlag =false.obs;
  RxBool isStarted = false.obs;
  bool isDisplayResult = false;
  RxList<ScannerOutputModel> totalResult = RxList<ScannerOutputModel>.empty(growable: true);
  ScannerConfigModel config = ScannerConfigModel();
  Timer? timer;
  int timeSec = 0;
  bool cancelFlag = false;
  bool msgShowing = false;
  @override
  void onInit() {
    try{
      config = Get.arguments;
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "ScannerController onInit");
    }
    cameraController = MobileScannerController(
      onPermissionSet: onPermissionSet,
      returnImage: config.saveImage,
    );
    cameraController.start();
    super.onInit();
  }
  @override
  void onReady() {
    super.onReady();
    if((config.timeAwait??0) >0){
      startTimer(init: true,callback: handleTimeLimmitScanner);
    }
    if(config.srcData != null){
      totalResult.value = (config.srcData!);
    }
  }
  @override
  void onClose() {
    if(timer != null && timer!.isActive){
      timer!.cancel();
    }
    try{
      cameraController.stop();
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "cameraController.stop() ScannerController");
    }
    try{
      cameraController.dispose();
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "cameraController.dispose(); ScannerController");
    }
    super.onClose();
  }

  void handleTimeLimmitScanner(){
    if((config.timeAwait??0) >0){
      if(config.isMultiple == true ){
        if((config.targetItem??0) >0 && totalResult.length >= (config.targetItem??0)){
          timer?.cancel();
          onCloseScanner();
        }
        else{
          startTimer(init: true,callback: handleTimeLimmitScanner);
        }
      }
      else{
        timer?.cancel();
        cameraController.stop();
        if(totalResult.isEmpty){
          Get.back();
        }
        AlertControl.push("Không thể đọc mã vui lòng thử lại [timeout]", type: AlertType.ERROR,);
      }
    }
  }

  void startTimer({bool init=false,VoidCallback? callback}) {
    
    if(init){
      timer?.cancel();
      timeSec = config.timeAwait??0;
    }
    const oneSec = Duration(seconds: 1);
      timer = Timer.periodic(oneSec,(Timer timer) {
        if (timeSec == 0) {
          timer.cancel();
          timeSec = config.timeAwait??0;
          if(callback != null){
            callback();
          }
        } else {
          timeSec --;
        }
      },
    );
  }

  void onPressFlash() async{
    // await cameraController.
    // var flag = await controller.getFlashStatus(); 
    flashFlag.value = !flashFlag.value;
    cameraController.toggleTorch();
  }

  void onPressSwitch(){
    cameraController.switchCamera();
  }

  void onDetect(BarcodeCapture result) async{
    if(config.isMultiple == true){
      if((config.targetItem??0) > 0 && totalResult.length < (config.targetItem??0) ){
        codeMapping(result.barcodes);
        startTimer(init: true,callback: handleTimeLimmitScanner);
      }
      else if((config.targetItem??0) > 0 && totalResult.length >= (config.targetItem??0)){
        onCloseScanner();
      }
      else{
        codeMapping(result.barcodes);
      }
    }
    else{
      if(config.isDisplayResult == true && result.barcodes.isNotEmpty){
        ScannerOutputModel temp = ScannerOutputModel(code: generateKeyCode(),data: result.barcodes.first.rawValue,createdAt: DateTime.now(),type:  ResponsesModel(statusCode: 0,data: result.barcodes.first.format.toString()));
        cameraController.stop();
        var resultQuestion = await Alert.showDialogConfirm("Kết quả","Kết quả sau khi quét: [${result.barcodes.first.rawValue}]\n bạn muốn lấy kết quả này?");
        if(resultQuestion){
          Get.back(result: temp);
        }
        else{
          await cameraController.start();
        }
      }
      else if(config.isDisplayResult == false && result.barcodes.isNotEmpty){
        ScannerOutputModel temp = ScannerOutputModel(code: generateKeyCode(),data: result.barcodes.first.rawValue,createdAt: DateTime.now(),type: ResponsesModel(statusCode: 0,data: result.barcodes.first.format.toString()));
        cameraController.stop();
        Get.back(result: temp);
      }
    }
  }
  Future<void> handleCheckOnline(ScannerOutputModel item) async{
    int index = totalResult.indexWhere((element) => element.code == item.code);
    if(index >-1){
      totalResult[index].type?.statusCode = 1;
      totalResult.refresh();
    }
    AppProvider().scannerOnlineCheck(config.urlOnlineCheck,inputData: item.data).then((ResponsesModel response){
      totalResult[index].type?.statusCode = response.statusCode;
      totalResult[index].type?.msg = response.msg;
      totalResult.refresh();
    }
    ).catchError((err){
      totalResult[index].type?.statusCode = -3;
      totalResult[index].type?.msg = err.toString();
      totalResult.refresh();
    });
    
  }
  bool checkWithOutListData(String data){
    bool result = true;
    try{
      if(config.withOutData != null && config.withOutData!.isNotEmpty && (config.withOutData!.indexWhere((element) => element.data == data) >=0)){
        result = false;
      }
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "checkWithOutListData");
    }
    return result;
  }
  void codeMapping(List<Barcode> barCodes){
    for(var item in barCodes){
      var temp = ScannerOutputModel(code: generateKeyCode(),data: item.rawValue,type:  ResponsesModel(statusCode: 0,data: item.format),createdAt: DateTime.now());
      if(config.allowDouplicate == true ){
        totalResult.add(temp);
      }
      else{
        int index = totalResult.indexWhere((element) => element.data == temp.data);
        if(index >=0){
          handleHightLightRow(index);
        }
        else{
          if(checkWithOutListData(item.rawValue??"") && ((config.targetItem == null || config.targetItem == 0) ||(config.targetItem != null && config.targetItem! >0 && totalResult.length < config.targetItem!))){
            totalResult.add(temp);
            startTimer(init: true,callback: handleTimeLimmitScanner);
            if(!PrCodeName.isEmpty(config.urlOnlineCheck)){
              handleCheckOnline(temp);
            }
          }
          else if(!msgShowing){
            msgShowing = true;
            Alert.showSnackbar("Thông báo","[${temp.data}] đã tồn tại",type: AlertTypeData.WARNING,duration: const Duration(seconds: 1),
              callback: (SnackbarStatus? v){
                if(v == SnackbarStatus.CLOSED){
                  msgShowing = false;
                }
              }
            );
          }
        }
      }
    }
  }

  Future<void> handleHightLightRow(int index) async{
    if(totalResult[index].hightLightColor == null){
      totalResult[index].hightLightColor = AppColor.brightRed;
      totalResult.refresh();
      await Future.delayed(const Duration(milliseconds: 200));
      totalResult[index].hightLightColor = null;
      await Future.delayed(const Duration(milliseconds: 200));
      totalResult[index].hightLightColor = AppColor.acacyColor;
      totalResult.refresh();
      await Future.delayed(const Duration(milliseconds: 300));
      totalResult[index].hightLightColor = null;
      await Future.delayed(const Duration(milliseconds: 200));
      totalResult[index].hightLightColor = AppColor.brightRed;
      totalResult.refresh();
      await Future.delayed(const Duration(milliseconds: 300));
      totalResult[index].hightLightColor = null;
      await Future.delayed(const Duration(milliseconds: 200));
      totalResult[index].hightLightColor = AppColor.acacyColor;
      totalResult.refresh();
      await Future.delayed(const Duration(milliseconds: 200));
      totalResult[index].hightLightColor = AppColor.brightRed;
      totalResult.refresh();
      await Future.delayed(const Duration(milliseconds: 400));
      totalResult[index].hightLightColor = null;
      totalResult.refresh();
    }
  }

  void onPermissionSet(bool p) {
    if (!p) {
      AlertControl.push("Vui lòng kiểm tra quyền và thử lại!", type: AlertType.ERROR);
    }
  }

  void removeScanItem(String code){
    totalResult.removeWhere((element) => element.code == code);
  }

  void onCloseScanner(){
    try{
      timer?.cancel();
      cameraController.stop();
    }
    catch(ex){
      AppLogsUtils.instance.writeLogs(ex,func: "onCloseScanner");
    }
    if(config.isMultiple == true){
      Get.back(result: totalResult);
    }
    else{
      Get.back();
    }
  }
}